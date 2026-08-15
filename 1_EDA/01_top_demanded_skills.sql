/*
    This query is used to find the top 10 most in-demand skills for Data Engineers who work from home, based on job posting frequencies.
    It joins the job_postings_fact table with the skills_job_dim and skills_dim tables to get the relevant skill information.
    The results are filtered to include only those job postings where the job title is 'Data Engineer' and the job allows working from home.
    The results are grouped by skill, and the final output is ordered by demand count in descending order, showing the top 10 skills.
*/
SELECT
    sd.skills,
    COUNT(jpf.*) AS demand_count 
FROM
    job_postings_fact AS jpf
INNER JOIN
  skills_job_dim AS sjd
ON
    jpf.job_id = sjd.job_id
INNER JOIN
    skills_dim AS sd
ON
    sjd.skill_id = sd.skill_id
WHERE
    job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = TRUE
GROUP BY
    sd.skills
ORDER BY
    demand_count DESC
LIMIT 10;


/* 
Top 10 most in-demand data engineering skills based on job posting frequencies.
SQL and Python lead by a wide margin (~29k listings each), followed by top cloud 
platforms (AWS, Azure) and big data processing tools (Spark, Airflow).

Essential Foundation: SQL and Python lead all demand by a massive margin.
Cloud Rankings: AWS leads, followed by Azure, with GCP lagging.
Processing & Orchestration: Spark and Airflow dominate infrastructure tooling. 
Warehousing Split: Snowflake and Databricks share similar mid-tier demand.
┌────────────┬──────────────┐
│   skills   │ demand_count │
│  varchar   │    int64     │
├────────────┼──────────────┤
│ sql        │        29221 │
│ python     │        28776 │
│ aws        │        17823 │
│ azure      │        14143 │
│ spark      │        12799 │
│ airflow    │         9996 │
│ snowflake  │         8639 │
│ databricks │         8183 │
│ java       │         7267 │
│ gcp        │         6446 │
└────────────┴──────────────┘
  10 rows         2 columns
*/

