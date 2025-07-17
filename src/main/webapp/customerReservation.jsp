<%@ page session="true" %>
<%@ page import="java.util.*" %>
<%@ page import="resort.model.RoomBooking" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    String customerName = (String) session.getAttribute("customerName");
    boolean isLoggedIn = (customerName != null);
    String serviceType = (String) session.getAttribute("serviceType");
    Double roomPrice = (Double) session.getAttribute("roomPrice");
    Double serviceCharge = (Double) session.getAttribute("serviceCharge");
    Double grandTotal = (Double) session.getAttribute("grandTotal");

    if (roomPrice == null) roomPrice = 0.0;
    if (serviceCharge == null) serviceCharge = 0.0;
    if (grandTotal == null) grandTotal = roomPrice + serviceCharge;

    // Format java.sql.Date to yyyy-MM-dd string for value attribute
    String checkInDateStr = "";
    String checkOutDateStr = "";
    Object ciDateObj = session.getAttribute("checkInDate");
    Object coDateObj = session.getAttribute("checkOutDate");
    if (ciDateObj != null) {
        checkInDateStr = ciDateObj.toString(); // Should be yyyy-MM-dd format
    }
    if (coDateObj != null) {
        checkOutDateStr = coDateObj.toString();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Booking Receipt</title>
<style>
    body {
        font-family: Arial, sans-serif;
        background-color: white;
        margin: 0; padding: 0; color: black;
    }
    header {
        background: white;
        display: flex; justify-content: space-between; align-items: center;
        padding: 10px 25px;
        font-size: 18px;
        box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        position: sticky; top: 0; z-index: 1000;
    }
    .logo img {
        height: 40px;
        margin-right: 10px;
    }
    .logo a {
        font-size: 18px;
        color: #728687;
        text-decoration: none;
        font-weight: bold;
    }
    .receipt-container {
        max-width: 800px;
        margin: 40px auto;
        background: white;
        border-radius: 10px;
        padding: 20px;
        box-shadow: 0 5px 15px rgba(0,0,0,0.1);
    }
    .section {
        margin-top: 20px;
        padding: 15px;
        border-radius: 8px;
        background: #f4f4f4;
    }
    .section h3 {
        color: black;
        margin-bottom: 10px;
    }
    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 15px;
    }
    th, td {
        padding: 12px;
        border: 1px solid #ddd;
        text-align: center;
    }
    th {
        background-color: #728687;
        color: white;
        font-size: 16px;
    }
    .btn {
        padding: 10px 20px;
        background-color: #728687;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        margin-top: 10px;
    }
    .btn:hover {
        background-color: #5a6e6e;
    }
    .message {
        color: red;
        font-weight: bold;
        margin-top: 10px;
    }
    footer {
        background: #728687;
        color: white;
        text-align: center;
        padding: 10px 0;
        margin-top: 30px;
    }
</style>

<script>
    // Function to get today's date in yyyy-mm-dd format
    function getTodayDate() {
        const today = new Date();
        const yyyy = today.getFullYear();
        const mm = String(today.getMonth() + 1).padStart(2, '0');
        const dd = String(today.getDate()).padStart(2, '0');
        return `${yyyy}-${mm}-${dd}`;
    }

    window.onload = function() {
        // Set min attribute to today for check-in and check-out inputs
        const todayStr = getTodayDate();

        const checkInInput = document.getElementById('newCheckInDate');
        const checkOutInput = document.getElementById('newCheckOutDate');

        checkInInput.min = todayStr;
        checkOutInput.min = todayStr;

        // Optional: Automatically adjust check-out min date to be at least next day after check-in
        checkInInput.addEventListener('change', function() {
            if (checkInInput.value) {
                let minCheckOut = new Date(checkInInput.value);
                minCheckOut.setDate(minCheckOut.getDate() + 1);
                let yyyy = minCheckOut.getFullYear();
                let mm = String(minCheckOut.getMonth() + 1).padStart(2, '0');
                let dd = String(minCheckOut.getDate()).padStart(2, '0');
                let minCheckOutStr = `${yyyy}-${mm}-${dd}`;
                checkOutInput.min = minCheckOutStr;

                // If current check-out is before new min, update it
                if (checkOutInput.value && checkOutInput.value < minCheckOutStr) {
                    checkOutInput.value = minCheckOutStr;
                }
            }
        });
    };
</script>

