package resort.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import resort.connection.ConnectionManager;
import resort.model.Reservation;
import resort.model.RoomBooking;
import resort.model.Service;

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
        List<Service> serviceList = new ArrayList<>();

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = ConnectionManager.getConnection();

            String sql = "SELECT r.reservationID, r.reservationDate, r.checkInDate, r.checkOutDate, r.totalAdult, r.totalKids, " +
                         "r.roomID, rm.roomType, rm.roomPrice, r.customerID, c.customerName, r.totalPayment, r.serviceID, " +
                         "s.serviceType, s.serviceCharge, fs.menuName, fs.menuPrice, fs.quantityMenu, es.venue, es.eventType, es.duration " +
                         "FROM Reservation r " +
                         "JOIN Customer c ON r.customerID = c.customerID " +
                         "JOIN Room rm ON r.roomID = rm.roomID " +
                         "LEFT JOIN Service s ON r.serviceID = s.serviceID " +
                         "LEFT JOIN FoodService fs ON s.serviceID = fs.serviceID " +
                         "LEFT JOIN EventService es ON s.serviceID = es.serviceID " +
                         "WHERE c.customerName = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, customerName);
            ResultSet rs = stmt.executeQuery();

            boolean sessionReservationSet = false;

            while (rs.next()) {
                // Create Reservation object
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
                userReservations.add(reservation);

                // Create RoomBooking object
                RoomBooking roomBooking = new RoomBooking(
                    rs.getInt("roomID"),
                    rs.getString("roomType"),
                    rs.getDouble("roomPrice"),
                    1 // assuming quantity = 1
                );
                roomBookingList.add(roomBooking);

                // Create Service object if service exists
                int serviceId = rs.getInt("serviceID");
                if (!rs.wasNull() && serviceId != 0) {
                    Service service = new Service();
                    service.setServiceId(serviceId);
                    service.setServiceType(rs.getString("serviceType"));
                    service.setServiceCharge(rs.getDouble("serviceCharge"));
                    service.setRoomId(rs.getInt("roomID"));

                    serviceList.add(service);
                }

                // Store reservation general info once into session
                if (!sessionReservationSet) {
                    session.setAttribute("reservationID", rs.getInt("reservationID"));
                    session.setAttribute("roomID", rs.getInt("roomID"));
                    session.setAttribute("roomType", rs.getString("roomType"));
                    session.setAttribute("roomPrice", rs.getDouble("roomPrice"));
                    session.setAttribute("totalPayment", rs.getDouble("totalPayment"));

                    // ✅ Save dates as java.sql.Date directly
                    session.setAttribute("checkInDate", rs.getDate("checkInDate"));
                    session.setAttribute("checkOutDate", rs.getDate("checkOutDate"));

                    session.setAttribute("totalAdult", rs.getInt("totalAdult"));
                    session.setAttribute("totalKids", rs.getInt("totalKids"));
                    sessionReservationSet = true;
                }
            }

            // Set lists to session
            session.setAttribute("roomBookingList", roomBookingList);
            session.setAttribute("serviceList", serviceList);

            // Set user reservations as request attribute for JSP
            request.setAttribute("userReservations", userReservations);

            // Forward to JSP page
            request.getRequestDispatcher("customerReservation.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (Exception ignored) {}
        }
    }
}
