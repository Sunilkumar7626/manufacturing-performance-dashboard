-- 04 - Load date dimension
-- Manufacturing Performance & KPI Dashboard
-- Loads distinct shift dates into mfg.dim_date. Run after raw data is loaded and the dimension table exists.
--
-- Reorganized from the user's supplied SQL files.
-- Review sql/README.md before running against an existing database.

INSERT INTO mfg.dim_date (
    date_key,
    calendar_date,
    year,
    quarter,
    month,
    month_name,
    week,
    day_of_month,
    day_of_week
)
SELECT DISTINCT
    EXTRACT(YEAR FROM shift_date)::INT * 10000
        + EXTRACT(MONTH FROM shift_date)::INT * 100
        + EXTRACT(DAY FROM shift_date)::INT AS date_key,
    shift_date AS calendar_date,
    EXTRACT(YEAR FROM shift_date)::INT AS year,
    EXTRACT(QUARTER FROM shift_date)::INT AS quarter,
    EXTRACT(MONTH FROM shift_date)::INT AS month,
    TO_CHAR(shift_date, 'Month') AS month_name,
    EXTRACT(WEEK FROM shift_date)::INT AS week,
    EXTRACT(DAY FROM shift_date)::INT AS day_of_month,
    EXTRACT(ISODOW FROM shift_date)::INT AS day_of_week
FROM raw_mfg005
ORDER BY shift_date;
