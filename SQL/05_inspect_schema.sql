-- 05 - Inspect schema objects
-- Manufacturing Performance & KPI Dashboard
-- Lists tables and columns in schema mfg. Read-only inspection queries.
--
-- Reorganized from the user's supplied SQL files.
-- Review sql/README.md before running against an existing database.

SELECT
    table_name
FROM information_schema.tables
WHERE table_schema = 'mfg'
ORDER BY table_name;

SELECT
    table_name,
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema = 'mfg'
ORDER BY table_name, ordinal_position;
