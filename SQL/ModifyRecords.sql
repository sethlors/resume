-- ModifyRecords.sql

-- Change the name of the student with ssn = 746897816 to Scott
UPDATE students
SET name = 'Scott'
WHERE ssn = 746897816;

-- Change the major of the student with ssn = 746897816 to Computer Science, Master
UPDATE major
SET name = 'Computer Science', level = 'MS'
WHERE snum = (
    SELECT snum
    FROM students
    WHERE ssn = 746897816
);

-- Delete all registration records that were in "Spring2021"
DELETE FROM register
WHERE regtime = 'Spring2021';
