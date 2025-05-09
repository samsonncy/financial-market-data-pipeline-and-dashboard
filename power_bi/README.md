# Financial Market Dashboard (Azure x Databricks x Power BI)

This project showcases a **real-world, cloud-based financial data pipeline** built using the **medallion architecture** (Bronze–Silver–Gold), powered by **Azure Databricks**, **Delta Lake**, and visualized through **Power BI**. It retrieves daily stock data from the Alpha Vantage API, processes it using PySpark, and delivers a rich dashboard experience for financial trend analysis.

## File

- `fmdp_yyyymmdd.pbix`  
  Main Power BI file containing the data model, visuals, and user interactions.

## Layout
![image](https://github.com/user-attachments/assets/7df9ab8a-32dc-4f1f-bc29-635b08db6c43)

## Features

- **Latest Market Snapshot**
  - Close, High, Low, Volume, DoD Change ($ and %)
  - Auto-updated based on the latest trading date

- **Symbol Selection Panel**
  - Quick switch between major stocks: `AAPL`, `AMZN`, `TSLA`, `GOOGL`, `META`, `MSFT`, `NVDA`, `QQQ`, `SPY`

- **Close Time Trend**
  - Interactive time-series chart with 20-day and 200-day moving averages
  - Date range slider

- **Volume by Date**
  - Bar chart showing daily trading volume over time

- **Performance by Day of Week**
  - Average daily return grouped by weekday to detect behavioral patterns

- **Monthly Return Heatmap**
  - Year-by-month return performance visualization

## Data Source & Update

The report is powered by curated `gold`-layer Delta tables exposed via **Azure Synapse Analytics**. Data is refreshed via Databricks notebooks that ingest and transform stock market data.

## Notes

- The dashboard is optimized for desktop viewing
- Built as part of a full-stack data engineering showcase using Azure, Databricks, and Power BI

---

Feel free to explore the full pipeline in the [root-level README](../README.md).
