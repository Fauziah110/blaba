package resort.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import resort.connection.ConnectionManager;
import resort.model.Reservation;
import resort.model.RoomBooking;

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
        List<RoomBooking> roomBookingList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = ConnectionManager.getConnection();
            String sql = "SELECT r.reservationID, r.reservationDate, r.checkInDate, r.checkOutDate, r.totalAdult, r.totalKids, " +
                         "r.roomID, rm.roomType, rm.roomPrice, r.customerID, c.customerName, r.totalPayment, r.serviceID " +
                         "FROM Reservation r " +
                         "JOIN Customer c ON r.customerID = c.customerID " +
                         "JOIN Room rm ON r.roomID = rm.roomID " +
                         "WHERE c.customerName = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, customerName);
            ResultSet rs = stmt.executeQuery();

            // Iterate over the result set and retrieve the necessary details
            while (rs.next()) {
                // Create a new reservation object
                Reservation reservation = new Reservation(
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
                );

                // Add the reservation to the list of user reservations
                userReservations.add(reservation);

                // Create a RoomBooking object and add it to the list
                RoomBooking roomBooking = new RoomBooking(
                    rs.getInt("roomID"),       // roomID
                    rs.getString("roomType"),  // roomType
                    rs.getDouble("roomPrice"), // price
                    1                          // assuming 1 room booked for now
                );
                roomBookingList.add(roomBooking);

                // Store all the session attributes related to reservation and room booking
                session.setAttribute("reservationID", rs.getInt("reservationID"));
                session.setAttribute("roomID", rs.getInt("roomID"));
                session.setAttribute("roomType", rs.getString("roomType"));
                session.setAttribute("roomPrice", rs.getDouble("roomPrice"));
                session.setAttribute("totalPayment", rs.getDouble("totalPayment"));
                session.setAttribute("checkInDate", rs.getDate("checkInDate").toString());
                session.setAttribute("checkOutDate", rs.getDate("checkOutDate").toString());
                session.setAttribute("totalAdult", rs.getInt("totalAdult"));
                session.setAttribute("totalKids", rs.getInt("totalKids"));
            }

            // Set the room booking list to the session so that it can be used in the receipt page
            session.setAttribute("roomBookingList", roomBookingList);

            // Set the user reservations list as a request attribute to be used in the JSP page
            request.setAttribute("userReservations", userReservations);

            // Forward the request to the JSP page to display the data
            request.getRequestDispatcher("customerReservation.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp"); // Handle errors and redirect to an error page
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (Exception ignored) {}
        }
    }
}
