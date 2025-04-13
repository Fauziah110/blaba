<%@ page session="true" %>
<%@ page import="java.util.*" %>

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

<% if (request.getParameter("updateSuccess") != null) { %>
    <% String message = "true".equals(request.getParameter("updateSuccess")) 
            ? "Profile updated successfully!" 
            : "Failed to update profile. Please try again."; %>
    <p style="color: <%= "true".equals(request.getParameter("updateSuccess")) ? "green" : "red" %>; font-weight: bold;">
        <%= message %>
    </p>
<% } %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MD Resort</title>
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
        .profile-container {
            width: 80%; /* Make it take 80% of the parent container */
            max-width: 600px; /* Prevent it from exceeding 600px */
            margin: 20px auto;
            background: #f4f4f4;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        h2 {
            margin: 0 0 20px;
            font-size: 24px;
            color: #333;
        }

        .section {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }

        .section:last-child {
            border-bottom: none;
        }

        .label {
            font-weight: bold;
            color: #555;
        }

        .value {
            color: #333;
            text-align: right; /* Align text to the right */
            flex: 1; /* Allow the value to occupy available space */
        }

        .edit {
            color: #007bff;
            text-decoration: none;
            font-size: 14px;
            margin-left: 10px;
        }

        .edit:hover {
            text-decoration: underline;
        }

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
        .social-icons a:hover {
            transform: translateY(-5px);
        }
        .social-icons a {
            margin: 0 10px;
            display: inline-block;
        }
        .social-icons a img {
            width: 30px;
            height: 30px;
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
        
        
        /* Dropdown Styles */
			.dropdown {
			    position: relative;
			}
			
			.dropdown-content {
			    display: none;
			    position: absolute;
			    background-color: #ffffff;
			    min-width: 160px;
			    box-shadow: 0px 8px 16px rgba(0,0,0,0.2);
			    z-index: 1;
			}
			
			.dropdown-content li {
			    list-style: none;
			}
			
			.dropdown-content li a {
			    display: block;
			    color: #333;
			    padding: 12px 16px;
			    text-decoration: none;
			}
			
			.dropdown-content li a:hover {
			    background-color: #f1f1f1;
			}
			
			/* Show dropdown on hover */
			.dropdown:hover .dropdown-content {
			    display: block;
			}
			        
    </style>
</head>
<body>
    <header>
		<div class="logo">
			<a href="index.jsp"> <img src="images/MDResort.png" alt="Logo">
			</a> <a href="index.jsp">MD Resort Pantai Siring Melaka</a>
		</div>
		<nav>
		    <ul>
		        <li><a href="roomCustomer.jsp">Room</a></li>
		        <li><a href="viewFacility.jsp">Facilities</a></li>
		
		        <!-- Dropdown for Service -->
		        <li class="dropdown">
		            <a href="#">Service</a>
		            <ul class="dropdown-content">
		                <li><a href="serviceCustomer.jsp">View Service</a></li>
		                <li><a href="bookService.jsp">Book Service</a></li>
		            </ul>
		        </li>
		
		        <%
		        if (isLoggedIn) {
		        %>
		        <!-- Display the profile icon and dropdown for logged-in users -->
		        <li>
		            <div class="profile-icon">
		                <img src="images/profile-icon.png" alt="Profile">
		                <span><%=customerName%></span>
		                <div class="dropdown-menu">
		                    <a href="profileCustomer.jsp">Profile</a>
		                    <a href="CustomerReservationController">Booking</a>
		                    <a href="LogoutController">Logout</a>
		                </div>
		            </div>
		        </li>
		        <%
		        } else {
		        %>
		        <!-- Show login/signup buttons for guests -->
		        <li><a href="signupCustomer.jsp">Sign Up</a></li>
		        <%
		        }
		        %>
		    </ul>
		</nav>

	</header>
    
    <img src="images/profile_front.png" alt="profile-background">
   
   <div class="profile-container">
        <h2>Personal Details</h2>

       <!-- Name Section -->
		<div class="section">
		    <span class="label">Name:</span>
		    <span class="value" id="name-value"><%= customerName %></span>
		    <a href="#" class="edit" onclick="enableEdit(event, 'name-form')">Edit</a>
		</div>
		<form id="name-form" class="edit-form" style="display: none;" method="post" action="ProfileController">
		    <input type="text" name="customerName" value="<%= customerName %>" required />
		    <button type="submit">Save</button>
		</form>


        <!-- Email Section -->
        <div class="section">
            <span class="label">Email Address:</span>
            <span class="value" id="email-value"><%= customerEmail %></span>
            <a href="#" class="edit" onclick="enableEdit(event, 'email-form')">Edit</a>
        </div>
        <form id="email-form" class="edit-form" style="display: none;" method="post" action="ProfileController">
            <input type="email" name="customerEmail" value="<%= customerEmail %>" required />
            <button type="submit">Save</button>
        </form>

        <!-- Phone Section -->
        <div class="section">
            <span class="label">Phone Number:</span>
            <span class="value" id="phone-value"><%= customerPhoneNo %></span>
            <a href="#" class="edit" onclick="enableEdit(event, 'phone-form')">Edit</a>
        </div>
        <form id="phone-form" class="edit-form" style="display: none;" method="post" action="ProfileController">
            <input type="text" name="customerPhoneNo" value="<%= customerPhoneNo %>" required />
            <button type="submit">Save</button>
        </form>
    </div>
<footer>
    <div class="footer-container">
      <div class="footer-logo">
        <img src="images/MDResort.png" alt="Logo">
      </div>
      <div class="social-icons">
        <a href="https://facebook.com"><img src="images/facebook_icon.png" alt="Facebook"></a>
        <a href="https://instagram.com"><img src="images/insta_icon.png" alt="Instagram"></a>
        <a href="https://whatsapp.com"><img src="images/whatsapp_icon.png" alt="WhatsApp"></a>
      </div>
      <ul class="footer-links">
        <li><a href="index.jsp">Home</a></li>
        <li><a href="roomCustomer.jsp">Room</a></li>
        <li><a href="facilityCustomer.jsp">Facilities</a></li>
      </ul>
    </div>
  </footer>
    
<script>
        function enableEdit(event, formId) {
            event.preventDefault();

            // Hide the current display section
            const valueSection = event.target.closest('.section').querySelector('.value');
            valueSection.style.display = 'none';

            // Show the edit form
            const formSection = document.getElementById(formId);
            formSection.style.display = 'block';
        }
    </script>

</body>
</html>
