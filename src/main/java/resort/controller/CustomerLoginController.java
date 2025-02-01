package resort.controller;

import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import resort.connection.ConnectionManager;

public class CustomerLoginController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Hash password using SHA-256
    private String hashPassword(String password) throws NoSuchAlgorithmException {
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] hashBytes = digest.digest(password.getBytes());
        StringBuilder hexString = new StringBuilder();
        for (byte b : hashBytes) {
            hexString.append(String.format("%02x", b));
        }
        return hexString.toString();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Retrieve and validate input
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Email and password cannot be empty.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        email = email.trim().toLowerCase(); // Normalize email to lowercase
        password = password.trim();

        // Debugging: Log email but hide password
        System.out.println("✅ DEBUG: Checking login for email: [" + email + "]");
        System.out.println("✅ DEBUG: Password is hidden for security");

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // Establish database connection
            conn = ConnectionManager.getConnection();
            System.out.println("✅ DEBUG: Database connected successfully.");
            System.out.println("✅ DEBUG: Connected to database: " + conn.getCatalog());

            // Check if email exists first
            String emailCheckQuery = "SELECT customerPassword FROM Customer WHERE LOWER(customerEmail) = LOWER(?)";
            pstmt = conn.prepareStatement(emailCheckQuery);
            pstmt.setString(1, email);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                // Email exists, now check password
                String storedHashedPassword = rs.getString("customerPassword");

                // Hash the input password before comparing
                String hashedInputPassword = hashPassword(password);
                
                if (hashedInputPassword.equals(storedHashedPassword)) {
                    // Password matches, now retrieve user details
                    String userDetailsQuery = "SELECT customerName, customerEmail, customerPhoneNo FROM Customer WHERE LOWER(customerEmail) = LOWER(?)";
                    pstmt = conn.prepareStatement(userDetailsQuery);
                    pstmt.setString(1, email);
                    rs = pstmt.executeQuery();

                    if (rs.next()) {
                        // Successful login: Create session and redirect
                        System.out.println("✅ DEBUG: Login successful for email: " + email);

                        HttpSession session = request.getSession();
                        session.setAttribute("customerName", rs.getString("customerName"));
                        session.setAttribute("customerEmail", rs.getString("customerEmail"));
                        session.setAttribute("customerPhoneNo", rs.getString("customerPhoneNo"));

                        response.sendRedirect("index.jsp");
                        return;
                    }
                } else {
                    System.out.println("❌ DEBUG: Incorrect password for email: " + email);
                    request.setAttribute("errorMessage", "Invalid email or password. Please try again.");
                }
            } else {
                System.out.println("❌ DEBUG: No user found with email: " + email);
                request.setAttribute("errorMessage", "Invalid email or password. Please try again.");
            }

            // Forward back to login page on failure
            request.getRequestDispatcher("login.jsp").forward(request, response);

        } catch (SQLException | NoSuchAlgorithmException e) {
            // Log error and show generic error message
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred. Please try again later.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } finally {
            // Close resources
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
