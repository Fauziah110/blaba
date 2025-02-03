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
import resort.utils.DatabaseUtility;

public class AdminLoginController extends HttpServlet {
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
            conn = DatabaseUtility.getConnection();
            System.out.println("Azure database connection established successfully.");

            // Use parameterized query to prevent SQL injection
            String sql = "SELECT staffName, staffEmail, staffPhoneNo, adminId FROM staff WHERE staffEmail = ? AND staffPassword = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);
            pstmt.setString(2, password);

            System.out.println("Executing query: SELECT ... FROM staff WHERE staffEmail = ? AND staffPassword = ?");

            rs = pstmt.executeQuery();

            if (rs.next()) {
                // Successful login: Create session and redirect
                System.out.println("Login successful for email: " + email);

                HttpSession session = request.getSession();
                session.setAttribute("staffName", rs.getString("staffName"));
                session.setAttribute("staffEmail", rs.getString("staffEmail"));
                session.setAttribute("staffPhoneNo", rs.getString("staffPhoneNo"));
                session.setAttribute("adminId", rs.getInt("adminId"));

                response.sendRedirect("Dashboard.jsp");
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
            DatabaseUtility.closeResources(rs, pstmt, conn);
            System.out.println("Database resources closed.");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("Login.jsp");
    }
}
