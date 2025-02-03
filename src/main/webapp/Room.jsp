<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="resort.connection.ConnectionManager"%>
<%@ page import="java.sql.*, java.io.*"%>

<!DOCTYPE html>
<html>
<head>
<title>Room Details</title>
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
<script>
	function showModal() {
		document.getElementById("addRoomModal").style.display = "block";
	}
	function closeModal() {
		document.getElementById("addRoomModal").style.display = "none";
	}
	function showEditModal(roomId, roomType, roomStatus, roomPrice,
			staffInCharge) {
		document.getElementById("editRoomModal").style.display = "block";
		document.getElementById("roomId").value = roomId;
		document.getElementById("roomType").value = roomType;
		document.getElementById("roomStatus").value = roomStatus;
		document.getElementById("roomPrice").value = roomPrice;
		document.getElementById("staffInCharge").value = staffInCharge;
		document.getElementById("isEdit").value = "true";
		document.getElementById("originalRoomId").value = roomId;
	}
	function closeEditModal() {
		document.getElementById("editRoomModal").style.display = "none";
	}
	function showDeleteModal(roomId) {
		document.getElementById("deleteRoomModal").style.display = "block";
		document.getElementById("deleteRoomId").value = roomId;
	}
	function closeDeleteModal() {
		document.getElementById("deleteRoomModal").style.display = "none";
	}
