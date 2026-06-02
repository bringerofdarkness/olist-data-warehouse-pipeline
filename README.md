# 🏗️ Olist Data Warehouse Pipeline

![Python](https://img.shields.io/badge/Python-3.x-blue)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-DataWarehouse-blue)

End-to-end Data Engineering pipeline using **PostgreSQL and Python**, featuring **SQL-driven transformations, Medallion Architecture, and production-grade monitoring**.

This pipeline ingests raw Olist e-commerce CSV data and transforms it into analytics-ready datasets through structured layers (Bronze, Silver, Gold) with built-in logging, quality checks, and automation.

---

## Project Overview

The pipeline processes raw data into analytics-ready tables using structured layers:


Raw CSV → Bronze → Silver → Gold → Quality Checks → Monitoring


---

##  Architecture

| Stage        | Description              |
|-------------|--------------------------|
| Raw CSV     | Source data              |
| Bronze      | Raw ingestion            |
| Silver      | Cleaned & transformed    |
| Gold        | Star schema              |
| Quality     | Data validation          |
| Monitoring  | Pipeline tracking        |


---

## Tech Stack

**Database**
- PostgreSQL  

**Programming & Frameworks**
- Python 3.11
- Django REST Framework (API Control Plane)

**Distributed Task Queue & Automation**
- Celery (Async Task Processing)
- Redis 7 (Isolated Message Broker)
- Docker & Docker Compose (Containerized Infrastructure)

**Data Processing**
- SQL (Medallion Architecture Layering)

**Drivers & Core Libraries**
- psycopg (v3 / Binary Edition)  
- python-dotenv  
- django-cors-headers 

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

## Project Structure

```text
olist-data-warehouse-pipeline/
│
├── core_pipeline/           # Moved original pipeline scripts here
│   ├── run_pipeline.py
│   └── quality_checks.py
│
├── olist_platform/          # Django API Core Configuration
│   ├── __init__.py
│   ├── celery.py            # Celery app initialization
│   ├── settings.py          # Dynamic enterprise settings
│   ├── urls.py
│   └── wsgi.py / asgi.py
│
├── pipeline_manager/        # Pipeline Control App
│   ├── models.py            # Reverse-engineered Django ORM models
│   ├── serializers.py       # Frontend-ready JSON serializers
│   ├── tasks.py             # Celery subprocess async tasks
│   ├── urls.py              # API endpoint mapping
│   └── views.py             # API Controllers (Trigger & Status)
│
├── sql/
│   └── ... (Your SQL scripts)
│
├── Dockerfile               # Production multi-stage Python environment
├── docker-compose.yml       # Isolated network & services orchestrator
├── manage.py
├── requirements.txt         # Added Django, Celery, Redis & Psycopg drivers
└── .gitignore
```

---

##  Data Warehouse Layers

### Bronze Layer (Raw Data)

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

###  Gold Layer (Analytics Layer)

Analytics-ready **star schema**.

**Tables:**
- gold.fact_orders  
- gold.dim_customers  
- gold.dim_products  
- gold.dim_sellers  
- gold.dim_date  

---

##  Pipeline Features

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

##  Pipeline Execution
The infrastructure is completely containerized and decoupled using Docker Compose across three isolated services: `backend` (Django REST API), `celery_worker` (Task Executor), and `olist_redis_service` (Broker). 

This allows you to run this pipeline seamlessly even if you have other Redis or Docker projects active on your machine.

### 1. Boot up the Infrastructure

Spin up the entire decoupled architecture in detached mode with an isolated network bridge:

```bash
docker-compose up -d --build
```

### 2. Trigger via REST API (De-coupled Control Plane)

Instead of running synchronous Python scripts that block execution, trigger the complete Medallion ETL pipeline asynchronously using any HTTP Client (Postman, cURL, or PowerShell):

* **Endpoint:** `POST http://localhost:8085/api/pipeline/trigger/`

**Example via cURL:**

```bash
curl -X POST http://localhost:8085/api/pipeline/trigger/
```

**Expected JSON Response:**

```json
{
  "message": "Pipeline triggered successfully",
  "celery_task_id": "bb07e179-e7a6-4574-96cf-7b76b76ceb4a"
}
```

### 3. Fetch Real-Time Metadata & Analytics (GET)

Retrieve full ORM-mapped nested pipeline steps and runs for live dashboarding directly through the control plane API. It provides a built-in interactive web interface when opened in a browser:

* **Endpoint:** `GET http://localhost:8085/api/pipeline/status/`

---

##  Pipeline Monitoring

###  Run-Level Tracking

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

##  Logging

Logs are stored in the `logs/` folder.

**Example:**

```text
Pipeline started
Executing step: sql/01_bronze_load.sql | Attempt: 1
Finished: sql/01_bronze_load.sql | Rows: 103886 | Time: 0.63s
Pipeline completed successfully
```

---

##  Retry Logic

Each step retries on failure:

```text
Attempt 1 → fail
Attempt 2 → retry
Attempt 3 → retry → fail
```

---

##  Data Quality Checks

- Row count validation
- Null checks
- Duplicate checks
- Fact table non-empty check

❗ Pipeline fails if checks fail.

---

##  Automation

Scheduled using **Windows Task Scheduler**.

Runs:

```bash
python run_pipeline.py
```

---

##  Environment Variables

Create a `.env` file:

```env
DB_NAME=olist_dw
DB_USER=postgres
DB_PASSWORD=your_password
DB_HOST=localhost
DB_PORT=5432
```

---

##  Setup & Run

```bash
git clone https://github.com/bringerofdarkness/olist-data-warehouse-pipeline.git
cd olist-data-warehouse-pipeline

python -m venv .venv
.venv\Scripts\activate

pip install -r requirements.txt

python run_pipeline.py
```

---

##  Future Improvements

```markdown
- Airflow orchestration for complex cross-pipeline dependency graphing
- Cloud deployment (AWS ECS / Managed Kubernetes)
- dbt (Data Build Tool) integration for structural data models and lineage
- Incremental data loading with Change Data Capture (CDC)

---

## 👤 Author

GitHub: https://github.com/bringerofdarkness

Linkedin: https://www.linkedin.com/in/md-shahrul-zakaria-24a805230/

---

