package resort.connection;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectionManager {
    // Database connection parameters
	private static final String DB_URL = "jdbc:oracle:thin:@localhost:1521:xe";
	private static final String DB_USER = "mdresort25";
	private static final String DB_PASSWORD = "mdresort123"; // New password


    // Method to get a database connection
    public static Connection getConnection() throws SQLException {
        Connection connection = null;
        try {
            // Load Oracle JDBC driver
            Class.forName("oracle.jdbc.driver.OracleDriver");
            // Establish the connection
            connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            System.out.println("Database connected successfully!");
        } catch (ClassNotFoundException e) {
            System.out.println("Oracle JDBC Driver not found. Please add the driver to your classpath.");
            e.printStackTrace();
            throw new SQLException("Unable to load JDBC driver.", e);
        } catch (SQLException e) {
            System.out.println("Database connection failed.");
            e.printStackTrace();
            throw e;
        }
        return connection;
    }

    // Main method for testing the connection
    public static void main(String[] args) {
        try (Connection connection = ConnectionManager.getConnection()) {
            if (connection != null) {
                System.out.println("Connection test successful!");
            }
        } catch (SQLException e) {
            System.out.println("Connection test failed.");
            e.printStackTrace();
        }
    }
}
