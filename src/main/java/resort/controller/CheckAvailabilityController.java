package resort.controller;

import java.io.IOException;
import java.sql.*;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import resort.connection.ConnectionManager;
import resort.model.Room;

public class CheckAvailabilityController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Retrieve parameters
        String checkInDateStr = request.getParameter("checkInDate");
        String checkOutDateStr = request.getParameter("checkOutDate");
        String adultsParam = request.getParameter("adults");
        String kidsParam = request.getParameter("kids");

        // Log input values
        System.out.println("✅ DEBUG: Check-In Date: " + checkInDateStr);
        System.out.println("✅ DEBUG: Check-Out Date: " + checkOutDateStr);
        System.out.println("✅ DEBUG: Adults: " + adultsParam);
        System.out.println("✅ DEBUG: Kids: " + kidsParam);

        // Validate input: Ensure dates are in the correct format and not in the past
        LocalDate today = LocalDate.now();
        LocalDate checkInDate, checkOutDate;

        try {
            checkInDate = LocalDate.parse(checkInDateStr);
            checkOutDate = LocalDate.parse(checkOutDateStr);

            // Prevent past dates from being booked
            if (checkInDate.isBefore(today) || checkOutDate.isBefore(today)) {
                request.setAttribute("errorMessage", "❌ Error: You cannot book a past date.");
                request.getRequestDispatcher("roomCustomer.jsp").forward(request, response);
                return;
            }

            // Ensure check-in date is before check-out date
            if (checkOutDate.isBefore(checkInDate)) {
                request.setAttribute("errorMessage", "❌ Error: Check-out date must be after check-in date.");
                request.getRequestDispatcher("roomCustomer.jsp").forward(request, response);
                return;
            }
        } catch (DateTimeParseException e) {
            request.setAttribute("errorMessage", "❌ Error: Invalid date format. Please use YYYY-MM-DD.");
            request.getRequestDispatcher("roomCustomer.jsp").forward(request, response);
            return;
        }

        // Store parameters in session
        session.setAttribute("checkInDate", checkInDateStr);
        session.setAttribute("checkOutDate", checkOutDateStr);
        session.setAttribute("adults", adultsParam);
        session.setAttribute("kids", kidsParam);

        // Retrieve customer details from session
        String customerName = (String) session.getAttribute("customerName");
        String customerEmail = (String) session.getAttribute("customerEmail");
        String customerPhoneNo = (String) session.getAttribute("customerPhoneNo");

        // Debugging: Ensure customer details are carried correctly
        System.out.println("✅ DEBUG: Customer Name: " + customerName);
        System.out.println("✅ DEBUG: Customer Email: " + customerEmail);
        System.out.println("✅ DEBUG: Customer Phone Number: " + customerPhoneNo);

        // Check if session attributes are null
        if (customerName == null || customerEmail == null || customerPhoneNo == null) {
            System.out.println("❌ DEBUG: Customer session attributes are NULL. Redirecting to login page.");
            response.sendRedirect("login.jsp");
            return;
        }

        // Query available rooms
        List<Room> availableRooms = new ArrayList<>();
        String query = "SELECT * FROM Room WHERE roomStatus = 'Available' AND roomID NOT IN " +
                       "(SELECT roomID FROM Reservation WHERE checkinDate <= CAST(? AS DATE) " +
                       "AND checkoutDate >= CAST(? AS DATE))";

        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
             
            stmt.setString(1, checkOutDateStr);
            stmt.setString(2, checkInDateStr);

            System.out.println("✅ DEBUG: Executing query for room availability...");
            
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
            response.getWriter().println("❌ Error: Database error occurred. " + e.getMessage());
            return;
        }

        // Pass available rooms and customer details to the JSP
        request.setAttribute("availableRooms", availableRooms);
        request.setAttribute("customerName", customerName);
        request.setAttribute("customerEmail", customerEmail);
        request.setAttribute("customerPhoneNo", customerPhoneNo);

        // Debugging: Ensure data is being passed
        System.out.println("✅ DEBUG: Forwarding to AvailableRoom.jsp...");
        System.out.println("✅ DEBUG: Available Rooms Count: " + availableRooms.size());

        // Forward to AvailableRoom.jsp
        request.getRequestDispatcher("availableRoom.jsp").forward(request, response);
    }

    // Handle GET requests
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
