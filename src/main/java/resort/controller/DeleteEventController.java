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

import resort.utils.DatabaseUtility;


public class DeleteEventController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            String serviceId = request.getParameter("serviceID");
            String staffPassword = request.getParameter("staffPassword");

            System.out.println("Received serviceID: " + serviceId);
            System.out.println("Received staffPassword: " + staffPassword);

            conn = DatabaseUtility.getConnection();

            // Verify staff password
            String verifyPasswordQuery = "SELECT COUNT(*) FROM staff WHERE staffpassword = ?";
            pstmt = conn.prepareStatement(verifyPasswordQuery);
            pstmt.setString(1, staffPassword);
            rs = pstmt.executeQuery();
            rs.next();

            if (rs.getInt(1) == 1) {
                // Password verified, proceed to delete event service
                System.out.println("Staff password verified.");

                String deleteQuery = "DELETE FROM eventservice WHERE serviceID = ?";
                pstmt = conn.prepareStatement(deleteQuery);
                pstmt.setString(1, serviceId);

                int result = pstmt.executeUpdate();
                if (result > 0) {
                    System.out.println("Event service deleted successfully.");
                    response.sendRedirect("EventService.jsp"); // Redirect to refresh page
                } else {
                    System.out.println("Failed to delete event service.");
                    response.getWriter().println("Failed to delete event service.");
                }
            } else {
                System.out.println("Invalid staff password.");
                response.getWriter().println("Invalid staff password.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        } finally {
            DatabaseUtility.closeResources(rs, pstmt, conn);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.getWriter().println("Delete operation requires a POST request.");
    }
}
