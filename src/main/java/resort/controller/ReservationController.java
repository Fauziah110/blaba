package resort.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import resort.connection.ConnectionManager;

import java.io.IOException;
import java.sql.*;

public class ReservationController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Debugging: Check if session exists and if customerID is available
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("customerID") == null) {
            System.out.println("❌ ERROR: Session expired or customerID is missing.");
            response.sendRedirect("serviceCustomer.jsp");
            return;
        }

        // Retrieve customerID from the session
        int customerID = Integer.parseInt(session.getAttribute("customerID").toString());
        System.out.println("✅ Retrieved customerID: " + customerID);

        String serviceType = request.getParameter("serviceType");
        double serviceCharge = 0.00;

        // Get the room booking details from the request
        String roomIDStr = request.getParameter("roomID");
        int roomID = roomIDStr != null && !roomIDStr.isEmpty() ? Integer.parseInt(roomIDStr) : 0; // Default to 0 if no room booked
        int totalAdults = Integer.parseInt(request.getParameter("totalAdults"));
        int totalKids = Integer.parseInt(request.getParameter("totalKids"));
        double totalPayment = Double.parseDouble(request.getParameter("totalPayment"));

        System.out.println("✅ Service Type: " + serviceType);

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = ConnectionManager.getConnection();
            if (conn == null) {
                System.out.println("❌ ERROR: Database connection failed.");
                response.sendRedirect("serviceCustomer.jsp?error=dbConnection");
                return;
            }

            // Service Charge Calculation based on service type
            if ("FoodService".equals(serviceType)) {
                String menuName = request.getParameter("menuName");
                int quantity = Integer.parseInt(request.getParameter("quantityMenu"));
                double menuPrice = 40.00; // Example fixed menu price
                serviceCharge = menuPrice * quantity;

                System.out.println("📌 FoodService - Service Charge: RM " + serviceCharge);
            }
            else if ("EventService".equals(serviceType)) {
                String venue = request.getParameter("venue");
                String eventType = request.getParameter("eventType");
                int duration = Integer.parseInt(request.getParameter("duration"));
                double basePrice = 100.00;
                serviceCharge = basePrice * duration;

                System.out.println("📌 EventService - Service Charge: RM " + serviceCharge);
            }

            // Insert into Reservation table
            System.out.println("📌 Inserting into Reservation table...");
            String insertReservationSQL = "INSERT INTO Reservation (reservationDate, checkInDate, checkOutDate, totalAdult, totalKids, roomID, customerID, totalPayment, serviceType) " +
                    "VALUES (CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, ?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(insertReservationSQL);
            stmt.setInt(1, totalAdults);
            stmt.setInt(2, totalKids);
            stmt.setInt(3, roomID);  // If no room booked, roomID will be set to 0
            stmt.setInt(4, customerID); // Ensure customerID is inserted correctly
            stmt.setDouble(5, totalPayment);
            stmt.setString(6, serviceType); // Store the service type in the reservation
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
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException ignored) {}
        }
    }
}
