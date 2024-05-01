-- Query7.sql

-- Print the names and snums of non-undergraduate students enrolled in "database" course, ordered by snum
SELECT s.name, s.snum
FROM students AS s
INNER JOIN major AS m ON s.snum = m.snum
INNER JOIN register AS r ON s.snum = r.snum
INNER JOIN courses AS c ON r.course_number = c.number
WHERE c.name = 'database' AND (m.level = 'MS' OR m.level = 'PhD')
ORDER BY s.snum;
