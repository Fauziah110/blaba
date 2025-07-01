package resort.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Date; // Import for handling SQL Date
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import resort.utils.DatabaseUtility;

public class EditServiceController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            String serviceId = request.getParameter("serviceId");
            String serviceType = request.getParameter("serviceType");
            String serviceCharge = request.getParameter("serviceCharge");
            String serviceDateStr = request.getParameter("serviceDate");

            // Convert the serviceDate string to java.sql.Date
            java.sql.Date serviceDate = java.sql.Date.valueOf(serviceDateStr);

            conn = DatabaseUtility.getConnection();

            // Update the existing service with serviceId
            String updateQuery = "UPDATE service SET serviceType = ?, serviceCharge = ?, serviceDate = ? WHERE serviceId = ?";
            pstmt = conn.prepareStatement(updateQuery);
            pstmt.setString(1, serviceType);
            pstmt.setString(2, serviceCharge);
            pstmt.setDate(3, serviceDate); // Set the service date here
            pstmt.setString(4, serviceId);

            int result = pstmt.executeUpdate();
            if (result > 0) {
                response.sendRedirect("Service.jsp"); // Redirect to the service page to refresh
            } else {
                response.getWriter().println("Failed to update service details.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        } catch (IllegalArgumentException e) {
            // Catch the exception if the date format is incorrect
            e.printStackTrace();
            response.getWriter().println("Invalid date format: " + e.getMessage());
        } finally {
            DatabaseUtility.closeResources(null, pstmt, conn); // Close the resources properly
        }
    }
}
