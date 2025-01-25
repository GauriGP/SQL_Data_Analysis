-- Date
SELECT 
    job_title_short as title,
    job_location as location,
    job_posted_date::date as date
FROM 
    job_postings_fact;

-- Time
SELECT 
    job_title_short as title,
    job_location as location,
    job_posted_date at time zone 'UTC' at time zone 'EST' as date_time
FROM 
    job_postings_fact
limit 5;

-- Extract function (month or year or other)
SELECT 
    job_title_short as title,
    job_location as location,
    job_posted_date at time zone 'UTC' at time zone 'EST' as date_time,
    Extract(YEAR FROM job_posted_date) as YEAR
FROM 
    job_postings_fact
limit 5;

-- Practice problem
CREATE table jan_jobs as
    SELECT *
    from job_postings_fact
    where EXTRACT(MONTH from job_posted_date) = 1;

CREATE table feb_jobs as
    SELECT *
    from job_postings_fact
    where EXTRACT(MONTH from job_posted_date) = 2;

CREATE table march_jobs as
    SELECT *
    from job_postings_fact
    where EXTRACT(MONTH from job_posted_date) = 3;

SELECT job_posted_date,job_title_short
FROM feb_jobs

-- case 
SELECT 
    job_title_short,
    job_location,
    case 
        when job_location = 'Anywhere' then 'Remote'
        when job_location = 'New York, NY' then 'local'
        else 'Onsite'
    end as location_category
FROM job_postings_fact
LIMIT 10;

SELECT 
    count(job_id) as number_of_jobs,
    case 
        when job_location = 'Anywhere' then 'Remote'
        when job_location = 'New York, NY' then 'local'
        else 'Onsite'
    end as location_category
FROM job_postings_fact
where job_title_short = 'Data Analyst'
GROUP BY location_category;

-- Practice Problem
SELECT 
    job_title_short,
    salary_year_avg,
    case
        when salary_year_avg > 80000 then 'High'
        when salary_year_avg < 60000 then 'Low'
        else 'Standard'
    end as salary_range
FROM job_postings_fact
where job_title_short = 'Data Analyst' 
and salary_year_avg is not Null
ORDER BY salary_year_avg desc;

-- Subqueries 
SELECT *
FROM (
    SELECT *
    FROM job_postings_fact
    where EXTRACT(MONTH FROM job_posted_date) = 1
) AS JANUARY_JOBS;

SELECT company_id,name as company_name
FROM company_dim
where company_id in ( --subquery start
    SELECT company_id
    FROM job_postings_fact
    where job_no_degree_mention = true
)-- subquery ends

-- CTAs [with] it is basically temparory / virtual table 
with JANUARY_JOBS
As (
    SELECT *
    FROM job_postings_fact
    where EXTRACT(MONTH FROM job_posted_date) = 1
) 
SELECT *
FROM JANUARY_JOBS;

-- to find number of jobs by company
with company_job_count as (
    SELECT company_id,
    count(*) as total_jobs
    FROM job_postings_fact
    GROUP BY company_id
)
SELECT company_dim.name as company_name,
       company_job_count.total_jobs
FROM company_dim
left join company_job_count on company_job_count.company_id = company_dim.company_id
ORDER BY total_jobs desc

-- Practice Problem
/* 
fine the count of the number of remote job posting per skill
    - Display the top 5 skills by their demand in remote jobs
    - Include skill ID, name and count of the postings requiring the skill
*/
with remote_job_skills as (
SELECT 
    skill_id,
    count(*) as skill_count
FROM skills_job_dim as skills_to_jobs
inner join job_postings_fact as job_postings 
on job_postings.job_id = skills_to_jobs.job_id
where job_postings.job_work_from_home = true and job_title_short = 'Data Analyst'
GROUP BY skill_id
)
SELECT remote_job_skills.skill_id,skills as skill_name,remote_job_skills.skill_count
from remote_job_skills
inner join skills_dim on skills_dim.skill_id = remote_job_skills.skill_id
ORDER BY skill_count desc
limit 5 

-- union operators
SELECT job_title_short, company_id, job_location
FROM jan_jobs

UNION

SELECT job_title_short, company_id, job_location
FROM feb_jobs

SELECT job_title_short, company_id, job_location
FROM jan_jobs
where job_title_short = 'Data Analyst'

UNION all

SELECT job_title_short, company_id, job_location
FROM feb_jobs

-- Practice problem
/*
find job posting from the first quater that have a salary greater than 70k
    - Combine job posting table from the first quater os 2023(jan-mar)
    - get job posting with an average yearly salary > 70k
    */
SELECT 
    job_title_short,
    job_location,
    job_via,
    job_posted_date::date,
    salary_year_avg
FROM (
    SELECT *
    FROM jan_jobs
    UNION all
    SELECT *
    FROM feb_jobs
    UNION all
    SELECT * 
    FROM march_jobs
) as Quarter_job_postings
where salary_year_avg > 70000 and
      job_title_short = 'Data Analyst'
ORDER BY salary_year_avg desc