-- COUNT ROWS - AGGREGATION ONLY
SELECT
COUNT(*)
FROM job_postings_fact;

-- COUNT ROWS - WINDOW FUNCTION
SELECT
    job_id,
    COUNT(*) OVER ()
FROM
    job_postings_fact;

----- PARTITION
SELECT
    job_id,
    job_title_short,
    company_id,
    salary_hour_avg,
    ROUND(
        AVG(salary_hour_avg) OVER (
            PARTITION BY job_title_short, company_id
        ),
        2
    ) AS avg_hourly_by_title
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL
ORDER BY RANDOM()
LIMIT 25;

-----------
SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
   RANK() OVER (
        ORDER BY salary_hour_avg DESC
    ) AS rank_hour_salary
FROM 
    job_postings_fact
WHERE 
    salary_hour_avg IS NOT NULL
ORDER BY 
   salary_hour_avg DESC
LIMIT 25;


-------------------- PARTITION AND ORDER BY-----------------
SELECT
    job_posted_date,
    job_title_short,
    salary_hour_avg,
    ROUND(
        AVG(salary_hour_avg) OVER (
            PARTITION BY job_title_short
            ORDER BY job_posted_date
        ),
        2
    ) AS running__title_avg_salary
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL
AND job_title_short = 'Data Engineer'
ORDER BY  job_title_short,
        job_posted_date
LIMIT 25; 

SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
   RANK() OVER (
        PARTITION BY job_title_short
        ORDER BY salary_hour_avg DESC
    ) AS rank_hour_salary
FROM 
    job_postings_fact
WHERE 
    salary_hour_avg IS NOT NULL
ORDER BY 
   salary_hour_avg DESC,
   job_title_short
LIMIT 25;


------------USING LAG FUNCTION-------------
 SELECT
    job_id,
    company_id,
    job_title,
    job_title_short,
    job_posted_date,
    salary_year_avg,
   LAG(salary_year_avg) OVER (
        PARTITION BY company_id
        ORDER BY job_posted_date
    ) AS previous_posting_salary,
    salary_year_avg - LAG(salary_year_avg) OVER (
        PARTITION BY company_id
        ORDER BY job_posted_date
    ) AS salary_change
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
ORDER BY company_id, job_posted_date
LIMIT 60; 

