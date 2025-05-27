/*

What are the top skills based on salary?

Look at the average salary associated with each skill for Data Analyst positions
Focuses on roles with specified salaries, regardless of location
Why? It reveals how different skills impact salary levels for Data Analysts and helps 
identify the most financially rewarding skills to acquire or improve
*/


SELECT
    skills,
    ROUND(AVG(salary_year_avg),0) AS avg_salary
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_work_from_home = True
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25;

/*
Key Trends and Insights:

1.Big Data and Cloud Expertise are Highly Valued: 
Skills like PySpark, Couchbase, DataRobot, Databricks,
and GCP are among the highest paying, indicating a strong demand for data analysts who can work with large datasets
and cloud-based analytical platforms. This suggests that companies are investing heavily in scalable data solutions.

2.Programming Proficiency is Crucial:
Python-related libraries (PySpark, Pandas, NumPy, Scikit-learn) 
are well-represented and command high salaries, reinforcing Python's dominance in data analysis and machine learning.
GoLang and Scala also appear, pointing to the value of diverse programming skills for performance-critical applications.

3.DevOps and MLOps are Emerging as Key Areas: 
Skills like Bitbucket, GitLab, Kubernetes, Airflow, and Jenkins,
while traditionally associated with software development and operations, are appearing on this list.
This suggests that data analysts are increasingly expected to contribute to the deployment, orchestration, 
and automation of data pipelines and machine learning models (MLOps).

4.Familiarity with Modern Data Tools:
The presence of Elasticsearch (for search and analytics), Jupyter (for interactive computing),
and PostgreSQL (relational database) indicates the importance of knowing modern tools for data storage, 
querying, and exploration.

5.AI and Machine Learning Integration:
Watson, DataRobot, and Scikit-learn highlight the growing expectation for data analysts to not just analyze data 
but also to build, deploy, and interpret machine learning models.

6.Version Control and Collaboration Skills: 
Bitbucket and GitLab underscore the need for data analysts to be proficient in version control systems,
crucial for collaborative development and managing code changes in data projects.

7.Operational and Deployment Understanding: Skills like Linux and Kubernetes suggest that data analysts 
who understand underlying infrastructure and deployment environments are more valuable, 
as they can contribute to the end-to-end lifecycle of data products.