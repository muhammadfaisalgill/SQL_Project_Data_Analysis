# Introduction

Dive into the data job market! Focusing on data analyst roles, this project explores 💰 top-paying jobs, 🔥 in-demand skills, and 📈 where high demand meets high salary in data analytics.

🔎 SQL queries? Check them out here: [SQL_Project_Data_Analysis folder](/SQL_Project_Data_Analysis/)
# Background
Driven by a quest to navigate the data analyst job market more effectively, this project was born from a desire to pinpoint top-paid and in-demand skills, streamlining others' work to find optimal jobs.

Data hails from this site [SQL Course](https://www.lukebarousse.com/sql). It's packed with insights on job titles, salaries, locations, and essential skills.

## The questions I wanted to answer through my SQL queries were:
1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?
# Tools I Used

For my deep dive into the data analyst job market, I harnessed the power of several key tools:

- **SQL:** The backbone of my analysis, allowing me to query the database and unearth critical insights.
- **PostgreSQL:** The chosen database management system, ideal for handling the job posting data.
- **Visual Studio Code:** My go-to for database management and executing SQL queries.
- **Git & GitHub:** Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.
# The Analysis

Each query for this project aimed at investigating specific aspects of the data analyst job market. Here's how I approached each question:


### Top Paying Data Analyst Jobs
To identify the highest-paying roles I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field.
```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```
Here's the breakdown of the top data analyst jobs in 2023:

- **Wide Salary Range:** Top 10 paying data analyst roles span from $184,000 to $650,000, indicating significant salary potential in the field.
- **Diverse Employers:** Companies like SmartAsset, Meta, and AT&T are among those offering high salaries, showing a broad interest across different industries.
- **Job Title Variety:** There's a high diversity in job titles, from Data Analyst to Director of Analytics, reflecting varied roles and specializations within data analytics.


![Top Paying Roles](/Visuals%20and%20plots/top_10_jobs_Data_analyst.png)

*Bar graph visualizing the salary for the top 10 salaries for data analysts; ChatGPT generated this graph from my SQL query results*

### Skills for Top Paying jobs

To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.

```sql
WITH top_paying_jobs AS(
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE 
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)
SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC;
```
![Skills for Top Paying Jobs for Data Analyst](/Visuals%20and%20plots/top_paying_job_skills.png)

*This Plot shows the Most sought after skills for Top Data Analysts Jobs*

🧠 Insights
1. SQL is the most requested skill, essential for querying and managing data—fundamental for any data analyst.

2. Python is a close second, highlighting the importance of scripting and automation for data analysis.

3. Tableau is the leading visualization tool in demand, showing how critical data storytelling and dashboarding are.

4. R is still valued, especially in roles with a statistical or research focus.

5. Tools like Snowflake, Excel, and Pandas reflect the demand for both traditional and modern data handling tools.

### In-Demand Skills for Data Analysts

This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.

```sql
SELECT
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst' AND
    job_work_from_home = True
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;
```

| skills | demand_count |
|:---------|:---------------|
| sql | 7291 |
| excel | 4611 |
| python | 4330 |
| tableau | 3745 |
| power bi | 2609 |

- **Most In-Demand Skill:** SQL stands out as the most in-demand skill, with a demand_count of 7291, indicating its critical importance in the current job market.

- **Overall Demand:** Other skills like Excel, Python, and Tableau also show substantial demand, with counts of 4611, 4330, and 3745, respectively.

![Top 5 Skills for Data Analysts](/Visuals%20and%20plots/top_demanded_skills.png)


### Skills Based On Salary
Here is the Query for listing the skills, based on Highest Salaries

```sql
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
```
*Table showing the Top 25 skills based on High Salary*

| skills        | avg_salary   |
|:--------------|:-------------|
| pyspark       | $208,172     |
| bitbucket     | $189,155     |
| couchbase     | $160,515     |
| watson        | $160,515     |
| datarobot     | $155,486     |
| gitlab        | $154,500     |
| swift         | $153,750     |
| jupyter       | $152,777     |
| pandas        | $151,821     |
| elasticsearch | $145,000     |
| golang        | $145,000     |
| numpy         | $143,513     |
| databricks    | $141,907     |
| linux         | $136,508     |
| kubernetes    | $132,500     |
| atlassian     | $131,162     |
| twilio        | $127,000     |
| airflow       | $126,103     |
| scikit-learn  | $125,781     |
| jenkins       | $125,436     |
| notion        | $125,000     |
| scala         | $124,903     |
| postgresql    | $123,879     |
| gcp           | $122,500     |
| microstrategy | $121,619     |

#### Insights from the above Table

1. Big Data and Cloud Expertise are Highly Valued: 
Skills like PySpark, Couchbase, DataRobot, Databricks,
and GCP are among the highest paying, indicating a strong demand for data analysts who can work with large datasets
and cloud-based analytical platforms. This suggests that companies are investing heavily in scalable data solutions.

2. Programming Proficiency is Crucial:
Python-related libraries (PySpark, Pandas, NumPy, Scikit-learn) 
are well-represented and command high salaries, reinforcing Python's dominance in data analysis and machine learning.
GoLang and Scala also appear, pointing to the value of diverse programming skills for performance-critical applications.

3. DevOps and MLOps are Emerging as Key Areas: 
Skills like Bitbucket, GitLab, Kubernetes, Airflow, and Jenkins,
while traditionally associated with software development and operations, are appearing on this list.
This suggests that data analysts are increasingly expected to contribute to the deployment, orchestration, 
and automation of data pipelines and machine learning models (MLOps).

4. Familiarity with Modern Data Tools:
The presence of Elasticsearch (for search and analytics), Jupyter (for interactive computing),
and PostgreSQL (relational database) indicates the importance of knowing modern tools for data storage, 
querying, and exploration.

5. AI and Machine Learning Integration:
Watson, DataRobot, and Scikit-learn highlight the growing expectation for data analysts to not just analyze data 
but also to build, deploy, and interpret machine learning models.

6. Version Control and Collaboration Skills: 
Bitbucket and GitLab underscore the need for data analysts to be proficient in version control systems,
crucial for collaborative development and managing code changes in data projects.

7. Operational and Deployment Understanding: Skills like Linux and Kubernetes suggest that data analysts 
who understand underlying infrastructure and deployment environments are more valuable, 
as they can contribute to the end-to-end lifecycle of data products.

### Optimal Skills
The following Query will fetch the results of the Optimal Skills which are in Demand and High paying Jobs.

```sql
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.skill_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_work_from_home = True AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.skill_id) > 10
ORDER BY
     avg_salary DESC,
    demand_count DESC
LIMIT 25;
```

*Here are some key Insights*
1. Most In-Demand Skills
Python leads significantly with 236 job postings, followed by:

| **Skill**     | **Job Postings** |
| ------------- | ---------------- |
| **Tableau**   | 230              |
| **R**         | 148              |
| **SAS**       | 63               |
| **Looker**    | 49               |
| **Oracle**    | 37               |
| **Snowflake** | 37               |


These tools/skills are essential in data science, analytics, and engineering roles.

2. Highest Paying Skills
Go has the highest average salary at $115,320, despite modest demand (27 postings).

Other high-paying skills:

| **Skill**      | **Average Salary (USD)** |
| -------------- | ------------------------ |
| **Confluence** | \$114,210                |
| **Hadoop**     | \$113,193                |
| **Snowflake**  | \$112,948                |
| **Azure**      | \$111,225                |

These are key in cloud, big data, and enterprise collaboration.

3. Data-Related Skills Dominate
Tools like Tableau, Looker, Qlik, SSRS, Redshift, Snowflake, Spark, Hadoop appear frequently, indicating strong demand for data visualization, warehousing, and analytics skills.

4. Cloud Platforms Are in Demand
AWS (32 postings), Azure (34), and Snowflake (37) show high relevance of cloud expertise.

5. BI and Reporting Tools
Strong demand and decent pay for Tableau, Looker, Qlik, SSRS, highlighting ongoing importance of BI tools.

6. Languages
Python, Java, R, Go, JavaScript, and C++ are all in demand. Among them:

***Go is highest-paying.***

***Python is the most in-demand.***

***JavaScript has a moderate demand with a lower average salary ($97,587).***

# What I Learned
🚀 Advanced SQL Mastery
Developed expertise in crafting complex queries, seamlessly merging tables, and using WITH clauses for efficient temporary table creation.

📊 Data Aggregation Skills
Gained strong command over GROUP BY and aggregate functions like COUNT() and AVG(), becoming proficient in summarizing and interpreting data.

🧠 Analytical Thinking
Enhanced real-world problem-solving abilities by transforming business questions into clear, actionable SQL insights.
# Conclusion

1. 💼 High-Paying Data Analyst Roles
Remote data analyst jobs can offer salaries up to $650,000, making them some of the most lucrative opportunities in the field.

2. 🧠 Key Skills for Top Salaries
Advanced SQL proficiency is a must-have for landing high-paying data analyst jobs, highlighting its importance in the job market.

3. 🔥 Most Sought-After Skill
SQL tops the list of in-demand skills for data analyst roles, making it a crucial tool for job seekers to master.

4. 💸 Specialized Skills = Higher Pay
Niche skills like SVN and Solidity often come with higher average salaries, showing that expertise in specialized tools is highly rewarded.

5. 📈 Best Skills for Career Value
With both high demand and competitive pay, SQL, Python stand out as one of the best skills to boost a data analyst’s market value.