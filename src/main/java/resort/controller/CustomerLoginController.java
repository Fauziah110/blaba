package resort.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import resort.connection.ConnectionManager;

public class CustomerLoginController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Retrieve and validate input
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Email and password cannot be empty.");
            request.getRequestDispatcher("Login.jsp").forward(request, response);
            return;
        }

        email = email.trim();
        password = password.trim();

        // Debugging: Log email and password (masked for security)
        System.out.println("Email: [" + email + "]");
        System.out.println("Password: [HIDDEN]");

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // Establish database connection
            conn = ConnectionManager.getConnection();
            System.out.println("Database connection established successfully.");

            // Use parameterized query to prevent SQL injection
            String sql = "SELECT customerName, customerEmail, customerPhoneNo, customerPassword FROM customer WHERE customerEmail = ? AND customerPassword = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);
            pstmt.setString(2, password);

            System.out.println("Executing query: SELECT ... FROM customer WHERE customerEmail = ? AND customerPassword = ?");

            rs = pstmt.executeQuery();

            if (rs.next()) {
                // Successful login: Create session and redirect
                System.out.println("Login successful for email: " + email);

                HttpSession session = request.getSession();
                session.setAttribute("customerName", rs.getString("customerName"));
                session.setAttribute("customerEmail", rs.getString("customerEmail"));
                session.setAttribute("customerPhoneNo", rs.getString("customerPhoneNo"));
                session.setAttribute("customerPassword", rs.getString("customerPassword"));

                response.sendRedirect("index.jsp");
            } else {
                // Login failed: Show error message
                System.out.println("Login failed. Invalid email or password.");
                request.setAttribute("errorMessage", "Invalid email or password. Please try again.");
                request.getRequestDispatcher("Login.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            // Log error and show generic error message
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred. Please try again later.");
            request.getRequestDispatcher("Login.jsp").forward(request, response);
        } finally {
            // Close resources
        	ConnectionManager.closeResources(rs, pstmt, conn);
            System.out.println("Database resources closed.");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("Login.jsp");
    }
}
