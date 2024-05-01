-- Query10.sql

-- Retrieve course number, name, and the number of students registered for each course
SELECT c.number AS course_number, c.name AS course_name, COUNT(r.snum) AS student_count
FROM courses AS c
LEFT JOIN register AS r ON c.number = r.course_number
GROUP BY c.number, c.name
ORDER BY c.number;
