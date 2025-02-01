package resort.connection;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ConnectionManager {
    // Azure SQL Database connection details
    private static final String URL = "jdbc:sqlserver://mdresort.database.windows.net:1433;"
                                    + "database=mdresort;"
                                    + "encrypt=true;trustServerCertificate=false;"
                                    + "hostNameInCertificate=*.database.windows.net;"
                                    + "loginTimeout=30;";
    private static final String USERNAME = "mdresort";
    private static final String PASSWORD = "mdresort_2025";

    // Static block to load the JDBC driver
    static {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("SQL Server JDBC Driver not found", e);
        }
    }

    // Method to get database connection
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }

    // Method to close database connection
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // Method to close ResultSet, PreparedStatement, and Connection
    public static void closeResources(ResultSet rs, PreparedStatement stmt, Connection conn) {
        try {
            if (rs != null) rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        try {
            if (stmt != null) stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        try {
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}