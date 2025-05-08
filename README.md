# 📈 Financial Market Data Pipeline and Dashboard

This is a portfolio project that demonstrates the design and implementation of a **modular, cloud-based data pipeline** for processing and visualizing stock market data. It combines **Terraform-provisioned Azure infrastructure**, **Databricks-powered ETL**, and a **Power BI dashboard** for insights — all centered around the **medallion architecture**.

---

## 🔧 Project Highlights

- **Infrastructure as Code**: Fully automated deployment using Terraform
- **Scalable Data Engineering**: ELT pipeline using Azure Databricks (Delta Lake)
- **Cloud-Native Architecture**: Azure-native services with RBAC & Key Vault integration
- **Insightful Analytics**: Power BI dashboard with market metrics, returns, volatility, and trend analysis
- **Component Isolation**: Modular repo structure (`terraform/`, `databricks/`, `synapse/`, `power_bi/`)

---

## 🗂️ Repository Structure
├── databricks/ PySpark notebooks (src-to-brz, brz-to-sil, sil-to-gld)

├── power_bi/ Dashboard (.pbix) & documentation

├── synapse/ (Planned) Synapse integration components 

├── terraform/ IaC scripts for provisioning Azure resources 

├── .gitignore 

└── README.md ← You're here


---

## 🔌 Pipeline Overview

**Data Source:** [Alpha Vantage API](https://www.alphavantage.co/documentation/)  
**Stock Symbols Tracked:** `AAPL`, `AMZN`, `GOOGL`, `META`, `MSFT`, `NVDA`, `TSLA`, `QQQ`, `SPY`  
**Architecture:** 

![image](https://github.com/user-attachments/assets/e2d9b460-06ca-44c3-9f02-cbb0f4920572)




---

## 📊 Dashboard Preview

![image](https://github.com/user-attachments/assets/8d7b3b19-f523-4efd-862e-157b7fe87ec1)



---

## 🚀 Getting Started (Coming Soon)

In future iterations, you'll be able to:

- Clone this repo
- Use `terraform/` to provision the infrastructure
- Run Databricks notebooks in `databricks/`
- Load processed data into Power BI from the gold layer

> 🔒 This repo is currently **private** and still under development.

---

## 👨‍💻 Author

**Samson Cheuk-yin Ng**  
📍 Data Engineer | Azure & Databricks  
🔗 [LinkedIn](https://www.linkedin.com/in/cy-samson-ng)  
📧 samsonncy@gmail.com

---

## ⭐ Stay tuned for updates, and feel free to reach out if you're interested in the technical breakdown.

