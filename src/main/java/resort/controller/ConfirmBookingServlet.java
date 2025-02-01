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

public class ConfirmBookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();

            // Retrieve customer details from session
            String customerName = (String) session.getAttribute("customerName");
            String customerEmail = (String) session.getAttribute("customerEmail");
            String customerPhoneNo = (String) session.getAttribute("customerPhoneNo");

            // Retrieve stay details from session and fix String to Integer conversion
            String checkInDate = (String) session.getAttribute("checkInDate");
            String checkOutDate = (String) session.getAttribute("checkOutDate");
            
            String adultsStr = (String) session.getAttribute("adults");
            String kidsStr = (String) session.getAttribute("kids");

            int adults = (adultsStr != null) ? Integer.parseInt(adultsStr) : 1;
            int kids = (kidsStr != null) ? Integer.parseInt(kidsStr) : 0;

            // Retrieve booking list from session (or initialize if null)
            @SuppressWarnings("unchecked")
            List<RoomBooking> bookingList = (List<RoomBooking>) session.getAttribute("bookingList");

            // Debugging: Log retrieved values
            System.out.println("✅ DEBUG: Customer Name: " + customerName);
            System.out.println("✅ DEBUG: Customer Email: " + customerEmail);
            System.out.println("✅ DEBUG: Customer Phone Number: " + customerPhoneNo);
            System.out.println("✅ DEBUG: Check-In Date: " + checkInDate);
            System.out.println("✅ DEBUG: Check-Out Date: " + checkOutDate);
            System.out.println("✅ DEBUG: Adults: " + adults);
            System.out.println("✅ DEBUG: Kids: " + kids);

            // Ensure required fields are not null
            if (customerName == null || customerEmail == null || customerPhoneNo == null ||
                checkInDate == null || checkOutDate == null) {
                System.out.println("❌ DEBUG: Missing customer or stay details!");
                response.getWriter().println("❌ ERROR: Missing customer details or stay information. Please log in again.");
                return;
            }

            // Ensure the booking list is not null
            if (bookingList == null) {
                bookingList = new ArrayList<>();
            }

            // Retrieve room details from request parameters
            String roomIDStr = request.getParameter("roomID");
            String roomType = request.getParameter("roomType");
            String priceStr = request.getParameter("price");
            String quantityStr = request.getParameter("quantity");

            // Validate room details
            if (roomIDStr == null || roomType == null || priceStr == null || quantityStr == null) {
                System.out.println("❌ DEBUG: Missing room details from request.");
                response.getWriter().println("❌ ERROR: Room details are missing. Please select a room before confirming.");
                return;
            }

            // Convert values to correct data types
            int roomID = Integer.parseInt(roomIDStr);
            double price = Double.parseDouble(priceStr);
            int quantity = Integer.parseInt(quantityStr);

            // Add the selected room to the booking list
            bookingList.add(new RoomBooking(roomID, roomType, price, quantity));

            // Store the updated booking list in session
            session.setAttribute("bookingList", bookingList);

            // Debugging: Log updated booking list
            System.out.println("✅ DEBUG: Room added to booking list.");
            for (RoomBooking booking : bookingList) {
                System.out.println("✅ DEBUG: Room ID: " + booking.getRoomID() + 
                                   ", Type: " + booking.getRoomType() + 
                                   ", Price: RM" + booking.getPrice() + 
                                   ", Quantity: " + booking.getQuantity());
            }

            // Forward to the booking summary page
            request.setAttribute("bookingList", bookingList);
            request.getRequestDispatcher("bookingSummary.jsp").forward(request, response);

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
}
