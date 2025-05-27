SELECT column_name, data_type
from information_schema.columns
where table_name = 'job_postings_fact';

--problem no 1
/* GET job details for both data analyst or business analyst

for business analyst  i want jobs > $70k
for data analyst i want > $100k

only include jobs located in  Either 'Boston, MA'
or 'Anywhere' (remotejobs)
*/
SELECT job_title_short, 
salary_year_avg, 
job_location
FROM job_postings_fact
where job_location IN ('Boston, MA', 'Anywhere') 
AND (
        (job_title_short = 'Data Analyst' AND salary_year_avg > 100000) 
        OR (job_title_short = 'Business Analyst' AND salary_year_avg > 70000)
    )


--Problem NO#2
/*
Question:
Look for non-senior data analyst or business analyst roles

·Only get job titles that include either 'Data' or 'Business'
·Also include those with 'Analyst' in any part of the title
·Don't include any job titles with 'Senior' followed by any character

Get the job title, location, and average yearly salary
*/
SELECT job_title ,
job_location,
salary_year_avg AS average_yearly_salary
FROM  job_postings_fact
where (job_title LIKE '%Data%' OR job_title LIKE '%Business%') AND job_title LIKE '%Analyst%'
AND job_title NOT LIKE '%Senior%'

--problem no 3
/*
note not executable in this vs code
visit link https://sqliteviz.com/app/#/workspace?hide_schema=1
SELECT 
    project_id, 
    SUM(hours_spent * hours_rate) AS original_rate,
    SUM(hours_spent * (hours_rate + 5)) AS raised_price,
    SUM(hours_spent * (hours_rate + 5)) - SUM(hours_spent * hours_rate) AS price_difference
FROM 
    invoices_fact
GROUP BY 
    project_id;
*/

--problem 5
/*

find average salary and number of job postings for each skill

*/
SELECT
sd.skills,
count(sjd.job_id) as number_of_jobs,
AVG(jpf.salary_year_avg) as average_salary
from skills_dim as sd
left join skills_job_dim as sjd ON sd.skill_id = sjd.skill_id
left join job_postings_fact as jpf ON sjd.job_id = jpf.job_id
group by sd.skills
order by average_salary DESC


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



/*problem no 7
find the count of the no. of remote job postings per skill
display 5 top skills by thier demand in remote jobs and for data anlyst role
include skill_id , name and count of postings requiring the skills
*/

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

-- note percentage i have included myself in subquery
--you can learn from CTEs and query further more regarding subquery and CTEs


/*
find job postings from first quarter from jan to march where data analyst
salary is greater that 70K dollars
*/

SELECT company_id,
job_title_short,
job_location,
job_via,
salary_year_avg
FROM (
SELECT * 
FROM january_jobs
UNION ALL
SELECT * 
FROM february_jobs
UNION ALL
SELECT * 
FROM march_jobs)
WHERE salary_year_avg > 70000 AND job_title_short = 'Data Analyst'
ORDER BY salary_year_avg DESC

/* problem no 8.
find the job postings from first quarter(jan feb march) that have salary greater than 70k
and job title is data analyst*/


SELECT
job_title_short,
job_via,
job_location,
salary_year_avg,
job_posted_date:: DATE
FROM 
    (SELECT *
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs) AS quarter_job_postings
WHERE salary_year_avg > 70000 AND
job_title_short = 'Data Analyst'
ORDER BY salary_year_avg DESC;


/* now same question above with CTE*/



WITH quarter_job_postings AS (
    SELECT *
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs)
SELECT
job_title_short,
job_via,
job_location,
salary_year_avg,
job_posted_date:: DATE
FROM quarter_job_postings
WHERE salary_year_avg > 70000 AND
job_title_short = 'Data Analyst'
ORDER BY salary_year_avg DESC;