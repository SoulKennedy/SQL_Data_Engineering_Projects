/* This query retrieves job postings along with their associated company information from the job_postings_fact and company_dim tables. 
.read Lessons/1.21/1.21_DDL_DML_Pt2.sql
*/
CREATE OR REPLACE TABLE staging.job_postings_flat AS 
SELECT
    jpf.job_id,
    jpf.company_id,
    jpf.job_title_short,
    jpf.job_title,
    jpf.job_location,
    jpf.job_via,
    jpf.job_schedule_type,
    jpf.job_work_from_home,
    jpf.search_location,
    jpf.job_posted_date,
    jpf.job_no_degree_mention,
    jpf.job_health_insurance,
    jpf.job_country,
    jpf.salary_rate,
    jpf.salary_year_avg,
    jpf.salary_hour_avg,
    cd.name company_name,
    cd.link company_link,
    cd.link_google company_link_google,
    cd.thumbnail company_thumbnail
FROM 
data_jobs.job_postings_fact AS jpf
LEFT JOIN 
data_jobs.company_dim AS cd
    ON 
jpf.company_id = cd.company_id;


SELECT 
COUNT (*) AS total_records
FROM 
staging.job_postings_flat;

CREATE OR REPLACE VIEW staging.job_postings_flat_view AS
SELECT 
    jpf.*
FROM staging.job_postings_flat AS jpf
JOIN (
    SELECT role_name
    FROM staging.priority_roles
    WHERE is_preferred = 1
) AS r
    ON jpf.job_title_short = r.role_name;


SELECT 
    job_title_short,
    COUNT(*) AS job_count
FROM staging.job_postings_flat_view
GROUP BY job_title_short
ORDER BY job_count DESC;

SELECT * FROM staging.job_postings_flat_view
WHERE job_title_short = 'Senior Data Engineer'
LIMIT 20;

-- Couldn't retrieve the entire job postings for Senior Data Engineer, so let's create a TEMP table to store those job postings TEMPORARILY.

/*
CREATE TEMPORARY TABLE senior_jobs_flat_temp AS
SELECT *
FROM staging.job_postings_flat_view
WHERE job_title_short = 'Senior Data Engineer';
*/

SELECT COUNT(*) FROM staging.job_postings_flat_view;
SELECT COUNT(*) FROM staging.job_postings_flat;


SELECT COUNT(*)
FROM staging.job_postings_flat_view
WHERE job_title_short = 'Senior Data Engineer';


DELETE FROM staging.job_postings_flat
WHERE job_posted_date < '2024-01-01';

--
TRUNCATE TABLE staging.job_postings_flat;


SELECT 
* 
FROM 
staging.job_postings_flat
LIMIT 10;


INSERT INTO staging.job_postings_flat
SELECT
    jpf.job_id,
    jpf.company_id,
    jpf.job_title_short,
    jpf.job_title,
    jpf.job_location,
    jpf.job_via,
    jpf.job_schedule_type,
    jpf.job_work_from_home,
    jpf.search_location,
    jpf.job_posted_date,
    jpf.job_no_degree_mention,
    jpf.job_health_insurance,
    jpf.job_country,
    jpf.salary_rate,
    jpf.salary_year_avg,
    jpf.salary_hour_avg,
    cd.name company_name,
    cd.link company_link,
    cd.link_google company_link_google,
    cd.thumbnail company_thumbnail
FROM 
data_jobs.job_postings_fact AS jpf
LEFT JOIN 
data_jobs.company_dim AS cd
    ON 
jpf.company_id = cd.company_id
WHERE jpf.job_posted_date >= '2024-01-01'; 



SELECT COUNT(*) FROM staging.job_postings_flat_view;
SELECT COUNT(*) FROM staging.job_postings_flat;


SELECT COUNT(*)
FROM staging.job_postings_flat_view
WHERE job_title_short = 'Senior Data Engineer';


