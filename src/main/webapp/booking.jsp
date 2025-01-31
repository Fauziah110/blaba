<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="resort.utils.DatabaseUtility"%>
<%@ page import="java.sql.*, java.io.*"%>

<!DOCTYPE html>
<html>
<head>
<title>Service Details</title>
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

#addRoomBtn {
	background-color: #5f7268;
	color: white;
	padding: 10px 20px;
	border: none;
	cursor: pointer;
	margin: 40px;
}

#addRoomBtn:hover {
	background-color: #5f7268;
}

#addServiceBtn {
	background-color: #5f7268;
	color: white;
	padding: 10px 20px;
	border: none;
	cursor: pointer;
	margin: 40px;
}

#addServiceBtn:hover {
	background-color: #5f7268;
}

#staffInCharge {
	color: #5f7268;
}
</style>
<body>
	<nav>
		<a href="Dashboard.jsp" class="logo-link"> <img
			src="Images/MDResort.PNG" alt="Resort Logo" class="logo-image">
			<span class="logo-text">MD Resort Pantai Siring Melaka</span>
		</a>
		<div class="spacer"></div>
		<ul>
			<li><a href="Booking.jsp">Booking</a></li>
			<li><a href="Room.jsp">Room</a></li>
			<li><a href="Service.jsp">Service</a>
				<ul class="submenu">
					<li><a href="FoodService.jsp">Food Service</a></li>
					<li><a href="EventService.jsp">Event Service</a></li>
				</ul></li>
			<li><a href="Profile.jsp">Profile</a></li>
		</ul>

	</nav>


	<h1>Booking Details</h1>

	<table>
		<thead>
			<tr>
				<th>No.</th>
				<th>Name Customer</th>
				<th>No Room</th>
				<th>Room Price</th>
				<th>No Service</th>
				<th>Service Price</th>
				<th>Total Payment</th>
				<th>Date Check In</th>
				<th>Date Check Out</th>
			</tr>
		</thead>
		<tbody>
			<%
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				Class.forName("oracle.jdbc.driver.OracleDriver");
				conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "system");
				String sql = "SELECT c.customerName, r.roomID, r.roomPrice, s.serviceID, s.serviceCharge, "
				+ "(r.roomPrice +s.serviceCharge + fs.menuPrice * fs.quantityMenu ) AS totalPayment, " + "re.checkinDate, re.checkoutDate "
				+ "FROM reservation re " + "JOIN customer c ON re.customerId = c.customerId "
				+ "JOIN room r ON re.roomId = r.roomId "
				+ "JOIN service s ON s.serviceID = (SELECT fs.serviceID FROM foodservice fs WHERE fs.serviceID = s.serviceID)"
				+ "JOIN foodservice fs ON fs.serviceID = s.serviceID";
				pstmt = conn.prepareStatement(sql);
				rs = pstmt.executeQuery();
				int count = 1;
				while (rs.next()) {
			%>
			<tr>
				<td><%=count++%></td>
				<td><%=rs.getString("customerName")%></td>
				<td><%=rs.getInt("roomID")%></td>
				<td><%=rs.getBigDecimal("roomPrice")%></td>
				<td><%=rs.getInt("serviceID")%></td>
				<td><%=rs.getBigDecimal("serviceCharge")%></td>
				<td><%=rs.getBigDecimal("totalPayment")%></td>
				<td><%=rs.getDate("checkinDate")%></td>
				<td><%=rs.getDate("checkoutDate")%></td>
			</tr>
			<%
			}
			} catch (Exception e) {
			out.println("Error: " + e.getMessage());
			e.printStackTrace();
			} finally {
			if (rs != null)
			try {
				rs.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
			if (pstmt != null)
			try {
				pstmt.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
			if (conn != null)
			try {
				conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
			}
			%>
		</tbody>
	</table>


</body>
</html>
