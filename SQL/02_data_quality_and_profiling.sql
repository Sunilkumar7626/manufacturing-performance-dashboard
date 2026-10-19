-- 02 - Data quality and profiling
-- Manufacturing Performance & KPI Dashboard
-- Read-only checks for schema, row counts, key uniqueness, shift consistency, nulls, and dimension consistency.
--
-- Reorganized from the user's supplied SQL files.
-- Review sql/README.md before running against an existing database.

-- Diagnostic queries below assume public.raw_mfg005 has been loaded.

SELECT
    ordinal_position,
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'raw_mfg005'
ORDER BY ordinal_position;

SELECT COUNT(*)
FROM raw_mfg005;

SELECT
    production_order_id,
    COUNT(DISTINCT product_id) AS product_count
FROM raw_mfg005
GROUP BY production_order_id
HAVING COUNT(DISTINCT product_id) > 1;

SELECT
    production_order_id,
    product_id,
    COUNT(*) AS row_count
FROM raw_mfg005
GROUP BY
    production_order_id,
    product_id
ORDER BY production_order_id, product_id;

SELECT
    production_order_id,
    product_id,
    COUNT(DISTINCT work_center_id) AS work_center_count,
    COUNT(DISTINCT shift_id) AS shift_count
FROM raw_mfg005
GROUP BY
    production_order_id,
    product_id
HAVING
    COUNT(DISTINCT work_center_id) > 1
    OR COUNT(DISTINCT shift_id) > 1
ORDER BY production_order_id;

SELECT column_name
FROM information_schema.columns
WHERE table_name = 'raw_mfg005'
ORDER BY ordinal_position;

SELECT
    shift_id,
    COUNT(*) AS production_records,
    COUNT(DISTINCT shift_date) AS dates,
    MIN(shift_date) AS first_date,
    MAX(shift_date) AS last_date
FROM raw_mfg005
GROUP BY shift_id
ORDER BY shift_id;

SELECT
    shift_id,
    COUNT(DISTINCT shift_number) AS shift_number_count,
    COUNT(DISTINCT shift_duration_minutes) AS duration_count
FROM raw_mfg005
GROUP BY shift_id
HAVING
    COUNT(DISTINCT shift_number) > 1
    OR COUNT(DISTINCT shift_duration_minutes) > 1;

SELECT
    shift_id,
    shift_date,
    shift_number,
    shift_duration_minutes,
    work_center_id,
    product_id,
    production_order_id
FROM raw_mfg005
WHERE shift_id = 'SHF-PLT-004-20221124-1';

SELECT
    shift_id,
    work_center_id,
    COUNT(DISTINCT shift_duration_minutes) AS duration_count,
    MIN(shift_duration_minutes) AS min_duration,
    MAX(shift_duration_minutes) AS max_duration
FROM raw_mfg005
GROUP BY
    shift_id,
    work_center_id
HAVING COUNT(DISTINCT shift_duration_minutes) > 1
ORDER BY shift_id, work_center_id;

SELECT
    production_order_id AS production_order,
    product_id AS product,
    COUNT(*) AS num_of_rows
FROM raw_mfg005
GROUP BY
    production_order_id,
    product_id
HAVING COUNT(*) > 1
ORDER BY num_of_rows DESC;

SELECT
    production_order_id,
    product_id,
    COUNT(DISTINCT work_center_id) AS work_center_count,
    COUNT(DISTINCT shift_id) AS shift_count
FROM raw_mfg005
GROUP BY
    production_order_id,
    product_id
HAVING
    COUNT(DISTINCT work_center_id) > 1
    OR COUNT(DISTINCT shift_id) > 1;

SELECT
    shift_id,
    COUNT(*) AS production_records
FROM raw_mfg005
GROUP BY shift_id
ORDER BY production_records DESC;

SELECT
    shift_id,
    COUNT(DISTINCT shift_duration_minutes) AS duration_count,
    MIN(shift_duration_minutes) AS min_duration,
    MAX(shift_duration_minutes) AS max_duration
FROM raw_mfg005
GROUP BY shift_id
HAVING COUNT(DISTINCT shift_duration_minutes) > 1
ORDER BY duration_count DESC;

WITH null_counts AS (
    SELECT
        SUM(CASE WHEN planned_production_quantity IS NULL THEN 1 ELSE 0 END)
            AS planned_production_quantity,
        SUM(CASE WHEN actual_production_quantity IS NULL THEN 1 ELSE 0 END)
            AS actual_production_quantity,
        SUM(CASE WHEN good_units_produced IS NULL THEN 1 ELSE 0 END)
            AS good_units_produced,
        SUM(CASE WHEN defective_units_produced IS NULL THEN 1 ELSE 0 END)
            AS defective_units_produced,
        SUM(CASE WHEN oee_overall IS NULL THEN 1 ELSE 0 END)
            AS oee_overall,
        SUM(CASE WHEN downtime_unplanned_minutes IS NULL THEN 1 ELSE 0 END)
            AS downtime_unplanned_minutes,
        SUM(CASE WHEN coolant_consumption_litres IS NULL THEN 1 ELSE 0 END)
            AS coolant_consumption_litres
    FROM raw_mfg005
)
SELECT
    v.column_name,
    v.null_count
