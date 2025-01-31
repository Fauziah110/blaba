package resort.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
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

            conn = DatabaseUtility.getConnection();

            // Update existing service
            String updateQuery = "UPDATE service SET serviceType = ?, serviceCharge = ? WHERE serviceId = ?";
            pstmt = conn.prepareStatement(updateQuery);
            pstmt.setString(1, serviceType);
            pstmt.setString(2, serviceCharge);
            pstmt.setString(3, serviceId);

            int result = pstmt.executeUpdate();
            if (result > 0) {
                response.sendRedirect("Service.jsp"); // Redirect to refresh page
            } else {
                response.getWriter().println("Failed to update service details.");
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        } finally {
            DatabaseUtility.closeResources(null, pstmt, conn);
        }
    }
}
