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
        Connection conn = null;
        PreparedStatement reservationStmt = null;
        PreparedStatement customerQueryStmt = null;
        int customerID = 0;

        try {
            conn = ConnectionManager.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // ✅ Retrieve session
            HttpSession session = request.getSession();

            // ✅ Retrieve customer details from session
            String customerName = (String) session.getAttribute("customerName");
            String customerEmail = (String) session.getAttribute("customerEmail");
            String customerPhoneNo = (String) session.getAttribute("customerPhoneNo");

            System.out.println("✅ DEBUG: Session Customer Name: " + customerName);
            System.out.println("✅ DEBUG: Session Customer Email: " + customerEmail);
            System.out.println("✅ DEBUG: Session Customer Phone: " + customerPhoneNo);

            // ✅ Ensure customer name exists
            if (customerName == null || customerName.trim().isEmpty()) {
                response.getWriter().println("<h3>Error: Customer details are missing. Please log in again.</h3>");
                return;
            }

            // ✅ Retrieve customerID from DB if session exists
            String customerQuery = "SELECT customerID FROM Customer WHERE customerName = ?";
            customerQueryStmt = conn.prepareStatement(customerQuery);
            customerQueryStmt.setString(1, customerName);
            ResultSet rs = customerQueryStmt.executeQuery();

            if (rs.next()) {
                customerID = rs.getInt("customerID");
                System.out.println("✅ DEBUG: Retrieved Customer ID: " + customerID);
            } else {
                System.out.println("❌ ERROR: No customer found for name: " + customerName);
                response.getWriter().println("<h3>Error: Customer not found in database. Please check your account.</h3>");
                return;
            }
            rs.close();

            // ✅ Ensure stay details exist in session
            String checkInDateStr = (String) session.getAttribute("checkInDate");
            String checkOutDateStr = (String) session.getAttribute("checkOutDate");

            if (checkInDateStr == null || checkOutDateStr == null) {
                response.getWriter().println("<h3>Error: Check-in and check-out dates cannot be null.</h3>");
                return;
            }

            // ✅ Convert to SQL Date safely
            Date checkInDate, checkOutDate;
            try {
                checkInDate = Date.valueOf(checkInDateStr);
                checkOutDate = Date.valueOf(checkOutDateStr);
            } catch (IllegalArgumentException e) {
                response.getWriter().println("<h3>Error: Invalid check-in or check-out date format.</h3>");
                return;
            }

            // ✅ Ensure room details exist in session
            int roomID = parseIntOrDefault(session.getAttribute("roomID"), -1);
            double roomPrice = parseDoubleOrDefault(session.getAttribute("roomPrice"), 0.0);
            int quantity = parseIntOrDefault(session.getAttribute("quantity"), 1);

            // ✅ Check for missing room details
            if (roomID == -1 || roomPrice == 0.0 || quantity == 0) {
                System.out.println("❌ ERROR: Room details are missing in session.");
                response.getWriter().println("<h3>Error: Room details are missing. Please select a room before proceeding.</h3>");
                return;
            }

            System.out.println("✅ DEBUG: Room ID: " + roomID);
            System.out.println("✅ DEBUG: Room Price: RM" + roomPrice);
            System.out.println("✅ DEBUG: Room Quantity: " + quantity);

            // ✅ Retrieve and validate total adults & kids
            int totalAdults = parseIntOrDefault(session.getAttribute("adults"), 1);
            int totalKids = parseIntOrDefault(session.getAttribute("kids"), 0);
            double totalPayment = roomPrice * quantity; // Calculate based on room price & quantity
            
            System.out.println("✅ DEBUG: Total Adults: " + totalAdults);
            System.out.println("✅ DEBUG: Total Kids: " + totalKids);
            System.out.println("✅ DEBUG: Total Payment: RM" + totalPayment);
         // ✅ Save total payment in session
            session.setAttribute("totalPayment", totalPayment);

            // ✅ Insert Reservation Data into DB
            String reservationSQL = "INSERT INTO Reservation (reservationDate, checkInDate, checkOutDate, totalAdult, totalKids, roomID, customerID, totalPayment) VALUES (CURRENT_DATE, ?, ?, ?, ?, ?, ?, ?)";
            reservationStmt = conn.prepareStatement(reservationSQL);
            reservationStmt.setDate(1, checkInDate);
            reservationStmt.setDate(2, checkOutDate);
            reservationStmt.setInt(3, totalAdults);
            reservationStmt.setInt(4, totalKids);
            reservationStmt.setInt(5, roomID);
            reservationStmt.setInt(6, customerID);
            reservationStmt.setDouble(7, totalPayment);
            reservationStmt.executeUpdate();

            // ✅ Commit Transaction
            conn.commit();
            System.out.println("✅ DEBUG: Reservation successfully saved!");

            // ✅ Redirect to confirmation page
            response.sendRedirect("receipt.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<h3>Error: " + e.getMessage() + "</h3>");
        } finally {
            try {
                if (customerQueryStmt != null) customerQueryStmt.close();
                if (reservationStmt != null) reservationStmt.close();
                if (conn != null) conn.close();
            } catch (SQLException ignored) {}
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    // ✅ Helper method to safely parse integers
    private int parseIntOrDefault(Object value, int defaultValue) {
        try {
            return (value != null) ? Integer.parseInt(value.toString()) : defaultValue;
        } catch (NumberFormatException ignored) {
            return defaultValue;
        }
    }

    // ✅ Helper method to safely parse doubles
    private double parseDoubleOrDefault(Object value, double defaultValue) {
        try {
            return (value != null) ? Double.parseDouble(value.toString()) : defaultValue;
        } catch (NumberFormatException ignored) {
            return defaultValue;
        }
    }
}
