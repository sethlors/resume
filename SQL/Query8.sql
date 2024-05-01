-- Query8.sql

-- Print the name, snum, and SSN of students with names containing "n" or "N", ordered by snum
SELECT s.name, s.snum, s.ssn
FROM students AS s
WHERE UPPER(s.name) LIKE '%N%'
ORDER BY s.snum;
