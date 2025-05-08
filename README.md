Employee Salary Data Warehouse (Oracle Star Schema Project)
This project implements a full OLTP-to-OLAP data warehouse pipeline using the classic Oracle HR schema. It includes:

Star schema design with dimensions and a fact table
ETL scripts for loading and transforming data
Historical job tracking using both current and past employee records
Compatible with Oracle Live SQL or any Oracle 19c+ instance
🧂 Prerequisites
Before running the ETL pipeline:

Make sure you have access to the Oracle HR schema
In Oracle Live SQL: SELECT * FROM hr.employees;
Or request a DB admin to grant access to the HR user
Clone the HR schema tables into your own schema:
CREATE TABLE employees     AS SELECT * FROM hr.employees;
CREATE TABLE departments   AS SELECT * FROM hr.departments;
CREATE TABLE jobs          AS SELECT * FROM hr.jobs;
CREATE TABLE job_history   AS SELECT * FROM hr.job_history;
CREATE TABLE locations     AS SELECT * FROM hr.locations;
CREATE TABLE countries     AS SELECT * FROM hr.countries;
CREATE TABLE regions       AS SELECT * FROM hr.regions;
Once done, proceed with:

02_star_schema_ddl.sql
03_star_schema_etl.sql
04_fact_table_etl.sql
🗂️ Project Structure
.
├── 01_copy_hr_tables.sql           # Copy HR tables into your schema
├── 02_star_schema_ddl.sql          # DDL for the star schema tables
├── 03_star_schema_etl.sql          # ETL logic for all dimension tables
├── 04_fact_table_etl.sql           # Final ETL script for fact table (current + history)
├── diagrams/
│   └── star_schema.png             # Visual representation of the star schema
└── README.md                       # Project documentation
🧱 Star Schema Overview
Fact Table: employee_salary_fact
Dimensions:
employee_dim
department_dim
job_dim
location_dim
time_dim
Each dimension uses surrogate keys. The time_dim is populated dynamically with fiscal/calendar logic using PL/SQL.

🔄 ETL Logic
Dimension Tables
Data sourced from cloned HR schema tables
Transformations include:
tenure_band calculation (employee_dim)
job_category classification (job_dim)
Email and phone normalization
Fact Table
Pulls salary data from employees (current) and job_history (historical)
Calculates:
Bonus: salary * commission_pct
Total compensation: salary + bonus
Joins to all 5 dimensions via natural keys → surrogate keys
⚙️ How to Run
Clone the HR schema tables using 01_copy_hr_tables.sql or the commands above.

Run 02_star_schema_ddl.sql to create your OLAP schema.

Run 03_star_schema_etl.sql to populate all dimensions.

Run 04_fact_table_etl.sql to load the fact table.

📸 Example Queries
-- Total number of salary records (fact table)
SELECT COUNT(*) FROM employee_salary_fact;

-- Total compensation per department
SELECT d.department_name, SUM(f.total_compensation)
FROM employee_salary_fact f
JOIN department_dim d ON f.surrogate_department_id = d.surrogate_department_id
GROUP BY d.department_name;

📌 Notes
All surrogate keys are VARCHAR2(32) and generated via SYS_GUID() or TO_CHAR(ORA_HASH(...)) where applicable.
This project is fully compliant with the conditions set in the Telerik Data Engineering course PDF.

## 🔄 Enhancements

### ✅ Slowly Changing Dimensions (Type 2)
This project supports SCD Type 2 tracking for all major dimension tables:
- `employee_dim`
- `department_dim`
- `job_dim`
- `location_dim`

Each dimension includes the following columns to capture historical changes:
- `effective_start_date` — when the current version became active
- `effective_end_date` — when the current version ended (NULL for active records)
- `is_current` — 'Y' for current records, 'N' for historical ones

The logic is implemented via `MERGE` operations with staging tables.
See:  
📄 `SCD2_all_dimensions_final.sql`

---

### 🔒 Referential Integrity
After successful ETL and fact table loading, foreign key constraints are applied to ensure dimensional consistency and integrity.

Fact table `employee_salary_fact` references:
- `employee_dim(surrogate_employee_id)`
- `department_dim(surrogate_department_id)`
- `job_dim(surrogate_job_id)`
- `location_dim(surrogate_location_id)`
- `time_dim(surrogate_time_id)`

All constraints are defined in:  
📄 `05_add_constraints.sql`

📎 License
MIT License or course usage only.