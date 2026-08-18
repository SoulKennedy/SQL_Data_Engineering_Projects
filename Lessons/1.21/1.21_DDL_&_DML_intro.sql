-- .read Lessons/1.21/1.21_DDL_&_DML_intro.sql
-- This script will create a new database called jobs_mart and a schema called staging.
USE data_jobs;

DROP DATABASE IF EXISTS jobs_mart;
DROP TABLE IF EXISTS staging.preferred_roles;
CREATE DATABASE IF NOT EXISTS jobs_mart;
SHOW DATABASES;

SELECT 
    * 
FROM information_schema.schemata;

USE jobs_mart;

CREATE SCHEMA IF NOT EXISTS staging;

CREATE TABLE IF NOT EXISTS staging.priority_roles (
    role_id INTEGER PRIMARY KEY,
    role_name VARCHAR(255)
);

SELECT 
    * 
FROM information_schema.tables
WHERE table_catalog = 'jobs_mart';

INSERT INTO staging.priority_roles (role_id, role_name)
 VALUES 
    (1, 'Data Engineer'),
    (2, 'Senior Data Engineer'),
    (3, 'Software Engineer');


SELECT
    *
FROM staging.priority_roles;

-- Create a new column in the priority_roles table to indicate if the role is preferred or not
ALTER TABLE staging.priority_roles
ADD COLUMN is_preferred BOOLEAN;

-- Update the priority_roles column to indicate which roles are preferred
UPDATE staging.priority_roles
SET is_preferred = TRUE 
    WHERE role_id = 1 OR role_id = 2;
--
ALTER TABLE staging.priority_roles
ALTER COLUMN is_preferred TYPE INTEGER;

UPDATE staging.priority_roles
SET is_preferred = 3
WHERE role_id = 3;

SELECT
    *
FROM staging.priority_roles;