import os
import logging
from datetime import datetime

import psycopg2
from dotenv import load_dotenv

from quality_checks import run_quality_checks



load_dotenv()


LOG_DIR = "logs"
os.makedirs(LOG_DIR, exist_ok=True)

log_file = os.path.join(
    LOG_DIR,
    f"pipeline_{datetime.now().strftime('%Y%m%d_%H%M%S')}.log"
)

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s | %(levelname)s | %(message)s",
    handlers=[
        logging.FileHandler(log_file, encoding="utf-8"),
        logging.StreamHandler()
    ]
)


SQL_FILES = [
    "sql/00_create_schemas.sql",
    "sql/01_bronze_load.sql",
    "sql/02_silver_transform.sql",
    "sql/03_gold_model.sql",
]


def get_db_connection():
    return psycopg2.connect(
        dbname=os.getenv("DB_NAME"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
        host=os.getenv("DB_HOST"),
        port=os.getenv("DB_PORT"),
    )


def run_sql_file(cursor, file_path):
    if not os.path.exists(file_path):
        raise FileNotFoundError(f"SQL file not found: {file_path}")

    logging.info(f"Starting: {file_path}")

    with open(file_path, "r", encoding="utf-8") as file:
        sql = file.read()

    if not sql.strip():
        raise ValueError(f"SQL file is empty: {file_path}")

    start_time = datetime.now()

    cursor.execute(sql)

    end_time = datetime.now()
    duration = (end_time - start_time).total_seconds()

    rows = cursor.rowcount

    logging.info(f"Finished: {file_path} | Rows: {rows} | Time: {duration}s")

        
def main():

    logging.info("Pipeline started")

    conn = None
    run_id = None

    try:
        conn = get_db_connection()
        conn.autocommit = False

        # Insert pipeline run start
        with conn.cursor() as cursor:
            cursor.execute("""
                INSERT INTO public.pipeline_runs (start_time, status)
                VALUES (%s, %s)
                RETURNING run_id;
            """, (datetime.now(), "RUNNING"))
            run_id = cursor.fetchone()[0]
        conn.commit()

        # Run SQL files with RETRY logic
        for sql_file in SQL_FILES:
            step_id = None
            max_retries = 2
            attempt = 0

            while attempt <= max_retries:
                try:
                    logging.info(f"Executing step: {sql_file} | Attempt: {attempt+1}")

                    # Insert step start
                    with conn.cursor() as cursor:
                        cursor.execute("""
                            INSERT INTO public.pipeline_steps
                                (run_id, step_name, start_time, status)
                            VALUES (%s, %s, %s, %s)
                            RETURNING step_id;
                        """, (run_id, sql_file, datetime.now(), "RUNNING"))
                        step_id = cursor.fetchone()[0]
                    conn.commit()

                    # Run SQL
                    with conn.cursor() as cursor:
                        run_sql_file(cursor, sql_file)
                    conn.commit()

                    # Mark step success
                    with conn.cursor() as cursor:
                        cursor.execute("""
                            UPDATE public.pipeline_steps
                            SET end_time = %s,
                                status = %s
                            WHERE step_id = %s;
                        """, (datetime.now(), "SUCCESS", step_id))
                    conn.commit()

                    break  # SUCCESS হলে loop break

                except Exception as step_error:
                    logging.error(
                        f"Step failed: {sql_file} | Attempt: {attempt+1}",
                        exc_info=True
                    )
                    conn.rollback()
                    attempt += 1

                    if attempt > max_retries:
                        if step_id is not None:
                            with conn.cursor() as cursor:
                                cursor.execute("""
                                    UPDATE public.pipeline_steps
                                    SET end_time = %s,
                                        status = %s
                                    WHERE step_id = %s;
                                """, (datetime.now(), "FAILED", step_id))
                            conn.commit()

                        raise step_error

        # =========================
        # Quality check step
        # =========================
        step_id = None

        try:
            with conn.cursor() as cursor:
                cursor.execute("""
                    INSERT INTO public.pipeline_steps
                        (run_id, step_name, start_time, status)
                    VALUES (%s, %s, %s, %s)
                    RETURNING step_id;
                """, (run_id, "quality_checks", datetime.now(), "RUNNING"))
                step_id = cursor.fetchone()[0]
            conn.commit()

            with conn.cursor() as cursor:
                run_quality_checks(cursor)
            conn.commit()

            with conn.cursor() as cursor:
                cursor.execute("""
                    UPDATE public.pipeline_steps
                    SET end_time = %s,
                        status = %s
                    WHERE step_id = %s;
                """, (datetime.now(), "SUCCESS", step_id))
            conn.commit()

        except Exception as qc_error:
            conn.rollback()

            if step_id is not None:
                with conn.cursor() as cursor:
                    cursor.execute("""
                        UPDATE public.pipeline_steps
                        SET end_time = %s,
                            status = %s
                        WHERE step_id = %s;
                    """, (datetime.now(), "FAILED", step_id))
                conn.commit()

            raise qc_error

        # Mark pipeline success
        with conn.cursor() as cursor:
            cursor.execute("""
                UPDATE public.pipeline_runs
                SET end_time = %s,
                    status = %s
                WHERE run_id = %s;
            """, (datetime.now(), "SUCCESS", run_id))
        conn.commit()

        logging.info("Pipeline completed successfully")

    except Exception as error:
        if conn:
            conn.rollback()

            if run_id is not None:
                with conn.cursor() as cursor:
                    cursor.execute("""
                        UPDATE public.pipeline_runs
                        SET end_time = %s,
                            status = %s
                        WHERE run_id = %s;
                    """, (datetime.now(), "FAILED", run_id))
                conn.commit()

        logging.exception(f"Pipeline failed: {error}")
        raise

    finally:
        if conn:
            conn.close()
            logging.info("Database connection closed")

if __name__ == "__main__":
    main()