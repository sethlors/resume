-- Query11.sql

-- Count of female students majoring or minoring in Software Engineering degrees
SELECT COUNT(DISTINCT s.snum) AS female_count
FROM students AS s

WHERE s.snum IN (SELECT mj.snum
FROM major as mj
WHERE mj.name = 'Software Engineering'
UNION
SELECT mn.snum
FROM minor as mn
WHERE mn.name = 'Software Engineering')
     AND s.gender = 'F';


