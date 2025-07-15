<%@ page session="true" %>
<%@ page import="java.util.*" %>
<%@ page import="resort.model.RoomBooking" %>
<%@ page import="resort.model.Service" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    // Retrieve session attributes
    String customerName = (String) session.getAttribute("customerName");
    String customerEmail = (String) session.getAttribute("customerEmail");
    String customerPhoneNo = (String) session.getAttribute("customerPhoneNo");

    java.sql.Date checkInDate = (java.sql.Date) session.getAttribute("checkInDate");
    java.sql.Date checkOutDate = (java.sql.Date) session.getAttribute("checkOutDate");
    int totalAdults = (Integer) session.getAttribute("totalAdult");
    int totalKids = (Integer) session.getAttribute("totalKids");
    double totalPayment = (Double) session.getAttribute("totalPayment");

    List<RoomBooking> bookingList = (List<RoomBooking>) session.getAttribute("roomBookingList");
    List<Service> serviceList = (List<Service>) session.getAttribute("serviceList");

    // Format the java.sql.Date to a string (YYYY-MM-DD)
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    String formattedCheckInDate = checkInDate != null ? dateFormat.format(checkInDate) : "Not Set";
    String formattedCheckOutDate = checkOutDate != null ? dateFormat.format(checkOutDate) : "Not Set";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Booking Receipt</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f5f5f5;
            margin: 0;
            padding: 0;
        }
        .receipt-container {
            max-width: 800px;
            margin: 40px auto;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        header {
            text-align: center;
            border-bottom: 2px solid #003580;
            padding-bottom: 10px;
        }
        header h1 {
            margin: 0;
            color: #003580;
        }
        .section {
            margin-top: 20px;
        }
        .section h3 {
            margin-bottom: 10px;
            color: #003580;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
        }
        th {
            background: #003580;
            color: white;
        }
        .total {
            text-align: right;
            font-weight: bold;
            margin-top: 15px;
        }
        .buttons {
            margin-top: 20px;
            display: flex;
            justify-content: space-between;
        }
        .btn {
            background: #007BFF;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border: none;
            border-radius: 5px;
        }
        .btn:hover {
            background: #0056b3;
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
        <p><strong>Name:</strong> <%= customerName %></p>
        <p><strong>Email:</strong> <%= customerEmail %></p>
        <p><strong>Phone:</strong> <%= customerPhoneNo %></p>
    </div>

    <% if (bookingList != null && !bookingList.isEmpty()) { %>
    <div class="section">
        <h3>Stay Details</h3>
        <p><strong>Check-In:</strong> <%= formattedCheckInDate %></p>
        <p><strong>Check-Out:</strong> <%= formattedCheckOutDate %></p>
        <p><strong>Adults:</strong> <%= totalAdults %></p>
        <p><strong>Kids:</strong> <%= totalKids %></p>

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
                    for (RoomBooking booking : bookingList) {
                        double roomTotal = booking.getQuantity() * booking.getPrice();
                %>
                <tr>
                    <td><%= booking.getRoomType() %></td>
                    <td><%= booking.getQuantity() %></td>
                    <td>RM <%= booking.getPrice() %></td>
                    <td>RM <%= roomTotal %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
    <% } else { %>
    <div class="section">
        <h3>Stay Details</h3>
        <p style="color: red;">No rooms booked.</p>
    </div>
    <% } %>

    <% if (serviceList != null && !serviceList.isEmpty()) { %>
    <div class="section">
        <h3>Services Booked</h3>
        <table>
            <thead>
                <tr>
                    <th>Service Type</th>
                    <th>Service Charge (RM)</th>
                    <th>Room ID</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    for (Service service : serviceList) {
                %>
                <tr>
                    <td><%= service.getServiceType() %></td>
                    <td>RM <%= service.getServiceCharge() %></td>
                    <td><%= service.getRoomId() %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
    <% } else { %>
    <div class="section">
        <h3>Services Booked</h3>
        <p style="color: red;">No services booked.</p>
    </div>
    <% } %>

    <div class="total">
        <p>Total Amount Paid: <strong>RM <%= totalPayment %></strong></p>
    </div>

    <div class="buttons">
        <button class="btn" onclick="printReceipt()">Print Receipt</button>
        <form action="index.jsp" style="display:inline;">
            <button type="submit" class="btn">Back to Homepage</button>
        </form>
    </div>
</div>
</body>
</html>
