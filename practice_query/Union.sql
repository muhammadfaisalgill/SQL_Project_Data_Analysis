SELECT
    company_id,
    job_title_short,
    job_location
from 
    january_jobs

UNION

SELECT
    company_id,
    job_title_short,
    job_location
from 
    february_jobs

UNION

SELECT
    company_id,
    job_title_short,
    job_location
from 
    march_jobs