
-- ============================================
-- 05_add_constraints.sql
-- Adds foreign key constraints to employee_salary_fact
-- ============================================

-- FK to employee_dim
ALTER TABLE employee_salary_fact
ADD CONSTRAINT fk_fact_employee
FOREIGN KEY (surrogate_employee_id)
REFERENCES employee_dim(surrogate_employee_id);

-- FK to department_dim
ALTER TABLE employee_salary_fact
ADD CONSTRAINT fk_fact_department
FOREIGN KEY (surrogate_department_id)
REFERENCES department_dim(surrogate_department_id);

-- FK to job_dim
ALTER TABLE employee_salary_fact
ADD CONSTRAINT fk_fact_job
FOREIGN KEY (surrogate_job_id)
REFERENCES job_dim(surrogate_job_id);

-- FK to location_dim
ALTER TABLE employee_salary_fact
ADD CONSTRAINT fk_fact_location
FOREIGN KEY (surrogate_location_id)
REFERENCES location_dim(surrogate_location_id);

-- FK to time_dim
ALTER TABLE employee_salary_fact
ADD CONSTRAINT fk_fact_time
FOREIGN KEY (surrogate_time_id)
REFERENCES time_dim(surrogate_time_id);
