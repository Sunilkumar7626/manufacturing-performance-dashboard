# SQL Scripts — Manufacturing Performance & KPI Dashboard

This folder contains organized copies of the SQL supplied for the portfolio project. The goal is to make the work easier to review without presenting missing steps as if they were supplied.

## Files

1. `01_create_raw_table.sql` — creates the `public.raw_mfg005` table structure.
2. `02_data_quality_and_profiling.sql` — read-only profiling and data-quality checks on the raw table.
3. `03_create_mfg_schema_and_tables.sql` — creates schema `mfg`, dimension tables, and `mfg.fact_production`.
4. `04_load_date_dimension.sql` — inserts distinct dates from `raw_mfg005` into `mfg.dim_date`.
5. `05_inspect_schema.sql` — lists schema tables and columns.

## Suggested order and prerequisites

- Run scripts against the intended PostgreSQL database.
- Run `01_create_raw_table.sql` only if `public.raw_mfg005` does not already exist. It creates the structure, not the data import.
- Load the source dataset into `public.raw_mfg005` using your actual import process before running scripts 02 and 04.
- Run `02_data_quality_and_profiling.sql` to review the data. These queries are diagnostic; they do not clean or modify the data.
- Run `03_create_mfg_schema_and_tables.sql` if the `mfg` objects do not already exist. It creates the schema and tables; it does not load the dimension or fact rows.
- Run `04_load_date_dimension.sql` after `mfg.dim_date` exists and `raw_mfg005` contains dates. The supplied query does not include `ON CONFLICT` handling, so running it again may produce a duplicate-key error.
- Run `05_inspect_schema.sql` after creating the schema.

## Important notes and gaps in the supplied SQL

- The original second and third files both contain a `CREATE TABLE mfg.fact_production` definition. The definition from original file 2 is retained in script 03; the repeated definition from original file 3 is omitted to avoid duplicate DDL. The original file 3's table/column inspection queries are retained in script 05.
- Some diagnostic queries in the original file 2 were repeated. Exact repeated queries have been deduplicated in script 02; distinct versions that provide different outputs (for example, null counts versus null percentages) are retained.
- The supplied files do not include a data import command for `raw_mfg005`.
- The supplied files do not include the `INSERT`/load statements for `dim_plant`, `dim_line`, `dim_work_center`, `dim_product`, `dim_shift`, or `fact_production`. Those steps may have been completed separately in your actual workflow, but they are not present in the uploaded scripts, so they have not been invented here.
- These files are organized portfolio copies, not a verified, end-to-end database rebuild. Before using them to recreate the database, compare the definitions with your actual database and confirm dependencies and load steps.

## Data and security

The project uses a synthetic manufacturing dataset. Check that no passwords, connection strings, or private information are included before publishing.
