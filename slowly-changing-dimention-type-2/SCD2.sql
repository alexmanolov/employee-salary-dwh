-- SCD Type 2 implementation

-- === 0. Initial population: set default SCD2 values on existing dim rows ===
UPDATE employee_dim
   SET effective_start_date = hire_date,
       effective_end_date   = NULL,
       is_current           = 'Y'
 WHERE effective_start_date IS NULL;

UPDATE department_dim
   SET effective_start_date = SYSDATE,
       effective_end_date   = NULL,
       is_current           = 'Y'
 WHERE effective_start_date IS NULL;

UPDATE job_dim
   SET effective_start_date = SYSDATE,
       effective_end_date   = NULL,
       is_current           = 'Y'
 WHERE effective_start_date IS NULL;

UPDATE location_dim
   SET effective_start_date = SYSDATE,
       effective_end_date   = NULL,
       is_current           = 'Y'
 WHERE effective_start_date IS NULL;

COMMIT;

-- === 1. Add unique indexes on (natural key, is_current) to speed MERGE ===
CREATE UNIQUE INDEX idx_emp_dim_key_current 
  ON employee_dim(employee_id, is_current);

CREATE UNIQUE INDEX idx_dept_dim_key_current 
  ON department_dim(department_id, is_current);

CREATE UNIQUE INDEX idx_job_dim_key_current 
  ON job_dim(job_id, is_current);

CREATE UNIQUE INDEX idx_loc_dim_key_current 
  ON location_dim(location_id, is_current);

-- === 2. ALTER DIMENSION TABLES (SCD2 columns) ===
ALTER TABLE employee_dim ADD (
    effective_start_date DATE,
    effective_end_date   DATE,
    is_current           CHAR(1)
);

ALTER TABLE department_dim ADD (
    effective_start_date DATE,
    effective_end_date   DATE,
    is_current           CHAR(1)
);

ALTER TABLE job_dim ADD (
    effective_start_date DATE,
    effective_end_date   DATE,
    is_current           CHAR(1)
);

ALTER TABLE location_dim ADD (
    effective_start_date DATE,
    effective_end_date   DATE,
    is_current           CHAR(1)
);

-- === 3. CREATE STAGING TABLES ===
CREATE TABLE employee_dim_staging AS SELECT * FROM employee_dim WHERE 1=0;
CREATE TABLE department_dim_staging AS SELECT * FROM department_dim WHERE 1=0;
CREATE TABLE job_dim_staging AS SELECT * FROM job_dim WHERE 1=0;
CREATE TABLE location_dim_staging AS SELECT * FROM location_dim WHERE 1=0;

-- === 4. MERGE and TRUNCATE loops ===

-- EMPLOYEE_DIM
MERGE INTO employee_dim d
USING employee_dim_staging s
  ON (d.employee_id = s.employee_id AND d.is_current = 'Y')
WHEN MATCHED THEN 
  UPDATE SET 
    d.effective_end_date = SYSDATE,
    d.is_current = 'N'
  WHERE 
    d.full_name != s.full_name OR
    d.job_id != s.job_id OR
    d.salary != s.salary OR
    d.email != s.email OR
    d.phone_number != s.phone_number OR
    d.manager_id != s.manager_id OR
    d.department_id != s.department_id OR
    d.tenure_band != s.tenure_band
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
    s.surrogate_employee_id,
    s.employee_id,
    s.full_name,
    s.hire_date,
    s.job_id,
    s.salary,
    s.commission_pct,
    s.email,
    s.phone_number,
    s.manager_id,
    s.department_id,
    s.tenure_band,
    SYSDATE, NULL, 'Y'
  );

TRUNCATE TABLE employee_dim_staging;

-- DEPARTMENT_DIM
MERGE INTO department_dim d
USING department_dim_staging s
  ON (d.department_id = s.department_id AND d.is_current = 'Y')
WHEN MATCHED THEN 
  UPDATE SET 
    d.effective_end_date = SYSDATE,
    d.is_current = 'N'
  WHERE 
    d.department_name != s.department_name OR
    d.location_id != s.location_id OR
    d.manager_id != s.manager_id
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
    s.surrogate_department_id,
    s.department_id,
    s.department_name,
    s.location_id,
    s.manager_id,
    SYSDATE, NULL, 'Y'
  );

TRUNCATE TABLE department_dim_staging;

-- JOB_DIM
MERGE INTO job_dim d
USING job_dim_staging s
  ON (d.job_id = s.job_id AND d.is_current = 'Y')
WHEN MATCHED THEN 
  UPDATE SET 
    d.effective_end_date = SYSDATE,
    d.is_current = 'N'
  WHERE 
    d.job_title != s.job_title OR
    d.min_salary != s.min_salary OR
    d.max_salary != s.max_salary OR
    d.job_category != s.job_category
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
    s.surrogate_job_id,
    s.job_id,
    s.job_title,
    s.min_salary,
    s.max_salary,
    s.job_category,
    SYSDATE, NULL, 'Y'
  );

TRUNCATE TABLE job_dim_staging;

-- LOCATION_DIM
MERGE INTO location_dim d
USING location_dim_staging s
  ON (d.location_id = s.location_id AND d.is_current = 'Y')
WHEN MATCHED THEN 
  UPDATE SET 
    d.effective_end_date = SYSDATE,
    d.is_current = 'N'
  WHERE 
    d.street_address != s.street_address OR
    d.postal_code != s.postal_code OR
    d.city != s.city OR
    d.state_province != s.state_province OR
    d.country_id != s.country_id OR
    d.country_name != s.country_name OR
    d.region_id != s.region_id OR
    d.region_name != s.region_name
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
    s.surrogate_location_id,
    s.location_id,
    s.street_address,
    s.postal_code,
    s.city,
    s.state_province,
    s.country_id,
    s.country_name,
    s.region_id,
    s.region_name,
    SYSDATE, NULL, 'Y'
  );

TRUNCATE TABLE location_dim_staging;

COMMIT;
