<%@ page session="true" %>
<%@ page import="java.util.*" %>

<%
    String customerName = (String) session.getAttribute("customerName");
    boolean isLoggedIn = (customerName != null);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MD Resort - Room</title>
    <style>
        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            font-family: Arial, sans-serif;
            background-color: white;
            color: #728687;
        }
        header {
            background: white; /* Maintain a clean background */
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 25px;
            font-size: 18px;
            color: #728687;
            position: sticky; /* Makes the header stick to the top */
            top: 0; /* Stick to the very top of the viewport */
            z-index: 1000; /* Ensures it stays above other elements */
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); /* Adds a subtle shadow underneath */
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
            color: #728687; /* Updated color for "MD Resort" text */
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
            color: #728687; /* Updated color for navigation links */
            font-weight: bold;
            padding: 5px 20px;
        }
        nav ul li a.btn {
            background: #728687;
            color: white;
            border-radius: 10px;
            padding: 13px 25px;
        }
        nav ul li a.btn:hover {
            background: #04aa6d;
            color: white;
        }
        nav ul li .dropdown-menu {
            display: none;
            position: absolute;
            top: 30px;
            left: 0;
            background: #728687;
            padding: 10px 0;
            border-radius: 5px;
        }
        nav ul li .dropdown-menu a {
            display: block;
            padding: 10px 30px;
            color: white;
            text-decoration: none;
        }
        nav ul li .dropdown-menu a:hover {
            color: black;
        }
        nav ul li:hover .dropdown-menu {
            display: block;
        }

        header nav ul li a:hover {
            color: black;
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
            color: black; /* Ensures the user's last name is black */
            font-weight: bold; /* Optional: Adds emphasis */
            margin-left: 5px; /* Adds spacing between the icon and name */
        }
        .welcome-section {
            text-align: center;
            padding: 50px 20px;
        }
        .welcome-section h1 {
            font-size: 50px;
            color: black;
        }
        .welcome-section p {
            font-size: 18px;
            color: black;
            max-width: 800px;
            margin: 20px auto;
            line-height: 1.6;
        }
        /* Date Picker and Guests Form */
        .reservation-form {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 20px;
            margin: 20px auto;
            max-width: 900px;
            background-color: #f4f7fa;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 15px;
        }
        .reservation-form input, .reservation-form select {
            padding: 10px;
            font-size: 16px;
            border: 1px solid #ddd;
            border-radius: 5px;
            flex: 1;
            text-align: center;
        }
        .reservation-form button {
            background-color: #007BFF;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
        }
        .reservation-form button:hover {
            background-color: #0056b3;
        }
        /* Main Content */
        .main-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            padding: 20px;
        }
        .content3 {
            background-color: #f4f4f4;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            text-align: center;
            padding: 15px;
        }
        .content3 img.room-image {
            width: 100%;
            height: 200px;
            object-fit: cover;
            border-radius: 8px;
        }
        
        .content3:hover {
            transform: translateY(-5px);
        }
        .button {
            display: inline-block;
            padding: 10px 20px;
            margin-top: 10px;
            background-color: #007BFF;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            font-weight: bold;
        }
        .button:hover {
            background-color: #0056b3;
        }
        /* Footer */
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
        .footer-logo img {
            max-width: 100px;
            margin-bottom: 5px;
        }
        .social-icons {
            margin: 10px 0;
        }
        .social-icons a {
            margin: 0 10px;
            display: inline-block;
        }
        .social-icons a img {
            width: 30px;
            height: 30px;
        }
        .social-icons a:hover {
            transform: translateY(-5px);
        }
        .footer-links {
            list-style: none;
            padding: 0;
            margin-top: 10px;
            border-top: 1px solid #8B6A50;
            display: flex;
            justify-content: center;
            gap: 20px;
            padding-top: 10px;
            border-top: 1px solid white;
        }
        .footer-links a {
            color: black;
            text-decoration: none;
            font-size: 14px;
        }
        .footer-links a:hover {
            color: white;
        }
    </style>
</head>
<body>
<header>
        <div class="logo">
<a href="MdResort_HOMEPAGE.jsp">
    <img src="MdResort_logo.png" alt="Logo">
</a>            <a href="MdResort_HOMEPAGE.jsp">MD Resort</a>
        </div>
        <nav>
            <ul>
                <li><a href="MdResort_HOMEPAGE.jsp">HOME</a></li>
                <li><a href="MdResort_ROOM.jsp">ROOM</a></li>
                <li><a href="MdResort_FACILITIES.jsp">FACILITIES</a></li>
                <li><a href="MdResort_SERVICE.jsp">SERVICES</a></li>
                <% if (isLoggedIn) { %>
                    <!-- Display the profile icon and dropdown for logged-in users -->
                    <li>
                        <div class="profile-icon">
                            <img src="profile-icon.png" alt="Profile">
                            <span><%= customerName %></span>
                            <div class="dropdown-menu">
                                <a href="MdResort_PROFILE.jsp">Profile</a>
                                <a href="BookingServlet">Booking</a>
                                <a href="LogoutCustomerServlet">Logout</a>
                            </div>
                        </div>
                    </li>
                <% } else { %>
                    <!-- Show login/signup buttons for guests -->
                    <li><a href="MdResort_LOGIN.html" class="btn">Log In</a></li>
                    <li><a href="MdResort_SIGNUP.html" class="btn">Sign Up</a></li>
                <% } %>
            </ul>
        </nav>
    </header>

<img src="service_front.png" style="width: 100%;">

<!-- Reservation Form -->


<main class="main-content">
    <div class="content3">
        <h2>Hall 1</h2>
        <img src="hall1.jpg" alt="Family Room" class="room-image">
        <p>From RM1500</p>
    </div>
    <div class="content3">
        <h2>Hall 2</h2>
        <img src="hall2.jpg" alt="Cabin Room" class="room-image">
        <p>From RM500</p>
    </div>
    <div class="content3">
        <h2>Court</h2>
        <img src="court.jpg" alt="Wood Room" class="room-image">
        <p>From RM250</p>
    </div>
</main>

<footer>
	    <div class="footer-container">
	        <div class="footer-logo">
	            <a href="MdResort_HOMEPAGE.jsp">
	    <img src="MdResort_logo.png" alt="Logo">
	</a>
	</div>
        <div class="social-icons">
            <a href="https://facebook.com"><img src="facebook_icon.png" alt="Facebook"></a>
            <a href="https://instagram.com"><img src="insta_icon.png" alt="Instagram"></a>
            <a href="https://whatsapp.com"><img src="whatsapp_icon.png" alt="WhatsApp"></a>
        </div>
        <ul class="footer-links">
            <li><a href="MdResort_HOMEPAGE.jsp">Home</a></li>
            <li><a href="MdResort_ROOM.jsp">Room</a></li>
            <li><a href="MdResort_FACILITIES.jsp">Facilities</a></li>
                <li><a href="MdResort_SERVICE.jsp">Services</a></li>
        </ul>
    </div>
</footer>
</body>
</html>
