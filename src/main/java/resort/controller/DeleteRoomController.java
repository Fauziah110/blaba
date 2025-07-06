package resort.controller;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
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

            // ✅ Check staff password
            String verifyPasswordQuery = "SELECT COUNT(*) FROM staff WHERE staffpassword = ?";
            pstmt = conn.prepareStatement(verifyPasswordQuery);
            pstmt.setString(1, staffPassword);
            rs = pstmt.executeQuery();
            rs.next();

            if (rs.getInt(1) == 1) {
                // ✅ Valid password → delete room
                pstmt.close(); // reuse pstmt
                String deleteQuery = "DELETE FROM room WHERE roomId = ?";
                pstmt = conn.prepareStatement(deleteQuery);
                pstmt.setString(1, roomId);
                int result = pstmt.executeUpdate();

                if (result > 0) {
                    response.sendRedirect("Room.jsp");
                } else {
                    request.getSession().setAttribute("deleteError", "deleteFailed");
                    response.sendRedirect("Room.jsp");
                }
            } else {
                // ❌ Wrong password → set error
                request.getSession().setAttribute("deleteError", "invalidPassword");
                response.sendRedirect("Room.jsp");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.getSession().setAttribute("deleteError", "sqlError");
            response.sendRedirect("Room.jsp");
        } finally {
            ConnectionManager.closeResources(rs, pstmt, conn);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.getWriter().println("Delete operation requires POST.");
    }
}