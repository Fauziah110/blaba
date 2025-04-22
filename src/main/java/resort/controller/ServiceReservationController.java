package resort.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import resort.connection.ConnectionManager;

import java.io.IOException;
import java.sql.*;

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

            // If no new service insertion is needed, skip this section
            // Remove the logic for inserting into the Service table entirely

            // Only calculate the service charge based on the service type
            if ("FoodService".equals(serviceType)) {
                String menuName = request.getParameter("menuName");
                int quantity = Integer.parseInt(request.getParameter("quantityMenu"));
                double menuPrice = 40.00; // Example fixed menu price
                serviceCharge = menuPrice * quantity;
                System.out.println("📌 FoodService - Service Charge: RM " + serviceCharge);
            } else if ("EventService".equals(serviceType)) {
                String venue = request.getParameter("venue");
                String eventType = request.getParameter("eventType");
                int duration = Integer.parseInt(request.getParameter("duration"));
                double basePrice = 100.00;
                serviceCharge = basePrice * duration;
                System.out.println("📌 EventService - Service Charge: RM " + serviceCharge);
            }

            // Insert into Reservation Table with default values (skip service table insert)
            System.out.println("📌 Inserting into Reservation table...");
            String insertReservationSQL = "INSERT INTO Reservation (reservationDate, checkInDate, checkOutDate, totalAdult, totalKids, roomID, customerID, totalPayment, serviceID) VALUES (CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, ?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(insertReservationSQL);
            stmt.setInt(1, 0); // No Adults
            stmt.setInt(2, 0); // No Kids
            stmt.setInt(3, 0); // No Room ID
            stmt.setInt(4, customerID);
            stmt.setDouble(5, serviceCharge);
            stmt.setNull(6, Types.INTEGER);  // No serviceID is associated, so it remains NULL
            stmt.executeUpdate();

            System.out.println("✅ Service Reservation stored in Reservation table.");

            // Redirect to confirmation page or success page
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
