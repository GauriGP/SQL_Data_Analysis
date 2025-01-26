/*
Q. : what are the top paying jobs?
- Identify the top 10 highest paying data analyst roles that are available remotely.
- Focuses on job posting with specific salaries (remove nulls).
- why? highlight the top paying opportunities for data analysts, offering insight into emmployment
*/

SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name as company_name
FROM
    job_postings_fact
LEFT JOIN company_dim on job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_title_short = 'Data Analyst' and job_location = 'Anywhere'
    and salary_year_avg is not NULL
ORDER BY 
    salary_year_avg DESC
LIMIT 10