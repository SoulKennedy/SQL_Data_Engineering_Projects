SELECT
    table_name, column_name, data_type
FROM information_schema.columns
WHERE table_name = 'job_postings_fact';
 
 DESCRIBE 
 SELECT 
    job_title_short,
    salary_year_avg
FROM 
    job_postings_fact;


SELECT
    job_id:: VARCHAR || '-' || company_id:: VARCHAR as job_company_id,
    job_work_from_home:: INT as job_work_from_home,
    job_posted_date:: DATE as job_posted_date,
    salary_year_avg:: DECIMAL(10, 0) as salary_year_avg
FROM
    job_postings_fact
WHERE
   salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10; 


SELECT
    job_id:: VARCHAR || '-' || company_id:: VARCHAR as job_company_id,
    job_work_from_home:: INT as job_work_from_home,
    job_posted_date:: DATE as job_posted_date,
    salary_year_avg:: DECIMAL(10, 0) as salary_year_avg
FROM
    job_postings_fact
WHERE
   salary_year_avg IS NOT NULL
LIMIT 10;