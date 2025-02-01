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
            margin: 0;
            padding: 0;
            background-color: #f9f9f9;
        }
        header, footer {
            background: #003580;
            color: white;
            text-align: center;
            padding: 20px 0;
        }
        main {
            padding: 20px;
            max-width: 900px;
            margin: auto;
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }
        .form-section {
            margin-top: 20px;
        }
        .form-section label {
            display: block;
            margin: 10px 0 5px;
            font-weight: bold;
        }
        .form-section input, .form-section select {
            width: 100%;
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .buttons {
            margin-top: 20px;
            text-align: center;
        }
        .buttons button {
            padding: 10px 20px;
            background: #007BFF;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .buttons button:hover {
            background: #0056b3;
        }
        .hidden {
            display: none;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 10px;
            border: 1px solid #ddd;
        }
        th {
            background-color: #003580;
            color: white;
        }
    </style>
</head>
<body>
<header>
    <h1>Booking Summary</h1>
</header>
<main>
    <h2>Customer Details</h2>
    <p><strong>Name:</strong> <%= session.getAttribute("customer_name") %></p>
    <p><strong>Email:</strong> <%= session.getAttribute("customer_email") %></p>
    <p><strong>Phone Number:</strong> <%= session.getAttribute("customer_phoneno") %></p>

    <h2>Stay Details</h2>
    <p><strong>Check-In Date:</strong> <%= session.getAttribute("checkInDate") %></p>
    <p><strong>Check-Out Date:</strong> <%= session.getAttribute("checkOutDate") %></p>
    <p><strong>Adults:</strong> <%= session.getAttribute("adults") %></p>
    <p><strong>Kids:</strong> <%= session.getAttribute("kids") %></p>

    <!-- Rooms Booked Section -->
    <h2>Rooms Booked</h2>
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
                <th>Price Per Night</th>
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
    <% 
        } else {
    %>
    <p class="no-data">No rooms booked yet. Please add rooms to your booking.</p>
    <% 
        }
    %>

    <h2>Service Selection</h2>
    <form action="ReservationServiceServlet" method="POST" id="serviceForm">
        <div>
            <input type="checkbox" id="foodServiceCheckbox" name="serviceType" value="FoodService">
            <label for="foodServiceCheckbox">Food Service</label>
        </div>
        <div>
            <input type="checkbox" id="eventServiceCheckbox" name="serviceType" value="EventService">
            <label for="eventServiceCheckbox">Event Service</label>
        </div>

        <!-- Food Service Form -->
        <div id="foodServiceForm" class="form-section hidden">
            <h3>Food Service</h3>
            <label for="menuName">Menu Name:</label>
            <select name="menuName" id="menuName">
                <option value="Chicken Rice|10.00">Chicken Rice (RM10.00)</option>
                <option value="Nasi Lemak|8.50">Nasi Lemak (RM8.50)</option>
                <option value="Spaghetti|12.00">Spaghetti (RM12.00)</option>
            </select>
            <label for="menuPrice">Price (RM):</label>
            <input type="text" id="menuPrice" name="menuPrice" readonly>
            <label for="menuQuantity">Quantity:</label>
            <input type="number" id="menuQuantity" name="menuQuantity" min="1" value="1">
        </div>

        <!-- Event Service Form -->
        <div id="eventServiceForm" class="form-section hidden">
            <h3>Event Service</h3>
            <label for="venue">Venue:</label>
            <select name="venue" id="venue">
                <option value="Hall A">Hall A</option>
                <option value="Hall B">Hall B</option>
                <option value="Garden">Garden</option>
            </select>
            <label for="eventType">Event Type:</label>
            <select name="eventType" id="eventType">
                <option value="Wedding">Wedding</option>
                <option value="Conference">Conference</option>
                <option value="Birthday Party">Birthday Party</option>
            </select>
            <label for="duration">Duration (Hours):</label>
            <input type="number" id="duration" name="duration" min="1" value="1">
        </div>

        <div class="buttons">
            <button type="submit">Add Service</button>
        </div>
    </form>

    <!-- Book Now Button -->
    <form action="ReservationServiceServlet" method="POST">
        <input type="hidden" name="checkInDate" value="<%= session.getAttribute("checkInDate") %>">
        <input type="hidden" name="checkOutDate" value="<%= session.getAttribute("checkOutDate") %>">
        <input type="hidden" name="totalAdults" value="<%= session.getAttribute("adults") %>">
        <input type="hidden" name="totalKids" value="<%= session.getAttribute("kids") %>">
        <input type="hidden" name="totalPrice" value="<%= totalRoomPrice %>">
        <button type="submit">Book Now</button>
    </form>
</main>
<footer>
    <p>&copy; 2025 MD Resort</p>
</footer>

<script>
    const foodServiceCheckbox = document.getElementById("foodServiceCheckbox");
    const eventServiceCheckbox = document.getElementById("eventServiceCheckbox");
    const foodServiceForm = document.getElementById("foodServiceForm");
    const eventServiceForm = document.getElementById("eventServiceForm");
    const menuName = document.getElementById("menuName");
    const menuPrice = document.getElementById("menuPrice");

    // Show/Hide forms based on checkbox selection
    foodServiceCheckbox.addEventListener("change", () => {
        foodServiceForm.classList.toggle("hidden", !foodServiceCheckbox.checked);
    });

    eventServiceCheckbox.addEventListener("change", () => {
        eventServiceForm.classList.toggle("hidden", !eventServiceCheckbox.checked);
    });

    // Update menu price based on selected menu
    menuName.addEventListener("change", function() {
        const [name, price] = this.value.split("|");
        menuPrice.value = price || "";
    });
</script>
</body>
</html>
