package resort.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import resort.connection.ConnectionManager;

public class EditRoomController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            String isEdit = request.getParameter("isEdit");
            String roomId = request.getParameter("roomId");
            String roomType = request.getParameter("roomType");
            String roomStatus = request.getParameter("roomStatus");
            String roomPrice = request.getParameter("roomPrice");
            String staffId = request.getParameter("staffInCharge"); // Use staffId for the column

            conn = ConnectionManager.getConnection();

            if ("true".equals(isEdit)) {
                String originalRoomId = request.getParameter("originalRoomId");
                String updateQuery = "UPDATE room SET roomType = ?, roomStatus = ?, roomPrice = ?, staffid = ? WHERE roomId = ?";
                pstmt = conn.prepareStatement(updateQuery);
                pstmt.setString(1, roomType);
                pstmt.setString(2, roomStatus);
                pstmt.setString(3, roomPrice);
                pstmt.setString(4, staffId);
                pstmt.setString(5, originalRoomId);
            } else {
                String insertQuery = "INSERT INTO room (roomId, roomType, roomStatus, roomPrice, staffid) VALUES (room_seq.nextval, ?, ?, ?, ?)";
                pstmt = conn.prepareStatement(insertQuery);
                pstmt.setString(1, roomType);
                pstmt.setString(2, roomStatus);
                pstmt.setString(3, roomPrice);
                pstmt.setString(4, staffId);
            }

            int result = pstmt.executeUpdate();
            if (result > 0) {
                response.sendRedirect("Room.jsp"); // Redirect to refresh page
            } else {
                response.getWriter().println("Failed to save room details.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        } finally {
        	ConnectionManager.closeResources(null, pstmt, conn);
        }
    }
}