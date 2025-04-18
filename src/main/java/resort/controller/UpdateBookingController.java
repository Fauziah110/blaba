package resort.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import resort.connection.ConnectionManager;

public class UpdateBookingController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve the new dates from the form
        String newCheckInDate = request.getParameter("newCheckInDate");
        String newCheckOutDate = request.getParameter("newCheckOutDate");

        // Get the current session
        HttpSession session = request.getSession();

        // Retrieve and carry all the booking details from the session
        String customerName = (String) session.getAttribute("customerName");
        String customerEmail = (String) session.getAttribute("customerEmail");
        String customerPhoneNo = (String) session.getAttribute("customerPhoneNo");

        Integer reservationID = (Integer) session.getAttribute("reservationID");
        Integer roomID = (Integer) session.getAttribute("roomID");
        String roomType = (String) session.getAttribute("roomType");

        Double roomPrice = (Double) session.getAttribute("roomPrice");  // Assuming price is stored as Double
        Double totalPayment = (Double) session.getAttribute("totalPayment");

        // Validate the new dates (simple validation)
        if (newCheckInDate != null && newCheckOutDate != null && !newCheckInDate.isEmpty() && !newCheckOutDate.isEmpty()) {

            // Check if the new check-in date is before the new check-out date
            if (newCheckInDate.compareTo(newCheckOutDate) >= 0) {
                session.setAttribute("errorMessage", "Check-In date must be before Check-Out date.");
                response.sendRedirect("receipt.jsp"); // Redirect with error message
                return;
            }

            // Update the session with the new dates
            session.setAttribute("checkInDate", newCheckInDate);
            session.setAttribute("checkOutDate", newCheckOutDate);

            // Carry all other booking details in the session
            session.setAttribute("customerName", customerName);
            session.setAttribute("customerEmail", customerEmail);
            session.setAttribute("customerPhoneNo", customerPhoneNo);

            // Ensure correct types are handled before setting session attributes
            session.setAttribute("reservationID", reservationID != null ? reservationID.toString() : "");
            session.setAttribute("roomID", roomID != null ? roomID.toString() : "");
            session.setAttribute("roomType", roomType != null ? roomType : "");
            session.setAttribute("roomPrice", roomPrice != null ? roomPrice.toString() : "0.00");
            session.setAttribute("totalPayment", totalPayment != null ? totalPayment.toString() : "0.00");

            // Update these dates in the database
            if (reservationID != null) {
                try {
                    updateBookingDatesInDatabase(reservationID, newCheckInDate, newCheckOutDate);
                } catch (SQLException e) {
                    e.printStackTrace();
                    session.setAttribute("errorMessage", "Failed to update booking dates in the database.");
                    response.sendRedirect("receipt.jsp");
                    return;
                }
            }

            // Redirect to the booking receipt page with the updated data
            response.sendRedirect("receipt.jsp");

        } else {
            // If the dates are not valid, redirect back with an error
            session.setAttribute("errorMessage", "Please provide valid dates.");
            response.sendRedirect("receipt.jsp");
        }
    }

    // Method to update the check-in and check-out dates in the database
    private void updateBookingDatesInDatabase(int reservationID, String newCheckInDate, String newCheckOutDate) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = ConnectionManager.getConnection();

            // SQL statement to update the dates in the Reservation table
            String sql = "UPDATE Reservation SET checkInDate = ?, checkOutDate = ? WHERE reservationID = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, newCheckInDate);
            stmt.setString(2, newCheckOutDate);
            stmt.setInt(3, reservationID);

            // Execute the update statement
            int rowsUpdated = stmt.executeUpdate();

            if (rowsUpdated > 0) {
                System.out.println("Booking dates updated successfully!");
            } else {
                System.out.println("No booking found with the provided reservationID.");
            }

        } finally {
            // Close the resources
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }
}
