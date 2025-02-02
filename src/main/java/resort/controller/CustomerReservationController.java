package resort.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import resort.connection.ConnectionManager;
import resort.model.Booking;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CustomerReservationController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String customerName = (String) session.getAttribute("customerName");

        if (customerName == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Booking> userBookings = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = ConnectionManager.getConnection();
            String sql = "SELECT bookingID, roomType, checkInDate, checkOutDate, totalPayment, status FROM Reservation WHERE customerID = (SELECT customerID FROM Customer WHERE customerName = ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, customerName);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                userBookings.add(new Booking(
                    rs.getInt("bookingID"),
                    rs.getString("roomType"),
                    rs.getDate("checkInDate"),
                    rs.getDate("checkOutDate"),
                    rs.getDouble("totalPayment"),
                    rs.getString("status")
                ));
            }

            request.setAttribute("userBookings", userBookings);
            request.getRequestDispatcher("c.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (stmt != null) stmt.close(); if (conn != null) conn.close(); } catch (Exception ignored) {}
        }
    }
}
