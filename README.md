# 🏗️ Olist Data Warehouse Pipeline

![Python](https://img.shields.io/badge/Python-3.x-blue)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-DataWarehouse-blue)

End-to-end Data Engineering pipeline using **PostgreSQL and Python**, featuring **SQL-driven transformations, Medallion Architecture, and production-grade monitoring**.

This pipeline ingests raw Olist e-commerce CSV data and transforms it into analytics-ready datasets through structured layers (Bronze, Silver, Gold) with built-in logging, quality checks, and automation.

---

## 📌 Project Overview

The pipeline processes raw data into analytics-ready tables using structured layers:


Raw CSV → Bronze → Silver → Gold → Quality Checks → Monitoring


---

## 🧱 Architecture

| Stage        | Description              |
|-------------|--------------------------|
| Raw CSV     | Source data              |
| Bronze      | Raw ingestion            |
| Silver      | Cleaned & transformed    |
| Gold        | Star schema              |
| Quality     | Data validation          |
| Monitoring  | Pipeline tracking        |


---

## 🛠️ Tech Stack

**Database**
- PostgreSQL  

**Programming**
- Python  

**Data Processing**
- SQL  

**Libraries**
- psycopg2  
- python-dotenv  

**Orchestration & Automation**
- Python scripts  
- Windows Task Scheduler  

**Version Control**
- Git  
- GitHub   

---

## 📂 Project Structure

```text
olist-data-warehouse-pipeline/
│
├── sql/
│   ├── 00_create_schemas.sql
│   ├── 01_bronze_load.sql
│   ├── 02_silver_transform.sql
│   ├── 03_gold_model.sql
│   ├── 04_quality_checks.sql
│   ├── 05_analytics_queries.sql
│   └── 06_bi_views.sql
│
├── run_pipeline.py
├── quality_checks.py
├── requirements.txt
├── README.md
└── .gitignore
```

---

## 🧱 Data Warehouse Layers

### 🟤 Bronze Layer (Raw Data)

Stores raw CSV data with minimal transformation.

**Tables:**
- bronze.raw_orders  
- bronze.raw_order_items  
- bronze.raw_customers  
- bronze.raw_products  
- bronze.raw_product_category_translation  
- bronze.raw_sellers  
- bronze.raw_order_payments  

---

### ⚪ Silver Layer (Cleaned Data)

Cleaned, structured, and typed data.

**Tables:**
- silver.clean_orders  
- silver.clean_order_items  
- silver.clean_customers  
- silver.clean_products  
- silver.final_products  
- silver.clean_sellers  
- silver.clean_order_payments  
- silver.order_details  

---

### 🟡 Gold Layer (Analytics Layer)

Analytics-ready **star schema**.

**Tables:**
- gold.fact_orders  
- gold.dim_customers  
- gold.dim_products  
- gold.dim_sellers  
- gold.dim_date  

---

## ⚙️ Pipeline Features

- Medallion Architecture  
- Python orchestration  
- SQL transformations  
- Logging (file + console)  
- Retry logic  
- Data quality checks  
- Pipeline run tracking  
- Step-level tracking  
- Automation via Task Scheduler  

---

## ▶️ Pipeline Execution

Pipeline steps:

1. Create schemas  
2. Load Bronze data  
3. Transform to Silver  
4. Build Gold model  
5. Run quality checks  

Run manually:

```bash
python run_pipeline.py
```

---

## 📊 Pipeline Monitoring

### 🔁 Run-Level Tracking

**Table:** `public.pipeline_runs`

**Columns:**
- run_id
- start_time
- end_time
- status

### 🔹 Step-Level Tracking

**Table:** `public.pipeline_steps`

**Columns:**
- step_id
- run_id
- step_name
- start_time
- end_time
- status

---

## 📜 Logging

Logs are stored in the `logs/` folder.

**Example:**

```text
Pipeline started
Executing step: sql/01_bronze_load.sql | Attempt: 1
Finished: sql/01_bronze_load.sql | Rows: 103886 | Time: 0.63s
Pipeline completed successfully
```

---

## 🔁 Retry Logic

Each step retries on failure:

```text
Attempt 1 → fail
Attempt 2 → retry
Attempt 3 → retry → fail
```

---

## 🔍 Data Quality Checks

- Row count validation
- Null checks
- Duplicate checks
- Fact table non-empty check

❗ Pipeline fails if checks fail.

---

## ⏱️ Automation

Scheduled using **Windows Task Scheduler**.

Runs:

```bash
python run_pipeline.py
```

---

## 🔐 Environment Variables

Create a `.env` file:

```env
DB_NAME=olist_dw
DB_USER=postgres
DB_PASSWORD=your_password
DB_HOST=localhost
DB_PORT=5432
```

---

## 🚀 Setup & Run

```bash
git clone https://github.com/bringerofdarkness/olist-data-warehouse-pipeline.git
cd olist-data-warehouse-pipeline

python -m venv .venv
.venv\Scripts\activate

pip install -r requirements.txt

python run_pipeline.py
```

---

## 🔮 Future Improvements

- Incremental loading
- Docker
- Airflow
- Cloud deployment
- Alert system

---

## 👤 Author

GitHub: https://github.com/bringerofdarkness

Linkedin: https://www.linkedin.com/in/md-shahrul-zakaria-24a805230/

---

