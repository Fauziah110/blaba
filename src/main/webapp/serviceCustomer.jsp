<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
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
                    <option value="SET A">SET A</option>
                    <option value="SET B">SET B</option>
                    <option value="SET C">SET C</option>
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
                    <option value="Beachfront">Beachfront</option>
                    <option value="Garden">Garden</option>
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
