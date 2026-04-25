CREATE SCHEMA IF NOT EXISTS bronze;
CREATE SCHEMA IF NOT EXISTS silver;
CREATE SCHEMA IF NOT EXISTS gold;

-- =========================================================
-- Pipeline Metadata Table
-- =========================================================

CREATE TABLE IF NOT EXISTS public.pipeline_runs (
    run_id SERIAL PRIMARY KEY,
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    status VARCHAR(20)
);


-- =========================================================
-- Pipeline Step Tracking
-- =========================================================

CREATE TABLE IF NOT EXISTS public.pipeline_steps (
    step_id SERIAL PRIMARY KEY,
    run_id INT,
    step_name TEXT,
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    status VARCHAR(20)
);