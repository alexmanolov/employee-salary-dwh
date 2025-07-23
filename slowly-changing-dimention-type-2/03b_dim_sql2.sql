-- SCD2 Merge for employee_dim
-- Replaces old records with updated employee data and tracks history using SCD2 logic

-- If the following columns haven't been added yet, uncomment and run once:
ALTER TABLE employee_dim ADD (
    effective_start_date DATE,
    effective_end_date DATE,
    is_current CHAR(1)
);

MERGE INTO employee_dim tgt
USING (
    SELECT
        e.employee_id,
        e.first_name || ' ' || e.last_name AS full_name,
        e.hire_date,
        e.job_id,
        e.salary,
        e.commission_pct,
        LOWER(e.email) || '@oracle.com' AS email,
        '+359-' || REPLACE(e.phone_number, '.', '-') AS phone_number,
        e.manager_id,
        NVL(e.department_id, -1) AS department_id,
        CASE 
            WHEN MONTHS_BETWEEN(DATE '2009-01-01', e.hire_date)/12 < 1 THEN 'Less than 1 year'
            WHEN MONTHS_BETWEEN(DATE '2009-01-01', e.hire_date)/12 BETWEEN 1 AND 3 THEN '1-3 years'
            WHEN MONTHS_BETWEEN(DATE '2009-01-01', e.hire_date)/12 BETWEEN 4 AND 6 THEN '4-6 years'
            WHEN MONTHS_BETWEEN(DATE '2009-01-01', e.hire_date)/12 BETWEEN 7 AND 10 THEN '7-10 years'
            ELSE '10+ years'
        END AS tenure_band,
        SYSDATE AS effective_start_date,
        NULL AS effective_end_date,
        'Y' AS is_current
    FROM employees e
) src
ON (
    tgt.employee_id = src.employee_id AND tgt.is_current = 'Y'
)
WHEN MATCHED AND (
    tgt.full_name        != src.full_name OR
    tgt.hire_date        != src.hire_date OR
    tgt.job_id           != src.job_id OR
    tgt.salary           != src.salary OR
    tgt.commission_pct   != src.commission_pct OR
    tgt.email            != src.email OR
    tgt.phone_number     != src.phone_number OR
    tgt.manager_id       != src.manager_id OR
    tgt.department_id    != src.department_id OR
    tgt.tenure_band      != src.tenure_band
)
THEN UPDATE SET
    tgt.effective_end_date = SYSDATE,
    tgt.is_current = 'N'

WHEN NOT MATCHED THEN
INSERT (
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
    tenure_band,
    effective_start_date,
    effective_end_date,
    is_current
)
VALUES (
    ORA_HASH(src.employee_id || src.full_name || src.hire_date || src.job_id || src.salary || src.email || src.phone_number || src.manager_id || src.department_id),
    src.employee_id,
    src.full_name,
    src.hire_date,
    src.job_id,
    src.salary,
    src.commission_pct,
    src.email,
    src.phone_number,
    src.manager_id,
    src.department_id,
    src.tenure_band,
    src.effective_start_date,
    src.effective_end_date,
    src.is_current
);

COMMIT;


---------------------------------------------------------------------------
-- SCD2 Merge for department_dim
-- Tracks changes to departments using SCD Type 2 (name, location, manager)

-- If the following columns haven't been added yet, uncomment and run once:
ALTER TABLE department_dim ADD (
    effective_start_date DATE,
    effective_end_date DATE,
    is_current CHAR(1)
);

MERGE INTO department_dim tgt
USING (
    SELECT
        d.department_id,
        d.department_name,
        d.location_id,
        d.manager_id,
        SYSDATE AS effective_start_date,
        NULL AS effective_end_date,
        'Y' AS is_current
    FROM departments d
) src
ON (
    tgt.department_id = src.department_id AND tgt.is_current = 'Y'
)
WHEN MATCHED AND (
    tgt.department_name != src.department_name OR
    tgt.location_id     != src.location_id OR
    tgt.manager_id      != src.manager_id
)
THEN UPDATE SET
    tgt.effective_end_date = SYSDATE,
    tgt.is_current = 'N'

WHEN NOT MATCHED THEN
INSERT (
    surrogate_department_id,
    department_id,
    department_name,
    location_id,
    manager_id,
    effective_start_date,
    effective_end_date,
    is_current
)
VALUES (
    ORA_HASH(src.department_id || src.department_name || src.location_id || src.manager_id),
    src.department_id,
    src.department_name,
    src.location_id,
    src.manager_id,
    src.effective_start_date,
    src.effective_end_date,
    src.is_current
);

