<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.HttpSession"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="resort.utils.DatabaseUtility"%>

<%
HttpSession session1 = request.getSession(false);
String staffName = (String) session.getAttribute("staffName");
String staffEmail = (String) session.getAttribute("staffEmail");
String staffPhoneNo = (String) session.getAttribute("staffPhoneNo");
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
%>


<!DOCTYPE html>
<html>
<head>
<title>Admin Profile</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css">
<style>
body {
	margin: 0;
	font-family: Arial, Helvetica, sans-serif;
}

header {
	background-color: #5f7268; /* Dark greenish color */
	color: white;
	padding: 10px;
	text-align: center;
	font-size: 18px;
}

nav {
	display: flex;
	align-items: center;
	padding: 10px 20px;
	background-color: white;
	border-bottom: 1px solid #ddd;
	width: 100%;
}

nav .logo-link {
	display: flex;
	align-items: center;
	text-decoration: none; /* Remove underline */
	color: #5f7268; /* Text color */
}

.logo-image {
	height: 55px; /* Adjust as needed */
	margin-right: 10px; /* Space between logo and text */
}

.logo-text {
	font-size: 16px;
	font-weight: bold;
	margin-right: 200px;
}

nav .spacer {
	flex: 1; /* Creates space between the logo and navigation links */
}

nav ul {
	list-style: none;
	display: flex;
	margin: 0;
	padding: 0;
	position: relative; /* Ensure submenus are positioned correctly */
}

nav ul li {
	position: relative; /* Required for submenu positioning */
	margin: 0 50px;
	font-weight: bold;
}

nav ul li a {
	text-decoration: none;
	color: #5f7268;
	font-size: 16px;
	padding: 5px 10px;
	display: inline-block; /* Ensure clickable area */
}

nav ul li a:hover {
	text-decoration: underline;
}

/* Submenu Styling */
nav ul .submenu {
	display: none;
	position: absolute;
	top: 100%; /* Position below the parent link */
	left: 0;
	background-color: white;
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
	padding: 10px 0;
	list-style: none;
	z-index: 10;
}

nav ul .submenu li {
	margin: 0;
}

nav ul .submenu li a {
	padding: 10px 20px;
	font-size: 14px;
	display: block; /* Make the entire area clickable */
	white-space: nowrap; /* Prevent wrapping of text */
}

nav ul .submenu li a:hover {
	background-color: #f2f2f2;
}

/* Show submenu on hover */
nav ul li:hover>.submenu {
	display: block;
}

h1 {
	font-size: 18px;
	font-weight: bold;
	margin: 40px 40px 10px;
	color: #5f7268;
}

table {
	width: 100%;
	max-width: 90%; /* Set a maximum width */
	border-collapse: collapse;
	margin: 1px 40px 10px;
}

th, td {
	border: 1px solid #000;
	padding: 10px;
	text-align: center;
	color: #5f7268;
}

th {
	background-color: #5f7268;
	color: white;
}

.centered-select {
	display: flex;
	justify-content: center; /* Centers the content horizontally */
}

.action-buttons a {
	margin-right: 5px;
}

.modal {
	display: none;
	position: fixed;
	z-index: 1;
	left: 0;
	top: 0;
	width: 100%;
	height: 100%;
	overflow: auto;
	background-color: rgba(0, 0, 0, 0.4);
}

.modal-content {
	width: 400px;
	margin: 50px auto;
	background-color: #f3f3f3;
	color: #5f7268;
	border-radius: 10px;
	padding: 20px;
	box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
}

.modal-content label {
	font-size: 16px;
	font-weight: bold;
	margin-bottom: 5px;
	display: inline-block;
}

.modal-content input, .modal-content select, .modal-content textarea {
	width: 100%;
	padding: 8px 10px;
	margin-bottom: 15px;
	border: 1px solid #ccc;
	border-radius: 5px;
	font-size: 14px;
}

