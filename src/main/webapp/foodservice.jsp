<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="resort.utils.DatabaseUtility"%>
<%@ page import="java.sql.*, java.io.*"%>
<%@ page import="java.math.BigDecimal"%>


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

	<h1>Food Service Details</h1>
	<button id="addServiceBtn" onclick="showModal()">+ Add Service</button>

	<table>
		<thead>
			<tr>
				<th>No Room</th>
				<th>No Service</th>
				<th>Menu Name</th>
				<th>Price</th>
				<th>Quantity</th>
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
				String sql = "SELECT s.roomID, s.serviceID, fs.menuName, fs.menuPrice, fs.quantityMenu " + "FROM service s "
				+ "JOIN foodservice fs ON s.serviceID = fs.serviceID";
				pstmt = conn.prepareStatement(sql);
				rs = pstmt.executeQuery();
				while (rs.next()) {
			%>
			<tr>
				<td><%=rs.getInt("roomID")%></td>
				<td><%=rs.getInt("serviceID")%></td>
				<td><%=rs.getString("menuName")%></td>
				<td><%=rs.getBigDecimal("menuPrice")%></td>
				<td><%=rs.getInt("quantityMenu")%></td>
				<td class="action-buttons">
					<!-- Edit Button -->
					<button class="btn btn-sm btn-secondary"
						onclick="showEditModal('<%=rs.getInt("roomID")%>', '<%=rs.getInt("serviceID")%>', '<%=rs.getString("menuName")%>', '<%=rs.getBigDecimal("menuPrice")%>', '<%=rs.getInt("quantityMenu")%>')">
						Edit</button> <!-- Delete Button -->
					<button class="btn btn-sm btn-danger"
						onclick="showDeleteModal('<%=rs.getInt("serviceID")%>')">
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
			<h2>Add Food Service</h2>
			<form action="FoodService.jsp" method="post">
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
				</select><br> <label for="serviceId">No Service</label> <select
					id="serviceId" name="serviceId">
					<%
					Connection conn2 = null;
					PreparedStatement pstmt2 = null;
					ResultSet rs2 = null;
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
				</select><br> <label for="menuName">Menu Name</label> <select
					id="menuName" name="menuName">
					<option value="Set A">Set A - RM 18.00</option>
					<option value="Set B">Set B - RM 18.00</option>
					<option value="Set Combo">Combo - RM 30.00</option>
				</select> <br> <label for="menuPrice">Price:</label> <input type="text"
					id="menuPrice" name="menuPrice" required> <br> <label
					for="quantityMenu">Quantity:</label> <input type="text"
					id="quantityMenu" name="quantityMenu" required> <br>
				<button type="submit">Add Food Service</button>
			</form>
		</div>
	</div>

	<%
	if ("POST".equalsIgnoreCase(request.getMethod())) {
		int roomId = Integer.parseInt(request.getParameter("roomId"));
		int serviceId = Integer.parseInt(request.getParameter("serviceId"));
		String menuName = request.getParameter("menuName");
		double menuPrice = Double.parseDouble(request.getParameter("menuPrice"));

		String quantityMenuParam = request.getParameter("quantityMenu");
		int quantityMenu = 0; // Default value
		if (quantityMenuParam != null && !quantityMenuParam.isEmpty()) {
			try {
		quantityMenu = Integer.parseInt(quantityMenuParam);
			} catch (NumberFormatException e) {
		response.getWriter().println("Error: quantityMenu must be a valid number.");
		return;
			}
		} else {
			response.getWriter().println("Error: quantityMenu is required.");
			return;
		}

		Connection conn3 = null; // Declare here if not already declared earlier
		PreparedStatement ps = null; // Declare here if not already declared earlier

		try {
			conn = DatabaseUtility.getConnection();
			String sql = "INSERT INTO foodservice (serviceID, menuName, menuPrice, quantityMenu) VALUES (?, ?, ?, ?)";
			ps = conn.prepareStatement(sql);
			ps.setInt(1, serviceId);
			ps.setString(2, menuName);
			ps.setDouble(3, menuPrice);
			ps.setInt(4, quantityMenu);
			ps.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (ps != null)
		ps.close();
			if (conn != null)
		conn.close();
		}
	}
	%>

	<!-- Edit Service Modal -->
	<div id="editServiceModal" class="modal">
		<div class="modal-content">
			<span class="close" onclick="closeModal()">&times;</span>
			<h2>Edit Service</h2>
			<form id="editServiceForm" action="EditFoodController" method="post">
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
				</select><br> <label for="editMenuName">Menu Name</label> <select
					id="editMenuName" name="menuName">
					<option value="Set A">Set A - RM 18.00</option>
					<option value="Set B">Set B - RM 18.00</option>
					<option value="Set Combo">Set Combo - RM 30.00</option>
				</select><br> <label for="editMenuPrice">Price:</label> <input
					type="text" id="editMenuPrice" name="menuPrice" required><br>

				<label for="editQuantityMenu">Quantity:</label> <input type="text"
					id="editQuantityMenu" name="quantityMenu" required><br>

				<button type="submit">Update Service</button>
			</form>
		</div>
	</div>




	<!-- Delete Food Modal -->
	<div id="deleteFoodModal" class="modal">
		<div class="modal-content">
			<span class="close" onclick="closeDeleteModal()">&times;</span>
			<h2 id="modalTitle">Delete Food</h2>
			<form id="deleteFoodForm" action="DeleteFoodController" method="post">
				<input type="hidden" id="deleteServiceId" name="deleteServiceId"
					value=""> <label for="staffPassword">Staff
					Password:</label> <input type="password" id="staffPassword"
					name="staffPassword" required><br>
				<button type="submit">Delete Food</button>
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

		function showEditModal(serviceID, menuName, menuPrice, quantityMenu) {
			document.getElementById('editServiceID').value = serviceID;
			document.getElementById('editMenuName').value = menuName;
			document.getElementById('editMenuPrice').value = menuPrice;
			document.getElementById('editQuantityMenu').value = quantityMenu;
			document.getElementById('editServiceModal').style.display = 'block';
		}

		function showDeleteModal(serviceID) {
			document.getElementById("deleteServiceId").value = serviceID;
			document.getElementById("deleteFoodModal").style.display = "block";
		}
		function closeDeleteModal() {
			document.getElementById("deleteFoodModal").style.display = "none";
		}
	</script>
</body>
</html>
