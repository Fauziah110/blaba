package resort.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DatabaseUtility {
    // ✅ Updated for Microsoft SQL Server
    private static final String DB_URL = "jdbc:sqlserver://mdresort.database.windows.net:1433;"
            + "databaseName=mdresort;"  // ✅ Fixed 'database' → 'databaseName'
            + "user=mdresort;"
            + "password=resort_2025;"
            + "encrypt=true;"
            + "trustServerCertificate=false;"
            + "hostNameInCertificate=*.database.windows.net;"
            + "loginTimeout=30;";

    public static Connection getConnection() throws SQLException {
        try {
            // ✅ Ensure SQL Server JDBC driver is loaded
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            System.out.println("✅ DEBUG: SQL Server JDBC Driver loaded successfully.");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("❌ SQL Server JDBC Driver not found! Please check the JAR file.", e);
        }

        // ✅ Establish database connection
        Connection conn = DriverManager.getConnection(DB_URL);
        System.out.println("✅ DEBUG: Database connected successfully.");
        return conn;
    }

    // ✅ Close ResultSet, PreparedStatement, and Connection safely
    public static void closeResources(ResultSet rs, PreparedStatement pstmt, Connection conn) {
        try {
            if (rs != null) rs.close();
        } catch (SQLException e) {
            System.err.println("❌ ERROR: Failed to close ResultSet - " + e.getMessage());
        }

        try {
            if (pstmt != null) pstmt.close();
        } catch (SQLException e) {
            System.err.println("❌ ERROR: Failed to close PreparedStatement - " + e.getMessage());
        }

        try {
            if (conn != null && !conn.isClosed()) {
                conn.close();
                System.out.println("✅ DEBUG: Database connection closed.");
            }
        } catch (SQLException e) {
            System.err.println("❌ ERROR: Failed to close Connection - " + e.getMessage());
        }
    }
}
