<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
String customerName = (String) session.getAttribute("customerName");
boolean isLoggedIn = (customerName != null);
%>
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

.features {
	display: flex;
	justify-content: center;
	flex-wrap: wrap;
	gap: 30px;
	padding: 20px;
}

.feature {
	background-color: #f4f4f4;
	border-radius: 10px;
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
	padding: 20px;
	max-width: 300px;
	text-align: center;
}

.feature img {
	width: 100px;
	margin-bottom: 15px;
}

.feature h3 {
	font-size: 20px;
	color: black;
	margin-bottom: 10px;
}

.feature p {
	font-size: 16px;
	color: black;
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

/* facily css */
.facilities-container {
	text-align: center;
	padding: 20px;
	max-width: 1200px; /* Adjust as needed */
	margin: 0 auto; /* Center the container horizontally */
}

.facilities-grid {
	display: grid;
	grid-template-columns: repeat(3, 1fr);
	gap: 20px;
	justify-content: center;
	padding: 20px;
}

.facility-item {
	background-color: #f4f4f4;
	border-radius: 10px;
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
	padding: 20px;
	text-align: center;
	transition: transform 0.2s ease-in-out;
}

.facility-item img {
	width: 60px;
	margin-bottom: 10px;
}

.facility-item h3 {
	font-size: 18px;
	margin-bottom: 8px;
	color: #333;
}

.facility-item p {
	font-size: 14px;
	color: #555;
}

.facility-item:hover {
	transform: translateY(-5px);
}

.facility-card {
	display: flex;
	align-items: center;
	background-color: #f4f4f4;
	margin: 20px auto;
	padding: 15px;
	border-radius: 10px;
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
	max-width: 800px;
	overflow: hidden;
}

.facility-card img {
	width: 150px;
	height: 100px;
	object-fit: cover;
	border-radius: 8px;
	margin-right: 15px;
}

.facility-card div {
	text-align: left;
}

.facility-card h3 {
	margin: 0;
	color: #333;
}

.facility-card p {
	margin: 5px 0 0;
	font-size: 14px;
	color: #555;
}
</style>
</head>
<body>
	<!-- Top header -->
	<header>
		<div class="logo">
			<a href="index.jsp"> <img src="Images/MDResort.PNG" alt="Logo">
			</a> <a href="index.jsp">MD Resort Pantai Siring Melaka</a>
		</div>
		<nav>
			<ul>
				<li><a href="RoomCustomer.jsp">Room</a></li>
				<li><a href="FacilitiesCustomer.jsp">Facilities</a></li>
				<li><a href="ServiceCustomer.jsp">Service</a></li>

				<%
				if (isLoggedIn) {
				%>
				<!-- Display the profile icon and dropdown for logged-in users -->
				<li>
					<div class="profile-icon">
						<img src="Images/profile-icon.png" alt="Profile"> <span><%=customerName%></span>
						<div class="dropdown-menu">
							<a href="ProfileCustomer.jsp">Profile</a> <a
								href="BookingServlet">Booking</a> <a
								href="LogoutCustomerServlet">Logout</a>
						</div>
					</div>
				</li>
				<%
				} else {
				%>
				<!-- Show login/signup buttons for guests -->
				<li><a href="SignupCustomer.jsp">Sign Up</a></li>
				<%
				}
				%>
			</ul>
		</nav>
	</header>

	<img src="Images/facilities_front.png" style="width: 100%">
	<div class="facilities-container">
		<h1 style="color: black;">Our Facilities</h1>
		<div class="facilities-grid">
			<div class="facility-item">
				<img src="Images/wifi-icon.jpg" alt="Free Wi-Fi">
				<h3>Free high-speed Wi-Fi</h3>
				<p>All rooms have good high-speed Wi-Fi connectivity</p>
			</div>
			<div class="facility-item">
				<img src="Images/kitchen-icon.jpg" alt="Kitchen">
				<h3>Well-equipped kitchen</h3>
				<p>Enjoy cooking in our spacious, modern open kitchen</p>
			</div>
			<div class="facility-item">
				<img src="Images/bbq-icon.jpg" alt="BBQ">
				<h3>Outdoor BBQ area</h3>
				<p>Experience outdoor dining at our beautifully designed BBQ
					area</p>
			</div>
			<div class="facility-item">
				<img src="Images/room-icon.jpg" alt="Furnished Rooms">
				<h3>Furnished rooms</h3>
				<p>Each room is thoughtfully decorated and equipped with modern
					amenities</p>
			</div>
			<div class="facility-item">
				<img src="Images/parking-icon.jpg" alt="Parking">
				<h3>Free parking</h3>
				<p>Enjoy our urban oasis with green lawns, tree-lined paths,
					athletic</p>
			</div>
			<div class="facility-item">
				<img src="Images/security-icon.jpg" alt="Security">
				<h3>24/7 Security</h3>
				<p>We take safety seriously through our dedicated team</p>
			</div>
		</div>
		<br> <br>
		<div class="other-facilities">
			<h1 style="color: black;">Other Facilities</h1>
			<div class="facility-card">
				<img src="Images/BBQ-place.jpg" alt="BBQ Place">
				<div>
					<h3>BBQ Place</h3>
					<p>Description: Outdoor BBQ Area</p>
					<p>Experience the joy of outdoor dining at our beautifully
						designed BBQ area</p>
				</div>
			</div>
			<div class="facility-card">
				<img src="Images/open-kitchen.jpg" alt="Open Kitchen">
				<div>
					<h3>Open Kitchen</h3>
					<p>Description: Public Kitchen and Dining Area</p>
					<p>Enjoy cooking in our modern open kitchen with stunning views</p>
				</div>
			</div>
		</div>
	</div>

	<footer>
		<div class="footer-container">
			<div class="footer-logo">
				<a href="index.jsp"> <img src="Images/MdResort_logo.png"
					alt="Logo">
				</a>
			</div>
			<div class="social-icons">
				<a href="https://facebook.com"><img
					src="Images/facebook_icon.png" alt="Facebook"></a> <a
					href="https://instagram.com"><img src="Images/insta_icon.png"
					alt="Instagram"></a> <a href="https://whatsapp.com"><img
					src="Images/whatsapp_icon.png" alt="WhatsApp"></a>
			</div>
			<ul class="footer-links">
				<li><a href="index.jsp">Home</a></li>
				<li><a href="RoomCustomer.jsp">Room</a></li>
				<li><a href="FacilitiesCustomer.jsp">Facilities</a></li>
			</ul>
		</div>
	</footer>
</body>
</html>
