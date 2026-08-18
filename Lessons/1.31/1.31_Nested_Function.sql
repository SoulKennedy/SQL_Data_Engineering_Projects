-------------------ARRAY--------------------------------------------
WITH skills AS (
    SELECT 'Python' AS skill
    UNION ALL
    SELECT 'Sql'
    UNION ALL
    SELECT 'R'
), skills_array AS (
SELECT ARRAY_AGG(skill ORDER BY skill) AS skills
FROM skills
)
SELECT skills[1] AS first_skill
FROM skills_array;

----------------STRUCT -------------------------------------
SELECT {skill: 'Python', type: 'Programming'} AS skil_struct;


WITH skill_struct AS (
    SELECT 
        STRUCT_PACK
        (skill := 'Python', 
        type := 'Programming'
        ) AS s
)
SELECT 
    s.skill,
    s.type
FROM skill_struct;


WITH skill_struct AS (
SELECT 'Python' AS skills, 'Programming' AS types
UNION ALL
SELECT 'Sql', 'Query language'
UNION ALL
SELECT 'R', 'Programming'
)
SELECT 
    STRUCT_PACK
    (
        skill:= skills,
        type:= types
    ) AS s
FROM skill_struct;

----ARRAY OF STRUCTS-------
SELECT [
    {skill: 'Python', type: 'Programming'} ,
    {skill: 'SQL', type: 'query_language'} 
] AS skills_array_of_structs;



WITH skill_struct AS (
SELECT 'Python' AS skills, 'Programming' AS types
UNION ALL
SELECT 'Sql', 'Query language'
UNION ALL
SELECT 'R', 'Programming'
), skills_array_struct AS (
    SELECT 
        ARRAY_AGG(
            STRUCT_PACK
            (
                skill:= skills,
                type:= types
        )
    ) AS array_struct
    FROM skill_struct
)
SELECT
    array_struct[1].skill AS first_item --extracting a value
FROM skills_array_struct;


------JSON {JAVASCRIPT OBJECT NOTATION}---------
 WITH raw_skill_json AS (
    SELECT
        '{"skill":"python", "type":"programming"}'::JSON AS skill_json
)
SELECT 
    STRUCT_PACK(
        skill := json_extract_string(skill_json, '$.skill'),
        type  := json_extract_string(skill_json, '$.type')
    ) AS s
FROM
    raw_skill_json;


------------------------------------------

WITH raw_skill_json AS (
    SELECT [
        '{"skill":"python", "type":"programming"}',
        '{"skill":"SQL", "type":"query_language"}'
    ]::JSON AS skill_json
)
SELECT
    STRUCT_PACK(
        skill := json_extract_string(skill_json, '$.skill'),
        type  := json_extract_string(skill_json, '$.type')
    ) AS s
FROM raw_skill_json,
LATERAL UNNEST(json_extract(skill_json, '$[*]')) AS t(skill);

----------------------------------------------------------
WITH raw_json AS (
    SELECT
        '[{"skill":"python", "type":"programming"},
        {"skill":"sql", "type":"query_language"},
        {"skill":"r", "type":"programming"}
        ]' ::JSON AS skill_json
)
SELECT 
    ARRAY_AGG(
        STRUCT_PACK(
            skill := json_extract_string(e.value, '$.skill'),
            type  := json_extract_string(e.value, '$.type')
        ) 
        ORDER BY json_extract_string(e.value, '$.skill')
    ) AS s
FROM
    raw_json, json_each(skill_json) AS e;


----------------------------- ------------------------------   
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(sd.skills) AS skills_array
FROM job_postings_fact jpf
LEFT JOIN 
        skills_job_dim sjd
    ON
        jpf.job_id = sjd.job_id
LEFT JOIN
        skills_dim sd
    ON
        sd.skill_id = sjd.skill_id
GROUP BY ALL;

-----------------------------------------------------
CREATE OR REPLACE TEMP TABLE job_skill_array AS 
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(sd.skills) AS skills_array
FROM job_postings_fact jpf
LEFT JOIN 
        skills_job_dim sjd
    ON
        jpf.job_id = sjd.job_id
LEFT JOIN
        skills_dim sd
    ON
        sd.skill_id = sjd.skill_id
GROUP BY ALL;

with flat_skills AS (
SELECT
    job_id,
    job_title_short,
    salary_year_avg,
    UNNEST(skills_array) AS skill
FROM 
    job_skill_array
)
SELECT
    skill,
    MEDIAN(salary_year_avg) AS median_salary
FROM
    flat_skills
GROUP BY skill
ORDER BY median_salary DESC
LIMIT 20;

--------------------ARRAY STRUCTS-------------------------------------------
CREATE OR REPLACE TEMP TABLE job_skill_array_struct AS 
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
   ARRAY_AGG(
        STRUCT_PACK(
                skill_type := sd.type,
                skill_name:= sd.skills
            )
        ) AS array_of_structs
FROM job_postings_fact jpf
LEFT JOIN 
        skills_job_dim sjd
    ON
        jpf.job_id = sjd.job_id
LEFT JOIN
        skills_dim sd
    ON
        sd.skill_id = sjd.skill_id
GROUP BY ALL;


SELECT
    job_id,
   job_title_short,
    salary_year_avg,
    UNNEST(array_of_structs).skill_type AS skill_type,
     UNNEST(array_of_structs).skill_name AS skill_name
FROM
    job_skill_array_struct;



----------------------------------------------------------

WITH flat_skills AS (
    SELECT
    job_id,
   job_title_short,
    salary_year_avg,
    UNNEST(array_of_structs).skill_type AS skill_type,
     UNNEST(array_of_structs).skill_name AS skill_name
FROM
    job_skill_array_struct
)
SELECT
    skill_type,
    MEDIAN(salary_year_avg) AS median_salary
FROM
    flat_skills
GROUP BY skill_type;