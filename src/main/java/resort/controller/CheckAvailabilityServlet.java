package resort.controller;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import resort.connection.ConnectionManager;
import resort.model.Room;
public class CheckAvailabilityServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Retrieve parameters from session or request
        String checkInDate = request.getParameter("checkInDate");
        String checkOutDate = request.getParameter("checkOutDate");
        String adultsParam = request.getParameter("adults");
        String kidsParam = request.getParameter("kids");

        // Log the retrieved parameters
        System.out.println("Check-In Date: " + checkInDate);
        System.out.println("Check-Out Date: " + checkOutDate);
        System.out.println("Adults: " + adultsParam);
        System.out.println("Kids: " + kidsParam);

        // Validate and set defaults if missing
        if ((checkInDate == null || checkInDate.isEmpty()) && session.getAttribute("checkInDate") != null) {
            checkInDate = (String) session.getAttribute("checkInDate");
        }
        if ((checkOutDate == null || checkOutDate.isEmpty()) && session.getAttribute("checkOutDate") != null) {
            checkOutDate = (String) session.getAttribute("checkOutDate");
        }
        int adults = (adultsParam != null) ? Integer.parseInt(adultsParam) : (session.getAttribute("adults") != null ? (Integer) session.getAttribute("adults") : 1);
        int kids = (kidsParam != null) ? Integer.parseInt(kidsParam) : (session.getAttribute("kids") != null ? (Integer) session.getAttribute("kids") : 0);

        // Store parameters in session
        session.setAttribute("checkInDate", checkInDate);
        session.setAttribute("checkOutDate", checkOutDate);
        session.setAttribute("adults", adults);
        session.setAttribute("kids", kids);

        // Retrieve customer details from session
        String customerName = (String) session.getAttribute("customer_name");
        String customerEmail = (String) session.getAttribute("customer_email");
        String customerPhoneNo = (String) session.getAttribute("customer_phoneno");

        // Debugging: Ensure customer details are carried correctly
        System.out.println("Customer Name: " + customerName);
        System.out.println("Customer Email: " + customerEmail);
        System.out.println("Customer Phone Number: " + customerPhoneNo);

        // Query available rooms
        List<Room> availableRooms = new ArrayList<>();
        String query = "SELECT * FROM Room WHERE roomStatus = 'Available' AND roomID NOT IN " +
                       "(SELECT roomID FROM Reservation WHERE checkinDate <= TO_DATE(?, 'YYYY-MM-DD') AND checkoutDate >= TO_DATE(?, 'YYYY-MM-DD'))";

        try (Connection conn = ConnectionManager.getConnection(); // Use DatabaseUtility
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, checkOutDate);
            stmt.setString(2, checkInDate);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    availableRooms.add(new Room(
                        rs.getInt("roomID"),
                        rs.getString("roomType"),
                        rs.getString("roomStatus"),
                        rs.getDouble("roomPrice"),
                        rs.getInt("staffID")
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Error: Database error occurred. " + e.getMessage());
            return;
        }

        // Pass available rooms and customer details to the JSP
        request.setAttribute("availableRooms", availableRooms);
        request.setAttribute("customerName", customerName);
        request.setAttribute("customerEmail", customerEmail);
        request.setAttribute("customerPhoneNo", customerPhoneNo);

        // Forward to AvailableRoom.jsp
        request.getRequestDispatcher("AvailableRoom.jsp").forward(request, response);
    }

    // Handle GET requests
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
