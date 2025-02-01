<%@ page session="true" %>
<%@ page import="java.util.*" %>
<%@ page import="resort.model.RoomBooking" %>

<% session.setAttribute("customerID", request.getParameter("customerID")); %>
<% session.setAttribute("totalAdult", request.getParameter("totalAdult")); %>
<% session.setAttribute("totalKids", request.getParameter("totalKids")); %>


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
            background: #003580;
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
            color: #003580;
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
            color: #003580;
            text-align: center;
            padding: 10px;
            background: #e0f7ff;
            border-radius: 5px;
            margin-top: 10px;
        }
        .btn {
            display: block;
            width: 100%;
            background: #007BFF;
            color: white;
            padding: 12px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            margin-top: 10px;
        }
        .btn:hover {
            background: #0056b3;
        }
    </style>
    <script>
        function updateTotalPrice() {
            let basePrice = parseFloat(document.getElementById("baseTotalPrice").value);
            let foodPrice = document.getElementById("menuName").value ? parseFloat(document.getElementById("menuName").value.split("|")[1]) : 0;
            let foodQuantity = parseInt(document.getElementById("menuQuantity").value) || 1;
            let eventPrice = document.getElementById("eventType").value ? 100 : 0; // Assume RM100 per event
            let duration = parseInt(document.getElementById("duration").value) || 1;

            let totalServicePrice = (foodPrice * foodQuantity) + (eventPrice * duration);
            let finalTotal = basePrice + totalServicePrice;

            document.getElementById("totalPayment").value = finalTotal.toFixed(2);
            document.getElementById("displayTotalPayment").innerText = "RM" + finalTotal.toFixed(2);
        }
    </script>
</head>
<body>
<header>
    <h1>Booking Summary</h1>
</header>

<main>
    <div class="section">
        <h3>Customer Details</h3>
        <p><strong>Name:</strong> <%= session.getAttribute("customer_name") %></p>
        <p><strong>Email:</strong> <%= session.getAttribute("customer_email") %></p>
        <p><strong>Phone:</strong> <%= session.getAttribute("customer_phoneno") %></p>
    </div>

    <div class="section">
        <h3>Stay Details</h3>
        <p><strong>Check-In:</strong> <%= session.getAttribute("checkInDate") %></p>
        <p><strong>Check-Out:</strong> <%= session.getAttribute("checkOutDate") %></p>
        <p><strong>Adults:</strong> <%= session.getAttribute("adults") %></p>
        <p><strong>Kids:</strong> <%= session.getAttribute("kids") %></p>
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
                    <td><%= booking.getRoomType() %></td>
                    <td><%= booking.getQuantity() %></td>
                    <td>RM<%= booking.getPrice() %></td>
                    <td>RM<%= roomTotal %></td>
                </tr>
                <%
                    }
                %>
                <tr>
                    <th colspan="3">Room Grand Total</th>
                    <th>RM<%= totalRoomPrice %></th>
                </tr>
            </tbody>
        </table>
        <% } else { %>
            <p>No rooms booked. Please select a room.</p>
        <% } %>
    </div>

    <form action="ReservationController" method="POST">
         <input type="hidden" name="customerID" value="<%= session.getAttribute("customerID") %>">
	    <input type="hidden" name="roomType" value="<%= session.getAttribute("roomType") %>"> 
	    <input type="hidden" id="baseTotalPrice" value="<%= totalRoomPrice %>">
	    <input type="hidden" id="totalPayment" name="totalPrice" value="<%= totalRoomPrice %>">

        <div class="section">
            <h3>Food Service</h3>
            <label>Menu:</label>
            <select name="menuName" id="menuName" onchange="updateTotalPrice()">
                <option value="">-- Select Food --</option>
                <option value="Chicken Rice|10">Chicken Rice (RM10)</option>
                <option value="Nasi Lemak|8.5">Nasi Lemak (RM8.5)</option>
                <option value="Spaghetti|12">Spaghetti (RM12)</option>
            </select>

            <label>Quantity:</label>
            <input type="number" id="menuQuantity" name="menuQuantity" min="1" value="1" onchange="updateTotalPrice()">
        </div>

        <div class="section">
            <h3>Event Service</h3>
            <label>Venue:</label>
            <select name="venue">
                <option value="Hall A">Hall A</option>
                <option value="Hall B">Hall B</option>
            </select>

            <label>Event Type:</label>
            <select name="eventType" id="eventType" onchange="updateTotalPrice()">
                <option value="">-- Select Event --</option>
                <option value="Wedding">Wedding (RM100)</option>
                <option value="Conference">Conference (RM100)</option>
            </select>

            <label>Duration (Hours):</label>
            <input type="number" id="duration" name="duration" min="1" value="1" onchange="updateTotalPrice()">
        </div>

        <div class="total-price">
            Total Payment: <span id="displayTotalPayment">RM<%= totalRoomPrice %></span>
        </div>

        <button type="submit" class="btn">Confirm Booking</button>
    </form>
</main>

<footer>
    <p>&copy; 2025 MD Resort</p>
</footer>

</body>
</html>
