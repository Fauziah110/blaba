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
        footer {
            background: #728687;
            color: white;
            text-align: center;
            padding: 10px 0;
            margin-top: 30px;
        }
    </style>
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
    <h1>Your Booking Receipt</h1>
    <p>Thank you for booking with <strong>MD Resort</strong></p>

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