COMMIT;

-----------------------------------------------------------------------------------
-- SCD2 Merge for job_dim
-- Tracks changes in job titles, salary ranges, and job categories using SCD Type 2

-- If the following columns haven't been added yet, uncomment and run once:
ALTER TABLE job_dim ADD (
    effective_start_date DATE,
    effective_end_date DATE,
    is_current CHAR(1)
);

MERGE INTO job_dim tgt
USING (
    SELECT
        j.job_id,
        j.job_title,
        j.min_salary,
        j.max_salary,
        CASE 
            WHEN job_title IN ('Accounting Manager', 'Purchasing Manager', 'Sales Manager', 'Stock Manager',
                               'Administration Vice President', 'Marketing Manager', 'Finance Manager', 'President') THEN 'Management'
            WHEN job_title IN ('Programmer', 'Public Accountant', 'Accountant', 'Public Relations Representative',
                               'Human Resources Representative', 'Marketing Representative') THEN 'Technical/Professional'
            WHEN job_title IN ('Administration Assistant', 'Purchasing Clerk', 'Shipping Clerk', 'Stock Clerk') THEN 'Clerical/Support'
            ELSE 'Other'
        END AS job_category,
        SYSDATE AS effective_start_date,
        NULL AS effective_end_date,
        'Y' AS is_current
    FROM jobs j
) src
ON (
    tgt.job_id = src.job_id AND tgt.is_current = 'Y'
)
WHEN MATCHED AND (
    tgt.job_title     != src.job_title OR
    tgt.min_salary    != src.min_salary OR
    tgt.max_salary    != src.max_salary OR
    tgt.job_category  != src.job_category
)
THEN UPDATE SET
    tgt.effective_end_date = SYSDATE,
    tgt.is_current = 'N'

WHEN NOT MATCHED THEN
INSERT (
    surrogate_job_id,
    job_id,
    job_title,
    min_salary,
    max_salary,
    job_category,
    effective_start_date,
    effective_end_date,
    is_current
)
VALUES (
    ORA_HASH(src.job_id || src.job_title || src.min_salary || src.max_salary),
    src.job_id,
    src.job_title,
    src.min_salary,
    src.max_salary,
    src.job_category,
    src.effective_start_date,
    src.effective_end_date,
    src.is_current
);

COMMIT;


----------------------------------------------------------------------------
-- SCD2 Merge for location_dim
-- Tracks changes to location data using SCD Type 2 (city, state, postal code, etc.)

-- If the following columns haven't been added yet, uncomment and run once:
ALTER TABLE location_dim ADD (
    effective_start_date DATE,
    effective_end_date DATE,
    is_current CHAR(1)
);

MERGE INTO location_dim tgt
USING (
    SELECT
        l.location_id,
        l.street_address,
        l.postal_code,
        l.city,
        l.state_province,
        l.country_id,
        c.country_name,
        c.region_id,
        r.region_name,
        SYSDATE AS effective_start_date,
        NULL AS effective_end_date,
        'Y' AS is_current
    FROM locations l
    JOIN countries c ON l.country_id = c.country_id
    JOIN regions r ON c.region_id = r.region_id
) src
ON (
    tgt.location_id = src.location_id AND tgt.is_current = 'Y'
)
WHEN MATCHED AND (
    tgt.street_address != src.street_address OR
    tgt.postal_code     != src.postal_code OR
    tgt.city            != src.city OR
    tgt.state_province  != src.state_province OR
    tgt.country_id      != src.country_id OR
    tgt.country_name    != src.country_name OR
    tgt.region_id       != src.region_id OR
    tgt.region_name     != src.region_name
)
THEN UPDATE SET
    tgt.effective_end_date = SYSDATE,
    tgt.is_current = 'N'

WHEN NOT MATCHED THEN
INSERT (
    surrogate_location_id,
    location_id,
    street_address,
    postal_code,
    city,
    state_province,
    country_id,
    country_name,
    region_id,
    region_name,
    effective_start_date,
    effective_end_date,
    is_current
)
VALUES (
    ORA_HASH(src.location_id || src.street_address || src.city || src.postal_code || src.country_id),
    src.location_id,
    src.street_address,
    src.postal_code,
    src.city,
    src.state_province,
    src.country_id,
    src.country_name,
    src.region_id,
    src.region_name,
    src.effective_start_date,
    src.effective_end_date,
    src.is_current
);

COMMIT;
