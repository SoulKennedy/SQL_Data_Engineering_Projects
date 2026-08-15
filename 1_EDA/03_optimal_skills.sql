/* 
This query calculates the optimal skills for a Data Engineer role based on salary and demand. 
It joins the job postings fact table with the skills dimension tables to aggregate data on skills, median salary, and demand count. 
The optimal score is calculated as the product of the median salary and the natural logarithm of the demand count, normalized to millions. 
The results are filtered to include only skills with more than 100 job postings and are ordered by the optimal score in descending order, returning the top 25 skills.
*/

SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg),0) AS median_salary,
    COUNT(jpf.salary_year_avg) AS demand_count,
    ROUND(LN(COUNT(jpf.*)),1) AS log_demand_count,
    ROUND(MEDIAN(jpf.salary_year_avg) * LN(COUNT(jpf.*))/1_000_000,2) AS optimal_score
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
    AND jpf.salary_year_avg IS NOT NULL
GROUP BY
    sd.skills
HAVING 
    COUNT(jpf.*) > 100
ORDER BY
    optimal_score DESC
LIMIT 25;

/*
Here's a breakdown of the optimal score identified skills offering the strongest balance between earning potential and market demand.

*Terraform ranks #1 (0.97), combining a high $184K median salary with solid demand.
*Python (0.95) and SQL (0.91) stand out for their very high demand, despite lower median salaries.
*AWS (0.91) provides another strong combination of compensation and demand.
*Airflow (0.89) and Spark (0.87) offer attractive salaries with moderate demand.
Overall, Terraform offers the best salary-demand trade-off, while Python and SQL provide the strongest volume of opportunities.

   skills   │ median_salary │ demand_count │ log_demand_count │ optimal_score │
│  varchar   │    double     │    int64     │      double      │    double     │
├────────────┼───────────────┼──────────────┼──────────────────┼───────────────┤
│ terraform  │      184000.0 │          193 │              5.3 │          0.97 │
│ python     │      135000.0 │         1133 │              7.0 │          0.95 │
│ aws        │      137320.0 │          783 │              6.7 │          0.91 │
│ sql        │      130000.0 │         1128 │              7.0 │          0.91 │
│ airflow    │      150000.0 │          386 │              6.0 │          0.89 │
│ spark      │      140000.0 │          503 │              6.2 │          0.87 │
│ kafka      │      145000.0 │          292 │              5.7 │          0.82 │
│ snowflake  │      135500.0 │          438 │              6.1 │          0.82 │
│ azure      │      128000.0 │          475 │              6.2 │          0.79 │
│ java       │      135000.0 │          303 │              5.7 │          0.77 │
│ scala      │      137290.0 │          247 │              5.5 │          0.76 │
│ kubernetes │      150500.0 │          147 │              5.0 │          0.75 │
│ git        │      140000.0 │          208 │              5.3 │          0.75 │
│ databricks │      132750.0 │          266 │              5.6 │          0.74 │
│ redshift   │      130000.0 │          274 │              5.6 │          0.73 │
│ gcp        │      136000.0 │          196 │              5.3 │          0.72 │
│ nosql      │      134415.0 │          193 │              5.3 │          0.71 │
│ hadoop     │      135000.0 │          198 │              5.3 │          0.71 │
│ pyspark    │      140000.0 │          152 │              5.0 │           0.7 │
│ docker     │      135000.0 │          144 │              5.0 │          0.67 │
│ mongodb    │      135750.0 │          136 │              4.9 │          0.67 │
│ r          │      134775.0 │          133 │              4.9 │          0.66 │
│ go         │      140000.0 │          113 │              4.7 │          0.66 │
│ github     │      135000.0 │          127 │              4.8 │          0.65 │
│ bigquery   │      135000.0 │          123 │              4.8 │          0.65 │
└────────────┴───────────────┴──────────────┴──────────────────┴───────────────┘
  25 rows                                                            5 columns
*/