CREATE SCHEMA IF NOT EXISTS bronze;
CREATE SCHEMA IF NOT EXISTS silver;
CREATE SCHEMA IF NOT EXISTS gold;

-- =========================================================
-- Pipeline Metadata Table
-- =========================================================

CREATE TABLE IF NOT EXISTS public.pipeline_runs (
    run_id SERIAL PRIMARY KEY,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP,
    status VARCHAR(20) NOT NULL CHECK (status IN ('RUNNING', 'SUCCESS', 'FAILED'))
);

-- =========================================================
-- Pipeline Step Tracking
-- =========================================================

CREATE TABLE IF NOT EXISTS public.pipeline_steps (
    step_id SERIAL PRIMARY KEY,
    run_id INT NOT NULL REFERENCES public.pipeline_runs(run_id) ON DELETE CASCADE,
    step_name VARCHAR(255) NOT NULL,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP,
    status VARCHAR(20) NOT NULL CHECK (status IN ('RUNNING', 'SUCCESS', 'FAILED'))
);