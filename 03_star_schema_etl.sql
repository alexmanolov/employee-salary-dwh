
-- === EMPLOYEE_DIM ETL ===
INSERT INTO employee_dim (
    surrogate_employee_id,
    employee_id,
    full_name,
    hire_date,
    job_id,
    salary,
    commission_pct,
    email,
    phone_number,
    manager_id,
    department_id,
    tenure_band
)
SELECT
    ORA_HASH(employee_id || first_name || last_name || hire_date || job_id || salary || email || phone_number || manager_id || department_id),
    employee_id,
    first_name || ' ' || last_name,
    hire_date,
    job_id,
    salary,
    commission_pct,
    LOWER(email) || '@oracle.com',
    '+359-' || REPLACE(phone_number, '.', '-'),
    manager_id,
    NVL(department_id, -1),
    CASE 
        WHEN MONTHS_BETWEEN(DATE '2009-01-01', hire_date)/12 < 1 THEN 'Less than 1 year'
        WHEN MONTHS_BETWEEN(DATE '2009-01-01', hire_date)/12 BETWEEN 1 AND 3 THEN '1-3 years'
        WHEN MONTHS_BETWEEN(DATE '2009-01-01', hire_date)/12 BETWEEN 4 AND 6 THEN '4-6 years'
        WHEN MONTHS_BETWEEN(DATE '2009-01-01', hire_date)/12 BETWEEN 7 AND 10 THEN '7-10 years'
        ELSE '10+ years'
    END
FROM employees;

-- === DEPARTMENT_DIM ETL ===
INSERT INTO department_dim (
    surrogate_department_id,
    department_id,
    department_name,
    location_id,
    manager_id
)
SELECT
    ORA_HASH(department_id || department_name || location_id || manager_id),
    department_id,
    department_name,
    location_id,
    manager_id
FROM departments;

-- === DEPARTMENT_DIM ETL add dummy record ===
INSERT INTO DEPARTMENT_DIM (
    SURROGATE_DEPARTMENT_ID,
    DEPARTMENT_ID,
    DEPARTMENT_NAME,
    LOCATION_ID,
    MANAGER_ID
    )
VALUES (
    ORA_HASH(-1 || 'Unknown Department' || -1 || -1),
     -1, 'Unknown Department', -1, -1);

-- === JOB_DIM ETL ===
INSERT INTO job_dim (
    surrogate_job_id,
    job_id,
    job_title,
    min_salary,
    max_salary,
    job_category
)
SELECT
    ORA_HASH(job_id || job_title || min_salary || max_salary),
    job_id,
    job_title,
    min_salary,
    max_salary,
    CASE 
        WHEN job_title IN ('Accounting Manager', 'Purchasing Manager', 'Sales Manager', 'Stock Manager',
                           'Administration Vice President', 'Marketing Manager', 'Finance Manager', 'President') THEN 'Management'
        WHEN job_title IN ('Programmer', 'Public Accountant', 'Accountant', 'Public Relations Representative',
                           'Human Resources Representative', 'Marketing Representative') THEN 'Technical/Professional'
        WHEN job_title IN ('Administration Assistant', 'Purchasing Clerk', 'Shipping Clerk', 'Stock Clerk') THEN 'Clerical/Support'
        ELSE 'Other'
    END
FROM jobs;

-- === LOCATION_DIM ETL ===
INSERT INTO location_dim (
    surrogate_location_id,
    location_id,
    street_address,
    postal_code,
    city,
    state_province,
    country_id,
    country_name,
    region_id,
    region_name
)
SELECT
    ORA_HASH(l.location_id || l.street_address || l.city || l.postal_code || l.country_id),
    l.location_id,
    l.street_address,
    l.postal_code,
    l.city,
    l.state_province,
    l.country_id,
    c.country_name,
    c.region_id,
    r.region_name
FROM locations l
JOIN countries c ON l.country_id = c.country_id
JOIN regions r ON c.region_id = r.region_id;

-- === TIME_DIM ETL ===
DECLARE
    v_start_date DATE := TO_DATE('01-01-1995', 'dd-MM-yyyy');  -- Start date, adjusted to cover the earliest date in the data
    v_end_date   DATE := TO_DATE('31-12-2024', 'dd-MM-yyyy');  -- End date, extended slightly beyond the latest date in the data
BEGIN
    FOR d IN (SELECT v_start_date + LEVEL - 1 AS current_date
              FROM DUAL
              CONNECT BY LEVEL <= (v_end_date - v_start_date + 1))
    LOOP
        INSERT INTO Time_Dim (
            surrogate_time_id,
            time_id,
            dates,
            year,
            quarter,
            month,
            week,
            day,
            day_of_week,
            fiscal_year,
            fiscal_quarter
        )
        VALUES (
            SYS_GUID(),  -- Generate a unique surrogate key
            TO_NUMBER(TO_CHAR(d.current_date, 'YYYYMMDD')),  -- Generate time_id in YYYYMMDD format
            d.current_date,  -- Date value
            TO_NUMBER(TO_CHAR(d.current_date, 'YYYY')),  -- Year value
            TO_NUMBER(TO_CHAR(d.current_date, 'Q')),  -- Quarter value
            TO_NUMBER(TO_CHAR(d.current_date, 'MM')),  -- Month value
            TO_NUMBER(TO_CHAR(d.current_date, 'IW')),  -- ISO week of year
            TO_NUMBER(TO_CHAR(d.current_date, 'DD')),  -- Day of the month
            TO_CHAR(d.current_date, 'Day', 'NLS_DATE_LANGUAGE=ENGLISH'),  -- Day of the week
            TO_NUMBER(TO_CHAR(d.current_date, 'YYYY')),  -- Fiscal year (assumed to align with calendar year)
            TO_NUMBER(TO_CHAR(d.current_date, 'Q'))  -- Fiscal quarter (assumed to align with calendar quarters)
        );
    END LOOP;

    COMMIT;
END;
/