</head>
<body>

<header>
    <div class="logo">
        <a href="index.jsp">
            <img src="images/MDResort.png" alt="Logo" />
        </a>
        <a href="index.jsp">MD Resort Pantai Siring Melaka</a>
    </div>
</header>

<div class="receipt-container">
    <h1>Your Bookings</h1>
    <p>Thank you for booking with <strong>MD Resort</strong></p>

    <%-- Show success or error message if any --%>
    <%
        String errorMessage = (String) session.getAttribute("errorMessage");
        if (errorMessage != null) {
    %>
        <div class="message"><%= errorMessage %></div>
    <%
            session.removeAttribute("errorMessage");
        }
    %>

    <div class="section">
        <h3>Customer Details</h3>
        <p><strong>Name:</strong> <%= session.getAttribute("customerName") %></p>
        <p><strong>Email:</strong> <%= session.getAttribute("customerEmail") %></p>
        <p><strong>Phone:</strong> <%= session.getAttribute("customerPhoneNo") %></p>
    </div>

    <%-- Editable Stay Details Form --%>
    <form action="UpdateBookingController" method="post">
        <input type="hidden" name="reservationID" value="<%= session.getAttribute("reservationID") %>" />
        <div class="section">
            <h3>Stay Details</h3>
            <label for="newCheckInDate"><strong>Check-In:</strong></label>
            <input type="date" name="newCheckInDate" id="newCheckInDate"
                   value="<%= checkInDateStr %>" required>
            <br><br>
            <label for="newCheckOutDate"><strong>Check-Out:</strong></label>
            <input type="date" name="newCheckOutDate" id="newCheckOutDate"
                   value="<%= checkOutDateStr %>" required>
            <br><br>
            <button type="submit" class="btn">Update Dates</button>
        </div>
    </form>

    <div class="section">
        <h3>Room Details</h3>
        <table>
            <tr>
                <th>Room ID</th>
                <th>Room Type</th>
                <th>Room Price (RM/night)</th>
            </tr>
            <tr>
                <td><%= session.getAttribute("roomID") != null ? session.getAttribute("roomID") : "-" %></td>
                <td><%= session.getAttribute("roomType") != null ? session.getAttribute("roomType") : "-" %></td>
                <td>RM <%= String.format("%.2f", roomPrice) %></td>
            </tr>
        </table>
    </div>

    <div class="section">
        <h3>Service Details</h3>

        <%
            if (serviceType == null) {
        %>
            <p>No additional services booked.</p>
        <%
            } else if ("Food Service".equals(serviceType)) {
                String menuName = (String) session.getAttribute("menuName");
                Integer quantityMenu = (Integer) session.getAttribute("quantityMenu");
        %>
            <table>
                <tr>
                    <th>Service Type</th>
                    <th>Menu Name</th>
                    <th>Quantity</th>
                    <th>Service Charge (RM)</th>
                </tr>
                <tr>
                    <td><%= serviceType %></td>
                    <td><%= menuName != null ? menuName : "-" %></td>
                    <td><%= quantityMenu != null ? quantityMenu : "-" %></td>
                    <td>RM <%= String.format("%.2f", serviceCharge) %></td>
                </tr>
            </table>
        <%
            } else if ("Event Service".equals(serviceType)) {
                String venue = (String) session.getAttribute("venue");
                String eventType = (String) session.getAttribute("eventType");
                Integer duration = (Integer) session.getAttribute("duration");
        %>
            <table>
                <tr>
                    <th>Service Type</th>
                    <th>Venue</th>
                    <th>Event Type</th>
                    <th>Duration (Hours)</th>
                    <th>Service Charge (RM)</th>
                </tr>
                <tr>
                    <td><%= serviceType %></td>
                    <td><%= venue != null ? venue : "-" %></td>
                    <td><%= eventType != null ? eventType : "-" %></td>
                    <td><%= duration != null ? duration : "-" %></td>
                    <td>RM <%= String.format("%.2f", serviceCharge) %></td>
                </tr>
            </table>
        <%
            }
        %>
    </div>

    <div class="section">
        <h3>Total Payment</h3>
        <p style="font-size: 20px; font-weight: bold;">
            RM <%= String.format("%.2f", grandTotal) %>
        </p>
    </div>
</div>

<footer>
    <p>&copy; 2025 MD Resort. All rights reserved.</p>
</footer>

</body>
</html>
