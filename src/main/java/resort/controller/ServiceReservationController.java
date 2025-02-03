package resort.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import resort.connection.ConnectionManager;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ServiceReservationController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("customerID") == null) {
            System.out.println("❌ ERROR: Session expired or customerID is missing.");
            response.sendRedirect("login.jsp");
            return;
        }

        int customerID = Integer.parseInt(session.getAttribute("customerID").toString());
        String serviceType = request.getParameter("serviceType");
        double serviceCharge = 0.00;
        int newServiceID = -1;

        System.out.println("✅ Retrieved customerID: " + customerID);
        System.out.println("✅ Service Type: " + serviceType);

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = ConnectionManager.getConnection();
            if (conn == null) {
                System.out.println("❌ ERROR: Database connection failed.");
                response.sendRedirect("serviceCustomer.jsp?error=dbConnection");
                return;
            }

            System.out.println("📌 Inserting into Service table...");
            String insertServiceSQL = "INSERT INTO Service (serviceCharge, serviceDate, serviceType) VALUES (?, CURRENT_TIMESTAMP, ?)";
            stmt = conn.prepareStatement(insertServiceSQL, PreparedStatement.RETURN_GENERATED_KEYS);
            stmt.setDouble(1, serviceCharge);  // Default 0.00, will update later
            stmt.setString(2, serviceType);
            stmt.executeUpdate();

            rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                newServiceID = rs.getInt(1);
                System.out.println("✅ New Service ID: " + newServiceID);
            } else {
                System.out.println("❌ ERROR: Failed to retrieve new service ID.");
                response.sendRedirect("serviceCustomer.jsp?error=serviceInsertFail");
                return;
            }

            // Handle Food Service
            if ("FoodService".equals(serviceType)) {
                String menuName = request.getParameter("menuName");
                int quantity = Integer.parseInt(request.getParameter("quantityMenu"));
                double menuPrice = 40.00; // Example fixed menu price
                serviceCharge = menuPrice * quantity;

                System.out.println("📌 Inserting into FoodService table...");
                String insertFoodSQL = "INSERT INTO FoodService (serviceID, menuName, menuPrice, quantityMenu) VALUES (?, ?, ?, ?)";
                stmt = conn.prepareStatement(insertFoodSQL);
                stmt.setInt(1, newServiceID);
                stmt.setString(2, menuName);
                stmt.setDouble(3, menuPrice);
                stmt.setInt(4, quantity);
                stmt.executeUpdate();
                
                System.out.println("✅ FoodService reservation stored successfully.");
            }
            // Handle Event Service
            else if ("EventService".equals(serviceType)) {
                String venue = request.getParameter("venue");
                String eventType = request.getParameter("eventType");
                int duration = Integer.parseInt(request.getParameter("duration"));
                double basePrice = 100.00;
                serviceCharge = basePrice * duration;

                System.out.println("📌 Inserting into EventService table...");
                String insertEventSQL = "INSERT INTO EventService (serviceID, venue, eventType, duration) VALUES (?, ?, ?, ?)";
                stmt = conn.prepareStatement(insertEventSQL);
                stmt.setInt(1, newServiceID);
                stmt.setString(2, venue);
                stmt.setString(3, eventType);
                stmt.setInt(4, duration);
                stmt.executeUpdate();
                
                System.out.println("✅ EventService reservation stored successfully.");
            }

            // Update service charge in Service table
            System.out.println("📌 Updating Service Charge in Service table...");
            String updateServiceChargeSQL = "UPDATE Service SET serviceCharge = ? WHERE serviceID = ?";
            stmt = conn.prepareStatement(updateServiceChargeSQL);
            stmt.setDouble(1, serviceCharge);
            stmt.setInt(2, newServiceID);
            stmt.executeUpdate();

            System.out.println("✅ Service Charge Updated: RM " + serviceCharge);
            response.sendRedirect("serviceCustomer.jsp?success=true");

        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("❌ ERROR: SQL Exception - " + e.getMessage());
            response.sendRedirect("serviceCustomer.jsp?error=sqlException");
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException ignored) {}
        }
    }
}
