/*
    This query is used to find the top 25 highest paying skills for Data Engineers who work from home, based on median salary and demand count.
    It joins the job_postings_fact table with the skills_job_dim and skills_dim tables to get the relevant skill information.
    The results are filtered to include only those job postings where the job title is 'Data Engineer' and the job allows working from home.
    The results are grouped by skill, and only those skills with more than 100 job postings are included in the final output.
    The final output is ordered by median salary in descending order, showing the top 25 skills.
*/
SELECT
    sd.skills,
   ROUND(MEDIAN(jpf.salary_year_avg),0) AS median_salary,
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
HAVING 
    COUNT(jpf.*) > 100
ORDER BY
    median_salary DESC
LIMIT 25;

/*
Top 25 highest paying data engineering skills based on median salary and job posting frequencies.
Key Insights:
* Rust has the highest median salary at $210K, but relatively low demand (232).
* Golang & Terraform both reach $184K; Terraform stands out with much higher demand (3,248).
* Terraform offers the strongest balance of high salary + high demand.
* Airflow has the highest demand (9,996) but a lower median salary of $150K.
* Neo4j, GDPR, and GraphQL show that specialized skills can command high salaries despite lower demand.

Overall, salary does not directly correlate with demand—specialization appears to carry a salary premium.
────────────┬───────────────┬──────────────┐
│   skills   │ median_salary │ demand_count │
│  varchar   │    double     │    int64     │
├────────────┼───────────────┼──────────────┤
│ rust       │      210000.0 │          232 │
│ golang     │      184000.0 │          912 │
│ terraform  │      184000.0 │         3248 │
│ spring     │      175500.0 │          364 │
│ neo4j      │      170000.0 │          277 │
│ gdpr       │      169616.0 │          582 │
│ zoom       │      168438.0 │          127 │
│ graphql    │      167500.0 │          445 │
│ mongo      │      162250.0 │          265 │
│ fastapi    │      157500.0 │          204 │
│ django     │      155000.0 │          265 │
│ bitbucket  │      155000.0 │          478 │
│ crystal    │      154224.0 │          129 │
│ atlassian  │      151500.0 │          249 │
│ c          │      151500.0 │          444 │
│ typescript │      151000.0 │          388 │
│ kubernetes │      150500.0 │         4202 │
│ airflow    │      150000.0 │         9996 │
│ node       │      150000.0 │          179 │
│ css        │      150000.0 │          262 │
│ ruby       │      150000.0 │          736 │
│ redis      │      149000.0 │          605 │
│ vmware     │      148798.0 │          136 │
│ ansible    │      148798.0 │          475 │
│ jupyter    │      147500.0 │          400 │
└────────────┴───────────────┴──────────────┘
  25 rows                         3 columns
*/