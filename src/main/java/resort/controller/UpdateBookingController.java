package resort.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

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
        String newCheckInDateStr = request.getParameter("newCheckInDate");
        String newCheckOutDateStr = request.getParameter("newCheckOutDate");
        String reservationIDStr = request.getParameter("reservationID");

        HttpSession session = request.getSession();

        if (newCheckInDateStr == null || newCheckOutDateStr == null ||
            newCheckInDateStr.isEmpty() || newCheckOutDateStr.isEmpty()) {
            session.setAttribute("errorMessage", "Please provide valid check-in and check-out dates.");
            response.sendRedirect("customerReservation.jsp");
            return;
        }

        LocalDate newCheckInDate;
        LocalDate newCheckOutDate;
        LocalDate today = LocalDate.now();

        try {
            newCheckInDate = LocalDate.parse(newCheckInDateStr);
            newCheckOutDate = LocalDate.parse(newCheckOutDateStr);
        } catch (DateTimeParseException e) {
            session.setAttribute("errorMessage", "Invalid date format.");
            response.sendRedirect("customerReservation.jsp");
            return;
        }

        // Check if check-in date is before today (past date)
        if (newCheckInDate.isBefore(today)) {
            session.setAttribute("errorMessage", "Check-in date cannot be in the past.");
            response.sendRedirect("customerReservation.jsp");
            return;
        }

        // Check if check-out date is before or same as check-in date
        if (!newCheckOutDate.isAfter(newCheckInDate)) {
            session.setAttribute("errorMessage", "Check-out date must be after check-in date.");
            response.sendRedirect("customerReservation.jsp");
            return;
        }

        int reservationID;
        try {
            reservationID = Integer.parseInt(reservationIDStr);
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid reservation ID.");
            response.sendRedirect("customerReservation.jsp");
            return;
        }

        // Update session dates
        session.setAttribute("checkInDate", newCheckInDate);
        session.setAttribute("checkOutDate", newCheckOutDate);

        try {
            updateBookingDatesInDatabase(reservationID, newCheckInDateStr, newCheckOutDateStr);
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Failed to update booking dates in the database.");
            response.sendRedirect("customerReservation.jsp");
            return;
        }

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
