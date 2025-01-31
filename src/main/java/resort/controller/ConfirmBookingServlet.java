package resort.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import resort.model.RoomBooking;

import java.io.IOException;
import java.util.List;

public class ConfirmBookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();

            // Retrieve customer details from session
            String customerName = (String) session.getAttribute("customer_name");
            String customerEmail = (String) session.getAttribute("customer_email");
            String customerPhoneNo = (String) session.getAttribute("customer_phoneno");

            // Retrieve stay details from the session
            String checkInDate = (String) session.getAttribute("checkInDate");
            String checkOutDate = (String) session.getAttribute("checkOutDate");
            Integer adults = (Integer) session.getAttribute("adults");
            Integer kids = (Integer) session.getAttribute("kids");

            // Retrieve booking list from the session
            @SuppressWarnings("unchecked")
            List<RoomBooking> bookingList = (List<RoomBooking>) session.getAttribute("bookingList");

            // Debugging: Log all details for verification
            System.out.println("Customer Name: " + customerName);
            System.out.println("Customer Email: " + customerEmail);
            System.out.println("Customer Phone Number: " + customerPhoneNo);
            System.out.println("Check-In Date: " + checkInDate);
            System.out.println("Check-Out Date: " + checkOutDate);
            System.out.println("Adults: " + adults);
            System.out.println("Kids: " + kids);

            if (bookingList != null) {
                for (RoomBooking booking : bookingList) {
                    System.out.println("Room Type: " + booking.getRoomType() +
                                       ", Quantity: " + booking.getQuantity() +
                                       ", Price: " + booking.getPrice());
                }
            } else {
                System.out.println("No bookings found.");
            }

            // Validate customer details
            if (customerName == null || customerName.isEmpty() ||
                customerEmail == null || customerEmail.isEmpty() ||
                customerPhoneNo == null || customerPhoneNo.isEmpty()) {
                response.getWriter().println("Error: Missing customer details. Please log in again.");
                return;
            }

            // Validate stay details
            if (checkInDate == null || checkOutDate == null || adults == null || kids == null) {
                response.getWriter().println("Error: Missing stay details. Please start the booking process again.");
                return;
            }

            // Validate booking list
            if (bookingList == null || bookingList.isEmpty()) {
                response.getWriter().println("Error: No rooms booked. Please add rooms to your booking.");
                return;
            }

            // Set customer details and stay details as request attributes for forwarding
            request.setAttribute("customerName", customerName);
            request.setAttribute("customerEmail", customerEmail);
            request.setAttribute("customerPhoneNo", customerPhoneNo);
            request.setAttribute("checkInDate", checkInDate);
            request.setAttribute("checkOutDate", checkOutDate);
            request.setAttribute("adults", adults);
            request.setAttribute("kids", kids);
            request.setAttribute("bookingList", bookingList);

            // Forward to BookingList.jsp
            request.getRequestDispatcher("BookingSummary.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: An unexpected error occurred. Please try again.");
        }
    }
}
