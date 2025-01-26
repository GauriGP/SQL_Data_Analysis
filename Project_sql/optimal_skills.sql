WITH skills_demand AS (
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        count(skills_job_dim.job_id) as demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short ='Data Analyst' and 
        salary_year_avg is NOT NULL and 
        job_work_from_home = TRUE
    GROUP BY skills_dim.skill_id
),average_salary AS (
    SELECT 
        skills_job_dim.skill_id,
        round (AVG(job_postings_fact.salary_year_avg),0) as avg_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short ='Data Analyst' 
        and salary_year_avg is NOT NULL
        and job_work_from_home = TRUE
    GROUP BY skills_job_dim.skill_id
)

SELECT 
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM 
    skills_demand
INNER JOIN average_salary on skills_demand.skill_id = average_salary.skill_id
WHERE
    demand_count>10
ORDER BY 
    avg_salary DESC,
    demand_count DESC
LIMIT 20