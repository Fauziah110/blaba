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

	<h1>Event Service Details</h1>
	<button id="addServiceBtn" onclick="showModal()">+ Add Service</button>

	<table>
		<thead>
			<tr>
				<th>No Room</th>
				<th>No Service</th>
				<th>Venue Name</th>
				<th>Event Type</th>
				<th>Duration</th>
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
				String sql = "SELECT s.roomID, s.serviceID, es.venue, es.eventtype, es.duration " + "FROM service s "
				+ "JOIN eventservice es ON s.serviceID = es.serviceID";
				pstmt = conn.prepareStatement(sql);
				rs = pstmt.executeQuery();
				while (rs.next()) {
			%>
			<tr>
				<td><%=rs.getInt("roomID")%></td>
				<td><%=rs.getInt("serviceID")%></td>
				<td><%=rs.getString("venue")%></td>
				<td><%=rs.getString("eventtype")%></td>
				<td><%=rs.getInt("duration")%></td>
				<td class="action-buttons">
					<button class="btn btn-sm btn-secondary"
						onclick="showEditModal('<%=rs.getInt("serviceID")%>', '<%=rs.getString("venue")%>', '<%=rs.getString("eventtype")%>', '<%=rs.getInt("duration")%>')">Edit</button>
					<button class="btn btn-sm btn-danger"
						onclick="showDeleteModal('<%=rs.getInt("serviceID")%>')">Delete</button>
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


	<!-- Add EventService Modal -->
	<div id="addServiceModal" class="modal">
		<div class="modal-content">
			<span class="close" onclick="closeModal()">&times;</span>
			<h2>Add Event Service</h2>
			<form action="EventService.jsp" method="post">
				<label for="roomId">No Room:</label> <select id="roomId"
					name="roomId">
					<%
					Connection conn1 = null;
					PreparedStatement pstmt1 = null;
					ResultSet rs1 = null;
					try {
						conn = DatabaseUtility.getConnection();
						String sql = "SELECT roomID FROM room";
						pstmt = conn.prepareStatement(sql);
						rs = pstmt.executeQuery();
						while (rs.next()) {
					%>
					<option value="<%=rs.getInt("roomID")%>"><%=rs.getInt("roomID")%></option>
					<%
					}
					} catch (SQLException e) {
					e.printStackTrace();
					} finally {
					DatabaseUtility.closeResources(rs, pstmt, conn);
					}
					%>
				</select><br> <label for="serviceId">Service ID:</label> <input
					type="number" id="serviceId" name="serviceId" required> <br>
				<label for="venue">Venue:</label> <input type="text" id="venue"
					name="venue" required> <br> <label for="eventType">Event
					Type:</label> <input type="text" id="eventType" name="eventType" required>
				<br> <label for="duration">Duration:</label> <input
					type="number" id="duration" name="duration" required> <br>
				<button type="submit">Add Event Service</button>
			</form>
		</div>
	</div>

	<%
	if ("POST".equalsIgnoreCase(request.getMethod())) {
		int serviceId = Integer.parseInt(request.getParameter("serviceId"));
		String venue = request.getParameter("venue");
		String eventType = request.getParameter("eventType");
		int duration = Integer.parseInt(request.getParameter("duration"));

		Connection conn3 = null;
		PreparedStatement ps = null;

		try {
			conn3 = DatabaseUtility.getConnection();
			String sql = "INSERT INTO eventservice (serviceID, venue, eventtype, duration) VALUES (?, ?, ?, ?)";
			ps = conn3.prepareStatement(sql);
			ps.setInt(1, serviceId);
			ps.setString(2, venue);
			ps.setString(3, eventType);
			ps.setInt(4, duration);
			ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (ps != null)
		ps.close();
			if (conn3 != null)
		conn3.close();
		}
	}
	%>

	<!-- Edit Service Modal -->
	<div id="editServiceModal" class="modal">
		<div class="modal-content">
			<span class="close" onclick="closeModal()">&times;</span>
			<h2>Edit Service</h2>
			<form id="editServiceForm" action="EditEventController" method="post">
				<input type="hidden" id="editServiceID" name="serviceID"> <label
					for="editRoomId">No Room:</label> <select id="editRoomId"
					name="roomId">
					<%
					try {
						conn = DatabaseUtility.getConnection();
						String sql = "SELECT roomID FROM room";
						pstmt = conn.prepareStatement(sql);
						rs = pstmt.executeQuery();
						while (rs.next()) {
					%>
					<option value="<%=rs.getInt("roomID")%>"><%=rs.getInt("roomID")%></option>
					<%
					}
					} catch (SQLException e) {
					e.printStackTrace();
					} finally {
					DatabaseUtility.closeResources(rs, pstmt, conn);
					}
					%>
				</select><br> <label for="editServiceId">No Service</label> <select
					id="editServiceId" name="serviceId">
					<%
					try {
						conn = DatabaseUtility.getConnection();
						String sql = "SELECT serviceID FROM service";
						pstmt = conn.prepareStatement(sql);
						rs = pstmt.executeQuery();
						while (rs.next()) {
					%>
					<option value="<%=rs.getInt("serviceID")%>"><%=rs.getInt("serviceID")%></option>
					<%
					}
					} catch (SQLException e) {
					e.printStackTrace();
					} finally {
					DatabaseUtility.closeResources(rs, pstmt, conn);
					}
					%>
				</select><br> <label for="editVenue">Venue:</label> <input type="text"
					id="editVenue" name="venue" required><br> <label
					for="editEventType">Event Type:</label> <input type="text"
					id="editEventType" name="eventType" required><br> <label
					for="editDuration">Duration:</label> <input type="number"
					id="editDuration" name="duration" required><br>

				<button type="submit">Update Event Service</button>
			</form>
		</div>
	</div>

	<!-- Delete Event Service Modal -->
	<div id="deleteEventModal" class="modal">
		<div class="modal-content">
			<span class="close" onclick="closeDeleteModal()">&times;</span>
			<h2 id="modalTitle">Delete Event Service</h2>
			<form id="deleteEventForm" action="DeleteEventController"
				method="post">
				<input type="hidden" id="deleteServiceId" name="serviceID" value="">
				<label for="staffPassword">Staff Password:</label> <input
					type="password" id="staffPassword" name="staffPassword" required><br>
				<button type="submit">Delete Event Service</button>
			</form>
		</div>
	</div>



	<script>
		function showModal() {
			document.getElementById("addServiceModal").style.display = "block";
		}

		function closeModal() {
			document.getElementById("addServiceModal").style.display = "none";
			document.getElementById("editServiceModal").style.display = "none";
		}

		function showEditModal(serviceID, venue, eventType, duration) {
			document.getElementById('editServiceID').value = serviceID;
			document.getElementById('editVenue').value = venue;
			document.getElementById('editEventType').value = eventType;
			document.getElementById('editDuration').value = duration;
			document.getElementById('editServiceModal').style.display = 'block';
		}

		function showDeleteModal(serviceID) {
			console.log("showDeleteModal called with serviceID:", serviceID);
			document.getElementById("deleteServiceId").value = serviceID;
			console.log("deleteServiceId set to:", document
					.getElementById("deleteServiceId").value);
			document.getElementById("deleteEventModal").style.display = "block";
			console.log("deleteEventModal display set to block");
		}

		function closeDeleteModal() {
			document.getElementById("deleteEventModal").style.display = "none";
		}

		// Close the modal when clicking outside of it
		window.onclick = function(event) {
			if (event.target == document.getElementById('deleteEventModal')) {
				closeDeleteModal();
			}
		}
	</script>


</body>
</html>