package resort.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

@WebServlet("/SignupCustomerController") // Ensure correct URL mapping
public class SignupCustomerController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Hash password using SHA-256 for security
    private String hashPassword(String password) throws NoSuchAlgorithmException {
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] hashBytes = digest.digest(password.getBytes());
        StringBuilder hexString = new StringBuilder();
        for (byte b : hashBytes) {
            hexString.append(String.format("%02x", b));
        }
        return hexString.toString();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve form data
        String customerName = request.getParameter("customer-name");  
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phoneNo = request.getParameter("phone-no");

        // Validate input (Ensure all fields are filled)
        if (customerName == null || email == null || password == null || phoneNo == null ||
            customerName.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty() || phoneNo.trim().isEmpty()) {
            response.getWriter().println("<script>alert('All fields are required!'); window.history.back();</script>");
            return;
        }

        // **Azure SQL Database Connection**
        String url = "jdbc:sqlserver://mdresort.database.windows.net:1433;databaseName=mdresort";
        String username = "mdresort";
        String dbPassword = "resort_2025";

        // Insert query
        String insertQuery = "INSERT INTO Customer (customerName, customerEmail, customerPassword, customerPhoneNo) VALUES (?, ?, ?, ?)";

        try {
            // Hash password before storing
            String hashedPassword = hashPassword(password);

            // Load SQL Server JDBC driver
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

            // Establish connection & execute insert query
            try (Connection conn = DriverManager.getConnection(url, username, dbPassword);
                 PreparedStatement stmt = conn.prepareStatement(insertQuery)) {

                // Set parameters
                stmt.setString(1, customerName);
                stmt.setString(2, email);
                stmt.setString(3, hashedPassword);
                stmt.setString(4, phoneNo);

                // Execute query
                int rowsAffected = stmt.executeUpdate();

                if (rowsAffected > 0) {
                    // Success: Show success alert and redirect to login
                    response.setContentType("text/html");
                    response.getWriter().println("<script>alert('Sign-up successful! Redirecting to login...');"
                            + "window.location.href = 'login.jsp';</script>");
                } else {
                    // Failure: Show error message
                    response.getWriter().println("<script>alert('Sign-up failed. Please try again!'); window.history.back();</script>");
                }
            }
        } catch (SQLException e) {
            // Handle SQL errors
            e.printStackTrace();
            response.getWriter().println("<script>alert('Database error: " + e.getMessage() + "'); window.history.back();</script>");
        } catch (ClassNotFoundException e) {
            // Handle missing driver
            e.printStackTrace();
            response.getWriter().println("<script>alert('JDBC Driver not found!'); window.history.back();</script>");
        } catch (NoSuchAlgorithmException e) {
            // Handle hashing errors
            e.printStackTrace();
            response.getWriter().println("<script>alert('Error hashing password!'); window.history.back();</script>");
        }
    }
}
