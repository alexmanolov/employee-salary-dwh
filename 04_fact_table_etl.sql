-- 04_FACT_TABLE_ETL.SQL 
-- Populates employee_salary_fact with:
--   1) Current employee salaries (from EMPLOYEES)
--   2) Historical job salaries (from JOB_HISTORY)
-- Uses SYS_GUID() for unique surrogate_fact_id

-- === 1. Current Employees ETL ===
INSERT INTO employee_salary_fact (
    surrogate_fact_id,
    surrogate_employee_id,
    surrogate_department_id,
    surrogate_job_id,
    surrogate_time_id,
    surrogate_location_id,
    salary,
    bonus,
    total_compensation,
    effective_date
)
SELECT
    -- SYS_GUID(),
    ORA_HASH(ed.surrogate_employee_id || dd.surrogate_department_id || jd.surrogate_job_id || td.surrogate_time_id || ld.surrogate_location_id),
    ed.surrogate_employee_id,
    dd.surrogate_department_id,
    jd.surrogate_job_id,
    td.surrogate_time_id,
    ld.surrogate_location_id,
    ed.salary,
    NVL(ed.commission_pct, 0) * ed.salary AS bonus,
    ed.salary + NVL(ed.commission_pct, 0) * ed.salary AS total_compensation,
    ed.hire_date
FROM employee_dim ed
LEFT JOIN department_dim dd ON ed.department_id = dd.department_id
LEFT JOIN job_dim jd ON ed.job_id = jd.job_id
LEFT JOIN location_dim ld ON dd.location_id = ld.location_id
-- LEFT JOIN time_dim td ON TO_NUMBER(TO_CHAR(e.hire_date, 'YYYYMMDD')) = td.time_id
LEFT JOIN time_dim td ON td.YEAR BETWEEN EXTRACT(YEAR FROM SYSDATE) - 15 AND EXTRACT(YEAR FROM SYSDATE)-1
WHERE
    ed.surrogate_employee_id IS NOT NULL
    AND td.YEAR >= EXTRACT(YEAR FROM ed.HIRE_DATE)   -- Exclude dates before hiring
    AND td.MONTH = 12 AND td.DAY = 31                -- Only one row per year, at the end of the year, 31st Dec
;

-- === 2. Historical Job Records ETL ===
INSERT INTO employee_salary_fact (
    surrogate_fact_id,
    surrogate_employee_id,
    surrogate_department_id,
    surrogate_job_id,
    surrogate_time_id,
    surrogate_location_id,
    salary,
    bonus,
    total_compensation,
    effective_date
)
SELECT
    SYS_GUID(),
    -- ORA_HASH(ed.surrogate_employee_id || dd.surrogate_department_id || jd.surrogate_job_id || td.surrogate_time_id || ld.surrogate_location_id || td.time_id),
    ed.surrogate_employee_id,
    dd.surrogate_department_id,
    jd.surrogate_job_id,
    td.surrogate_time_id,
    ld.surrogate_location_id,
    ed.salary,
    NVL(ed.commission_pct, 0) * ed.salary AS bonus,
    ed.salary + NVL(ed.commission_pct, 0) * ed.salary AS total_compensation,
    jh.start_date
FROM job_history jh
LEFT JOIN employee_dim ed ON jh.employee_id = ed.employee_id
LEFT JOIN department_dim dd ON jh.department_id = dd.department_id
LEFT JOIN job_dim jd ON jh.job_id = jd.job_id
LEFT JOIN location_dim ld ON dd.location_id = ld.location_id
JOIN time_dim td ON td.year BETWEEN EXTRACT(YEAR FROM jh.start_date) AND EXTRACT(YEAR FROM NVL(jh.end_date, SYSDATE))
                 AND td.month = 12
                 AND td.day = 31
WHERE ed.surrogate_employee_id IS NOT NULL
  -- AND dd.surrogate_department_id IS NOT NULL
  AND jd.surrogate_job_id IS NOT NULL
  AND td.surrogate_time_id IS NOT NULL
  AND td.year BETWEEN EXTRACT(YEAR FROM SYSDATE) - 15 AND EXTRACT(YEAR FROM SYSDATE)
  -- AND ld.surrogate_location_id IS NOT NULL
;