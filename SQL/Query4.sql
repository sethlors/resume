-- Query4.sql

-- Print the names of students enrolled in Fall 2020 semester
SELECT DISTINCT s.name
FROM students AS s
INNER JOIN register AS r ON s.snum = r.snum
WHERE r.regtime LIKE '%Fall2020%';
