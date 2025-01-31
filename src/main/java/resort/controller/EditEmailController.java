package resort.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import resort.utils.DatabaseUtility;

public class EditEmailController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String newEmail = request.getParameter("newEmail");
        HttpSession session = request.getSession(false);

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DatabaseUtility.getConnection();
            String sql = "UPDATE staff SET STAFFEMAIL = ? WHERE STAFFEMAIL = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, newEmail);
            pstmt.setString(2, (String) session.getAttribute("staffEmail")); // Assuming current username is stored in the session

            int rowsUpdated = pstmt.executeUpdate();
            if (rowsUpdated > 0) {
                session.setAttribute("staffEmail", newEmail); // Update session attribute
                response.sendRedirect("Profile.jsp"); // Redirect to profile page to refresh
            } else {
                request.setAttribute("errorMessage", "No rows updated.");
                request.getRequestDispatcher("Error.jsp").forward(request, response);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "SQL Exception: " + e.getMessage());
            request.getRequestDispatcher("Error.jsp").forward(request, response);
        } finally {
            DatabaseUtility.closeResources(null, pstmt, conn);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("Profile.jsp"); // Redirect to profile page if accessed via GET
    }
}
