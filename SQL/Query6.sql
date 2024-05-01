-- Query6.sql

-- Print the snum and names of students with a minor, ordered by snum
SELECT s.snum, s.name
FROM students AS s
INNER JOIN minor AS m ON s.snum = m.snum
ORDER BY s.snum;