.modal-content button {
	width: 100%;
	padding: 10px;
	background-color: #5f7268;
	color: white;
	border: none;
	border-radius: 5px;
	font-size: 16px;
	cursor: pointer;
}

.modal-content button:hover {
	background-color: #4b5c53;
}

.modal-header, .modal-footer {
	border: none;
}

.modal-header h5 {
	color: #5f7268;
}

.close {
	position: absolute;
	top: 20px;
	right: 20px;
	color: #5f7268;
	font-size: 24px;
	font-weight: bold;
	cursor: pointer;
}

.close:hover {
	color: #4b5c53; /* Slightly darker hover color */
}

#addRoomBtn, #addServiceBtn {
	background-color: #5f7268;
	color: white;
	padding: 10px 20px;
	border: none;
	cursor: pointer;
	margin: 40px;
}

#addRoomBtn:hover, #addServiceBtn:hover {
	background-color: #4b5c53;
}

#staffInCharge {
	color: #5f7268;
}

/* Profile Section */
.profile-header {
	text-align: center;
	margin: 2em 0;
}

.profile-header img {
	width: 100px;
	height: 100px;
	border-radius: 50%;
}

.profile-header h2 {
	margin: 0.5em 0;
	color: #5f7268;
}

.profile-header p {
	color: #5f7268;
}

/* User Profile & Security Sections */
.card {
	background: #fff;
	border-radius: 5px;
	padding: 1.5em;
	margin: 2em auto;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
	max-width: 800px;
}

.card h3 {
	margin-bottom: 1em;
	color: #5f7268;
	border-bottom: 1px solid #ccc;
	padding-bottom: 0.5em;
}

.card .info {
	display: flex;
	justify-content: space-between;
	margin-bottom: 1em;
	align-items: center;
}

.card .info span {
	font-weight: bold;
	color: #5f7268;
}

.card .info a {
	color: #5f7268;
	text-decoration: none;
	font-size: 0.9em;
}

.card .info a:hover {
	text-decoration: underline;
}

/* Logout Button */
.btn-logout {
	display: block;
	margin: 0 auto;
	padding: 0.8em 2em;
	background: red;
	color: white;
	border: none;
	border-radius: 5px;
	font-size: 1em;
	cursor: pointer;
}

.btn-logout:hover {
	background: darkred;
}

.success-message {
	background-color: #d4edda;
	color: #5f7268;
	padding: 10px;
	border-radius: 5px;
	margin-top: 10px;
}

