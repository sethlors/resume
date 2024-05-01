-- Query13.sql

-- Retrieve degree name, degree level, and number of students for the most popular degrees
WITH DegreePopularity AS (
    SELECT
        d.name AS degree_name,
        d.level AS degree_level,
        COUNT(DISTINCT m.snum) AS student_count
    FROM
        degrees d
    LEFT JOIN
        major m ON d.name = m.name AND d.level = m.level
    GROUP BY
        d.name, d.level
    UNION
    SELECT
        d.name AS degree_name,
        d.level AS degree_level,
        COUNT(DISTINCT mn.snum) AS student_count
    FROM
        degrees d
    LEFT JOIN
        minor mn ON d.name = mn.name AND d.level = mn.level
    GROUP BY
        d.name, d.level
)
SELECT
    degree_name,
    degree_level,
    SUM(student_count) AS total_student_count
FROM
    DegreePopularity
GROUP BY
    degree_name, degree_level
ORDER BY
    total_student_count DESC;
