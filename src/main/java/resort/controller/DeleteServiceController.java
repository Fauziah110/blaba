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

            System.out.println("🔐 Password entered: '" + staffPassword + "'");

            conn = ConnectionManager.getConnection();

            if (conn == null) {
                response.getWriter().println("❌ ERROR: Database connection failed.");
                return;
            }

            // Step 1: Verify staff password (plain text comparison)
            String verifyPasswordQuery = "SELECT COUNT(*) FROM staff WHERE staffpassword = ?";
            pstmt = conn.prepareStatement(verifyPasswordQuery);
            pstmt.setString(1, staffPassword);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                int count = rs.getInt(1);
                if (count == 1) {
                    // Password is correct, proceed to check usage in child tables

                    rs.close();
                    pstmt.close();

                    // Step 2: Check if serviceID is used in Reservation table
                    String checkUsageQuery = "SELECT COUNT(*) FROM Reservation WHERE serviceID = ?";
                    pstmt = conn.prepareStatement(checkUsageQuery);
                    pstmt.setString(1, serviceId);
                    rs = pstmt.executeQuery();
                    rs.next();
                    int usageCount = rs.getInt(1);
                    rs.close();
                    pstmt.close();

                    if (usageCount > 0) {
                        // Service is in use, deny deletion and show user-friendly message
                        String message = "";

                        // Specific message for known service IDs
                        if ("110".equals(serviceId) || "129".equals(serviceId)) {
                            message = "Deletion not allowed: Service ID " + serviceId + " (Chicken chop or nasi lemak) is currently in use in reservations.";
                        } else if ("149".equals(serviceId) || "150".equals(serviceId)) {
                            message = "Deletion not allowed: Service ID " + serviceId + " (Hall A or Beachfront) is currently in use in reservations.";
                        } else {
                            message = "Deletion not allowed: This service is currently in use in reservations.";
                        }

                        response.setContentType("text/html");
                        response.getWriter().println("<script>alert('" + message + "'); window.location='Service.jsp';</script>");
                        return;
                    }

                    // Step 3: Delete dependent records from FoodService table first
                    String deleteFoodServiceQuery = "DELETE FROM FoodService WHERE serviceID = ?";
                    pstmt = conn.prepareStatement(deleteFoodServiceQuery);
                    pstmt.setString(1, serviceId);
                    int foodDeleted = pstmt.executeUpdate();
                    System.out.println("🗑️ Deleted " + foodDeleted + " rows from FoodService.");
                    pstmt.close();

                    // Step 4: Delete the service record from the Service table
                    String deleteServiceQuery = "DELETE FROM Service WHERE serviceID = ?";
                    pstmt = conn.prepareStatement(deleteServiceQuery);
                    pstmt.setString(1, serviceId);

                    int deletedRows = pstmt.executeUpdate();
                    System.out.println("🗑️ Deleted " + deletedRows + " rows from Service.");

                    if (deletedRows > 0) {
                        response.sendRedirect("Service.jsp"); // Redirect to refresh page after deletion
                    } else {
                        response.getWriter().println("❌ Error: Failed to delete service.");
                    }
                } else {
                    // Password incorrect
                    response.getWriter().println("❌ Invalid staff password.");
                }
            } else {
                // No results from query
                response.getWriter().println("❌ Invalid staff password.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("❌ Error: " + e.getMessage());
        } finally {
            ConnectionManager.closeResources(rs, pstmt, conn);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.getWriter().println("Delete operation requires a POST request.");
    }
}
