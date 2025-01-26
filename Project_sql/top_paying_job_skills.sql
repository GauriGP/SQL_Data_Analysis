/*
Q. what skills are required for the top paying data analyst jobs?
- use the top 10 highest paying data analyst jobs from first query
- why? it provides a detailed look at which high-paying jobs demand certain skills,
  helping job seekers understand which skills to devlop that align with top salaries
*/

WITH top_paying_jobs AS (

    SELECT
        job_id,
        job_title,
        salary_year_avg,
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
)

SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim on top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY 
    salary_year_avg DESC

/* final result
The analysis of the skills column shows the top 10 most commonly required skills for data analyst roles:

SQL - 8 mentions
Python - 7 mentions
Tableau - 6 mentions
R - 4 mentions
Snowflake - 3 mentions
Pandas - 3 mentions
Excel - 3 mentions
Azure - 2 mentions
Confluence - 2 mentions
Go - 2 mentions
This suggests that SQL, Python, and Tableau are the most sought-after skills for data analysts in the job postings analyzed.
*/