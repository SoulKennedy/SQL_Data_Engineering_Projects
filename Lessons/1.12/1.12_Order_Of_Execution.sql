
explain analyze
select
    cd.name as company_name,
    count(jpf.*) as job_postings_count
from job_postings_fact jpf
left join company_dim cd
    on jpf.company_id = cd.company_id
where jpf.job_country = 'United States'
group by cd.name
having count(jpf.*) > 3000
order by job_postings_count desc;

 