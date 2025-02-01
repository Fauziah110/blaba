<%@ page session="true"%>
<%@ page import="java.util.*"%>

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
			<a href="index.jsp"> <img src="images/MDResort.png" alt="Logo">
			</a> <a href="index.jsp">MD Resort Pantai Siring Melaka</a>
		</div>
		<nav>
			<ul>
				<li><a href="roomCustomer.jsp">Room</a></li>
				<li><a href="facilityCustomer.jsp">Facilities</a></li>
				<li><a href="serviceCustomer.jsp">Service</a></li>

				<%
				if (isLoggedIn) {
				%>
				<!-- Display the profile icon and dropdown for logged-in users -->
				<li>
					<div class="profile-icon">
						<img src="images/profile-icon.png" alt="Profile"> <span><%=customerName%></span>
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


	<img src="images/room_front.png" style="width: 100%;">

	<!-- Reservation Form -->
	<div class="reservation-form">
		<form action="CheckAvailabilityServlet" method="post">
			<input type="date" name="checkInDate" required> <input
				type="date" name="checkOutDate" required> <select
				name="adults">
				<option value="1">1 adult</option>
				<option value="2">2 adults</option>
				<option value="3">3 adults</option>
			</select> <select name="kids">
				<option value="0">0 kids</option>
				<option value="1">1 kid</option>
				<option value="2">2 kids</option>
			</select>
			<button type="submit">Check Availability</button>
		</form>
	</div>


	<main class="main-content">
		<section class="content3"
			style="background-image: url('wood-texture.jpg');">
			<h2>Family Room</h2>
			<img src="images/family-room.jpg" alt="Family Room" class="room-image">
			<div class="description">
				<p>From RM150 / night</p>
				<p>It features 1 king-sized bed, 1 day bed (which can be made up
					for sleeping), and 2 bunk beds in the annexe for children. Cots are
					available upon request, making it an ideal fit for a family of 2
					adults and 3 children (0-12 years old) or 3 adults and 2 children
					(0-12 years).</p>
				<p>Fast WiFi connection, satellite TV, and standard electric
					socket are standard throughout the Resort.</p>
			</div>
		</section>
		<section class="content3"
			style="background-image: url('wood-texture.jpg');">
			<h2>Cabin Room</h2>
			<img src="images/cabin-room.jpg" alt="Cabin Room" class="room-image">
			<p>From RM100 / night</p>
			<p>The room is furnished with 1 king-sized bed, 1 day bed (can be
				made up for sleeping), and 2 bunk beds in the annexe for children,
				with cots available upon request. Best suited for 2 adults and 3
				children (0-12 years old), this room is accessed via a long flight
				of stairs, which may make it unsuitable for guests with mobility
				issues or families with young children.</p>
			<p>Fast WiFi connection, satellite TV, and standard electric
				socket are standard throughout the Resort.</p>

		</section>

		<section class="content3"
			style="background-image: url('wood-texture.jpg');">
			<h2>Wood Room</h2>
			<img src="images/wood-room.jpg" alt="Wood Room" class="room-image">
			<p>From RM150 / night</p>
			<p>All our rooms have small windows to help you take a view of
				the beach nearby. For this wood house, we offer a room with one
				single bed, one queen bed, and a bathroom completed with a hot
				shower, which brings relaxation to you after a long day.</p>
			<p>Fast WiFi connection, satellite TV, and standard electric
				socket are standard throughout the Resort.</p>

		</section>
	</main>

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
				<li><a href="RoomCustomer.jsp">Room</a></li>
				<li><a href="MdResort_FACILITIES.jsp">Facilities</a></li>
			</ul>
		</div>
	</footer>
</body>
</html>
