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
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("customerID") == null) {
            System.out.println("❌ ERROR: Session expired or customerID is missing.");
            response.sendRedirect("serviceCustomer.jsp");
            return;
        }

        // Retrieve customerID from the session
        String customerIDStr = (String) session.getAttribute("customerID");
        int customerID = (customerIDStr != null && !customerIDStr.isEmpty()) ? Integer.parseInt(customerIDStr) : 0;

        // Get room booking details from the request
        String roomIDStr = request.getParameter("roomID");
        int roomID = (roomIDStr != null && !roomIDStr.isEmpty()) ? Integer.parseInt(roomIDStr) : 0;
        String totalAdultsStr = request.getParameter("totalAdults");
        int totalAdults = (totalAdultsStr != null && !totalAdultsStr.isEmpty()) ? Integer.parseInt(totalAdultsStr) : 0;
        String totalKidsStr = request.getParameter("totalKids");
        int totalKids = (totalKidsStr != null && !totalKidsStr.isEmpty()) ? Integer.parseInt(totalKidsStr) : 0;

        // Capture totalPayment from the form in Booking Summary.jsp
        String totalPaymentStr = request.getParameter("totalPrice");
        double totalPayment = 0.0;
        if (totalPaymentStr != null && !totalPaymentStr.isEmpty()) {
            try {
                totalPayment = Double.parseDouble(totalPaymentStr.trim());
            } catch (NumberFormatException e) {
                System.out.println("❌ ERROR: Invalid payment amount.");
                response.sendRedirect("serviceCustomer.jsp?error=invalidPayment");
                return;
            }
        }

        // Get and validate check-in and check-out dates from the form submission
        String checkInDateStr = request.getParameter("checkInDate");
        String checkOutDateStr = request.getParameter("checkOutDate");

        if (checkInDateStr == null || checkOutDateStr == null || checkInDateStr.isEmpty() || checkOutDateStr.isEmpty()) {
            System.out.println("❌ ERROR: Check-In or Check-Out date is missing.");
            response.sendRedirect("serviceCustomer.jsp?error=missingDates");
            return;
        }

        Date checkInDate = Date.valueOf(checkInDateStr);  // Convert to java.sql.Date
        Date checkOutDate = Date.valueOf(checkOutDateStr); // Convert to java.sql.Date

        // Set session attributes
        session.setAttribute("checkInDate", checkInDate);
        session.setAttribute("checkOutDate", checkOutDate);
        session.setAttribute("totalAdult", totalAdults);
        session.setAttribute("totalKids", totalKids);
        session.setAttribute("totalPayment", totalPayment);

        // Database insertion logic (same as before)
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = ConnectionManager.getConnection();
            String insertReservationSQL = "INSERT INTO Reservation (reservationDate, checkInDate, checkOutDate, totalAdult, totalKids, roomID, customerID, totalPayment) " +
                    "VALUES (CURRENT_TIMESTAMP, ?, ?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(insertReservationSQL);
            stmt.setDate(1, checkInDate);
            stmt.setDate(2, checkOutDate);
            stmt.setInt(3, totalAdults);
            stmt.setInt(4, totalKids);
            stmt.setInt(5, roomID);
            stmt.setInt(6, customerID);
            stmt.setDouble(7, totalPayment);
            stmt.executeUpdate();

            System.out.println("✅ Reservation stored in the Reservation table.");

            // Redirect to the receipt page after successful booking
            response.sendRedirect("receipt.jsp?success=true");
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
