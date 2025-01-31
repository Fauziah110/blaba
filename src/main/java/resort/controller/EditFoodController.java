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

public class EditFoodController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            int serviceId = Integer.parseInt(request.getParameter("serviceId"));
            String menuName = request.getParameter("menuName");
            double menuPrice = Double.parseDouble(request.getParameter("menuPrice"));
            int quantityMenu = Integer.parseInt(request.getParameter("quantityMenu"));

            conn = DatabaseUtility.getConnection();

            // Update existing foodservice
            String updateQuery = "UPDATE foodservice SET menuName = ?, menuPrice = ?, quantityMenu = ? WHERE serviceId = ?";
            pstmt = conn.prepareStatement(updateQuery);
            pstmt.setString(1, menuName);
            pstmt.setDouble(2, menuPrice);
            pstmt.setInt(3, quantityMenu);
            pstmt.setInt(4, serviceId);

            int result = pstmt.executeUpdate();
            if (result > 0) {
                response.sendRedirect("FoodService.jsp"); // Redirect to refresh page
            } else {
                response.getWriter().println("Failed to update foodservice details.");
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        } finally {
            DatabaseUtility.closeResources(null, pstmt, conn);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
