# Financial Market Data Pipeline - Databricks Component

This directory contains the Databricks notebooks that implement the core ETL (Extract, Transform, Load) processes for the Financial Market Data Pipeline.

## Overview

The Databricks component is responsible for:
1. Extracting stock market data from Alpha Vantage API
2. Processing it through a medallion architecture (Bronze → Silver → Gold)
3. Creating analytics-ready datasets with financial metrics and indicators

## Notebooks

### [`src_to_brz.ipynb`](./src_to_brz.ipynb)
Extracts data from Alpha Vantage and loads it into the Bronze layer.

**Key Features:**
- Supports both full historical loads (20+ years of data) and daily incremental updates (latest 100 days)
- Implements efficient change detection to prevent duplicate data storage
- Handles API rate limiting and includes retry logic
- Captures complete metadata for data lineage and auditing

**Function:** `av_time_series_daily_src_to_brz(symbol, outputsize="compact", initial_load=False)`

### [`brz_to_sil.ipynb`](./brz_to_sil.ipynb)
Transforms raw JSON data from the Bronze layer into structured tables in the Silver layer.

**Key Features:**
- Parses nested JSON into structured Delta tables with explicit schema
- Validates data quality and flags invalid records
- Supports both full rebuilds and incremental updates
- Efficiently handles record-level updates and inserts

**Function:** `av_time_series_daily_brz_to_sil(symbols=None, start_date=None, end_date=None, rebuild=False)`

### [`sil_to_gld.ipynb`](./sil_to_gld.ipynb)
Enriches structured data with financial metrics and technical indicators in the Gold layer.

**Key Features:**
- Calculates daily returns, moving averages, and volatility metrics
- Generates trading signals based on technical indicators
- Computes relative performance against market benchmark (SPY)

**Function:** `av_time_series_daily_sil_to_gld()`

## Setup and Configuration

Each notebook begins with the same configuration code to establish authentication and storage paths:

```python
# Retrieve secrets
secret_scope_name = "your-secret-scope-name"
client_id = dbutils.secrets.get(scope=secret_scope_name, key="fmdp-databricks-sp-client-id")
client_secret = dbutils.secrets.get(scope=secret_scope_name, key="fmdp-databricks-sp-client-secret")
tenant_id = dbutils.secrets.get(scope=secret_scope_name, key="tenant-id")
alpha_vantage_api_key = dbutils.secrets.get(scope=secret_scope_name, key="fmdp-alpha-vantage-api-key")

# Define storage paths
storage_account_name = "your-storage-account-name"
bronze_path = f"abfss://financial-data@{storage_account_name}.dfs.core.windows.net/bronze"
silver_path = f"abfss://financial-data@{storage_account_name}.dfs.core.windows.net/silver"
gold_path = f"abfss://financial-data@{storage_account_name}.dfs.core.windows.net/gold"

# Configure storage authentication (OAuth with service principal)
configs = {
  f"fs.azure.account.auth.type.{storage_account_name}.dfs.core.windows.net": "OAuth",
  f"fs.azure.account.oauth.provider.type.{storage_account_name}.dfs.core.windows.net": "org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider",
  f"fs.azure.account.oauth2.client.id.{storage_account_name}.dfs.core.windows.net": client_id,
  f"fs.azure.account.oauth2.client.secret.{storage_account_name}.dfs.core.windows.net": client_secret,
  f"fs.azure.account.oauth2.client.endpoint.{storage_account_name}.dfs.core.windows.net": f"https://login.microsoftonline.com/{tenant_id}/oauth2/token"
}

# Apply configurations
for k, v in configs.items(): spark.conf.set(k, v)
```

### Required Secrets

You'll need to set up the following secrets in a Databricks secret scope named `fmdp-secrets`:

- `fmdp-databricks-sp-client-id`: Client ID of the service principal for ADLS access
- `fmdp-databricks-sp-client-secret`: Client secret of the service principal
- `tenant-id`: Azure tenant ID
- `fmdp-alpha-vantage-api-key`: Alpha Vantage API key

## Data Model

### Bronze Layer
Raw data preservation layer:
- Complete JSON responses from Alpha Vantage
- Metadata fields for tracking and lineage
- Partitioned by symbol and ingestion date

### Silver Layer
Structured, validated data:
- Clean OHLCV (Open, High, Low, Close, Volume) daily data
- Data validation flags
- Processing metadata
- Partitioned by symbol

### Gold Layer
Analytics-ready data:
- All silver data plus calculated metrics:
  - Daily return percentages
  - Moving averages (5, 20, 50, 200 day)
  - Price volatility (5-day, 20-day)
  - Normalized prices
  - Trading signals (MA crossovers)
  - Relative strength vs market

## Usage Instructions

### Initial Setup (One-time)

1. **Upload notebooks** to your Databricks workspace
2. **Create a secret scope** named `fmdp-secrets` and add the required secrets
3. **Execute the configuration code** at the top of each notebook to verify connectivity

### Initial Historical Load

Run the following to create your initial historical dataset:

1. **Source to Bronze** with full historical data:
   ```python
   symbols = ["AAPL", "MSFT", "AMZN", "META", "NVDA", "TSLA", "GOOGL", "QQQ", "SPY"]
   
   for symbol in symbols:
       success = av_time_series_daily_src_to_brz(symbol, initial_load=True)
       time.sleep(60)  # Respect API rate limits
   ```

2. **Bronze to Silver** with rebuild mode:
   ```python
   av_time_series_daily_brz_to_sil(rebuild=True)
   ```

3. **Silver to Gold**:
   ```python
   av_time_series_daily_sil_to_gld()
   ```

### Daily Updates

Schedule a daily job with the following steps:

1. **Source to Bronze** with incremental mode:
   ```python
   symbols = ["AAPL", "MSFT", "AMZN", "META", "NVDA", "TSLA", "GOOGL", "QQQ", "SPY"]
   
   for i, symbol in enumerate(symbols):
       success = av_time_series_daily_src_to_brz(symbol)  # Default is incremental
       
       # Rate limiting
       if (i + 1) % 5 == 0:
           time.sleep(60)
       else:
           time.sleep(5)
   ```

2. **Bronze to Silver** with incremental mode:
   ```python
   av_time_series_daily_brz_to_sil(rebuild=False)
   ```

3. **Silver to Gold**:
   ```python
   av_time_series_daily_sil_to_gld()
   ```

## Performance Considerations

- **API rate limits**: Alpha Vantage limits to 5 requests/minute on free tier
- **Processing time**: Full historical loads will take significantly longer than daily updates
- **Storage growth**: Monitor bronze layer growth as it accumulates historical snapshots
- **Cluster sizing**: For large datasets, ensure sufficient memory for window operations in Gold layer

## Dependencies

- **Databricks Runtime**: 10.4 LTS or higher
- **Libraries**: Delta Lake, PySpark, requests, json, hashlib
- **Storage**: Azure Data Lake Storage Gen2 configured with service principal access
- **Secrets**: Access to the `fmdp-secrets` scope

## Integration Points

This component integrates with:
- **Alpha Vantage API** (upstream data source)
- **Power BI dashboards** (downstream visualization)
- **Synapse Analytics** (SQL analytics)

## Troubleshooting

- **Authentication errors**: Verify service principal credentials and permissions
- **API errors**: Check Alpha Vantage rate limits and API key validity
- **Missing data**: Verify symbol names and date ranges
- **Performance issues**: Check for skew in partitioning and optimize window operations