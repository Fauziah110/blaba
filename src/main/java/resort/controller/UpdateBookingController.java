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

        // Retrieve reservationID from the form (hidden input)
        String reservationIDStr = request.getParameter("reservationID");

        HttpSession session = request.getSession();

        if (newCheckInDate == null || newCheckOutDate == null || newCheckInDate.isEmpty() || newCheckOutDate.isEmpty()) {
            session.setAttribute("errorMessage", "Please provide valid dates.");
            response.sendRedirect("customerReservation.jsp");
            return;
        }

        if (newCheckInDate.compareTo(newCheckOutDate) >= 0) {
            session.setAttribute("errorMessage", "Check-In date must be before Check-Out date.");
            response.sendRedirect("customerReservation.jsp");
            return;
        }

        int reservationID = 0;
        try {
            reservationID = Integer.parseInt(reservationIDStr);
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid reservation ID.");
            response.sendRedirect("customerReservation.jsp");
            return;
        }

        // Update session dates with java.sql.Date objects
        session.setAttribute("checkInDate", java.sql.Date.valueOf(newCheckInDate));
        session.setAttribute("checkOutDate", java.sql.Date.valueOf(newCheckOutDate));

        // Update dates in the database
        try {
            updateBookingDatesInDatabase(reservationID, newCheckInDate, newCheckOutDate);
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Failed to update booking dates in the database.");
            response.sendRedirect("customerReservation.jsp");
            return;
        }

        // Redirect back to the page to show updated info
        response.sendRedirect("customerReservation.jsp");
    }

    private void updateBookingDatesInDatabase(int reservationID, String newCheckInDate, String newCheckOutDate) throws SQLException {
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                "UPDATE Reservation SET checkInDate = ?, checkOutDate = ? WHERE reservationID = ?")) {

            stmt.setString(1, newCheckInDate);
            stmt.setString(2, newCheckOutDate);
            stmt.setInt(3, reservationID);

            int rowsUpdated = stmt.executeUpdate();
            if (rowsUpdated <= 0) {
                System.out.println("No booking found with the provided reservationID.");
            }
        }
    }
}
