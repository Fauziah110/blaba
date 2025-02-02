<%@ page session="true" %>
<%@ page import="java.util.*" %>
<%@ page import="resort.model.Reservation" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Booking Details</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f9f9f9;
        }
        .container {
            max-width: 800px;
            margin: 20px auto;
            padding: 20px;
            background: white;
            border-radius: 8px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
        }
        .header {
            text-align: center;
            color: #003580;
            font-size: 22px;
            font-weight: bold;
            margin-bottom: 20px;
        }
        .section {
            padding: 15px;
            border-bottom: 1px solid #ddd;
        }
        .section h3 {
            margin: 0;
            color: #003580;
            font-size: 18px;
        }
        .details p {
            margin: 5px 0;
            font-size: 16px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        table, th, td {
            border: 1px solid #ddd;
        }
        th, td {
            padding: 12px;
            text-align: left;
        }
        th {
            background: #003580;
            color: white;
            text-align: center;
        }
        .total {
            font-size: 18px;
            font-weight: bold;
            text-align: right;
            margin-top: 15px;
        }
        .no-reservation {
            text-align: center;
            color: red;
            font-size: 18px;
            margin-top: 20px;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="header">Your Booking Details</div>

    <div class="section">
        <h3>Customer Information</h3>
        <%
            List<Reservation> userReservations = (List<Reservation>) request.getAttribute("userReservations");
            if (userReservations != null && !userReservations.isEmpty()) {
                Reservation res = userReservations.get(0); // Take first reservation to show customer details
        %>
        <div class="details">
            <p><strong>Customer ID:</strong> <%= res.getCustomerID() %></p>
            <p><strong>Customer Name:</strong> <%= res.getCustomerName() %></p>
        </div>
    </div>

    <div class="section">
        <h3>Booking Information</h3>
        <div class="details">
            <p><strong>Reservation ID:</strong> <%= res.getReservationID() %></p>
            <p><strong>Reservation Date:</strong> <%= res.getReservationDate() %></p>
            <p><strong>Check-In Date:</strong> <%= res.getCheckInDate() %></p>
            <p><strong>Check-Out Date:</strong> <%= res.getCheckOutDate() %></p>
        </div>
    </div>

    <div class="section">
        <h3>Room Details</h3>
        <table>
            <thead>
                <tr>
                    <th>Room Type</th>
                    <th>Adults</th>
                    <th>Kids</th>
                    <th>Service ID</th>
                    <th>Total Payment (RM)</th>
                </tr>
            </thead>
            <tbody>
                <%
                    for (Reservation reservation : userReservations) {
                %>
                <tr>
                    <td><%= reservation.getRoomType() %></td>
                    <td style="text-align: center;"><%= reservation.getTotalAdult() %></td>
                    <td style="text-align: center;"><%= reservation.getTotalKids() %></td>
                    <td style="text-align: center;"><%= (reservation.getServiceID() != 0) ? reservation.getServiceID() : "N/A" %></td>
                    <td style="text-align: right;">RM <%= reservation.getTotalPayment() %></td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>

    <div class="section total">
        <p><strong>Total Payment:</strong> RM <%= res.getTotalPayment() %></p>
    </div>
    <%
        } else {
    %>
    <p class="no-reservation">No reservations found.</p>
    <%
        }
    %>
</div>

</body>
</html>
