package resort.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import resort.connection.ConnectionManager;

import java.io.IOException;
import java.sql.*;
import java.util.List;
import java.util.ArrayList;

public class ReservationController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection conn = null;
        PreparedStatement reservationStmt = null;
        PreparedStatement customerQueryStmt = null;
        PreparedStatement roomQueryStmt = null;
        PreparedStatement updateRoomStmt = null;
        int customerID = 0;

        try {
            conn = ConnectionManager.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // ✅ Retrieve session
            HttpSession session = request.getSession();

            // ✅ Retrieve customerName from request or session
            String customerName = request.getParameter("customerName");
            if (customerName == null || customerName.isEmpty()) {
                customerName = (String) session.getAttribute("customer_name");
            }
            System.out.println("DEBUG: Retrieved customerName: " + customerName);

            // ✅ Retrieve customerID based on customerName
            if (customerName != null && !customerName.isEmpty()) {
                String customerQuery = "SELECT customerID FROM Customer WHERE customerName = ?";
                customerQueryStmt = conn.prepareStatement(customerQuery);
                customerQueryStmt.setString(1, customerName);
                ResultSet rs = customerQueryStmt.executeQuery();

                if (rs.next()) {
                    customerID = rs.getInt("customerID");
                    System.out.println("DEBUG: Retrieved customerID from database: " + customerID);
                } else {
                    System.out.println("DEBUG: No customer found for name: " + customerName);
                }
                rs.close();
            }

            // ✅ Retrieve stay details
            String checkInDateStr = request.getParameter("checkInDate");
            if (checkInDateStr == null || checkInDateStr.isEmpty()) {
                checkInDateStr = (String) session.getAttribute("checkInDate");
            }

            String checkOutDateStr = request.getParameter("checkOutDate");
            if (checkOutDateStr == null || checkOutDateStr.isEmpty()) {
                checkOutDateStr = (String) session.getAttribute("checkOutDate");
            }

            // ✅ Validate check-in and check-out dates
            if (checkInDateStr == null || checkOutDateStr == null || checkInDateStr.equals("null") || checkOutDateStr.equals("null")) {
                response.getWriter().println("<h3>Error: Check-in and check-out dates cannot be null.</h3>");
                return;
            }

            // ✅ Convert to SQL Date
            Date checkInDate;
            Date checkOutDate;
            try {
                checkInDate = Date.valueOf(checkInDateStr);
                checkOutDate = Date.valueOf(checkOutDateStr);
            } catch (IllegalArgumentException e) {
                response.getWriter().println("<h3>Error: Invalid date format. Please enter a valid check-in and check-out date.</h3>");
                return;
            }

            // ✅ Retrieve `roomType` from request or session
            String roomType = request.getParameter("roomType");
            if (roomType == null || roomType.trim().isEmpty()) {
                roomType = (String) session.getAttribute("roomType");
            }

            // ✅ Validate `roomType`
            if (roomType == null || roomType.trim().isEmpty()) {
                System.out.println("ERROR: Room Type is missing.");
                response.getWriter().println("<h3>Error: Room Type is missing. Please select a room type.</h3>");
                return;
            }
            System.out.println("DEBUG: Retrieved roomType: " + roomType);

            // ✅ Fix SQL Query - Use `TOP 1` instead of `LIMIT 1`
            int roomID = -1;
            String roomQuery = "SELECT TOP 1 roomID FROM Room WHERE roomType = ? AND roomStatus = 'Available' ORDER BY roomID ASC";
            roomQueryStmt = conn.prepareStatement(roomQuery);
            roomQueryStmt.setString(1, roomType);
            ResultSet roomRs = roomQueryStmt.executeQuery();

            if (roomRs.next()) {
                roomID = roomRs.getInt("roomID");
                System.out.println("DEBUG: Retrieved roomID from database: " + roomID);
            } else {
                System.out.println("DEBUG: No available rooms found for roomType: " + roomType);
                response.getWriter().println("<h3>Error: No available room found for the selected type. Please try another room.</h3>");
                return;
            }
            roomRs.close();

            // ✅ Retrieve other parameters
            int totalAdults = parseIntOrDefault(request.getParameter("totalAdult"), session.getAttribute("adults"), 1);
            int totalKids = parseIntOrDefault(request.getParameter("totalKids"), session.getAttribute("kids"), 0);
            double totalPayment = parseDoubleOrDefault(request.getParameter("totalPrice"), session.getAttribute("totalPrice"), 0.0);

            // ✅ Insert Reservation Data
            String reservationSQL = "INSERT INTO Reservation (reservationDate, checkInDate, checkOutDate, totalAdult, totalKids, roomID, customerID, totalPayment) VALUES (CURRENT_DATE, ?, ?, ?, ?, ?, ?, ?)";
            reservationStmt = conn.prepareStatement(reservationSQL);
            reservationStmt.setDate(1, checkInDate);
            reservationStmt.setDate(2, checkOutDate);
            reservationStmt.setInt(3, totalAdults);
            reservationStmt.setInt(4, totalKids);
            reservationStmt.setInt(5, roomID);
            reservationStmt.setInt(6, customerID == 0 ? java.sql.Types.NULL : customerID);
            reservationStmt.setDouble(7, totalPayment);
            reservationStmt.executeUpdate();

            // ✅ Commit Transaction
            conn.commit();
            System.out.println("DEBUG: Reservation successfully saved!");

            // ✅ Redirect to confirmation page
            response.sendRedirect("receipt.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<h3>Error: " + e.getMessage() + "</h3>");
        } finally {
            try {
                if (customerQueryStmt != null) customerQueryStmt.close();
                if (roomQueryStmt != null) roomQueryStmt.close();
                if (reservationStmt != null) reservationStmt.close();
                if (conn != null) conn.close();
            } catch (SQLException ignored) {}
        }
    }

    // ✅ Fix missing methods for parsing values
    private int parseIntOrDefault(String paramValue, Object sessionValue, int defaultValue) {
        try {
            return paramValue != null && !paramValue.equals("null") && !paramValue.isEmpty()
                    ? Integer.parseInt(paramValue)
                    : sessionValue != null ? Integer.parseInt(sessionValue.toString()) : defaultValue;
        } catch (NumberFormatException ignored) {}
        return defaultValue;
    }

    private double parseDoubleOrDefault(String paramValue, Object sessionValue, double defaultValue) {
        try {
            return paramValue != null && !paramValue.equals("null") && !paramValue.isEmpty()
                    ? Double.parseDouble(paramValue)
                    : sessionValue != null ? Double.parseDouble(sessionValue.toString()) : defaultValue;
        } catch (NumberFormatException ignored) {}
        return defaultValue;
    }
}
