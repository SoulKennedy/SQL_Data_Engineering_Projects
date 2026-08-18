SELECT 
    job_posted_date,
    job_posted_date:: DATE AS date,
    job_posted_date:: TIME AS time,
    job_posted_date:: TIMESTAMP AS timestamp,
    job_posted_date:: TIMESTAMPTZ AS timestampz
FROM job_postings_fact
LIMIT 10;

-- EXTRACT function 
SELECT 
    EXTRACT(YEAR FROM job_posted_date) AS job_posted_year,
    EXTRACT(MONTH FROM job_posted_date) AS job_posted_month,
    COUNT(job_id) AS job_count
FROM job_postings_fact
WHERE job_title_short = 'Data Engineer'
GROUP BY 
    EXTRACT(YEAR FROM job_posted_date),
    EXTRACT(MONTH FROM job_posted_date)
ORDER BY 
    job_posted_year,
    job_posted_month;

--- DATE_TRUNC function
SELECT
    job_posted_date,
    DATE_TRUNC('Year', job_posted_date) AS truncated_year,
    DATE_TRUNC('Month', job_posted_date) AS truncated_month,
    DATE_TRUNC('Week', job_posted_date) AS truncated_week,
    DATE_TRUNC('Day', job_posted_date) AS truncated_day,
    DATE_TRUNC('Hour', job_posted_date) AS truncated_hour
FROM job_postings_fact
ORDER BY RANDOM()
LIMIT 10;
-----------------------------
SELECT 
    DATE_TRUNC('Month', job_posted_date) AS job_posted_month,
    COUNT(job_id) AS job_count
FROM job_postings_fact
WHERE job_title_short = 'Data Engineer' AND
        EXTRACT(YEAR FROM job_posted_date) = 2024
GROUP BY 
    DATE_TRUNC('Month', job_posted_date)
ORDER BY 
    job_posted_month;

--- Using AT TIME ZONE
SELECT 
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST'
FROM
    job_postings_fact
LIMIT 10;
 
 SELECT 
    job_title_short,
    job_location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST'
FROM
    job_postings_fact
WHERE
    job_location LIKE 'New York, NY';


 SELECT 
    EXTRACT(HOUR FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST') AS job_posted_hour,
    COUNT(job_id) AS job_count
FROM
    job_postings_fact
WHERE
    job_location LIKE 'New York, NY'
 GROUP BY  
 EXTRACT(HOUR FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST')
 ORDER BY
    job_posted_hour;