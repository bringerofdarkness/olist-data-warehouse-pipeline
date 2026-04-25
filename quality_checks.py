import logging


QUALITY_CHECKS = [
       {
        "name": "gold dim_customers row count",
        "sql": "SELECT COUNT(*) FROM gold.dim_customers;",
        "expected": 99441,
    },
    {
        "name": "gold dim_products row count",
        "sql": "SELECT COUNT(*) FROM gold.dim_products;",
        "expected": 32951,
    },
    {
        "name": "gold dim_sellers row count",
        "sql": "SELECT COUNT(*) FROM gold.dim_sellers;",
        "expected": 3095,
    },
    {
        "name": "gold dim_date row count",
        "sql": "SELECT COUNT(*) FROM gold.dim_date;",
        "expected": 634,
    },
    {
        "name": "gold fact_orders not empty",
        "sql": "SELECT CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END FROM gold.fact_orders;",
        "expected": 1,
    },
]


def run_quality_checks(cursor):
    logging.info("Starting data quality checks")

    for check in QUALITY_CHECKS:
        cursor.execute(check["sql"])
        actual = cursor.fetchone()[0]

        if actual != check["expected"]:
            raise ValueError(
                f"Data quality check failed: {check['name']} | "
                f"expected={check['expected']} actual={actual}"
            )

        logging.info(
            f"Passed: {check['name']} | value={actual}"
        )

    logging.info("All data quality checks passed")