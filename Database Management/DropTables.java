package coms363Project1b;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class DropTables {
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

            // Drop tables in the specified order (reverse order of creation)
            stmt.executeUpdate("DROP TABLE IF EXISTS register;");
            stmt.executeUpdate("DROP TABLE IF EXISTS major;");
            stmt.executeUpdate("DROP TABLE IF EXISTS minor;");
            stmt.executeUpdate("DROP TABLE IF EXISTS courses;");
            stmt.executeUpdate("DROP TABLE IF EXISTS degrees;");
            stmt.executeUpdate("DROP TABLE IF EXISTS departments;");
            stmt.executeUpdate("DROP TABLE IF EXISTS students;");

            System.out.println("Tables dropped successfully.");

        } catch (SQLException e) {
            System.out.println("Error dropping tables: " + e.getMessage());
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
