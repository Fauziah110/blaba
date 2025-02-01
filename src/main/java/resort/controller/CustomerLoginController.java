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
        // ✅ Retrieve and validate input
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "❌ Email and password cannot be empty.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        email = email.trim();
        password = password.trim();

        // ✅ Debugging: Log email and password (masked for security)
        System.out.println("✅ DEBUG: Checking login for email: [" + email + "]");
        System.out.println("✅ DEBUG: Password is hidden for security");

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // ✅ Establish database connection
            conn = ConnectionManager.getConnection();
            System.out.println("✅ DEBUG: Database connection established successfully.");

            // ✅ SQL query with case-insensitive email check
            String sql = "SELECT customerName, customerEmail, customerPhoneNo FROM dbo.Customer " +
                         "WHERE LOWER(customerEmail) = LOWER(?) AND customerPassword = ?";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email.toLowerCase()); // ✅ Case-insensitive match
            pstmt.setString(2, password); // ✅ Ensure correct password is sent

            System.out.println("✅ DEBUG: Executing query...");

            rs = pstmt.executeQuery();

            if (!rs.isBeforeFirst()) { // ✅ No results found
                System.out.println("❌ DEBUG: No user found with email: " + email);
                request.setAttribute("errorMessage", "❌ Invalid email or password. Please try again.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            while (rs.next()) {
                System.out.println("✅ DEBUG: Found user: " + rs.getString("customerEmail"));

                // ✅ Successful login: Create session and redirect
                HttpSession session = request.getSession();
                session.setAttribute("customerName", rs.getString("customerName"));
                session.setAttribute("customerEmail", rs.getString("customerEmail"));
                session.setAttribute("customerPhoneNo", rs.getString("customerPhoneNo"));

                System.out.println("✅ DEBUG: Login successful for email: " + email);
                response.sendRedirect("index.jsp");
                return;
            }

        } catch (SQLException e) {
            // ❌ Log error and show a generic error message
            e.printStackTrace();
            request.setAttribute("errorMessage", "❌ An error occurred. Please try again later.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } finally {
            // ✅ Close resources
            ConnectionManager.closeResources(rs, pstmt, conn);
            System.out.println("✅ DEBUG: Database resources closed.");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("login.jsp");
    }
}
