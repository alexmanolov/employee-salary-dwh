-- Update to simulate a salary increase for an employee
UPDATE employees
SET salary = salary + 1000
WHERE employee_id = 101;

-- Update to simulate a department change for an employee
UPDATE employees
SET department_id = 60
WHERE employee_id = 103;

-- Update to simulate a job change for an employee
UPDATE employees
SET job_id = 'SA_REP'
WHERE employee_id = 110;

-- Update to standardize email format
UPDATE employees
SET email = CONCAT(email, '@oracle_NEW.com')
WHERE employee_id = 104;


-- Update to simulate department name change
UPDATE departments
SET department_name = 'Global Marketing'
WHERE department_id = 20;

-- Update to simulate department manager change
UPDATE departments
SET manager_id = 102
WHERE department_id = 40;

-- Update to simulate department relocation
UPDATE departments
SET location_id = 1900
WHERE department_id = 50;

-- Update to simulate adding a new manager to a department
UPDATE departments
SET manager_id = 105
WHERE department_id = 60;


-- Update to simulate job title change
UPDATE jobs
SET job_title = 'Senior Sales Representative'
WHERE job_id = 'SA_REP';

-- Update to simulate change in minimum salary for a job
UPDATE jobs
SET min_salary = 5000
WHERE job_id = 'IT_PROG';

-- Update to simulate change in maximum salary for a job
UPDATE jobs
SET max_salary = 30000
WHERE job_id = 'FI_ACCOUNT';

-- Update to simulate job title reclassification
UPDATE jobs
SET job_title = 'Sales Vice President'
WHERE job_id = 'SA_MAN';



-- Update to simulate location city change
UPDATE locations
SET city = 'New York'
WHERE location_id = 1700;

-- Update to simulate state or province change
UPDATE locations
SET state_province = 'California'
WHERE location_id = 1500;

-- Update to simulate country change for a location
UPDATE locations
SET country_id = 'UK'
WHERE location_id = 2400;

-- Update to simulate postal code standardization
UPDATE locations
SET postal_code = '10001'
WHERE location_id = 1800;


UPDATE EMPLOYEES
SET SALARY = SALARY * 1.05  -- Increase salary by 5%
WHERE HIRE_DATE <= TO_DATE('31-DEC-2008', 'DD-MON-YYYY');

UPDATE EMPLOYEES
SET COMMISSION_PCT = CASE
    WHEN JOB_ID IN ('SA_MAN', 'SA_REP') THEN 0.10  -- 10% commission
    ELSE NULL
END
WHERE HIRE_DATE <= TO_DATE('31-DEC-2005', 'DD-MON-YYYY');


-- Example: Employee 101 moved from department 10 to 20 in 2010
INSERT INTO JOB_HISTORY (EMPLOYEE_ID, START_DATE, END_DATE, JOB_ID, DEPARTMENT_ID)
VALUES (1001, TO_DATE('01-JAN-2005', 'DD-MON-YYYY'), TO_DATE('31-DEC-2009', 'DD-MON-YYYY'), 'IT_PROG', 10);

-- Update EMPLOYEES to reflect current department after the change
UPDATE EMPLOYEES
SET DEPARTMENT_ID = 20
WHERE EMPLOYEE_ID = 101;

---- more updates
INSERT INTO JOB_HISTORY (EMPLOYEE_ID, START_DATE, END_DATE, JOB_ID, DEPARTMENT_ID)
VALUES (1002, TO_DATE('01-JAN-2008', 'DD-MON-YYYY'), TO_DATE('31-DEC-2011', 'DD-MON-YYYY'), 'MK_REP', 20);

UPDATE EMPLOYEES
SET DEPARTMENT_ID = 30
WHERE EMPLOYEE_ID = 102;


UPDATE EMPLOYEES
SET SALARY = SALARY + 15000
WHERE EMPLOYEE_ID IN (100, 101, 110, 111, 112);

UPDATE EMPLOYEES
SET SALARY = SALARY + 12000
WHERE EMPLOYEE_ID IN (102, 113, 114, 115, 116);

UPDATE EMPLOYEES
SET SALARY = SALARY + 10000
WHERE EMPLOYEE_ID IN (103, 117, 118, 119, 120);



INSERT INTO EMPLOYEES (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
VALUES (1100, 'Alice', 'Johnson', 'AJOHNSON', '515.123.4567', TO_DATE('15-FEB-2015', 'DD-MON-YYYY'), 'FI_ACCOUNT', 75000, NULL, 100, 10);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
VALUES (1110, 'Bob', 'Lee', 'BLEE', '515.123.4568', TO_DATE('20-MAR-2016', 'DD-MON-YYYY'), 'FI_ACCOUNT', 72000, NULL, 100, 10);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
VALUES (1120, 'Carol', 'King', 'CKING', '515.123.4569', TO_DATE('10-APR-2017', 'DD-MON-YYYY'), 'FI_ACCOUNT', 70000, NULL, 100, 10);

-- Similar inserts for Departments 20 and 30
-- Department 20 new employees
INSERT INTO EMPLOYEES (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
VALUES (1130, 'David', 'Brown', 'DBROWN', '515.123.4570', TO_DATE('05-MAY-2015', 'DD-MON-YYYY'), 'SA_REP', 68000, NULL, 102, 20);
    

commit;
