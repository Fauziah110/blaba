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

public class EditPhoneController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String newPhone = request.getParameter("newPhone");
        HttpSession session = request.getSession(false);

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DatabaseUtility.getConnection();
            String sql = "UPDATE staff SET STAFFPHONENO = ? WHERE STAFFNAME = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, newPhone);
            pstmt.setString(2, (String) session.getAttribute("staffName")); // Assuming username is stored in the session

            int rowsUpdated = pstmt.executeUpdate();
            if (rowsUpdated > 0) {
                session.setAttribute("staffPhoneNo", newPhone); // Update session attribute
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
