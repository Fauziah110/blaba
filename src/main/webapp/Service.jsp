<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
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
			src="images/MDResort.png" alt="Resort Logo" class="logo-image">
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

	<h1>Service Details</h1>
	<button id="addServiceBtn" onclick="showModal()">+ Add Service</button>

	<table>
		<thead>
			<tr>
				<th>No Service</th>
				<th>Service Type</th>
				<th>Service Charge</th>
				<th>Service Date</th>
				<!-- Add Service Date column -->
				<th>Actions</th>
			</tr>
		</thead>
		<tbody>
			<%
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				conn = DatabaseUtility.getConnection();
				String sql = "SELECT * FROM service";
				pstmt = conn.prepareStatement(sql);
				rs = pstmt.executeQuery();
				while (rs.next()) {
			%>
			<tr>
				<td><%=rs.getInt("SERVICEID")%></td>
				<td><%=rs.getString("SERVICETYPE")%></td>
				<td><%=rs.getBigDecimal("SERVICECHARGE")%></td>
				<td><%=rs.getDate("SERVICEDATE")%></td>
				<!-- Display Service Date -->
				<td class="action-buttons">
					<!-- Edit Button -->
					<button class="btn btn-sm btn-secondary"
						onclick="showEditModal('<%=rs.getInt("SERVICEID")%>', 
                                           '<%=rs.getString("SERVICETYPE")%>', 
                                           '<%=rs.getBigDecimal("SERVICECHARGE")%>', 
                                           '<%=rs.getDate("SERVICEDATE")%>')">
						Edit</button> <!-- Delete Button -->
					<button class="btn btn-sm btn-danger"
						onclick="showDeleteModal('<%=rs.getInt("SERVICEID")%>')">
						Delete</button>
				</td>
			</tr>

			<%
			}
			} catch (Exception e) {
			e.printStackTrace();
			} finally {
			DatabaseUtility.closeResources(rs, pstmt, conn);
			}
			%>
		</tbody>
	</table>

	<!-- Add Service Modal -->
	<div id="addServiceModal" class="modal">
		<div class="modal-content">
			<span class="close" onclick="closeModal()">&times;</span>
			<h2>Add Service</h2>
			<form action="Service.jsp" method="post">
				<label for="serviceType">Type Service:</label> <input type="text"
					id="serviceType" name="serviceType" required><br> <label
					for="serviceCharge">Service Charge:</label> <input type="text"
					id="serviceCharge" name="serviceCharge" required><br>
				<label for="serviceDate">Service Date:</label> <input type="date"
					id="serviceDate" name="serviceDate" required><br>

				<button type="submit">Add Service</button>
			</form>



		</div>
	</div>
	<%
	if ("POST".equalsIgnoreCase(request.getMethod())) {
		// Get form data
		String serviceType = request.getParameter("serviceType");
		double serviceCharge = Double.parseDouble(request.getParameter("serviceCharge"));
		String serviceDate = request.getParameter("serviceDate"); // Get service date

		Connection conn2 = null;
		PreparedStatement ps2 = null;
		try {
			// Database connection
			conn2 = DatabaseUtility.getConnection();
			conn2.setAutoCommit(false); // Disable auto-commit for transaction control

			// SQL query (without serviceid)
			String insertServiceSql = "INSERT INTO service (servicetype, servicecharge, servicedate) VALUES (?, ?, ?)";
			ps2 = conn2.prepareStatement(insertServiceSql);

			// Set the values for the prepared statement
			ps2.setString(1, serviceType); // Set serviceType
			ps2.setDouble(2, serviceCharge); // Set serviceCharge
			ps2.setString(3, serviceDate); // Set serviceDate

			// Execute the insert statement
			ps2.executeUpdate();

			// Commit the transaction
			conn2.commit();

		} catch (Exception e) {
			e.printStackTrace();
			try {
		if (conn2 != null) {
			conn2.rollback(); // Rollback if any exception occurs
		}
			} catch (SQLException se) {
		se.printStackTrace();
			}
		} finally {
			try {
		if (ps2 != null) {
			ps2.close();
		}
		if (conn2 != null) {
			conn2.close();
		}
			} catch (SQLException se) {
		se.printStackTrace();
			}
		}
	}
	%>



	<!-- Edit Service Modal -->
	<div id="editServiceModal" class="modal">
		<div class="modal-content">
			<span class="close" onclick="closeModal()">&times;</span>
			<h2>Edit Service</h2>
			<form action="EditServiceController" method="post">
				<input type="hidden" id="serviceId" name="serviceId">
				<!-- Hidden field for service ID -->
				<label for="serviceType">Type Service:</label> <input type="text"
					id="serviceType" name="serviceType" required><br> <label
					for="serviceCharge">Service Charge:</label> <input type="text"
					id="serviceCharge" name="serviceCharge" required><br>
				<label for="serviceDate">Service Date:</label> <input type="date"
					id="serviceDate" name="serviceDate" required><br>

				<button type="submit">Save Service</button>
			</form>
		</div>
	</div>

	<!-- Delete Service Modal -->
	<div id="deleteServiceModal" class="modal">
		<div class="modal-content">
			<span class="close" onclick="closeDeleteModal()">&times;</span>
			<h2 id="modalTitle">Delete Service</h2>
			<form id="deleteServiceForm" action="DeleteServiceController"
				method="post">
				<input type="hidden" id="deleteServiceId" name="deleteServiceId"
					value=""> <label for="staffPassword">Staff
					Password:</label> <input type="password" id="staffPassword"
					name="staffPassword" required><br>
				<button type="submit">Delete Service</button>
			</form>
		</div>
	</div>
	<script>
		function showModal() {
			document.getElementById("addServiceModal").style.display = "block";
		}
		function closeModal() {
			document.getElementById("addServiceModal").style.display = "none";
		}
		function showEditModal(serviceId, serviceType, serviceCharge) {
			console.log(serviceId, serviceType, serviceCharge);

			// Populate the modal fields
			document.getElementById('serviceId').value = serviceId;
			document.getElementById('serviceType').value = serviceType;
			document.getElementById('serviceCharge').value = serviceCharge;
			document.getElementById('serviceDate').value = serviceDate;

			// Show the modal using the correct ID
			document.getElementById('editServiceModal').style.display = 'block';
		}
		function showDeleteModal(serviceId) {
			document.getElementById("deleteServiceModal").style.display = "block";
			document.getElementById("deleteServiceId").value = serviceId;
		}
		function closeDeleteModal() {
			document.getElementById("deleteServiceModal").style.display = "none";
		}
		// Close modal function
		function closeModal() {
			document.getElementById('editServiceModal').style.display = 'none';
		}
	</script>
</body>
</html>