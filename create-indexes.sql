-- DEMO 1 - b-tree

  -- b-tree index on data with a good spread

  EXPLAIN ANALYZE SELECT * FROM employee WHERE name = 'foo';

  CREATE INDEX idx_employee_name ON employee (name);

  EXPLAIN ANALYZE SELECT * FROM employee WHERE name = 'foo';


  -- b-tree index on data with a poor spread
  EXPLAIN ANALYZE SELECT * FROM employee WHERE location = 'Sydney'

  CREATE INDEX idx_employee_location ON employee (location);

  EXPLAIN ANALYZE SELECT * FROM employee WHERE location = 'Sydney'

  EXPLAIN ANALYZE SELECT * FROM employee WHERE location = 'Sydney' AND age >= 50 ORDER BY name LIMIT 50 OFFSET 20000;


-- DEMO 2 - Multiple b-tree indexes
	
  EXPLAIN ANALYZE SELECT * FROM employee WHERE location = 'Sydney' AND age >= 50 ORDER BY name LIMIT 50 OFFSET 20000;

  CREATE INDEX idx_employee_age ON employee (age);

  EXPLAIN ANALYZE SELECT * FROM employee WHERE location = 'Sydney' AND age >= 50 ORDER BY name LIMIT 50 OFFSET 20000;


-- DEMO 3 - Composite b-tree indexes

  CREATE INDEX idx_employee_age_location ON employee (age, location);

  EXPLAIN ANALYZE SELECT * FROM employee WHERE location = 'Sydney' AND age >= 50 ORDER BY name LIMIT 50 OFFSET 20000;

  CREATE INDEX idx_employee_location_age ON employee (location, age);

  EXPLAIN ANALYZE SELECT * FROM employee WHERE location = 'Sydney' AND age >= 50 ORDER BY name LIMIT 50 OFFSET 20000;


-- DEMO 4 - Covering Indexes
  EXPLAIN ANALYZE SELECT name, age FROM employee WHERE location = 'Sydney' AND age >= 50 ORDER BY name LIMIT 50 OFFSET 20000;

  CREATE INDEX idx_cov_employee_location_age_name ON employee (location, age) INCLUDE (name);

  EXPLAIN ANALYZE SELECT name, age FROM employee WHERE location = 'Sydney' AND age >= 50 ORDER BY name LIMIT 50 OFFSET 20000;


-- DEMO 5 - Partial Indexes

  EXPLAIN ANALYZE SELECT name, age FROM employee WHERE location = 'Sydney' AND age >= 50 AND end_date IS NULL ORDER BY name LIMIT 50 OFFSET 20000;

  CREATE INDEX idx_cov_employee_location_age_name_ed ON employee (location, age, end_date) INCLUDE (name);

  EXPLAIN ANALYZE SELECT name, age FROM employee WHERE location = 'Sydney' AND age >= 50 AND end_date IS NULL ORDER BY name LIMIT 50 OFFSET 20000;

  CREATE INDEX idx_par_employee_location_age_name ON employee (location, age) INCLUDE (name) WHERE end_date IS NULL;

  EXPLAIN ANALYZE SELECT name, age FROM employee WHERE location = 'Sydney' AND age >= 50 AND end_date IS NULL ORDER BY name LIMIT 50 OFFSET 20000;  

  CREATE INDEX idx_par_employee_sydney_age_name ON employee (age) INCLUDE (name) WHERE end_date IS NULL AND location = 'Sydney';

  EXPLAIN ANALYZE SELECT name, age FROM employee WHERE location = 'Sydney' AND age >= 50 AND end_date IS NULL ORDER BY name LIMIT 50 OFFSET 20000;

  -- However, after all this...
  CREATE INDEX idx_par_employee_sydney_name_age ON employee (name, age) WHERE end_date IS NULL AND location = 'Sydney';
  CREATE INDEX idx_par_employee_location_name_age ON employee (location, name, age) WHERE end_date IS NULL;

  EXPLAIN ANALYZE SELECT name, age FROM employee WHERE location = 'Sydney' AND age >= 50 AND end_date IS NULL ORDER BY name LIMIT 50 OFFSET 20000;

-- DEMO 6 - GIN Indexes

  -- Show that indexes are skipped for some LIKE queries
  EXPLAIN ANALYZE SELECT * FROM employee WHERE name LIKE 'foo%';
  EXPLAIN ANALYZE SELECT * FROM employee WHERE name LIKE '%foo';

  CREATE EXTENSION pg_trgm;
  CREATE INDEX trgm_idx_employee_name ON employee USING gin (name gin_trgm_ops);

  EXPLAIN ANALYZE SELECT * FROM employee WHERE name LIKE '%foo';

-- DEMO 7 - AUTOVACUUM

  SELECT n_live_tup, n_dead_tup, last_vacuum, last_autovacuum, last_analyze, last_autovacuum FROM pg_stat_user_tables;
  UPDATE employee SET name = 'Steve Cresswell' WHERE id = 1;	
  SELECT n_live_tup, n_dead_tup, last_vacuum, last_autovacuum, last_analyze, last_autovacuum FROM pg_stat_user_tables;

  VACUUM ANALYZE;

-- TESTING

  


