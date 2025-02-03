package resort.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import resort.model.RoomBooking;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class ConfirmBookingController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();

            // ✅ Retrieve customer details from session
            String customerName = (String) session.getAttribute("customerName");
            String customerEmail = (String) session.getAttribute("customerEmail");
            String customerPhoneNo = (String) session.getAttribute("customerPhoneNo");

            // ✅ Retrieve stay details from session
            String checkInDate = (String) session.getAttribute("checkInDate");
            String checkOutDate = (String) session.getAttribute("checkOutDate");
            int adults = parseIntOrDefault(session.getAttribute("adults"), 1);
            int kids = parseIntOrDefault(session.getAttribute("kids"), 0);

            // ✅ Ensure required fields are not null
            if (customerName == null || customerEmail == null || customerPhoneNo == null ||
                checkInDate == null || checkOutDate == null) {
                System.out.println("❌ ERROR: Missing customer or stay details!");
                response.getWriter().println("❌ ERROR: Missing customer details or stay information. Please log in again.");
                return;
            }

            // ✅ Retrieve or initialize booking list
            @SuppressWarnings("unchecked")
            List<RoomBooking> bookingList = (List<RoomBooking>) session.getAttribute("bookingList");
            if (bookingList == null) {
                bookingList = new ArrayList<>();
            }

            // ✅ Retrieve room details from request parameters
            String roomIDStr = request.getParameter("roomID");
            String roomType = request.getParameter("roomType");
            String priceStr = request.getParameter("price");
            String quantityStr = request.getParameter("quantity");

            // ✅ Validate room details
            if (roomIDStr == null || roomType == null || priceStr == null || quantityStr == null) {
                System.out.println("❌ ERROR: Missing room details from request.");
                response.getWriter().println("❌ ERROR: Room details are missing. Please select a room before confirming.");
                return;
            }

            // ✅ Convert values to correct data types
            int roomID = Integer.parseInt(roomIDStr);
            double price = Double.parseDouble(priceStr);
            int quantity = Integer.parseInt(quantityStr);

            // ✅ Check if the room already exists in the booking list (to prevent duplicates)
            boolean roomExists = false;
            for (RoomBooking existingBooking : bookingList) {
                if (existingBooking.getRoomID() == roomID) {
                    existingBooking.setQuantity(existingBooking.getQuantity() + quantity);
                    roomExists = true;
                    break;
                }
            }

            // ✅ If room is new, add it to the list
            if (!roomExists) {
                bookingList.add(new RoomBooking(roomID, roomType, price, quantity));
            }

            // ✅ Store the updated booking list in session
            session.setAttribute("bookingList", bookingList);
            session.setAttribute("roomID", roomID);
            session.setAttribute("roomType", roomType);
            session.setAttribute("roomPrice", price);
            session.setAttribute("quantity", quantity);

            // ✅ Debugging: Log updated booking list
            System.out.println("✅ DEBUG: Room stored in session.");
            System.out.println("    ➤ Room ID: " + roomID);
            System.out.println("    ➤ Room Type: " + roomType);
            System.out.println("    ➤ Price: RM" + price);
            System.out.println("    ➤ Quantity: " + quantity);
            System.out.println("    ➤ Total Booked Rooms: " + bookingList.size());

            for (RoomBooking booking : bookingList) {
                System.out.println("✅ DEBUG: [List] Room ID: " + booking.getRoomID() + 
                                   ", Type: " + booking.getRoomType() + 
                                   ", Price: RM" + booking.getPrice() + 
                                   ", Quantity: " + booking.getQuantity());
            }

            // ✅ Redirect to booking summary page
            response.sendRedirect("bookingSummary.jsp");

        } catch (Exception e) {
            e.printStackTrace(); // Print full error details in console
            response.setContentType("text/html");
            response.getWriter().println("❌ ERROR: " + e.getMessage());
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
}
