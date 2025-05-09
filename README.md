# Financial Market Data Pipeline and Dashboard

This is a portfolio project that demonstrates the design and implementation of a **modular, cloud-based data pipeline** for processing and visualizing stock market data. It combines **Terraform-provisioned Azure infrastructure**, **Databricks-powered ETL**, and a **Power BI dashboard** for insights — all centered around the **medallion architecture**.

## Project Highlights

- **Infrastructure as Code**: Fully automated deployment using Terraform to provision Azure resources with proper security
- **Scalable Data Engineering**: ELT pipeline using Azure Databricks with Delta Lake for reliable, efficient data processing
- **Cloud-Native Architecture**: Azure-native services with RBAC & Key Vault integration for secure credential management
- **Insightful Analytics**: Power BI dashboard with market metrics, returns, volatility, and trend analysis
- **Modern Data Architecture**: Implementation of the medallion architecture (Bronze-Silver-Gold) for progressive data refinement
- **Component Isolation**: Modular repo structure for clear separation of concerns

## Architecture Overview

![image](https://github.com/user-attachments/assets/3ac24d7e-2d8e-49ab-ab8c-744e0ca181e4)


The architecture follows a modern data engineering approach:

1. **Data Ingestion**: Stock market data from Alpha Vantage API is ingested via Databricks notebooks
2. **Data Processing**: 
   - **Bronze Layer**: Raw JSON data storage with metadata
   - **Silver Layer**: Structured, validated OHLCV data with proper schema
   - **Gold Layer**: Enriched data with calculated metrics (returns, moving averages, volatility)
3. **Analytics**: Synapse Analytics provides SQL querying capabilities through external tables
4. **Visualization**: Power BI dashboard connects to Synapse for interactive analysis

## Repository Structure

```
├── databricks/          # PySpark notebooks for the medallion architecture ETL
│   ├── src_to_brz.ipynb # Data extraction from Alpha Vantage to Bronze layer
│   ├── brz_to_sil.ipynb # Data transformation from Bronze to Silver layer
│   └── sil_to_gld.ipynb # Data enrichment from Silver to Gold layer
├── power_bi/            # Power BI dashboard and documentation
│   └── fmdp_v20250502.pbix # Interactive dashboard for stock analysis
├── synapse/             # Synapse Analytics components
│   ├── credential/      # Managed identities configuration
│   ├── linkedService/   # Connections to other Azure services
│   └── sqlscript/       # SQL scripts for creating external tables and views
├── terraform/           # Infrastructure as Code for Azure provisioning
│   ├── modules/         # Reusable Terraform modules
│   ├── main.tf          # Main Terraform configuration
│   └── variables.tf     # Variable definitions
└── README.md            # You are here
```

## Pipeline Details

### Data Source
- **Alpha Vantage API**: Provides time series data for stock market analysis
- **Symbols Tracked**: `AAPL`, `AMZN`, `GOOGL`, `META`, `MSFT`, `NVDA`, `TSLA`, `QQQ`, `SPY`

### Data Processing Pipeline
The project implements a complete medallion architecture data pipeline:

1. **Bronze Layer (Raw Data)**
   - Preserves raw API responses as JSON
   - Includes metadata for tracking and lineage
   - Implements change detection to prevent duplicate ingestion

2. **Silver Layer (Structured Data)**
   - Parses JSON into structured tables with explicit schema
   - Validates data quality and flags invalid records
   - Partitioned by symbol for efficient querying

3. **Gold Layer (Business Ready)**
   - Calculates technical indicators and financial metrics:
     - Daily returns and relative performance
     - Moving averages (5, 20, 50, 200 day)
     - Price volatility metrics
     - Trading signals (MA crossovers)
   - Adds time dimensions for analysis (year, month, quarter)

## Dashboard Preview

![image](https://github.com/user-attachments/assets/e7861b59-97a8-4b05-9160-9a5354c6f666)


The interactive dashboard provides:

- **Latest Market Snapshot**  
  - Displays the latest **Close**, **High**, **Low**, **Volume**, and **Day-over-Day (DoD)** changes.  
  - Automatically updates to reflect the most recent trading day.

- **Symbol Selector**  
  - Interactive buttons for switching between major stocks (e.g., `AAPL`, `AMZN`, `TSLA`, etc.).  
  - Updates all visuals across the dashboard based on the selected symbol.

- **Close Price Trend with Moving Averages**  
  - Line chart showing daily closing prices.  
  - Includes **20-day** and **200-day** moving averages for trend analysis.  
  - User-controlled date range filtering.

- **Daily Volume Chart**  
  - Bar chart visualizing daily trading volume.  
  - Useful for spotting volume surges and liquidity changes.

- **Day-of-Week Performance**  
  - Average daily return by weekday (Monday to Friday).  
  - Helps identify potential behavioral patterns or inefficiencies.

- **Monthly Return Heatmap**  
  - Calendar-style heatmap showing monthly return percentages by year.  
  - Highlights seasonality, strong/weak months, and year-over-year trends.

#### * The latest version is accessible at [`power_bi`](./power_bi).


## Technical Implementation

### Key Technologies
- **Azure Databricks**: For scalable data processing using PySpark
- **Delta Lake**: For reliable, transactional data storage
- **Azure Data Lake Storage Gen2**: For durable, hierarchical data storage
- **Azure Synapse Analytics**: For SQL-based analytics on processed data
- **Azure Key Vault**: For secure credential management
- **Power BI**: For interactive data visualization and analysis
- **Terraform**: For infrastructure as code and repeatable deployments

### Security Considerations
- Service Principal authentication for secure resource access
- Key Vault integration for secrets management
- RBAC implementation for proper access control

## Future Enhancements

- Integration with additional data sources (e.g., fundamental data, news sentiment)
- Automated anomaly detection for market events
- Machine learning models for price prediction
- Real-time data processing using streaming

## Getting Started (Coming Soon)

In future iterations, you'll be able to:
- Clone this repo
- Use `terraform/` to provision the infrastructure
- Run Databricks notebooks in `databricks/`
- Load processed data into Power BI from the gold layer

## Author

**Samson Cheuk-yin Ng**  
📍 Data Engineer | Azure & Databricks  
🔗 [LinkedIn](https://www.linkedin.com/in/cy-samson-ng)  
📧 samsonncy@gmail.com

## ⭐ Stay tuned for updates, and feel free to reach out if you're interested in the technical breakdown.

