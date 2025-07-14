
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
    SYS_GUID(),
    ed.surrogate_employee_id,
    dd.surrogate_department_id,
    jd.surrogate_job_id,
    td.surrogate_time_id,
    ld.surrogate_location_id,
    e.salary,
    NVL(e.commission_pct, 0) * e.salary AS bonus,
    e.salary + NVL(e.commission_pct, 0) * e.salary AS total_compensation,
    e.hire_date
FROM employees e
LEFT JOIN employee_dim ed ON e.employee_id = ed.employee_id
LEFT JOIN department_dim dd ON e.department_id = dd.department_id
LEFT JOIN job_dim jd ON e.job_id = jd.job_id
LEFT JOIN departments d ON d.department_id = e.department_id
LEFT JOIN location_dim ld ON d.location_id = ld.location_id
LEFT JOIN time_dim td ON TO_NUMBER(TO_CHAR(e.hire_date, 'YYYYMMDD')) = td.time_id
WHERE ed.surrogate_employee_id IS NOT NULL
  AND dd.surrogate_department_id IS NOT NULL
  AND jd.surrogate_job_id IS NOT NULL
  AND td.surrogate_time_id IS NOT NULL
  AND ld.surrogate_location_id IS NOT NULL;


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
    ed.surrogate_employee_id,
    dd.surrogate_department_id,
    jd.surrogate_job_id,
    td.surrogate_time_id,
    ld.surrogate_location_id,
    e.salary,
    NVL(e.commission_pct, 0) * e.salary AS bonus,
    e.salary + NVL(e.commission_pct, 0) * e.salary AS total_compensation,
    jh.start_date
FROM job_history jh
LEFT JOIN employees e ON jh.employee_id = e.employee_id
LEFT JOIN employee_dim ed ON e.employee_id = ed.employee_id
LEFT JOIN department_dim dd ON jh.department_id = dd.department_id
LEFT JOIN job_dim jd ON jh.job_id = jd.job_id
LEFT JOIN departments d ON d.department_id = jh.department_id
LEFT JOIN location_dim ld ON d.location_id = ld.location_id
LEFT JOIN time_dim td ON TO_NUMBER(TO_CHAR(jh.start_date, 'YYYYMMDD')) = td.time_id
WHERE ed.surrogate_employee_id IS NOT NULL
  AND dd.surrogate_department_id IS NOT NULL
  AND jd.surrogate_job_id IS NOT NULL
  AND td.surrogate_time_id IS NOT NULL
  AND ld.surrogate_location_id IS NOT NULL;