# 📊 Financial Market Dashboard (Azure x Databricks x Power BI)

This project showcases a **real-world, cloud-based financial data pipeline** built using the **medallion architecture** (Bronze–Silver–Gold), powered by **Azure Databricks**, **Delta Lake**, and visualized through **Power BI**. It retrieves daily stock data from the Alpha Vantage API, processes it using PySpark, and delivers a rich dashboard experience for financial trend analysis.

---

## 🚀 Features

### ✅ Latest Day Overview
- **Key metrics** (Close, High, Low, Volume)
- **Daily change** (ΔClose, ΔClose%)

### 📈 Trend Analysis
- Interactive date slicer
- Time series plot of Close price with:
  - **5-day Moving Average**
  - **200-day Moving Average**

### 📊 Volume by Date
- Clustered column chart displaying daily trading volume

### 📆 Return Analysis
- **Performance by Day of Week** (Average Return %)
- **Monthly Return Heatmap** (Color-encoded)

### 🔘 Symbol Selector
- Toggle between 10 popular U.S. stocks: `AAPL`, `AMZN`, `GOOGL`, `META`, `MSFT`, `NVDA`, `TSLA`, `QQQ`, `SPY`, etc.

