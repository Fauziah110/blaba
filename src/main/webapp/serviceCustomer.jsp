<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="resort.connection.ConnectionManager" %>
<%@ page import="java.sql.*, java.util.*" %>


<%
String customerName = (String) session.getAttribute("customerName");
boolean isLoggedIn = (customerName != null);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Reserve Services</title>
    <style>
        /* Basic Styling */
        body {
	    font-family: Arial, sans-serif;
	    margin: 0;
	    background-color: white;
	    display: flex;                /* Menambah flexbox pada body */
	    flex-direction: column;       /* Mengarahkan elemen-elemen dalam kolum */
	    min-height: 100vh;            /* Memastikan tinggi minimum 100vh (viewport height) */
		}

        /* Header Section Styling */
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
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
	/* Adds a subtle shadow underneath */
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

        /* Container and form styling */
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
            background-color: #728687;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }

        .hidden {
            display: none;
        }
        
        * Dropdown Styles */
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
		
		footer {
	    background: #728687;
	    color: white;
	    text-align: center;
	    padding: 10px 0;
	    margin-top: auto; /* Memastikan footer sentiasa berada di bawah */
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
                let menuPrice = 40.00;
                let totalCharge = menuPrice * quantity;
                document.getElementById("foodServiceChargeDisplay").innerHTML = "Total Charge: RM " + totalCharge.toFixed(2);
                document.getElementById("foodServiceCharge").value = totalCharge;
            } 
            else if (serviceType === "EventService") {
                let duration = document.getElementById("eventDuration").value;
                let basePrice = 100.00;
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
            return true;
        }
    </script>
</head>
<body>

    <!-- Header Section -->
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
			                <li><a href="ViewService.jsp">View Service</a></li>
			                <li><a href="serviceCustomer.jsp">Book Service</a></li>
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

    <!-- Content Section (Reserve Services Form) -->
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

        <!-- Food Service Form -->
        <form action="ServiceReservationController" method="post" id="foodServiceForm" class="hidden" onsubmit="return validateForm('FoodService')">
            <h2>Food Service</h2>
            <input type="hidden" name="serviceType" value="FoodService">
            <div class="form-group">
                <label for="menuName">Select Food Set</label>
                <select id="menuName" name="menuName" onchange="updateServiceCharge('FoodService')">
                    <option value="">-- Select Food Set --</option>
                    <% 
                        // Database query to fetch food sets (Populate the list dynamically from DB)
                        List<String> foodSets = new ArrayList<>();
                        Connection connection = null;
                        Statement stmt = null;
                        ResultSet rs = null;

                        try {
                            connection = ConnectionManager.getConnection();
                            String queryFoodSets = "SELECT menuName FROM dbo.FoodService";
                            stmt = connection.createStatement();
                            rs = stmt.executeQuery(queryFoodSets);
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
                        for (String foodSet : foodSets) {
                    %>
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

        <!-- Event Service Form -->
        <form action="ServiceReservationController" method="post" id="eventServiceForm" class="hidden" onsubmit="return validateForm('EventService')">
            <h2>Event Service</h2>
            <input type="hidden" name="serviceType" value="EventService">
            <div class="form-group">
                <label for="venue">Select Venue</label>
                <select id="venue" name="venue">
                    <option value="">-- Select Venue --</option>
                    <% 
                        // Database query to fetch venues (Populate the list dynamically from DB)
                        List<String> venues = new ArrayList<>();
                        try {
                            connection = ConnectionManager.getConnection();
                            String queryVenues = "SELECT venue FROM dbo.EventService";
                            stmt = connection.createStatement();
                            rs = stmt.executeQuery(queryVenues);
                            while (rs.next()) {
                                venues.add(rs.getString("venue"));
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
                        for (String venue : venues) {
                    %>
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
    
    <footer>
		<div class="footer-container">
			<div class="footer-logo">
				<a href="index.jsp"> <img src="images/MDResort.png"
					alt="Logo">
				</a>
			</div>
			<div class="social-icons">
				<a href="https://facebook.com"><img
					src="images/facebook_icon.png" alt="Facebook"></a> <a
					href="https://instagram.com"><img src="images/insta_icon.png"
					alt="Instagram"></a> <a href="https://whatsapp.com"><img
					src="images/whatsapp_icon.png" alt="WhatsApp"></a>
			</div>
			<ul class="footer-links">
				<li><a href="index.jsp">Home</a></li>
				<li><a href="MdResort_ROOM.jsp">Room</a></li>
				<li><a href="MdResort_FACILITIES.jsp">Facilities</a></li>
			</ul>
		</div>
	</footer>

</body>
</html>
