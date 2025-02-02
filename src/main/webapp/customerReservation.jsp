<%@ page session="true" %>
<%@ page import="java.util.List" %>
<%@ page import="resort.model.Booking" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Bookings</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: white;
        }
        header, footer {
            background: #003580;
            color: white;
            text-align: center;
            padding: 20px;
        }
        .container {
            max-width: 900px;
            margin: 20px auto;
            padding: 20px;
            background: #f4f4f4;
            border-radius: 8px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }
        table, th, td {
            border: 1px solid #ddd;
        }
        th, td {
            padding: 10px;
            text-align: left;
        }
        th {
            background: #003580;
            color: white;
        }
        .status {
            font-weight: bold;
        }
        .status.upcoming {
            color: #28a745;
        }
        .status.completed {
            color: #007bff;
        }
        .status.canceled {
            color: #dc3545;
        }
    </style>
</head>
<body>

<header>
    <h1>My Booking History</h1>
</header>

<main class="container">
    <h2>Bookings for <%= session.getAttribute("customerName") %></h2>

    <%
        List<Booking> bookings = (List<Booking>) request.getAttribute("userBookings");

        if (bookings != null && !bookings.isEmpty()) {
    %>
    <table>
        <thead>
            <tr>
                <th>Booking ID</th>
                <th>Room Type</th>
                <th>Check-In</th>
                <th>Check-Out</th>
                <th>Total Price (RM)</th>
                <th>Status</th>
            </tr>
        </thead>
        <tbody>
            <%
                for (Booking booking : bookings) {
                    String statusClass = booking.getStatus().equalsIgnoreCase("Upcoming") ? "status upcoming" :
                                        booking.getStatus().equalsIgnoreCase("Completed") ? "status completed" :
                                        "status canceled";
            %>
            <tr>
                <td><%= booking.getBookingID() %></td>
                <td><%= booking.getRoomType() %></td>
                <td><%= booking.getCheckInDate() %></td>
                <td><%= booking.getCheckOutDate() %></td>
                <td>RM <%= booking.getTotalPrice() %></td>
                <td class="<%= statusClass %>"><%= booking.getStatus() %></td>
            </tr>
            <%
                }
            %>
        </tbody>
    </table>
    <% } else { %>
        <p style="color: red; text-align: center;">No bookings found.</p>
    <% } %>
</main>

<footer>
    <p>&copy; 2025 MD Resort</p>
</footer>

</body>
</html>
