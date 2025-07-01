<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css">
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

        function showEditModal(roomId, roomType, roomStatus, roomPrice, staffInCharge) {
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
        <a href="Dashboard.jsp" class="logo-link"> 
            <img src="images/MDResort.png" alt="Resort Logo" class="logo-image">
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
                </ul>
            </li>
            <li><a href="Profile.jsp">Profile</a></li>
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
                           + "FROM ROOM R JOIN STAFF S ON R.STAFFID = S.STAFFID WHERE R.ROOMID != 0";

                pstmt = conn.prepareStatement(sql);
                rs = pstmt.executeQuery();
                while (rs.next()) {
            %>
            <tr>
                <td><%=rs.getInt("ROOMID")%></td>
                <td><%=rs.getString("ROOMTYPE")%></td>
                <td><%=rs.getString("ROOMSTATUS")%></td>
                <td><%=rs.getBigDecimal("ROOMPRICE")%></td>
                <td><%=rs.getString("STAFFNAME")%></td>
                <td class="action-buttons">
                    <button id="editRoomBtn" class="btn btn-sm btn-secondary"
                        onclick="showEditModal('<%=rs.getInt("ROOMID")%>', '<%=rs.getString("ROOMTYPE")%>', 
                                               '<%=rs.getString("ROOMSTATUS")%>', '<%=rs.getBigDecimal("ROOMPRICE")%>', 
                                               '<%=rs.getString("STAFFNAME")%>')">Edit</button>
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
    </table>
</body>
</html>