</script>
</head>
<body>
	<nav>
		<a href="dashboard.jsp" class="logo-link"> <img
			src="Images/MDResort.PNG" alt="Resort Logo" class="logo-image">
			<span class="logo-text">MD Resort Pantai Siring Melaka</span>
		</a>
		<div class="spacer"></div>
		<ul>
			<li><a href="booking.jsp">Booking</a></li>
			<li><a href="Room.jsp">Room</a></li>
			<li><a href="service.jsp">Service</a>
				<ul class="submenu">
					<li><a href="foodService.jsp">Food Service</a></li>
					<li><a href="eventService.jsp">Event Service</a></li>
				</ul></li>
			<li><a href="profile.jsp">Profile</a></li>
		</ul>

	</nav>

	<h1>Room Details</h1>
	<button id="addRoomBtn" onclick="showModal()">+ Add Room</button>

	<table>
		<thead>
			<tr>
				<th>No Room</th>
				<th>Type</th>
				<th>Status</th>
				<th>Price</th>
				<th>Staff In Charge</th>
				<th>Action</th>
			</tr>
		</thead>
		<tbody>
			<%
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				conn = ConnectionManager.getConnection();
				String sql = "SELECT R.ROOMID, R.ROOMTYPE, R.ROOMSTATUS, R.ROOMPRICE, S.STAFFNAME "
				+ "FROM ROOM R JOIN STAFF S ON R.STAFFID = S.STAFFID";

				pstmt = conn.prepareStatement(sql);
				rs = pstmt.executeQuery();
				int count = 1;
				while (rs.next()) {
			%>
			<tr>
				<td><%=rs.getInt("ROOMID")%></td>
				<td><%=rs.getString("ROOMTYPE")%></td>
				<td><%=rs.getString("ROOMSTATUS")%></td>
				<td><%=rs.getBigDecimal("ROOMPRICE")%></td>
				<td><%=rs.getString("STAFFNAME")%></td>
				<!-- Example button in the table row to trigger the delete modal -->
				<td class="action-buttons">
					<!-- Edit Button -->
					<button id="editRoomBtn" class="btn btn-sm btn-secondary"
						onclick="showEditModal('<%=rs.getInt("ROOMID")%>', '<%=rs.getString("ROOMTYPE")%>', '<%=rs.getString("ROOMSTATUS")%>', '<%=rs.getBigDecimal("ROOMPRICE")%>', '<%=rs.getString("STAFFNAME")%>')">Edit</button>
					<!-- Delete Button -->
					<button class="btn btn-sm btn-danger"
						onclick="showDeleteModal('<%=rs.getInt("ROOMID")%>')">Delete</button>
				</td>

			</tr>
			<%
			}
			} catch (Exception e) {
			e.printStackTrace();
			} finally {
			ConnectionManager.closeResources(rs, pstmt, conn);
			}
			%>
		</tbody>

		<!-- Add Room Modal -->
		<div id="addRoomModal" class="modal">
			<div class="modal-content">
				<span class="close" onclick="closeModal()">&times;</span>
				<h2>Add Room</h2>
				<form action="Room.jsp" method="post">
					<label for="roomType">Type Room:</label> <select id="roomType"
						name="roomType">
						<option value="Family">Family</option>
						<option value="Cabin">Cabin</option>
						<option value="Wood">Wood</option>
					</select><br> <label for="roomStatus">Room Status:</label> <select
						id="roomStatus" name="roomStatus">
						<option value="Available">Available</option>
						<option value="Occupied">Occupied</option>
						<option value="Reserved">Reserved</option>
						<option value="Under Maintenance">Under Maintenance</option>
						<option value="Out of Service">Out of Service</option>
					</select><br> <label for="roomPrice">Room Price:</label> <input
						type="text" id="roomPrice" name="roomPrice" required><br>
					<label for="staffInCharge">Staff In Charge:</label> <select
						id="staffInCharge" name="staffInCharge">
						<%
						// Use existing conn, pstmt, rs variables
						conn = ConnectionManager.getConnection();
						String sql2 = "SELECT staffid, staffname FROM staff";
						pstmt = conn.prepareStatement(sql2);
						rs = pstmt.executeQuery();
						while (rs.next()) {
						%>
						<option value="<%=rs.getInt("staffid")%>"><%=rs.getString("staffname")%></option>
						<%
						}
						ConnectionManager.closeResources(rs, pstmt, conn);
						%>
					</select><br>
					<button type="submit">Add Room</button>
				</form>
			</div>
		</div>

		<%
		if ("POST".equalsIgnoreCase(request.getMethod())) {
			// Get form data
			String roomType = request.getParameter("roomType");
			String roomStatus = request.getParameter("roomStatus");
			double roomPrice = Double.parseDouble(request.getParameter("roomPrice"));
			int staffInCharge = Integer.parseInt(request.getParameter("staffInCharge"));

			Connection conn2 = null;
			PreparedStatement ps2 = null;
			try {
				conn2 = ConnectionManager.getConnection();
				conn2.setAutoCommit(false); // Disable auto-commit for transaction control

				// Insert SQL query (excluding roomId)
				String insertRoomSql = "INSERT INTO room (roomtype, roomstatus, roomprice, staffid) VALUES (?, ?, ?, ?)";
				ps2 = conn2.prepareStatement(insertRoomSql);
				ps2.setString(1, roomType);
				ps2.setString(2, roomStatus);
				ps2.setDouble(3, roomPrice);
				ps2.setInt(4, staffInCharge);

				// Execute insert and commit
				int rowsAffected = ps2.executeUpdate();
				if (rowsAffected > 0) {
			conn2.commit(); // Commit the transaction if insertion was successful
			response.sendRedirect("Room.jsp"); // Redirect to refresh page
				} else {
			out.println("Failed to add room.");
			conn2.rollback(); // Rollback the transaction in case of failure
				}
			} catch (SQLException e) {
				e.printStackTrace();
				out.println("Error: " + e.getMessage());
				try {
			if (conn2 != null) {
				conn2.rollback(); // Rollback in case of error
			}
				} catch (SQLException se) {
			se.printStackTrace();
				}
			} finally {
				ConnectionManager.closeResources(null, ps2, conn2); // Close resources
			}
		}
		%>

		<!-- Edit Room Modal -->
		<div id="editRoomModal" class="modal">
			<div class="modal-content">
				<span class="close" onclick="closeEditModal()">&times;</span>
				<h2 id="modalTitle">Edit Room</h2>
				<form action="EditRoomController" method="post">
					<!-- Hidden fields to determine action type -->
					<input type="hidden" id="isEdit" name="isEdit" value="false">
					<input type="hidden" id="originalRoomId" name="originalRoomId"
						value="">

					<!-- Room fields -->
					<label for="roomId">No Room:</label> <input type="text" id="roomId"
						name="roomId" readonly><br> <label for="roomType">Room
						Type:</label> <select id="roomType" name="roomType">
						<option value="Family">Family</option>
						<option value="Cabin">Cabin</option>
						<option value="Wood">Wood</option>
					</select><br> <label for="roomStatus">Room Status:</label> <select
						id="roomStatus" name="roomStatus">
						<option value="Available">Available</option>
						<option value="Occupied">Occupied</option>
						<option value="Reserved">Reserved</option>
						<option value="Under Maintenance">Under Maintenance</option>
						<option value="Out of Service">Out of Service</option>
					</select><br> <label for="roomPrice">Room Price:</label> <input
						type="text" id="roomPrice" name="roomPrice" required><br>

					<label for="staffInCharge">Staff In Charge:</label> <select
						id="staffInCharge" name="staffInCharge">
						<%
						Connection conn3 = null;
						PreparedStatement pstmt3 = null;
						ResultSet rs3 = null;
						try {
							conn3 = ConnectionManager.getConnection();
							String staffQuery = "SELECT staffid, staffname FROM staff";
							pstmt3 = conn3.prepareStatement(staffQuery);
							rs3 = pstmt3.executeQuery();
							while (rs3.next()) {
						%>
						<option value="<%=rs3.getInt("staffid")%>">
							<%=rs3.getString("staffname")%>
						</option>
						<%
						}
						} catch (SQLException e) {
						e.printStackTrace();
						} finally {
						ConnectionManager.closeResources(rs3, pstmt3, conn3);
						}
						%>
					</select><br>

					<!-- Submit button -->
					<button type="submit" id="modalSubmitButton">Save Room</button>
				</form>
			</div>
		</div>

		<!-- Delete Room Modal -->
		<div id="deleteRoomModal" class="modal">
			<div class="modal-content">
				<span class="close" onclick="closeDeleteModal()">&times;</span>
				<h2 id="modalTitle">Delete Room</h2>
				<form action="DeleteRoomController" method="post">
					<input type="hidden" id="deleteRoomId" name="deleteRoomId" value="">
					<label for="staffPassword">Staff Password:</label> <input
						type="password" id="staffPassword" name="staffPassword" required><br>
					<button type="submit">Delete Room</button>
				</form>
			</div>
		</div>

	</table>
</body>
</html>
