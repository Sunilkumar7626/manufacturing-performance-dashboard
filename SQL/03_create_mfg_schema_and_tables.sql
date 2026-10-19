-- 03 - Create manufacturing schema and tables
-- Manufacturing Performance & KPI Dashboard
-- Creates mfg.dim_date, descriptive dimensions, and mfg.fact_production.
--
-- Reorganized from the user's supplied SQL files.
-- Review sql/README.md before running against an existing database.

CREATE SCHEMA IF NOT EXISTS mfg;


-- =========================================================
-- DATE DIMENSION
-- =========================================================

CREATE TABLE mfg.dim_date (
    date_key        INTEGER PRIMARY KEY,
    calendar_date   DATE NOT NULL UNIQUE,
    year            INTEGER NOT NULL,
    quarter         INTEGER NOT NULL,
    month           INTEGER NOT NULL,
    month_name      VARCHAR(20) NOT NULL,
    week            INTEGER NOT NULL,
    day_of_month    INTEGER NOT NULL,
    day_of_week     INTEGER NOT NULL
);


-- =========================================================
-- PLANT DIMENSION
-- =========================================================

CREATE TABLE mfg.dim_plant (
    plant_key       INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    plant_id        VARCHAR(50) NOT NULL UNIQUE,
    plant_location  VARCHAR(100),
    industry_sector VARCHAR(100)
);


-- =========================================================
-- LINE DIMENSION
-- =========================================================

CREATE TABLE mfg.dim_line (
    line_key            INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    line_id             VARCHAR(100) NOT NULL UNIQUE,
    line_type           VARCHAR(100),
    automation_level    VARCHAR(100),
    number_of_stations  INTEGER,
    line_configuration  VARCHAR(100)
);


-- =========================================================
-- WORK CENTER DIMENSION
-- =========================================================

CREATE TABLE mfg.dim_work_center (
    work_center_key INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    work_center_id  VARCHAR(50) NOT NULL UNIQUE
);


-- =========================================================
-- PRODUCT DIMENSION
-- =========================================================

CREATE TABLE mfg.dim_product (
    product_key     INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_id      VARCHAR(100) NOT NULL UNIQUE,
    product_family  VARCHAR(100)
);


-- =========================================================
-- SHIFT DIMENSION
-- =========================================================

CREATE TABLE mfg.dim_shift (
    shift_key     INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    shift_id      VARCHAR(100) NOT NULL UNIQUE,
    shift_date    DATE,
    shift_number  INTEGER
);


