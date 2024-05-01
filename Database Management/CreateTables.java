package coms363Project1b;

import java.sql.*;

public class CreateTables {
    private static Connection connect = null;

    public static void main(String[] args) {

        try {
            //Set up connection parameters
            String userName = "coms363";
            String password = "password";
            String dbServer = "jdbc:mysql://localhost:3306/project1";
            connect = DriverManager.getConnection(dbServer, userName, password);
        } catch (Exception e) {

        }

        Statement stmt = null;
        try {
            stmt = connect.createStatement();
            stmt.addBatch("CREATE TABLE students (\r\n" +
                    "	snum INT,\r\n" +
                    "	ssn INTEGER,\r\n" +
                    "    name VARCHAR(10),\r\n" +
                    "    gender VARCHAR(1),\r\n" +
                    "    dob DATE, \r\n" +
                    "    c_addr VARCHAR(20),\r\n" +
                    "    c_phone VARCHAR(10),\r\n" +
                    "    p_addr VARCHAR(20),\r\n" +
                    "    p_phone VARCHAR(10),\r\n" +
                    "    PRIMARY KEY(ssn),\r\n" +
                    "    UNIQUE(snum)\r\n" +
                    ");");

            stmt.addBatch("CREATE TABLE departments (\r\n" +
                    "	code INTEGER PRIMARY KEY,\r\n" +
                    "    name VARCHAR(50) UNIQUE,\r\n" +
                    "    phone VARCHAR(10),\r\n" +
                    "    college VARCHAR(20)\r\n" +
                    ");");

            stmt.addBatch("CREATE TABLE degrees (\r\n" +
                    "	name VARCHAR(50),\r\n" +
                    "    level VARCHAR(5),\r\n" +
                    "    department_code INTEGER,\r\n" +
                    "    PRIMARY KEY (name, level),\r\n" +
                    "    FOREIGN KEY (department_code) REFERENCES departments(code)\r\n" +
                    ");");

            stmt.addBatch("CREATE TABLE courses (\r\n" +
                    "	number INTEGER,\r\n" +
                    "    name VARCHAR(50),\r\n" +
                    "    description VARCHAR(50),\r\n" +
                    "    credithours INTEGER,\r\n" +
                    "    level VARCHAR(20),\r\n" +
                    "    department_code INTEGER,\r\n" +
                    "    PRIMARY KEY (number),\r\n" +
                    "    FOREIGN KEY (department_code) REFERENCES departments(code)\r\n" +
                    ");");

            stmt.addBatch("CREATE TABLE register (\r\n" +
                    "	snum INTEGER,\r\n" +
                    "    course_number INTEGER,\r\n" +
                    "    regtime VARCHAR(20),\r\n" +
                    "    grade INTEGER,\r\n" +
                    "    PRIMARY KEY (snum, course_number),\r\n" +
                    "    FOREIGN KEY (snum) REFERENCES students(snum),\r\n" +
                    "    FOREIGN KEY (course_number) REFERENCES courses(number)\r\n" +
                    ");");

            stmt.addBatch("CREATE TABLE major (\r\n" +
                    "	snum INTEGER,\r\n" +
                    "    name VARCHAR(50),\r\n" +
                    "    level VARCHAR(5),\r\n" +
                    "    PRIMARY KEY (snum, name, level),\r\n" +
                    "    FOREIGN KEY (snum) REFERENCES students(snum),\r\n" +
                    "    FOREIGN KEY (name, level) REFERENCES degrees(name, level)\r\n" +
                    ");");

            stmt.addBatch("CREATE TABLE minor (\r\n" +
                    "	snum INTEGER,\r\n" +
                    "    name VARCHAR(50),\r\n" +
                    "    level VARCHAR(5),\r\n" +
                    "    PRIMARY KEY (snum, name, level),\r\n" +
                    "    FOREIGN KEY (snum) REFERENCES students(snum),\r\n" +
                    "    FOREIGN KEY (name, level) REFERENCES degrees(name, level)\r\n" +
                    ");");


        } catch (SQLException e) {
            System.out.println("Error creating a connection: " + e.getMessage());
            e.printStackTrace();
        }

        try {

            stmt.executeBatch();

        } catch (SQLException e) {
            System.out.println("Error creating a connection: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                // Close connection
                if (stmt != null) {
                    stmt.close();
                }
                if (connect != null) {
                    connect.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}