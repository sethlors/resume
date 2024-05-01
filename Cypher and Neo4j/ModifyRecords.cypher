// Change the name of the student with ssn = 746897816 to Scott
Match(s:student)
  Where s.ssn = 746897816
Set s.name = "Scott"
Return s

// Change the major of the student with ssn = 746897816 to Computer Science, Master.
Match(s:student)-[m:major]->(d:degree)
  Where s.ssn = 746897816
Set d += {name: "Computer Science", level: "MS"}
Return s

// Delete all registration records that were in “Spring2021”.
Match(s:student)-[r:register {regtime:"Spring2021"}]->(c:courses)
Detach Delete r