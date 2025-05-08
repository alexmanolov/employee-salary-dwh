
-- EMPLOYEE_DIM
CREATE TABLE employee_dim (
    surrogate_employee_id NUMBER PRIMARY KEY,
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
    surrogate_department_id NUMBER PRIMARY KEY,
    department_id NUMBER,
    department_name VARCHAR2(100),
    location_id NUMBER,
    manager_id NUMBER
);

-- JOB_DIM
CREATE TABLE job_dim (
    surrogate_job_id NUMBER PRIMARY KEY,
    job_id VARCHAR2(10),
    job_title VARCHAR2(100),
    min_salary NUMBER,
    max_salary NUMBER,
    job_category VARCHAR2(50)
);

-- LOCATION_DIM
CREATE TABLE location_dim (
    surrogate_location_id NUMBER PRIMARY KEY,
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
CREATE TABLE Time_Dim (
    surrogate_time_id   RAW(16) PRIMARY KEY,  -- Surrogate key based on hash of the row
    time_id             NUMBER,  -- Natural key representing the date in a numeric format
    dates                DATE,  -- The specific calendar date
    year                NUMBER,  -- The year component of the date
    quarter             NUMBER,  -- The quarter of the year (1 through 4)
    month               NUMBER,  -- The month of the year (1 through 12)
    week                NUMBER,  -- The week number of the year
    day                 NUMBER,  -- The day of the month
    day_of_week         VARCHAR2(10),  -- The name of the day (e.g., 'Monday')
    fiscal_year         NUMBER,  -- The fiscal year corresponding to the date
    fiscal_quarter      NUMBER   -- The fiscal quarter corresponding to the date
);

-- EMPLOYEE_SALARY_FACT
CREATE TABLE employee_salary_fact (
    surrogate_fact_id VARCHAR2(32) PRIMARY KEY,
    surrogate_employee_id NUMBER,
    surrogate_department_id NUMBER,
    surrogate_job_id NUMBER,
    surrogate_time_id RAW(16),
    surrogate_location_id NUMBER,
    salary NUMBER,
    bonus NUMBER,
    total_compensation NUMBER,
    effective_date DATE
);
