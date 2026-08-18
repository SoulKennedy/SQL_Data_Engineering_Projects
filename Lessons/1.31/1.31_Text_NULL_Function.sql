WITH title_lower AS (
    SELECT
        job_title,
        LOWER(TRIM(job_title)) AS job_title_clean,
        job_title_short
    FROM job_postings_fact
)

SELECT
    job_title,
    CASE
        WHEN job_title_clean LIKE '%data%'
             AND job_title_clean LIKE '%analyst%'
            THEN 'Data Analyst'

        WHEN job_title_clean LIKE '%data%'
             AND job_title_clean LIKE '%engineer%'
            THEN 'Data Engineer'

        WHEN job_title_clean LIKE '%data%'
             AND job_title_clean LIKE '%scientist%'
            THEN 'Data Scientist'

        ELSE 'Other'
    END AS job_title_category,
    job_title_short
FROM title_lower
ORDER BY RANDOM()
LIMIT 30;


--NULL FUNCTIONS

SELECT NULLIF(5+5, 20);

SELECT 
    salary_year_avg,
    salary_hour_avg
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL OR salary_hour_avg IS NOT NULL
LIMIT 10;


--- COALESCE FUNCTION
SELECT 
    salary_year_avg,
    salary_hour_avg,
    COALESCE(salary_year_avg, salary_hour_avg * 2080) AS standardised_salary
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL OR salary_hour_avg IS NOT NULL
LIMIT 10;


SELECT 
    salary_year_avg,
    salary_hour_avg,
    COALESCE(salary_year_avg, salary_hour_avg * 2080) AS standardised_salary,
CASE
    WHEN standardised_salary IS NULL THEN 'Missing'
    WHEN COALESCE(salary_year_avg, salary_hour_avg * 2080) < 75_000 THEN 'Low'
    WHEN COALESCE(salary_year_avg, salary_hour_avg * 2080)< 150_000 THEN 'Medium'
    ELSE 'High'
    END AS salary_bucket
FROM job_postings_fact
ORDER BY standardised_salary DESC
LIMIT 35;