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
        double serviceCharge = 0.0;

        System.out.println("✅ Customer ID: " + customerID);
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

            // Calculate service charge
            if ("FoodService".equals(serviceType)) {
                int quantity = Integer.parseInt(request.getParameter("quantityMenu"));
                double menuPrice = 40.00; // Fixed price example
                serviceCharge = menuPrice * quantity;

                // Optional: store some info in session to display after redirect
                session.setAttribute("serviceType", "Food Service");
                session.setAttribute("menuName", request.getParameter("menuName"));
                session.setAttribute("quantityMenu", quantity);

            } else if ("EventService".equals(serviceType)) {
                int duration = Integer.parseInt(request.getParameter("duration"));
                double basePrice = 100.00; // Fixed price example
                serviceCharge = basePrice * duration;

                session.setAttribute("serviceType", "Event Service");
                session.setAttribute("venue", request.getParameter("venue"));
                session.setAttribute("eventType", request.getParameter("eventType"));
                session.setAttribute("duration", duration);
            } else {
                // If serviceType invalid or not selected
                response.sendRedirect("serviceCustomer.jsp?error=invalidService");
                return;
            }

            // Store serviceCharge in session for display
            session.setAttribute("serviceCharge", serviceCharge);

            // Insert reservation record (adjust if you have your own columns)
            String insertReservationSQL = "INSERT INTO Reservation (reservationDate, checkInDate, checkOutDate, totalAdult, totalKids, roomID, customerID, totalPayment, serviceID) VALUES (CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, ?, ?, ?, ?, ?, ?)";

            stmt = conn.prepareStatement(insertReservationSQL);
            stmt.setInt(1, 0); // totalAdult (example)
            stmt.setInt(2, 0); // totalKids (example)
            stmt.setInt(3, 0); // roomID (example)
            stmt.setInt(4, customerID);
            stmt.setDouble(5, serviceCharge);
            stmt.setNull(6, Types.INTEGER); // no serviceID associated

            int rowsInserted = stmt.executeUpdate();

            if (rowsInserted > 0) {
                System.out.println("✅ Service reservation inserted successfully.");
                // Redirect back to serviceCustomer.jsp with success message
                response.sendRedirect("serviceCustomer.jsp?success=true");
            } else {
                System.out.println("❌ ERROR: Failed to insert reservation.");
                response.sendRedirect("serviceCustomer.jsp?error=insertFail");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("serviceCustomer.jsp?error=sqlException");
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException ignored) {}
        }
    }
}
