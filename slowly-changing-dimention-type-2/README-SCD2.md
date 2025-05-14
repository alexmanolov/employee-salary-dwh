## 📝 Slowly Changing Dimensions (SCD Type 2)

This project includes a full implementation of Slowly Changing Dimensions Type 2 (SCD2) for all dimension tables:
- `employee_dim`
- `department_dim`
- `job_dim`
- `location_dim`

### ✅ Purpose
SCD Type 2 allows tracking historical changes in dimensional attributes while preserving previous versions of records.

### 🛠️ Logic Details
The SCD2 process includes:
1. **Initial Setup**
   - All records are marked with `is_current = 'Y'` and assigned an `effective_start_date`.
   - `effective_end_date` remains `NULL` for current records.

2. **Change Detection & Versioning**
   - Each dimension has a staging table to load incoming changes.
   - A `MERGE` operation compares the staging records to current records (`is_current = 'Y'`).
   - If changes are detected:
     - Existing record is expired (`is_current = 'N'`, `effective_end_date = SYSDATE`).
     - A new version is inserted with updated values and `is_current = 'Y'`.
   - If no current record exists, a new record is inserted directly.

3. **Indexing**
   - Unique indexes are applied on `(natural_key, is_current)` for each dimension to guarantee data consistency and improve performance.

4. **Reusable & Safe**
   - Staging tables are truncated after each `MERGE`, making the process safe for repeated runs.
   - The logic is fully repeatable and works incrementally.
