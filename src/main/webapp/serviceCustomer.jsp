<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
String customerName = (String) session.getAttribute("customerName");
boolean isLoggedIn = (customerName != null);
%>
<html>
<head>
    <meta charset="UTF-8">
    <title>Reserve Services</title>
    <style>
        /* Reset and basic styling */
        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            font-family: Arial, sans-serif;
            background-color: white;
            color: #728687;
        }

        /* Header Styling */
        header {
            background: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 25px;
            font-size: 18px;
            color: #728687;
            position: sticky;
            top: 0;
            z-index: 1000;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .logo {
            display: flex;
            align-items: center;
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

        nav ul {
            list-style: none;
            display: flex;
            margin: 0;
            padding: 0;
        }

        nav ul li {
            margin-left: 20px;
            position: relative;
        }

        nav ul li a {
            text-decoration: none;
            color: #728687;
            font-weight: bold;
            padding: 5px 20px;
        }

        /* Profile Dropdown */
        .profile-menu {
            position: relative;
        }

        .profile-icon {
            display: flex;
            align-items: center;
            cursor: pointer;
        }

        .profile-icon img {
            height: 30px;
            width: 30px;
            border-radius: 50%;
            margin-right: 5px;
        }

        .profile-icon span {
            color: black;
            font-weight: bold;
            margin-left: 5px;
        }

        .dropdown-menu {
            display: none;
            position: absolute;
            top: 40px;
            right: 0;
            background: #728687;
            padding: 10px 0;
            border-radius: 5px;
            width: 150px;
            text-align: left;
        }

        .dropdown-menu a {
            display: block;
            padding: 10px 20px;
            color: white;
            text-decoration: none;
        }

        .dropdown-menu a:hover {
            background-color: #04aa6d;
        }

        /* Show dropdown on hover */
        .profile-menu:hover .dropdown-menu {
            display: block;
        }

        /* Page Content */
        .container {
            width: 50%;
            margin: auto;
            padding: 20px;
            background: #f4f4f4;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-top: 40px;
        }

        h1, h2 {
            color: black;
            text-align: center;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: black;
        }

        .form-group input, .form-group select {
            width: 100%;
            padding: 8px;
            box-sizing: border-box;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        .form-group button {
            padding: 10px 20px;
            background-color: black;
            color: white;
            border: none;
            cursor: pointer;
            width: 100%;
            border-radius: 5px;
            font-size: 16px;
        }

        /* Footer Styling */
        footer {
            background: #728687;
            color: white;
            text-align: center;
            padding: 10px 0;
            margin-top: auto;
        }

        .footer-container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .footer-links {
            list-style: none;
            display: flex;
            justify-content: center;
            gap: 20px;
            padding-top: 10px;
        }

        .footer-links a {
            color: white;
            text-decoration: none;
            font-size: 14px;
        }

        .footer-links a:hover {
            color: black;
        }
    </style>
</head>
<body>
    <header>
        <div class="logo">
            <a href="index.jsp">
                <img src="images/MDResort.png" alt="Logo">
            </a>
            <a href="index.jsp">MD Resort Pantai Siring Melaka</a>
        </div>
        <nav>
            <ul>
                <li><a href="roomCustomer.jsp">Room</a></li>
                <li><a href="facilityCustomer.jsp">Facilities</a></li>
                <li><a href="serviceCustomer.jsp">Service</a></li>

                <% if (isLoggedIn) { %>
                <li class="profile-menu">
                    <div class="profile-icon">
                        <img src="images/profile-icon.png" alt="Profile">
                        <span><%= customerName %></span>
                        <div class="dropdown-menu">
                            <a href="profileCustomer.jsp">Profile</a>
                            <a href="CustomerReservationController">Booking</a>
                            <a href="LogoutController">Logout</a>
                        </div>
                    </div>
                </li>
                <% } else { %>
                <li><a href="signupCustomer.jsp">Sign Up</a></li>
                <% } %>
            </ul>
        </nav>
    </header>

    <div class="container">
        <h1>Reserve Services</h1>
        
        <!-- Room Service Form -->
        <h2>Reserve Room Service</h2>
        <form action="addService.jsp" method="post">
            <div class="form-group">
                <label for="checkInDate">Check-In Date</label>
                <input type="date" id="checkInDate" name="checkInDate" required>
            </div>
            <div class="form-group">
                <label for="checkOutDate">Check-Out Date</label>
                <input type="date" id="checkOutDate" name="checkOutDate" required>
            </div>
            
        </form>

        <!-- Event Service Form -->
        <h2>Reserve Event Service</h2>
        <form action="reserveEvent.jsp" method="post">
            <div class="form-group">
                <label for="venue">Select Venue</label>
                <select id="venue" name="venue">
                    <option value="Beachfront">Beachfront</option>
                    <option value="Garden">Garden</option>
                </select>
            </div>
            <div class="form-group">
                <button type="submit">Reserve Event</button>
            </div>
        </form>

        <!-- Food Service Form -->
        <h2>Reserve Food Service</h2>
        <form action="reserveFood.jsp" method="post">
            <div class="form-group">
                <label for="foodSet">Select Food Set</label>
                <select id="foodSet" name="foodSet">
                    <option value="SET A">SET A</option>
                    <option value="SET B">SET B</option>
                    <option value="SET C">SET C</option>
                </select>
            </div>
            <div class="form-group">
                <label for="quantity">Quantity</label>
                <input type="number" id="quantity" name="quantity" min="1" value="1" required>
            </div>
            <div class="form-group">
                <button type="submit">Reserve Food</button>
            </div>
        </form>
    </div>
</body>
</html>
