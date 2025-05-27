--NOTE : CTEs can be reffered in other query and CTEs and used for complex
--queries while subquery is used for lesss complex or simple queries


/*problem no 7
find the count of the no. of remote job postings per skill
display 5 top skills by thier demand in remote jobs and for data anlyst role
include skill_id , name and count of postings requiring the skills
note i have calculated percentage of jobs posted
*/

--Option 1: Using a CTE for total_jobs
--Here’s the correct approach using a separate CTE:


WITH remote_jobs AS (
    SELECT
        skills_job_dim.skill_id AS skill_id,
        COUNT(*) AS job_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    WHERE job_work_from_home IS TRUE
    AND job_title_short = 'Data Analyst'
    GROUP BY skill_id
),

skill_jobs AS (
    SELECT
        job_count,
        skills_dim.skills
    FROM remote_jobs
    INNER JOIN skills_dim ON remote_jobs.skill_id = skills_dim.skill_id
    ORDER BY job_count DESC
),

total_jobs AS (
    SELECT SUM(job_count) AS total_jobs
    FROM skill_jobs
)

SELECT
    skill_jobs.job_count,
    skill_jobs.skills,
    total_jobs.total_jobs,
    (skill_jobs.job_count / total_jobs.total_jobs) * 100 AS percentage_jobs
FROM skill_jobs, total_jobs;
--Option 2: Inline Subquery
--Alternatively, you can place the total_jobs calculation directly in the SELECT statement:

WITH remote_jobs AS (
    SELECT
        skills_job_dim.skill_id AS skill_id,
        COUNT(*) AS job_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    WHERE job_work_from_home IS TRUE
    AND job_title_short = 'Data Analyst'
    GROUP BY skill_id
),

skill_jobs AS (
    SELECT
        job_count,
        skills_dim.skills
    FROM remote_jobs
    INNER JOIN skills_dim ON remote_jobs.skill_id = skills_dim.skill_id
    ORDER BY job_count DESC
)

SELECT
    skill_jobs.job_count,
    skill_jobs.skills,
    (SELECT SUM(job_count) FROM skill_jobs) AS total_jobs,
    (skill_jobs.job_count / (SELECT SUM(job_count) FROM skill_jobs)) * 100 AS percentage_jobs
FROM skill_jobs;


--3rd option my written course
WITH remote_jobs AS(
SELECT
skills_job_dim.skill_id AS skill_id,
count(*) AS job_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id =
skills_job_dim.job_id
WHERE job_work_from_home IS TRUE
AND job_title_short = 'Data Analyst'
GROUP BY
skill_id
),

skill_jobs AS (
SELECT
job_count,
skills_dim.skills
from remote_jobs
INNER JOIN skills_dim ON remote_jobs.skill_id =
skills_dim.skill_id
ORDER BY
job_count DESC)


SELECT
skill_jobs.job_count,
skill_jobs.skills,
total_jobs.total_jobs,
(skill_jobs.job_count/total_jobs.total_jobs)*100 AS percentage_jobs
FROM skill_jobs, (
SELECT SUM(job_count) AS total_jobs
FROM skill_jobs
) AS total_jobs


--4th option i have written the most optimzed
--just one CTE and calculation of percentage in subquery

with job as(
SELECT 
sjd.skill_id,
count(*) as jobs
from skills_job_dim sjd
inner join job_postings_fact jpf
ON sjd.job_id = jpf.job_id
where job_work_from_home = true AND job_title_short = 'Data Analyst'
GROUP BY skill_id)

SELECT
j.skill_id,
j.jobs,
sd.skills,
(jobs/(select sum(jobs) from job) * 100) as percent_jobs
from job j
inner join skills_dim sd
on j.skill_id = sd.skill_id
ORDER BY j.jobs DESC
limit 5

--find the comapnies that have the most job openings
--BY CTE OPTION 1
with job_count as
(SELECT 
company_id,
count(*) as jobs
from job_postings_fact
GROUP BY company_id
ORDER BY company_id)


SELECT
cd.name,
jc.jobs
from company_dim as cd
left join job_count as jc ON cd.company_id = jc.company_id
ORDER BY jobs DESC

-- OPTION 2 FOR ABOVE PROBLEM
-- by Sunquery
SELECT
    cd.name,
    jc.jobs
FROM 
    company_dim AS cd
LEFT JOIN 
    (SELECT 
        company_id,
        COUNT(*) AS jobs
     FROM 
        job_postings_fact
     GROUP BY 
        company_id
     ORDER BY 
        company_id) AS jc
ON 
    cd.company_id = jc.company_id
ORDER BY 
    jc.jobs DESC;
