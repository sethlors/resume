-- Query2.sql

-- Print the major name and major level of students named "Kevin"
SELECT m.name AS major_name, m.level AS major_level
FROM students AS s
INNER JOIN major AS m ON s.snum = m.snum
WHERE s.name = 'Kevin';
