package resort.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import resort.connection.ConnectionManager;

public class DeleteRoomController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            String roomId = request.getParameter("deleteRoomId");
            String staffPassword = request.getParameter("staffPassword");

            conn = ConnectionManager.getConnection();

            // Verify staff password
            String verifyPasswordQuery = "SELECT COUNT(*) FROM staff WHERE staffpassword = ?";
            pstmt = conn.prepareStatement(verifyPasswordQuery);
            pstmt.setString(1, staffPassword);
            rs = pstmt.executeQuery();
            rs.next();

            if (rs.getInt(1) == 1) {
                // Password verified, proceed to delete room
                String deleteQuery = "DELETE FROM room WHERE roomId = ?";
                pstmt = conn.prepareStatement(deleteQuery);
                pstmt.setString(1, roomId);

                int result = pstmt.executeUpdate();
                if (result > 0) {
                    response.sendRedirect("Room.jsp"); // Redirect to refresh page
                } else {
                    response.getWriter().println("Failed to delete room.");
                }
            } else {
                response.getWriter().println("Invalid staff password.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        } finally {
        	ConnectionManager.closeResources(rs, pstmt, conn);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.getWriter().println("Delete operation requires a POST request.");
    }
}