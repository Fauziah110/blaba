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

.features-grid {
	display: grid;
	grid-template-columns: repeat(3, 1fr);
	gap: 20px;
	justify-content: center;
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

.feature:hover {
	transform: translateY(-5px);
}

.feature img {
	width: 60px;
	margin-bottom: 10px;
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

.content {
	padding: 20px;
	background-color: white;
	text-align: center;
}

.content h1 {
	margin-top: 0;
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
				<li><a href="signupCustomer.jsp">Sign Up</a></li>
				<%
				}
				%>
			</ul>
		</nav>
	</header>

	<img src="images/home_front.jpg" alt="Homepage-background">

	<div class="welcome-section">
		<h1>WELCOME TO MD RESORT</h1>
		<h3>Experience the serenity of nature and luxury combined</h3>
	</div>

	<div class="features">
		<div class="features-grid">
			<div class="feature">
				<img src="images/nature.png" alt="Nature">
				<h3>Live Amidst Nature</h3>
				<p>Feel and experience nature in its fullest glory to refresh
					yourself</p>
			</div>
			<div class="feature">
				<img src="images/adventure.png" alt="Adventure">
				<h3>Adventure and Activities</h3>
				<p>Explore the natural beauty of Pantai with our guided tours</p>
			</div>
			<div class="feature">
				<img src="images/family.png" alt="Family">
				<h3>Family Friendly</h3>
				<p>The calm and comfortable environment will make your family
					feel at home</p>
			</div>
			<div class="feature">
				<img src="images/beach-volleyball.png" alt="Beach">
				<h3>Beach Games</h3>
				<p>Whether it's beach volleyball, sandcastle building, or
					frisbee, the beach is a great place for family fun</p>
			</div>
			<div class="feature">
				<img src="images/kayaking.png" alt="Kayak">
				<h3>Water Sports</h3>
				<p>For a more adventurous experience, tourists can try kayaking
					or even jet skiing</p>
			</div>
			<div class="feature">
				<img src="images/stall.png" alt="Stall">
				<h3>Local Delights</h3>
				<p>Explore the vibrant food stalls along the beach offering a
					variety of delicious local dishes, refreshing beverages, fresh
					seafood to tropical fruit juices</p>
			</div>
		</div>
	</div>

	<div align="center">
		<h1 style="color: black;">Our Location</h1>
		<iframe
			src="https://embed.waze.com/iframe?zoom=16&lat=2.140292&lon=102.362056&pin=1"
			width="600" height="450"></iframe>
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


