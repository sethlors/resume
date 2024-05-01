package coms363Project1b;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class ModifyRecords {
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

            // Disable foreign key checks temporarily
            stmt.execute("SET FOREIGN_KEY_CHECKS = 0");

            // 1) Change the name of the student with ssn = 746897816 to Scott
            stmt.executeUpdate("UPDATE students SET name = 'Scott' WHERE ssn = 746897816");

            // 2) Change the major of the student with ssn = 746897816 to Computer Science, Master
            stmt.executeUpdate("UPDATE major SET name = 'Computer Science', level = 'Master' WHERE snum = 746897816");

            // 3) Delete all registration records that were in “Spring2021”
            stmt.executeUpdate("DELETE FROM register WHERE regtime = 'Spring2021'");

            // Delete duplicates in courses table (including corresponding records in register)
            stmt.executeUpdate("DELETE c FROM courses c " +
                    "JOIN (SELECT MIN(number) AS min_number, level, department_code " +
                    "      FROM courses " +
                    "      GROUP BY level, department_code " +
                    "      HAVING COUNT(*) > 1) AS duplicates " +
                    "ON c.number > duplicates.min_number " +
                    "AND c.level = duplicates.level " +
                    "AND c.department_code = duplicates.department_code");

            // Re-enable foreign key checks
            stmt.execute("SET FOREIGN_KEY_CHECKS = 1");

        } catch (SQLException e) {
            System.out.println("Error modifying records: " + e.getMessage());
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
