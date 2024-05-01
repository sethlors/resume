-- Query9.sql

-- Print the name, snum, and SSN of students with names between "Becky" and "Nicole", ordered by name
SELECT s.name, s.snum, s.ssn
FROM students AS s
WHERE s.name BETWEEN 'Becky' AND 'Nicole'
ORDER BY s.name;
