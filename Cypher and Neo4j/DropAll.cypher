// This script deletes all nodes and edges from the database.
Match(s:student)
Detach Delete s

Match(d:departments)
Detach Delete d

Match(d:degrees)
Detach Delete d

Match(c:courses)
Detach Delete c

Match(r:register)
Detach Delete r

Match(m:major)
Detach Delete m

Match(m:minor)
Detach Delete m