/*problem no 7
find the count of the no. of remote job postings per skill
display 5 top skills by thier demand in remote jobs and for data anlyst role
include skill_id , name and count of postings requiring the skills
note i have calculated percentage of jobs posted*/

WITH remote_jobs AS (
SELECT sjd.skill_id,
count(jpf.job_id) as number_of_jobs
from skills_job_dim as sjd
inner join job_postings_fact as jpf
on sjd.job_id = jpf.job_id
WHERE job_work_from_home = True and job_title_short = 'Data Analyst'
GROUP BY sjd.skill_id
)

SELECT sd.skills,
number_of_jobs,
(number_of_jobs * 100 / (select sum(number_of_jobs) from remote_jobs)) as percentage_jobs
FROM remote_jobs as rj
inner join skills_dim as sd ON
rj.skill_id = sd.skill_id
ORDER BY number_of_jobs DESC
LIMIT 5
