
-- EMPLOYEE_DIM
CREATE TABLE employee_dim (
    surrogate_employee_id VARCHAR2(32) PRIMARY KEY,
    employee_id NUMBER,
    full_name VARCHAR2(100),
    hire_date DATE,
    job_id VARCHAR2(10),
    salary NUMBER,
    commission_pct NUMBER,
    email VARCHAR2(100),
    phone_number VARCHAR2(30),
    manager_id NUMBER,
    department_id NUMBER,
    tenure_band VARCHAR2(30)
);

-- DEPARTMENT_DIM
CREATE TABLE department_dim (
    surrogate_department_id VARCHAR2(32) PRIMARY KEY,
    department_id NUMBER,
    department_name VARCHAR2(100),
    location_id NUMBER,
    manager_id NUMBER
);

-- JOB_DIM
CREATE TABLE job_dim (
    surrogate_job_id VARCHAR2(32) PRIMARY KEY,
    job_id VARCHAR2(10),
    job_title VARCHAR2(100),
    min_salary NUMBER,
    max_salary NUMBER,
    job_category VARCHAR2(50)
);

-- LOCATION_DIM
CREATE TABLE location_dim (
    surrogate_location_id VARCHAR2(32) PRIMARY KEY,
    location_id NUMBER,
    street_address VARCHAR2(100),
    postal_code VARCHAR2(20),
    city VARCHAR2(50),
    state_province VARCHAR2(50),
    country_id VARCHAR2(5),
    country_name VARCHAR2(100),
    region_id NUMBER,
    region_name VARCHAR2(100)
);

-- TIME_DIM
CREATE TABLE time_dim (
    surrogate_time_id VARCHAR2(32) PRIMARY KEY,
    time_id NUMBER,
    dates DATE,
    year NUMBER,
    quarter NUMBER,
    month NUMBER,
    week NUMBER,
    day NUMBER,
    day_of_week VARCHAR2(10),
    fiscal_year NUMBER,
    fiscal_quarter NUMBER
);

-- EMPLOYEE_SALARY_FACT
CREATE TABLE employee_salary_fact (
    surrogate_fact_id VARCHAR2(32) PRIMARY KEY,
    surrogate_employee_id VARCHAR2(32),
    surrogate_department_id VARCHAR2(32),
    surrogate_job_id VARCHAR2(32),
    surrogate_time_id VARCHAR2(32),
    surrogate_location_id VARCHAR2(32),
    salary NUMBER,
    bonus NUMBER,
    total_compensation NUMBER,
    effective_date DATE
);
