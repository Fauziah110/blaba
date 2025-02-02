package resort.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import resort.connection.ConnectionManager;
import resort.model.Reservation;

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

        List<Reservation> userReservations = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = ConnectionManager.getConnection();
            String sql = "SELECT r.reservationID, r.reservationDate, r.checkInDate, r.checkOutDate, r.totalAdult, r.totalKids, r.roomID, rm.roomType, r.customerID, c.customerName, r.totalPayment, r.serviceID " +
                         "FROM Reservation r " +
                         "JOIN Customer c ON r.customerID = c.customerID " +
                         "JOIN Room rm ON r.roomID = rm.roomID " +
                         "WHERE c.customerName = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, customerName);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                userReservations.add(new Reservation(
                    rs.getInt("reservationID"),
                    rs.getDate("reservationDate"),
                    rs.getDate("checkInDate"),
                    rs.getDate("checkOutDate"),
                    rs.getInt("totalAdult"),
                    rs.getInt("totalKids"),
                    rs.getInt("roomID"),
                    rs.getString("roomType"),
                    rs.getInt("customerID"),
                    rs.getString("customerName"),
                    rs.getDouble("totalPayment"),
                    rs.getInt("serviceID")
                ));
            }

            request.setAttribute("userReservations", userReservations);
            request.getRequestDispatcher("customerReservation.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (stmt != null) stmt.close(); if (conn != null) conn.close(); } catch (Exception ignored) {}
        }
    }
}