.error { .success-message { background-color:#d4edda;
	color: #5f7268;
	padding: 10px;
	border-radius: 5px;
	margin-top: 10px;
}

.error-message {
	background-color: #f8d7da;
	color: #721c24;
	padding: 10px;
	border-radius: 5px;
	margin-top: 10px;
}

/* Modal Styles */
.modal {
	display: none;
	position: fixed;
	z-index: 1;
	left: 0;
	top: 0;
	width: 100%;
	height: 100%;
	overflow: auto;
	background-color: rgba(0, 0, 0, 0.4);
}

.modal-content {
	background-color: #fefefe;
	margin: 15% auto;
	padding: 20px;
	border: 1px solid #888;
	width: 80%;
	max-width: 600px;
	border-radius: 5px;
}

.close {
	color: #aaa;
	float: right;
	font-size: 28px;
	font-weight: bold;
}

.close:hover, .close:focus {
	color: black;
	text-decoration: none;
	cursor: pointer;
}

.btn-register {
	padding: 10px 20px;
	background-color: #5f7268;
	color: white;
	border: none;
	border-radius: 5px;
	cursor: pointer;
}

.btn-register:hover {
	background-color: #5f7268;
	font-weight: bold;
}
</style>
</head>
<body>
	<nav>
		<a href="Dashboard.jsp" class="logo-link"> <img
			src="images/MDResort.png" alt="Resort Logo" class="logo-image">
			<span class="logo-text">MD Resort Pantai Siring Melaka</span>
		</a>
		<div class="spacer"></div>
		<ul>
			<li><a href="Booking.jsp">Booking</a></li>
			<li><a href="roomCustomer.jsp">Room</a></li>
			<li><a href="serviceCustomer.jsp">Service</a>
				<ul class="submenu">
					<li><a href="FoodService.jsp">Food Service</a></li>
					<li><a href="EventService.jsp">Event Service</a></li>
				</ul></li>
			<li><a href="Profile.jsp">Profile</a></li>
		</ul>
	</nav>

	<!-- Profile Header -->
	<section class="profile-header">
		<img src="images/profile-icon.png" alt="Profile Logo"
			style="width: 60px; height: auto;">


	</section>

	<!-- User Profile Section -->
	<section class="card">
		<h3>Admin Profile</h3>
		<div class="info">
			<span>Username:</span> <span><%=staffName != null ? staffName : "N/A"%>
				<a href="javascript:void(0);" onclick="showEditUsernameModal()">Edit</a>
			</span>
		</div>

		<div class="info">
			<span>E-mail:</span> <span><%=staffEmail != null ? staffEmail : "N/A"%>
				<a href="javascript:void(0);" onclick="showEditEmailModal()">Edit</a>
			</span>
		</div>
		<div class="info">
			<span>Phone Number:</span> <span><%=staffPhoneNo != null ? staffPhoneNo : "N/A"%>
				<a href="javascript:void(0);" onclick="showEditPhoneModal()">Edit</a>
			</span>
		</div>
		<div class="info">
			<span>Register New Staff:</span> <a href="javascript:void(0);"
				onclick="openRegisterStaffModal()"><strong>Register
					Staff</strong></a>
		</div>

	</section>

	<!-- Security Section -->
	<section class="card">
		<h3>Security</h3>
		<div class="info">
			<span>Password:</span> <span>**** <a
				href="javascript:void(0);" onclick="showChangePasswordModal()">Change
					Password</a></span>
		</div>

		
	</section>

	<!-- Logout Button -->
	<form action="index.jsp?logout=true" method="post">
		<button type="submit" class="btn-logout">LOG OUT</button>
		<%
		if ("true".equals(request.getParameter("logout"))) {
			session.invalidate();
			response.sendRedirect("index.jsp");
		}
		%>
	</form>


	<!-- Edit Username Modal -->
	<div id="editUsernameModal" class="modal">
		<div class="modal-content">
			<span class="close" onclick="closeEditUsernameModal()">&times;</span>
			<h2>Edit Username</h2>
			<form action="EditUsernameController" method="post">
				<label for="newUsername">New Username:</label> <input type="text"
					id="newUsername" name="newUsername" required><br>
				<button type="submit">Save</button>
			</form>
		</div>
	</div>

	<script>
		function showEditUsernameModal() {
			document.getElementById("editUsernameModal").style.display = "block";
		}

		function closeEditUsernameModal() {
			document.getElementById("editUsernameModal").style.display = "none";
		}

		// Close the modal when clicking outside of it
		window.onclick = function(event) {
			if (event.target == document.getElementById("editUsernameModal")) {
				closeEditUsernameModal();
			}
		}
	</script>

	<!-- Register New Staff Modal -->
	<div id="registerStaffModal" class="modal">
		<div class="modal-content">
			<span class="close" onclick="closeModal()">&times;</span>
			<h2>Register New Staff</h2>
			<form action="RegisterStaffController" method="post">
				<label for="staffName">Name:</label> <input type="text"
					id="staffName" name="staffName" required><br> <label
					for="staffEmail">Email:</label> <input type="email" id="staffEmail"
					name="staffEmail" required><br> <label
					for="staffPhoneNo">Phone Number:</label> <input type="text"
					id="staffPhoneNo" name="staffPhoneNo" required><br> <label
					for="staffPassword">Password:</label> <input type="password"
					id="staffPassword" name="staffPassword" required><br>
				<label for="manageByAdmin">Manage by Admin:</label> <select
					id="manageByAdmin" name="manageByAdmin">
					<%
					Connection conn2 = null;
					PreparedStatement pstmt2 = null;
					ResultSet rs2 = null;
					try {
						conn = DatabaseUtility.getConnection();
						String sql2 = "SELECT staffid, staffname FROM staff";
						pstmt = conn.prepareStatement(sql2);
						rs = pstmt.executeQuery();
						while (rs.next()) {
					%>
					<option value="<%=rs.getInt("staffid")%>"><%=rs.getString("staffname")%></option>
					<%
					}
					} catch (Exception e) {
					e.printStackTrace();
					} finally {
					DatabaseUtility.closeResources(rs, pstmt, conn);
					}
					%>
				</select><br>
				<button type="submit">Register</button>
			</form>

		</div>
	</div>


	<script>
		function openRegisterStaffModal() {
			document.getElementById('registerStaffModal').style.display = 'block';
		}

		function closeModal() {
			document.getElementById('registerStaffModal').style.display = 'none';
		}

		// Close the modal when clicking outside of it
		window.onclick = function(event) {
			if (event.target == document.getElementById('registerStaffModal')) {
				closeModal();
			}
		}
	</script>

	<!-- Edit Email Modal -->
	<div id="editEmailModal" class="modal">
		<div class="modal-content">
			<span class="close" onclick="closeEditEmailModal()">&times;</span>
			<h2>Edit Email</h2>
			<form action="EditEmailController" method="post">
				<label for="newEmail">New Email:</label> <input type="email"
					id="newEmail" name="newEmail" required><br>
				<button type="submit">Save</button>
			</form>
		</div>
	</div>

	<!-- Edit Phone Number Modal -->
	<div id="editPhoneModal" class="modal">
		<div class="modal-content">
			<span class="close" onclick="closeEditPhoneModal()">&times;</span>
			<h2>Edit Phone Number</h2>
			<form action="EditPhoneController" method="post">
				<label for="newPhone">New Phone Number:</label> <input type="text"
					id="newPhone" name="newPhone" required><br>
				<button type="submit">Save</button>
			</form>
		</div>
	</div>

	<script>
		function showEditEmailModal() {
			document.getElementById("editEmailModal").style.display = "block";
		}

		function closeEditEmailModal() {
			document.getElementById("editEmailModal").style.display = "none";
		}

		function showEditPhoneModal() {
			document.getElementById("editPhoneModal").style.display = "block";
		}

		function closeEditPhoneModal() {
			document.getElementById("editPhoneModal").style.display = "none";
		}

		// Close the modal when clicking outside of it
		window.onclick = function(event) {
			if (event.target == document.getElementById("editEmailModal")) {
				closeEditEmailModal();
			}
			if (event.target == document.getElementById("editPhoneModal")) {
				closeEditPhoneModal();
			}
		}
	</script>

	<!-- Change Password Modal -->
	<div id="changePasswordModal" class="modal">
		<div class="modal-content">
			<span class="close" onclick="closeChangePasswordModal()">&times;</span>
			<h2>Change Password</h2>
			<form action="EditPasswordController" method="post">
				<label for="newPassword">New Password:</label> <input
					type="password" id="newPassword" name="newPassword" required><br>
				<button type="submit">Save</button>
			</form>
		</div>
	</div>

	<script>
		function showChangePasswordModal() {
			document.getElementById("changePasswordModal").style.display = "block";
		}

		function closeChangePasswordModal() {
			document.getElementById("changePasswordModal").style.display = "none";
		}

		// Close the modal when clicking outside of it
		window.onclick = function(event) {
			if (event.target == document.getElementById("changePasswordModal")) {
				closeChangePasswordModal();
			}
		}
	</script>

</body>
</html>
