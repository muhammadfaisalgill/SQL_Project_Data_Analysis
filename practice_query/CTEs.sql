-- can reference within a SELECT, INSERT, UPDATE, DELETE
--Defined with WITH
--Used for more complex queriesS
/*
CTEs-Common Table Expression
Notes:
·CTE - A temporary result set that you can reference 
within a SELECTI NSERT UPDATE or DELETE statement.
Exists only during the execution of a query
·It's a defined query that can be referenced in the main query 
or other CTEs
WITH-used to define CTE at the beginning of a query.

*/
WITH january_jobs AS(
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT (MONTH FROM job_posted_date)=1
)

SELECT *
FROM january_jobs

--CTE
--find the comapnies that have the most job openings
WITH company_job_count AS(
SELECT
    company_id,
    COUNT(*) AS total_jobs
FROM
    job_postings_fact
GROUP BY(company_id)
)




SELECT 
    company_dim.name AS company_name,
    company_job_count.total_jobs

FROM company_dim
LEFT JOIN company_job_count ON company_dim.company_id = company_job_count.company_id
ORDER BY
    total_jobs DESC;

    
WITH company_job_count AS (
    SELECT
        company_id,
        COUNT(*) AS total_jobs
    FROM
        job_postings_fact
    GROUP BY
        company_id
)

SELECT 
    company_dim.name AS company_name,
    company_job_count.total_jobs
FROM 
    company_dim
LEFT JOIN 
    company_job_count 
ON 
    company_dim.company_id = company_job_count.company_id;

/*problem no 7
find the count of the no. of remote job postings per skill
display 5 top skills by thier demand in remote jobs and for data anlyst role
include skill_id , name and count of postings requiring the skills
*/



WITH Remote_job_skill AS(
SELECT
    skill_id,
    COUNT(*) AS skill_count
FROM
    skills_job_dim AS skills_to_job
INNER JOIN job_postings_fact AS job_postings ON skills_to_job.job_id = job_postings.job_id
WHERE
    
    job_postings.job_work_from_home = True AND
    job_postings.job_title_short = 'Data Analyst'
GROUP BY
    skill_id
)

SELECT
    Remote_job_skill.skill_id,
    Remote_job_skill.skill_count,
    skills_dim.skills
FROM
    skills_dim
INNER JOIN Remote_job_skill ON
skills_dim.skill_id = Remote_job_skill.skill_id
ORDER BY
    skill_count DESC
LIMIT 5;


/*
You can also define multiple CTEs and even reference one CTE inside another.

sql
Copy code

WITH high_salary_employees AS (
    SELECT id, name, department, salary
    FROM employees
    WHERE salary > 50000
),
department_avg_salary AS (
    SELECT department, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department
)
SELECT hse.name, hse.salary, das.avg_salary
FROM high_salary_employees hse
JOIN department_avg_salary das
ON hse.department = das.department;
Here:

The first CTE, high_salary_employees, filters employees with high salaries.
The second CTE, department_avg_salary, calculates the average salary for each department.
The main query joins both CTEs to list the high-salary employees along with their department's average salary.
CTEs can simplify complex queries and make them easier to manage.
*/