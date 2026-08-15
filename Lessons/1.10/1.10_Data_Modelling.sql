SELECT
  job_id,
  job_title_short,
  job_location,
  job_via,
  salary_year_avg,
FROM
  job_postings_fact
LIMIT 10;

SELECT
    company_id,
    name
FROM
    company_dim
LIMIT 10;

SELECT
    *
FROM
    company_dim
WHERE
    NAME IN ('Google', 'Microsoft', 'Amazon', 'Facebook', 'Apple');


SELECT
    *
FROM
    skills_job_dim
limit 5;    

SELECT
    *
FROM
    skills_dim
limit 5;  

 SELECT table_name, column_name, data_type
FROM information_schema.columns
WHERE table_catalog = 'data_jobs';


 SELECT *FROM information_schema.table_constraints
WHERE table_catalog = 'data_jobs';


PRAGMA show_tables_expanded;

DESCRIBE TABLE job_postings_fact;


 