-- Query3.sql

-- Print the numbers and names of courses offered by the Computer Science department
SELECT number, name
FROM courses
WHERE department_code = 401
ORDER BY number;
