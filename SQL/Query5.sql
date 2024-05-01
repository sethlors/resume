-- Query5.sql

-- Print all degree names and levels offered by the Computer Science department
SELECT name, level
FROM degrees
WHERE department_code = 401
ORDER BY level;
