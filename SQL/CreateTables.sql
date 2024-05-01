-- CreateTables.sql

-- Create a new database
-- CREATE DATABASE student_data;

-- -- Select the newly created database
-- USE student_data;

-- Drop the register table
DROP TABLE IF EXISTS register;

-- Drop the major table
DROP TABLE IF EXISTS major;

-- Drop the minor table
DROP TABLE IF EXISTS minor;

-- Drop the courses table
DROP TABLE IF EXISTS courses;

-- Drop the degrees table
DROP TABLE IF EXISTS degrees;

-- Drop the departments table
DROP TABLE IF EXISTS departments;

-- Drop the Students table
DROP TABLE IF EXISTS students;


-- students table
CREATE TABLE students (
    snum INTEGER UNIQUE,
    ssn INTEGER PRIMARY KEY,
    name VARCHAR(10),
    gender VARCHAR(1),
    dob DATETIME,
    c_addr VARCHAR(20),
    c_phone VARCHAR(10),
    p_addr VARCHAR(20),
    p_phone VARCHAR(10)
);

-- departments table
CREATE TABLE departments (
    code INTEGER PRIMARY KEY,
    name VARCHAR(50) UNIQUE,
    phone VARCHAR(10),
    college VARCHAR(20)
);

-- degrees table
CREATE TABLE degrees (
    name VARCHAR(50),
    level VARCHAR(5),
    department_code INTEGER,
    PRIMARY KEY (name, level),
    FOREIGN KEY (department_code) REFERENCES departments(code)
);

-- courses table
CREATE TABLE courses (
    number INTEGER,
    name VARCHAR(50),
    description VARCHAR(50),
    credithours INTEGER,
    level VARCHAR(20),
    department_code INTEGER,
    PRIMARY KEY (number),
    FOREIGN KEY (department_code) REFERENCES departments(code)
);

-- register table
CREATE TABLE register (
    snum INTEGER,
    course_number INTEGER,
    regtime VARCHAR(20),
    grade INTEGER,
    PRIMARY KEY (snum, course_number), 
    FOREIGN KEY (snum) REFERENCES students(snum),
    FOREIGN KEY (course_number) REFERENCES courses(number)
);

-- major table
CREATE TABLE major (
    snum INTEGER,
    name VARCHAR(50),
    level VARCHAR(5),
    PRIMARY KEY (snum, name, level),
    FOREIGN KEY (snum) REFERENCES students(snum),
    FOREIGN KEY (name, level) REFERENCES degrees(name, level)
);

-- minor table
CREATE TABLE minor (
    snum INTEGER,
    name VARCHAR(50),
    level VARCHAR(5),
    PRIMARY KEY (snum, name, level),
    FOREIGN KEY (snum) REFERENCES students(snum),
    FOREIGN KEY (name, level) REFERENCES degrees(name, level)
);