FROM null_counts
CROSS JOIN LATERAL (
    VALUES
        ('planned_production_quantity', planned_production_quantity),
        ('actual_production_quantity', actual_production_quantity),
        ('good_units_produced', good_units_produced),
        ('defective_units_produced', defective_units_produced),
        ('downtime_unplanned_minutes', downtime_unplanned_minutes),
        ('oee_overall', oee_overall),
        ('coolant_consumption_litres', coolant_consumption_litres)
) AS v(column_name, null_count)
ORDER BY v.null_count DESC;

WITH null_counts AS (
    SELECT
        COUNT(*) AS total_rows,
        SUM(CASE WHEN planned_production_quantity IS NULL THEN 1 ELSE 0 END)
            AS planned_production_quantity,
        SUM(CASE WHEN actual_production_quantity IS NULL THEN 1 ELSE 0 END)
            AS actual_production_quantity,
        SUM(CASE WHEN good_units_produced IS NULL THEN 1 ELSE 0 END)
            AS good_units_produced,
        SUM(CASE WHEN defective_units_produced IS NULL THEN 1 ELSE 0 END)
            AS defective_units_produced,
        SUM(CASE WHEN oee_overall IS NULL THEN 1 ELSE 0 END)
            AS oee_overall,
        SUM(CASE WHEN downtime_unplanned_minutes IS NULL THEN 1 ELSE 0 END)
            AS downtime_unplanned_minutes,
        SUM(CASE WHEN coolant_consumption_litres IS NULL THEN 1 ELSE 0 END)
            AS coolant_consumption_litres
    FROM raw_mfg005
)
SELECT
    v.column_name,
    v.null_count,
    ROUND(100.0 * v.null_count / nc.total_rows, 2) AS null_percentage
FROM null_counts nc
CROSS JOIN LATERAL (
    VALUES
        ('planned_production_quantity', planned_production_quantity),
        ('actual_production_quantity', actual_production_quantity),
        ('good_units_produced', good_units_produced),
        ('defective_units_produced', defective_units_produced),
        ('downtime_unplanned_minutes', downtime_unplanned_minutes),
        ('oee_overall', oee_overall),
        ('coolant_consumption_litres', coolant_consumption_litres)
) AS v(column_name, null_count)
ORDER BY v.null_count DESC;

SELECT
    line_id,
    COUNT(DISTINCT plant_id) AS plant_count,
    COUNT(DISTINCT line_type) AS line_type_count,
    COUNT(DISTINCT automation_level) AS automation_count,
    COUNT(DISTINCT number_of_stations) AS station_count,
    COUNT(DISTINCT line_configuration) AS configuration_count
FROM raw_mfg005
GROUP BY line_id
HAVING COUNT(DISTINCT plant_id) > 1
    OR COUNT(DISTINCT line_type) > 1
    OR COUNT(DISTINCT automation_level) > 1
    OR COUNT(DISTINCT number_of_stations) > 1
    OR COUNT(DISTINCT line_configuration) > 1
ORDER BY line_id;

SELECT
    work_center_id,
    COUNT(DISTINCT line_id) AS line_count
FROM raw_mfg005
GROUP BY work_center_id
HAVING COUNT(DISTINCT line_id) > 1
ORDER BY work_center_id;

SELECT
    line_id,
    COUNT(DISTINCT work_center_id) AS work_center_count
FROM raw_mfg005
GROUP BY line_id
ORDER BY work_center_count DESC;

SELECT
    work_center_id,
    COUNT(DISTINCT plant_id) AS plant_count
FROM raw_mfg005
GROUP BY work_center_id
HAVING COUNT(DISTINCT plant_id) > 1
ORDER BY work_center_id;

SELECT
    product_id,
    COUNT(DISTINCT product_family) AS product_family_count
FROM raw_mfg005
GROUP BY product_id
HAVING COUNT(DISTINCT product_family) > 1
ORDER BY product_id;

SELECT
    product_id,
    product_family,
    COUNT(*) AS row_count
FROM raw_mfg005
WHERE product_id = 'PRD-2020-SKU-02624'
GROUP BY product_id, product_family
ORDER BY product_family;

SELECT
    COUNT(*) AS affected_products
FROM (
    SELECT product_id
    FROM raw_mfg005
    GROUP BY product_id
    HAVING COUNT(DISTINCT product_family) > 1
) AS x;
