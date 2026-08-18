-- Subqueries and Common Table Expressions (CTEs) are powerful tools in SQL that allow you to break down complex queries into simpler, more manageable parts. They can help improve the readability and maintainability of your SQL code.
SELECT *
FROM (
    SELECT *
    FROM job_postings_fact
    WHERE salary_year_avg IS NOT NULL
    OR salary_hour_avg IS NOT NULL
)
LIMIT 10;

-- CTE
WITH valid_salaries AS (
    SELECT *
    FROM job_postings_fact
    WHERE salary_year_avg IS NOT NULL
    OR salary_hour_avg IS NOT NULL
)
SELECT *
FROM valid_salaries
LIMIT 10;

-- SUBQURIES
-- Scenario 1: Find median salary for all jobs
SELECT
    job_title_short, 
    salary_year_avg, 
    (
      SELECT MEDIAN (salary_year_avg)
      FROM job_postings_fact
    ) AS market_median_salary
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
LIMIT 10;

-- Scenario 2: Find median salary for remote jobs

SELECT
    job_title_short, 
    MEDIAN(salary_year_avg) AS median_salary, 
    (
      SELECT MEDIAN (salary_year_avg)
      FROM job_postings_fact
      WHERE job_work_from_home = TRUE
    ) AS market_remote_median_salary
FROM 
(
    SELECT 
        job_title_short, 
        salary_year_avg
    FROM job_postings_fact
    WHERE job_work_from_home = TRUE
) AS work_from_home_jobs
WHERE salary_year_avg IS NOT NULL
GROUP BY job_title_short
LIMIT 10;


-- Scenario 3: Find jobs with above-median salaries in the remote market
SELECT
    job_title_short, 
    MEDIAN(salary_year_avg) AS median_salary, 
    (
      SELECT MEDIAN (salary_year_avg)
      FROM job_postings_fact
      WHERE job_work_from_home = TRUE
    ) AS market_remote_median_salary
FROM 
(
    SELECT 
        job_title_short, 
        salary_year_avg
    FROM job_postings_fact
    WHERE job_work_from_home = TRUE
) AS work_from_home_jobs
GROUP BY job_title_short
HAVING MEDIAN (salary_year_avg) > (
      SELECT MEDIAN (salary_year_avg)
      FROM job_postings_fact
      WHERE job_work_from_home = TRUE
    )
LIMIT 10;
 

-- CTE Scenario-----------------------------------------

WITH title_median AS (
    SELECT
    job_title_short,
    job_work_from_home, 
    MEDIAN(salary_year_avg):: INT AS median_salary,
    FROM
    job_postings_fact
    WHERE job_country = 'United States'
    GROUP BY job_title_short, job_work_from_home
)
SELECT 
r.job_title_short,
r.median_salary remote_median_salary,
o.median_salary onsite_median_salary,
(r.median_salary - onsite_median_salary) remote_premium
FROM 
title_median AS r
INNER JOIN title_median AS o
ON r.job_title_short = o.job_title_short
WHERE r.job_work_from_home = TRUE
AND o.job_work_from_home = FALSE
ORDER BY 
remote_premium DESC;

--------------------------Filtering------------------------
 SELECT * FROM RANGE(3) AS src(key);

 SELECT * FROM RANGE(2) AS tgt(key);

 SELECT * FROM RANGE(3) AS src(key)
 WHERE EXISTS (
    SELECT 1
    FROM RANGE(2) AS tgt(key)
    WHERE tgt.key = src.key
 );

 SELECT * FROM RANGE(3) AS src(key)
 WHERE NOT EXISTS (
    SELECT 1
    FROM RANGE(2) AS tgt(key)
    WHERE tgt.key = src.key
 );
------------------------------------------------------------
/* Identify job postings that have no associated skills before loading them into a data mart
*/-----------------------------------------------------------
SELECT *
FROM job_postings_fact
ORDER BY job_id
LIMIT 10;

SELECT *
FROM skills_job_dim
LIMIT 40;


SELECT tgt.*
FROM job_postings_fact AS tgt
WHERE NOT EXISTS (
    SELECT 1
    FROM skills_job_dim AS src
    WHERE tgt.job_id = src.job_id
)
ORDER BY tgt.job_id
LIMIT 15;

 SELECT COUNT(*) AS matched_jobs
            FROM job_postings_fact AS tgt
            WHERE EXISTS (
                SELECT 1
                FROM skills_job_dim AS src
                WHERE tgt.job_id = src.job_id 
            );