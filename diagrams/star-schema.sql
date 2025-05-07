CREATE TABLE "employee_dim" (
	"surrogate_employee_id" RAW(16),
	"employee_id" NUMBER,
	"full_name" VARCHAR2(100),
	"hire_date" DATE,
	"job_id" VARCHAR2(10),
	"salary" NUMBER,
	"commission_pct" NUMBER,
	"email" VARCHAR2(100),
	"phone_number" VARCHAR2(30),
	"manager_id" NUMBER,
	"department_id" NUMBER,
	"tenure_band" VARCHAR2(30),
	PRIMARY KEY("surrogate_employee_id")
);


CREATE TABLE "department_dim" (
	"surrogate_department_id" RAW(16),
	"department_id" NUMBER,
	"department_name" VARCHAR2(100),
	"location_id" NUMBER,
	"manager_id" NUMBER,
	PRIMARY KEY("surrogate_department_id")
);


CREATE TABLE "job_dim" (
	"surrogate_job_id" RAW(16),
	"job_id" VARCHAR2(10),
	"job_title" VARCHAR2(100),
	"min_salary" NUMBER,
	"max_salary" NUMBER,
	"job_category" VARCHAR2(50),
	PRIMARY KEY("surrogate_job_id")
);


CREATE TABLE "location_dim" (
	"surrogate_location_id" RAW(16),
	"location_id" NUMBER,
	"street_address" VARCHAR2(100),
	"postal_code" VARCHAR2(20),
	"city" VARCHAR2(50),
	"state_province" VARCHAR2(50),
	"country_id" VARCHAR2(5),
	"country_name" VARCHAR2(100),
	"region_id" NUMBER,
	"region_name" VARCHAR2(100),
	PRIMARY KEY("surrogate_location_id")
);


CREATE TABLE "time_dim" (
	"surrogate_time_id" RAW(16),
	"time_id" NUMBER,
	"dates" DATE,
	"year" NUMBER,
	"quarter" NUMBER,
	"month" NUMBER,
	"week" NUMBER,
	"day" NUMBER,
	"day_of_week" VARCHAR2(10),
	"fiscal_year" NUMBER,
	"fiscal_quarter" NUMBER,
	PRIMARY KEY("surrogate_time_id")
);


CREATE TABLE "employee_salary_fact" (
	"surrogate_fact_id" RAW(16),
	"surrogate_employee_id" RAW(16),
	"surrogate_department_id" RAW(16),
	"surrogate_job_id" RAW(16),
	"surrogate_time_id" RAW(16),
	"surrogate_location_id" RAW(16),
	"salary" NUMBER,
	"bonus" NUMBER,
	"total_compensation" NUMBER,
	"effective_date" DATE,
	PRIMARY KEY("surrogate_fact_id")
);


ALTER TABLE "employee_salary_fact"
ADD CONSTRAINT "fk_salary_employee" FOREIGN KEY ("surrogate_employee_id") REFERENCES "employee_dim" ("surrogate_employee_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "employee_salary_fact"
ADD CONSTRAINT "fk_salary_department" FOREIGN KEY ("surrogate_department_id") REFERENCES "department_dim" ("surrogate_department_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "employee_salary_fact"
ADD CONSTRAINT "fk_salary_job" FOREIGN KEY ("surrogate_job_id") REFERENCES "job_dim" ("surrogate_job_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "employee_salary_fact"
ADD CONSTRAINT "fk_salary_time" FOREIGN KEY ("surrogate_time_id") REFERENCES "time_dim" ("surrogate_time_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "employee_salary_fact"
ADD CONSTRAINT "fk_salary_location" FOREIGN KEY ("surrogate_location_id") REFERENCES "location_dim" ("surrogate_location_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;