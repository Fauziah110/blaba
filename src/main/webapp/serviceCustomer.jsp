<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="resort.connection.ConnectionManager" %>
<%@ page import="java.sql.*, java.util.*" %>

<!DOCTYPE html>
<%
    // Assuming you already have a connection manager, use it to get the connection
    Connection connection = null;
    Statement stmt = null;
    ResultSet rs = null;

    // Lists to hold venues and food sets
    List<String> venues = new ArrayList<>();
    List<String> foodSets = new ArrayList<>();

    try {
        // Use your existing connection manager here to get the connection
        connection = ConnectionManager.getConnection();  // Replace with your connection manager method

        // Query to get the venues from the eventService table
        String queryVenues = "SELECT venue FROM dbo.EventService";  // Replace with your actual query for venues
        stmt = connection.createStatement();
        rs = stmt.executeQuery(queryVenues);

        // Fetch the venue names and add them to the list
        while (rs.next()) {
            venues.add(rs.getString("venue"));
        }

        // Query to get the food sets from the foodService table
        String queryFoodSets = "SELECT menuName FROM dbo.FoodService";  // Replace with your actual query for food sets
        rs = stmt.executeQuery(queryFoodSets);

        // Fetch the food sets and add them to the list
        while (rs.next()) {
            foodSets.add(rs.getString("menuName"));
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (connection != null) connection.close();
        } catch (SQLException se) {
            se.printStackTrace();
        }
    }

    if (session.getAttribute("customerID") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String customerID = (String) session.getAttribute("customerID");
    String customerName = (String) session.getAttribute("customerName");
    String customerEmail = (String) session.getAttribute("customerEmail");
    String customerPhoneNo = (String) session.getAttribute("customerPhoneNo");
    boolean isLoggedIn = (customerName != null);
%>
<html>
<head>
    <meta charset="UTF-8">
    <title>Reserve Services</title>
    <style>
        /* Basic Styling */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            background-color: white;
        }

        .container {
            width: 50%;
            margin: auto;
            padding: 20px;
            background: #f4f4f4;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-top: 40px;
            text-align: center;
        }

        .form-group {
            margin-bottom: 15px;
            text-align: left;
        }

        .form-group label {
            display: block;
            font-weight: bold;
        }

        .form-group input, .form-group select {
            width: 100%;
            padding: 8px;
            box-sizing: border-box;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        .form-group button {
            width: 100%;
            padding: 10px;
            background-color: black;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }

        .hidden {
            display: none;
        }
    </style>

    <script>
        function showServiceForm() {
            let serviceType = document.getElementById("serviceType").value;
            document.getElementById("foodServiceForm").classList.add("hidden");
            document.getElementById("eventServiceForm").classList.add("hidden");

            if (serviceType === "FoodService") {
                document.getElementById("foodServiceForm").classList.remove("hidden");
            } else if (serviceType === "EventService") {
                document.getElementById("eventServiceForm").classList.remove("hidden");
            }
        }

        function updateServiceCharge(serviceType) {
            if (serviceType === "FoodService") {
                let quantity = document.getElementById("foodQuantity").value;
                let menuPrice = 40.00; // Example fixed price per menu
                let totalCharge = menuPrice * quantity;
                document.getElementById("foodServiceChargeDisplay").innerHTML = "Total Charge: RM " + totalCharge.toFixed(2);
                document.getElementById("foodServiceCharge").value = totalCharge;
            } 
            else if (serviceType === "EventService") {
                let duration = document.getElementById("eventDuration").value;
                let basePrice = 100.00; // Example price per hour
                let totalCharge = basePrice * duration;
                document.getElementById("eventServiceChargeDisplay").innerHTML = "Total Charge: RM " + totalCharge.toFixed(2);
                document.getElementById("eventServiceCharge").value = totalCharge;
            }
        }

        function validateForm(serviceType) {
            if (serviceType === "FoodService") {
                updateServiceCharge('FoodService');
            } else if (serviceType === "EventService") {
                updateServiceCharge('EventService');
            }
            return true; // Ensures form submits
        }
    </script>
</head>
<body>

    <div class="container">
        <h1>Reserve Services</h1>

        <!-- Service Selection -->
        <div class="form-group">
            <label for="serviceType">Select Service Type</label>
            <select id="serviceType" name="serviceType" onchange="showServiceForm()">
                <option value="">-- Select --</option>
                <option value="FoodService">Food Service</option>
                <option value="EventService">Event Service</option>
            </select>
        </div>

        <!-- 📌 Food Service Form -->
        <form action="ServiceReservationController" method="post" id="foodServiceForm" class="hidden" onsubmit="return validateForm('FoodService')">
            <h2>Food Service</h2>
            <input type="hidden" name="serviceType" value="FoodService">
            <div class="form-group">
                <label for="menuName">Select Food Set</label>
                <select id="menuName" name="menuName" onchange="updateServiceCharge('FoodService')">
                    <option value="">-- Select Food Set --</option>
                    <% for (String foodSet : foodSets) { %>
                        <option value="<%= foodSet %>"><%= foodSet %></option>
                    <% } %>
                </select>
            </div>
            <div class="form-group">
                <label for="foodQuantity">Quantity</label>
                <input type="number" id="foodQuantity" name="quantityMenu" min="1" value="1" required onchange="updateServiceCharge('FoodService')">
            </div>
            <p id="foodServiceChargeDisplay">Total Charge: RM 0.00</p>
            <input type="hidden" id="foodServiceCharge" name="serviceCharge">
            <div class="form-group">
                <button type="submit">Reserve Food</button>
            </div>
        </form>

        <!-- 📌 Event Service Form -->
        <form action="ServiceReservationController" method="post" id="eventServiceForm" class="hidden" onsubmit="return validateForm('EventService')">
            <h2>Event Service</h2>
            <input type="hidden" name="serviceType" value="EventService">
            <div class="form-group">
                <label for="venue">Select Venue</label>
                <select id="venue" name="venue">
                    <option value="">-- Select Venue --</option>
                    <% for (String venue : venues) { %>
                        <option value="<%= venue %>"><%= venue %></option>
                    <% } %>
                </select>
            </div>
            <div class="form-group">
                <label for="eventType">Event Type</label>
                <input type="text" id="eventType" name="eventType" required>
            </div>
            <div class="form-group">
                <label for="eventDuration">Duration (Hours)</label>
                <input type="number" id="eventDuration" name="duration" min="1" value="1" required onchange="updateServiceCharge('EventService')">
            </div>
            <p id="eventServiceChargeDisplay">Total Charge: RM 0.00</p>
            <input type="hidden" id="eventServiceCharge" name="serviceCharge">
            <div class="form-group">
                <button type="submit">Reserve Event</button>
            </div>
        </form>
    </div>

</body>
</html>
