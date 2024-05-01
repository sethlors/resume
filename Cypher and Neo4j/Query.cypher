// 1) (4pts) The campus addresses of the students whose name is "Kevin"
MATCH (s:student)
  WHERE s.name = "Kevin"
RETURN s.c_addr AS CampusAddress

// 2) (4pts) The major name and major level of the students whose name is "Kevin"
MATCH(s:student)-[m:major]->(d:degree)
WHERE s.name = "Kevin"
RETURN d.name, d.level

// 3) (4pts) The numbers and names of all courses offered by the department of Computer Science, order by course number
MATCH (d:department)-[:administer]->(dg:degree)
  WHERE d.name="Computer Science"
RETURN d.dcode, d.name;

// 4) (4pts) The name of the students enrolled in Fall2020 semester
MATCH(s:student)-[r:register]->(c:course)
  WHERE r.regtime="Fall2020"
RETURN s.name

// 5) (4pts) All degree names and levels offered by the department Computer Science, order by degree level
MATCH (dg:degree)<-[:administer]-(d:department)
  WHERE d.name="Computer Science"
RETURN dg.name, dg.level;

// 6) (5pts) The snum and names of all students who have a minor, order by student snum
MATCH(s:student)-[:minor]->(d:degree)
RETURN s.name, s.snum

// 7) (5pts) The names and snums of all non-undergraduate students enrolled in course “database”, order by snum. (“non-undergraduate students” means the major degrees of these students are MS or PhD levels)
MATCH(s:student)-[:register]->(c:course)
  WHERE c.name = "Database"
RETURN s.name, s.snum
    ORDER BY s.snum

// 8) (5pts) The name, snum and SSN of the students whose name contains letter “n” or “N”, order by snum
MATCH(s:student)
  WHERE s.name Contains 'N' OR s.name Contains 'n'
RETURN s.name, s.snum, s.ssn

// 9) (5pts) The name, snum and SSN of the students whose name is between “Becky” and “Nicole”, order by name
MATCH(s:student)
  WHERE s.name > "Becky" AND s.name < "Nicole"
RETURN s.name, s.snum, s.ssn

// 10) (5pts) The course number, name and the number of students registered for each course, order by course number (if a course has no student registered, the count should be 0)
MATCH(s:student)-[:register]->(c:course)
RETURN c.number, c.name, count(s)

// 11) (5pts) The count of female students who major or minor in Software Engineering degrees at any level
MATCH (s:student)-[:major]->(majorDegree:degree)
MATCH (s:student)-[:minor]->(minorDegree:degree)
  WHERE (majorDegree.name = "Software Engineering" OR minorDegree.name = "Software Engineering") AND s.gender = "F"
RETURN count(s)

// 12) (5pts) The numbers and names of courses and their corresponding average grades from students registered in the past semesters.
MATCH (s:student)-[r:register]->(c:course)
RETURN c.number, c.name, avg(r.grade)

// 13) (5pts) The count of female students who major or minor in a degree managed by LAS departments
MATCH (s:student)-[:major|minor]->(d:degree)-[:administer]->(dpt:department)
  WHERE dpt.name STARTS WITH "LAS" AND s.gender = "F"
RETURN count(s)

// 14) (5pts) The names of degrees that have more male students than female students(major or minor)
MATCH (d:degree)<-[:major|minor]-(s:student)
WITH d.name as degree_name, s.gender AS gender
WITH
  degree_name,
  sum(CASE WHEN gender = 'M' THEN 1 ELSE 0 END) AS male_students,
  sum(CASE WHEN gender = 'F' THEN 1 ELSE 0 END) AS female_students
  WHERE male_students > female_students
RETURN degree_name

// 15) (5pts) The major degree that the youngest student is taken
Match(s:student)-[:major]->(d:degree)
return s.name
  order by s.dob desc limit 1

// 16)(bonus 5pts) The most popular major degrees and the number of students of these most popular majors (I.e., the major with the highest number of students)
MATCH (d:degree)<-[:major]-(s:student)
WITH d, count(s) AS num_students
  ORDER BY num_students DESC
  LIMIT 1
RETURN d.name AS most_popular_major, num_students AS num_students_of_most_popular_major

// 17)(bonus 5pts) The most popular major degrees and number of students of the most popular degrees (I.e., the degree program with the highest number of students taking it as major or minor
MATCH (d:degree)<-[:major|minor]-(s:student)
WITH d, count(s) AS num_students
  ORDER BY num_students DESC
  LIMIT 1
RETURN d.name AS most_popular_degree, num_students AS num_students_of_most_popular_degree


