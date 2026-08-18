-- duckdb dw_marts.duckdb -c ".read build_dw_marts.sql"
-- Step 1: DW - Create star schema tables
.read 01_create_tables_dw.sql

-- Step 2: DW - Load DATA CSV files into tables
.read 02_load_schema_dw.sql

-- Step 3: Mart - Creat flat mart
.read 03_create_flat_mart.sql
