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

public class DeleteServiceController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            String serviceId = request.getParameter("deleteServiceId");
            String staffPassword = request.getParameter("staffPassword");

            conn = ConnectionManager.getConnection();

            // Step 1: Verify staff password
            String verifyPasswordQuery = "SELECT COUNT(*) FROM staff WHERE staffpassword = ?";
            pstmt = conn.prepareStatement(verifyPasswordQuery);
            pstmt.setString(1, staffPassword);
            rs = pstmt.executeQuery();
            rs.next();

            if (rs.getInt(1) == 1) {
                // Step 2: Delete dependent records from FoodService table first
                String deleteFoodServiceQuery = "DELETE FROM FoodService WHERE serviceID = ?";
                pstmt = conn.prepareStatement(deleteFoodServiceQuery);
                pstmt.setString(1, serviceId);
                pstmt.executeUpdate();  // Delete all related records from FoodService

                // Step 3: Delete the service record from the Service table
                String deleteServiceQuery = "DELETE FROM Service WHERE serviceID = ?";
                pstmt = conn.prepareStatement(deleteServiceQuery);
                pstmt.setString(1, serviceId);

                int deletedRows = pstmt.executeUpdate();  // Delete the service
                if (deletedRows > 0) {
                    response.sendRedirect("Service.jsp"); // Redirect to refresh page after deletion
                } else {
                    response.getWriter().println("Error: Failed to delete service.");
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