CREATE TABLE mfg.fact_production (
    production_key BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    -- Foreign keys
    date_key        INTEGER NOT NULL,
    plant_key       INTEGER NOT NULL,
    line_key        INTEGER NOT NULL,
    work_center_key INTEGER NOT NULL,
    product_key     INTEGER NOT NULL,
    shift_key       INTEGER NOT NULL,

    -- Business identifier
    production_order_id VARCHAR(100) NOT NULL,

    -- Production measures
    planned_production_quantity   NUMERIC(18,2),
    actual_production_quantity    NUMERIC(18,2),
    good_units_produced           NUMERIC(18,2),
    defective_units_produced      NUMERIC(18,2),
    scrap_units                   NUMERIC(18,2),
    rework_units                  NUMERIC(18,2),

    throughput_rate_actual_uph    NUMERIC(18,2),
    throughput_rate_design_uph   NUMERIC(18,2),
    throughput_rate_ratio         NUMERIC(18,4),

    output_variance_pct           NUMERIC(18,4),
    total_parts_processed         NUMERIC(18,2),

    -- Time / availability
    shift_duration_minutes
        NUMERIC(18,2),

    planned_production_time_minutes
        NUMERIC(18,2),

    available_time_minutes
        NUMERIC(18,2),

    availability_loss_minutes
        NUMERIC(18,2),

    performance_loss_units
        NUMERIC(18,2),

    quality_loss_units
        NUMERIC(18,2),

    -- OEE
    oee_availability  NUMERIC(18,4),
    oee_performance   NUMERIC(18,4),
    oee_quality      NUMERIC(18,4),
    oee_overall      NUMERIC(18,4),

    teep_pct          NUMERIC(18,4),
    loading_pct       NUMERIC(18,4),

    -- Cycle / bottleneck
    takt_time_seconds
        NUMERIC(18,2),

    designed_cycle_time_seconds
        NUMERIC(18,2),

    actual_cycle_time_avg_seconds
        NUMERIC(18,2),

    actual_cycle_time_std_seconds
        NUMERIC(18,2),

    bottleneck_cycle_time_seconds
        NUMERIC(18,2),

    bottleneck_utilisation_pct
        NUMERIC(18,4),

    cycle_time_loss_seconds
        NUMERIC(18,2),

    -- Downtime
    downtime_unplanned_minutes
        NUMERIC(18,2),

    downtime_planned_minutes
        NUMERIC(18,2),

    downtime_event_count
        INTEGER,

    mtbf_minutes
        NUMERIC(18,2),

    mttr_minutes
        NUMERIC(18,2),

    largest_downtime_event_minutes
        NUMERIC(18,2),

    equipment_failure_flag
        BOOLEAN,

    planned_maintenance_flag
        BOOLEAN,

    -- Quality
    defect_rate_ppm
        NUMERIC(18,2),

    sigma_level
        NUMERIC(18,4),

    cpk_primary_characteristic
        NUMERIC(18,4),

    cp_primary_characteristic
        NUMERIC(18,4),

    first_pass_yield_pct
        NUMERIC(18,4),

    right_first_time_pct
        NUMERIC(18,4),

    spc_control_chart_flag
        BOOLEAN,

    control_chart_out_of_control
        BOOLEAN,

    quality_alert_issued
        BOOLEAN,

    customer_complaint_flag
        BOOLEAN,

    -- Energy
    energy_consumption_kwh
        NUMERIC(18,2),

    energy_per_good_unit_kwh
        NUMERIC(18,4),

    peak_demand_kw
        NUMERIC(18,2),

    compressed_air_consumption_m3
        NUMERIC(18,2),

    coolant_consumption_litres
        NUMERIC(18,2),

    energy_efficiency_score
        NUMERIC(18,4),

    carbon_footprint_kg_co2
        NUMERIC(18,2),

    -- Cost
    direct_labour_cost_usd
        NUMERIC(18,2),

    overhead_cost_usd
        NUMERIC(18,2),

    material_cost_per_unit_usd
        NUMERIC(18,4),

    scrap_cost_usd
        NUMERIC(18,2),

    rework_cost_usd
        NUMERIC(18,2),

    downtime_cost_per_minute_usd
        NUMERIC(18,4),

    total_downtime_cost_usd
        NUMERIC(18,2),

    cost_of_poor_quality_usd
        NUMERIC(18,2),

    production_cost_per_unit_usd
        NUMERIC(18,4),

    -- Foreign-key constraints
    CONSTRAINT fk_fact_date
        FOREIGN KEY (date_key)
        REFERENCES mfg.dim_date(date_key),

    CONSTRAINT fk_fact_plant
        FOREIGN KEY (plant_key)
        REFERENCES mfg.dim_plant(plant_key),

    CONSTRAINT fk_fact_line
        FOREIGN KEY (line_key)
        REFERENCES mfg.dim_line(line_key),

    CONSTRAINT fk_fact_work_center
        FOREIGN KEY (work_center_key)
        REFERENCES mfg.dim_work_center(work_center_key),

    CONSTRAINT fk_fact_product
        FOREIGN KEY (product_key)
        REFERENCES mfg.dim_product(product_key),

    CONSTRAINT fk_fact_shift
        FOREIGN KEY (shift_key)
        REFERENCES mfg.dim_shift(shift_key)
);


SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'mfg'
ORDER BY table_name;
