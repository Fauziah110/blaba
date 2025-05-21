<%@ page session="true" %>
<%@ page import="java.util.*" %>
<%@ page import="resort.model.RoomBooking" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // Retrieve session attributes
    String customerName = (String) session.getAttribute("customerName");
    java.sql.Date checkInDate = (java.sql.Date) session.getAttribute("checkInDate");
    java.sql.Date checkOutDate = (java.sql.Date) session.getAttribute("checkOutDate");
    int totalAdults = (Integer) session.getAttribute("totalAdult");
    int totalKids = (Integer) session.getAttribute("totalKids");
    double totalPayment = (Double) session.getAttribute("totalPayment");
    List<RoomBooking> bookingList = (List<RoomBooking>) session.getAttribute("roomBookingList");

    // Format the java.sql.Date to a string (YYYY-MM-DD)
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    String formattedCheckInDate = checkInDate != null ? dateFormat.format(checkInDate) : "Not Set";
    String formattedCheckOutDate = checkOutDate != null ? dateFormat.format(checkOutDate) : "Not Set";

    double totalRoomPrice = 0;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Receipt</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
        }
        .receipt-container {
            max-width: 800px;
            margin: 40px auto;
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        header {
            text-align: center;
            padding-bottom: 20px;
            border-bottom: 2px solid #003580;
        }
        header h1 {
            color: #003580;
            margin: 0;
        }
        .section {
            margin-top: 20px;
            padding: 15px;
            border-radius: 8px;
            background: #f4f4f4;
        }
        .section h3 {
            margin-top: 0;
            color: #003580;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        th, td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: left;
        }
        th {
            background-color: #003580;
            color: white;
        }
        .total-price {
            font-size: 20px;
            font-weight: bold;
            color: #003580;
            text-align: right;
            padding-top: 15px;
        }
        .buttons {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }
        .btn {
            padding: 12px 20px;
            background: #007BFF;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }
        .btn:hover {
            background: #0056b3;
        }
        .footer {
            text-align: center;
            margin-top: 30px;
            color: #555;
        }
    </style>
    <script>
        function printReceipt() {
            window.print();
        }
    </script>
</head>
<body>

<div class="receipt-container">
    <header>
        <h1>Booking Receipt</h1>
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
        <p><strong>Check-In:</strong> <%= formattedCheckInDate %></p>
        <p><strong>Check-Out:</strong> <%= formattedCheckOutDate %></p>
        <p><strong>Adults:</strong> <%= totalAdults %></p>
        <p><strong>Kids:</strong> <%= totalKids %></p>
    </div>

    <div class="section">
        <h3>Rooms Booked</h3>
        <table>
            <thead>
                <tr>
                    <th>Room Type</th>
                    <th>Quantity</th>
                    <th>Price/Night (RM)</th>
                    <th>Total Price (RM)</th>
                </tr>
            </thead>
            <tbody>
                <%
                    if (bookingList != null && !bookingList.isEmpty()) {
                        for (RoomBooking booking : bookingList) {
                            double roomTotal = booking.getQuantity() * booking.getPrice();
                            totalRoomPrice += roomTotal;
                %>
                <tr>
                    <td><%= booking.getRoomType() %></td>
                    <td><%= booking.getQuantity() %></td>
                    <td>RM <%= booking.getPrice() %></td>
                    <td>RM <%= roomTotal %></td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="4" style="text-align:center; color: red;">No rooms booked. Please select a room.</td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>

    <div class="total-price">
        <p>Total Amount Paid: <strong>RM <%= totalPayment %></strong></p>
    </div>

    <div class="buttons">
        <button onclick="printReceipt()" class="btn">Print Receipt</button>
        <form action="index.jsp">
            <button type="submit" class="btn">Back to Homepage</button>
        </form>
    </div>

    <div class="footer">
        <p>&copy; 2025 MD Resort. All rights reserved.</p>
    </div>
</div>

</body>
</html>
