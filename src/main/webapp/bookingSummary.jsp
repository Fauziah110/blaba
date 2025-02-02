<%@ page session="true" %>
<%@ page import="java.util.*" %>
<%@ page import="resort.model.RoomBooking" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Summary</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
        }
        header, footer {
            background: #728687;
            color: white;
            text-align: center;
            padding: 20px;
        }
        main {
            padding: 20px;
            max-width: 900px;
            margin: auto;
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }
        .section {
            padding: 20px;
            border-radius: 8px;
            background: #f4f4f4;
            margin-top: 20px;
        }
        .section h3 {
            margin-top: 0;
            color: black;
        }
        label {
            font-weight: bold;
            display: block;
            margin: 10px 0 5px;
        }
        select, input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            margin-bottom: 10px;
        }
        .total-price {
            font-size: 18px;
            font-weight: bold;
            color:#728687;
            text-align: center;
            padding: 10px;
            background: #f4f4f4;
            border-radius: 5px;
            margin-top: 10px;
        }
        .btn {
            display: block;
            width: 100%;
            background: #728687;
            color: white;
            padding: 12px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            margin-top: 10px;
        }
        .btn:hover {
            background: #728687;
        }
    </style>
</head>
<body>

<header>
    <h1>Booking Summary</h1>
</header>

<main>
    <div class="section">
        <h3>Customer Details</h3>
        <p><strong>Name:</strong> <%= session.getAttribute("customerName") != null ? session.getAttribute("customerName") : "Not Available" %></p>
        <p><strong>Email:</strong> <%= session.getAttribute("customerEmail") != null ? session.getAttribute("customerEmail") : "Not Available" %></p>
        <p><strong>Phone:</strong> <%= session.getAttribute("customerPhoneNo") != null ? session.getAttribute("customerPhoneNo") : "Not Available" %></p>
    </div>

    <div class="section">
        <h3>Stay Details</h3>
        <p><strong>Check-In:</strong> <%= session.getAttribute("checkInDate") != null ? session.getAttribute("checkInDate") : "Not Set" %></p>
        <p><strong>Check-Out:</strong> <%= session.getAttribute("checkOutDate") != null ? session.getAttribute("checkOutDate") : "Not Set" %></p>
        <p><strong>Adults:</strong> <%= session.getAttribute("adults") != null ? session.getAttribute("adults") : "0" %></p>
        <p><strong>Kids:</strong> <%= session.getAttribute("kids") != null ? session.getAttribute("kids") : "0" %></p>
    </div>

    <div class="section">
        <h3>Rooms Booked</h3>
        <%
            List<RoomBooking> bookingList = (List<RoomBooking>) session.getAttribute("bookingList");
            double totalRoomPrice = 0;
            if (bookingList != null && !bookingList.isEmpty()) {
        %>
        <table>
            <thead>
                <tr>
                    <th>Room ID</th>
                    <th>Room Type</th>
                    <th>Quantity</th>
                    <th>Price/Night</th>
                    <th>Total Price</th>
                </tr>
            </thead>
            <tbody>
                <%
                    for (RoomBooking booking : bookingList) {
                        double roomTotal = booking.getQuantity() * booking.getPrice();
                        totalRoomPrice += roomTotal;
                %>
                <tr>
                    <td><%= booking.getRoomID() %></td>
                    <td><%= booking.getRoomType() %></td>
                    <td><%= booking.getQuantity() %></td>
                    <td>RM<%= booking.getPrice() %></td>
                    <td>RM<%= roomTotal %></td>
                </tr>
                <%
                    }
                %>
                <tr>
                    <th colspan="4">Room Grand Total</th>
                    <th>RM<%= totalRoomPrice %></th>
                </tr>
            </tbody>
        </table>
        <% } else { %>
            <p style="color: red;">No rooms booked. Please select a room.</p>
        <% } %>
    </div>

    <form action="ReservationController" method="POST">
        <input type="hidden" name="customerID" value="<%= session.getAttribute("customerID") %>">
        <input type="hidden" name="roomID" value="<%= session.getAttribute("roomID") != null ? session.getAttribute("roomID") : "" %>">
        <input type="hidden" name="roomType" value="<%= session.getAttribute("roomType") != null ? session.getAttribute("roomType") : "" %>"> 
        <input type="hidden" id="baseTotalPrice" value="<%= totalRoomPrice %>">
        <input type="hidden" id="totalPayment" name="totalPrice" value="<%= totalRoomPrice %>">

        <div class="total-price">
            Total Payment: <span id="displayTotalPayment">RM<%= totalRoomPrice %></span>
        </div>

        <% if (bookingList != null && !bookingList.isEmpty()) { %>
            <button type="submit" class="btn">Confirm Booking</button>
        <% } else { %>
            <button type="button" class="btn" disabled>Please Select a Room First</button>
        <% } %>
    </form>
</main>

<footer>
    <p>&copy; 2025 MD Resort</p>
</footer>

</body>
</html>
