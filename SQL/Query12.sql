-- Query12.sql

-- Retrieve degree name, degree level, and number of students for the most popular majors
SELECT m.name AS degree_name, m.level AS degree_level, COUNT(DISTINCT m.snum) AS student_count
FROM major AS m
GROUP BY m.name, m.level
HAVING COUNT(DISTINCT m.snum) = (
    SELECT MAX(student_count)
    FROM (
        SELECT name, level, COUNT(DISTINCT snum) AS student_count
        FROM major
        GROUP BY name, level
    ) AS max_counts
)
ORDER BY m.name;
