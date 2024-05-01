package coms363Project1b;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class Query {
    private static Connection connect = null;

    public static void main(String[] args) {

        try {
            // Set up connection parameters
            String userName = "coms363";
            String password = "password";
            String dbServer = "jdbc:mysql://localhost:3306/project1";
            connect = DriverManager.getConnection(dbServer, userName, password);
        } catch (Exception e) {
            e.printStackTrace();
        }

        Statement stmt = null;
        try {
            stmt = connect.createStatement();

            // 1) The numbers and names of courses and their corresponding average grades
            // from students registered in the past semesters.
            ResultSet resultSet1 = stmt.executeQuery("SELECT c.number, c.name, AVG(r.grade) AS avg_grade " +
                    "FROM courses c " +
                    "JOIN register r ON c.number = r.course_number " +
                    "GROUP BY c.number, c.name");

            System.out.println("1) Course Numbers, Names, and Average Grades:");
            while (resultSet1.next()) {
                int courseNumber = resultSet1.getInt("number");
                String courseName = resultSet1.getString("name");
                double avgGrade = resultSet1.getDouble("avg_grade");
                System.out.println("Course Number: " + courseNumber + ", Course Name: " + courseName + ", Average Grade: " + avgGrade);
            }
            System.out.println();

            // 2) The count of female students who major or minor in a degree managed by LAS departments
            ResultSet resultSet2 = stmt.executeQuery("SELECT COUNT(*) AS female_count " +
                    "FROM (SELECT s.snum " +
                    "      FROM students s " +
                    "      JOIN major m ON s.snum = m.snum " +
                    "      JOIN degrees d ON m.name = d.name AND m.level = d.level " +
                    "      JOIN departments dept ON d.department_code = dept.code " +
                    "      WHERE s.gender = 'F' AND dept.college = 'LAS' " +
                    "      UNION " +
                    "      SELECT s.snum " +
                    "      FROM students s " +
                    "      JOIN minor mi ON s.snum = mi.snum " +
                    "      JOIN degrees d ON mi.name = d.name AND mi.level = d.level " +
                    "      JOIN departments dept ON d.department_code = dept.code " +
                    "      WHERE s.gender = 'F' AND dept.college = 'LAS') AS female_students");

            int totalFemaleCount = 0;
            if (resultSet2.next()) {
                totalFemaleCount = resultSet2.getInt("female_count");
            }
            System.out.println("2) Count of Female Students in LAS Departments: " + totalFemaleCount);
            System.out.println();

            // 3) The names of degrees that have more male students than female students (major or minor)
            ResultSet resultSet3 = stmt.executeQuery("SELECT d.name " +
                    "FROM degrees d " +
                    "WHERE (SELECT COUNT(*) FROM major m WHERE m.name = d.name AND m.level = d.level AND (SELECT s.gender FROM students s WHERE s.snum = m.snum) = 'M') > " +
                    "(SELECT COUNT(*) FROM major m WHERE m.name = d.name AND m.level = d.level AND (SELECT s.gender FROM students s WHERE s.snum = m.snum) = 'F') " +
                    "UNION " +
                    "SELECT d.name " +
                    "FROM degrees d " +
                    "WHERE (SELECT COUNT(*) FROM minor mi WHERE mi.name = d.name AND mi.level = d.level AND (SELECT s.gender FROM students s WHERE s.snum = mi.snum) = 'M') > " +
                    "(SELECT COUNT(*) FROM minor mi WHERE mi.name = d.name AND mi.level = d.level AND (SELECT s.gender FROM students s WHERE s.snum = mi.snum) = 'F')");

            System.out.println("3) Degrees with More Male Students than Female Students:");
            while (resultSet3.next()) {
                String degreeName = resultSet3.getString("name");
                System.out.println(degreeName);
            }
            System.out.println();

            // 4) The major degree that the youngest student is taking
            ResultSet resultSet4 = stmt.executeQuery("SELECT m.name " +
                    "FROM major m " +
                    "JOIN students s ON m.snum = s.snum " +
                    "WHERE s.dob = (SELECT MIN(dob) FROM students)");

            System.out.println("4) Major Degree of the Youngest Student:");
            if (resultSet4.next()) {
                String majorName = resultSet4.getString("name");
                System.out.println(majorName);
            }
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
