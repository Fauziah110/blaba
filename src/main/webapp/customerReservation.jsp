<%@ page session="true" %>
<%@ page import="java.util.*" %>
<%@ page import="resort.model.RoomBooking" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
String customerName = (String) session.getAttribute("customerName");
boolean isLoggedIn = (customerName != null);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Receipt</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: white;
            margin: 0;
            padding: 0;
            color: black;
        }
        header {
            background: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 25px;
            font-size: 18px;
            top: 0;
            z-index: 1000;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .logo {
            display: flex;
            align-items: center;
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
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        .section {
            margin-top: 20px;
            padding: 15px;
            border-radius: 8px;
            background: #f4f4f4;
        }
        .section h3 {
            color: black;
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
        footer {
            background: #728687;
            color: white;
            text-align: center;
            padding: 10px 0;
            margin-top: 30px;
        }
        .footer-container {
            max-width: 1200px;
            margin: 0 auto;
        }
        .footer-links {
            list-style: none;
            padding: 0;
            display: flex;
            justify-content: center;
            gap: 20px;
            padding-top: 10px;
            border-top: 1px solid white;
        }
        .footer-links a {
            color: black;
            text-decoration: none;
            font-size: 14px;
        }
        .footer-links a:hover {
            color: white;
        }

        /* Update Dates Button Style */
        .update-button {
            padding: 10px 20px;
            background-color: #728687;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .update-button:hover {
            background-color: #5a6b61;  /* Slightly darker shade */
        }
    </style>
    <script>
        function printReceipt() {
            window.print();
        }
    </script>
</head>
<body>
<header>
    <div class="logo">
        <a href="index.jsp">
            <img src="images/MDResort.png" alt="Logo">
        </a>
        <a href="index.jsp">MD Resort Pantai Siring Melaka</a>
    </div>
</header>
<div class="receipt-container">
    <header>
        <h1>Your Booking</h1>
        <p>Thank you for booking with <strong>MD Resort</strong></p>
    </header>
    <div class="section">
        <h3>Customer Details</h3>
        <p><strong>Name:</strong> <%= session.getAttribute("customerName") %></p>
        <p><strong>Email:</strong> <%= session.getAttribute("customerEmail") %></p>
        <p><strong>Phone:</strong> <%= session.getAttribute("customerPhoneNo") %></p>
    </div>
    <div class="section">
        <h3>Stay Details</h3>
        <p><strong>Check-In:</strong> <%= session.getAttribute("checkInDate") %></p>
        <p><strong>Check-Out:</strong> <%= session.getAttribute("checkOutDate") %></p>
        <p><strong>Adults:</strong> <%= session.getAttribute("totalAdult") %></p>
        <p><strong>Kids:</strong> <%= session.getAttribute("totalKids") %></p>
    </div>

    <!-- Change Stay Dates Form -->
    <div class="section">
        <h3>Change Stay Dates</h3>
        <form action="UpdateBookingController" method="post">
            <div class="form-group">
                <label for="newCheckInDate">New Check-In Date:</label>
                <input type="date" id="newCheckInDate" name="newCheckInDate" value="<%= session.getAttribute("checkInDate") %>" required>
            </div>
            <div class="form-group">
                <label for="newCheckOutDate">New Check-Out Date:</label>
                <input type="date" id="newCheckOutDate" name="newCheckOutDate" value="<%= session.getAttribute("checkOutDate") %>" required>
            </div>
            <button type="submit" class="update-button">Update Booking</button>
        </form>
    </div>

    <div class="section">
        <h3>Booking Details</h3>
        <table>
            <tr>
                <th>Reservation ID</th>
                <th>Room ID</th>
                <th>Room Type</th>
                <th>Room Price (RM/night)</th>
                <th>Total Payment (RM)</th>
            </tr>
            <tr>
                <td><%= session.getAttribute("reservationID") %></td>
                <td><%= session.getAttribute("roomID") %></td>
                <td><%= session.getAttribute("roomType") %></td>
                <td>RM <%= session.getAttribute("roomPrice") %></td>
                <td>RM <%= session.getAttribute("totalPayment") %></td>
            </tr>
        </table>

        <!-- Display Service Details in a Table -->
        <c:if test="${not empty serviceType}">
            <h4>Service Details</h4>
            <table>
                <tr>
                    <th>Reservation ID</th>
                    <th>Service Type</th>
                    <th>Service Charge (RM)</th>
                    <th>Food Menu</th>
                    <th>Food Menu Price (RM)</th>
                    <th>Quantity</th>
                    <th>Event Venue</th>
                    <th>Event Type</th>
                    <th>Event Duration (hours)</th>
                </tr>
                <tr>
                    <td><%= session.getAttribute("reservationID") %></td>
                    <td>${serviceType}</td>
                    <td>RM ${serviceCharge}</td>
                    <td>${foodMenuName}</td>
                    <td>RM ${foodMenuPrice}</td>
                    <td>${foodQuantityMenu}</td>
                    <td>${eventVenue}</td>
                    <td>${eventType}</td>
                    <td>${eventDuration}</td>
                </tr>
            </table>
        </c:if>
    </div>
</div>
<footer>
    <div class="footer-container">
        <ul class="footer-links">
            <li><a href="index.jsp">Home</a></li>
            <li><a href="roomCustomer.jsp">Room</a></li>
            <li><a href="facilityCustomer.jsp">Facilities</a></li>
        </ul>
        <p>&copy; 2025 MD Resort. All rights reserved.</p>
    </div>
</footer>
</body>
</html>
