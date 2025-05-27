SELECT
    job_title_short AS jobs,
    AVG(salary_year_avg) AS salaryAVG,
    COUNT(job_title_short) AS countJOBS
FROM 
    job_postings_fact
GROUP BY
    jobs
HAVING
    COUNT(job_title_short) > 100
ORDER BY
    salaryAVG;