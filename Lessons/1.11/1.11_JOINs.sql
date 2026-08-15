-- LEFT JOIN Example
SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.company_id,
    cd.name AS company_name,
    jpf.job_location
FROM 
    job_postings_fact AS jpf
LEFT JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id
LIMIT 10;


-- Right Join Example
SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.company_id,
    cd.name AS company_name,
    jpf.job_location
FROM 
    job_postings_fact AS jpf
RIGHT JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id;


-- INNER JOIN Example
SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.company_id,
    cd.name AS company_name,
    jpf.job_location
FROM 
    job_postings_fact AS jpf
INNER JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id
LIMIT 10;


-- FULL OUTER JOIN Example
SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.company_id,
    cd.name AS company_name,
    jpf.job_location
FROM 
    job_postings_fact AS jpf
FULL OUTER JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id
LIMIT 10;

SELECT
   *
FROM 
    skills_job_dim
lIMIT 10;


SELECT
   *
FROM 
    skills_dim
lIMIT 10;

select
    jpf.job_id,
    jpf.job_title_short,
    sjd.skill_id,
    sd.skills
from
    job_postings_fact as jpf
join
    skills_job_dim as sjd
on
    jpf.job_id = sjd.job_id
join
    skills_dim as sd
on
    sjd.skill_id = sd.skill_id
limit 10;

select
    jpf.job_id,
    jpf.job_title_short,
    sjd.skill_id,
    sd.skills
from
    job_postings_fact as jpf
left join
    skills_job_dim as sjd
on
    jpf.job_id = sjd.job_id
left join
    skills_dim as sd
on
    sjd.skill_id = sd.skill_id
limit 10;