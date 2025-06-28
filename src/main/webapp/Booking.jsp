<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="resort.connection.ConnectionManager" %>

<!DOCTYPE html>
<html>
<head>
    <title>Booking Details</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css">
    <style>
        body {
            margin: 0;
            font-family: Arial, Helvetica, sans-serif;
        }
        header {
            background-color: #5f7268;
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
            text-decoration: none;
            color: #5f7268;
        }
        .logo-image {
            height: 55px;
            margin-right: 10px;
        }
        .logo-text {
            font-size: 16px;
            font-weight: bold;
            margin-right: 200px;
        }
        nav .spacer {
            flex: 1;
        }
        nav ul {
            list-style: none;
            display: flex;
            margin: 0;
            padding: 0;
            position: relative;
        }
        nav ul li {
            position: relative;
            margin: 0 50px;
            font-weight: bold;
        }
        nav ul li a {
            text-decoration: none;
            color: #5f7268;
            font-size: 16px;
            padding: 5px 10px;
            display: inline-block;
        }
        nav ul li a:hover {
            text-decoration: underline;
        }
        nav ul .submenu {
            display: none;
            position: absolute;
            top: 100%;
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
            display: block;
            white-space: nowrap;
        }
        nav ul .submenu li a:hover {
            background-color: #f2f2f2;
        }
        nav ul li:hover > .submenu {
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
            max-width: 90%;
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
    </style>
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
                conn = ConnectionManager.getConnection();
                String sql = "SELECT c.customerName, r.roomID, r.roomPrice, s.serviceID, s.serviceCharge, " +
                        "(r.roomPrice + COALESCE(s.serviceCharge, 0) + COALESCE(fs.menuPrice * fs.quantityMenu, 0)) AS totalPayment, " +
                        "re.checkinDate, re.checkoutDate " +
                        "FROM reservation re " +
                        "JOIN customer c ON re.customerId = c.customerId " +
                        "JOIN room r ON re.roomId = r.roomId " +
                        "LEFT JOIN service s ON re.serviceID = s.serviceID " +
                        "LEFT JOIN foodservice fs ON fs.serviceID = s.serviceID;";
                pstmt = conn.prepareStatement(sql);
                rs = pstmt.executeQuery();
                int count = 1;
                while (rs.next()) {
            %>
            <tr>
                <td><%= count++ %></td>
                <td><%= rs.getString("customerName") %></td>
                <td><%= rs.getInt("roomID") %></td>
                <td><%= rs.getBigDecimal("roomPrice") %></td>
                <td>
                    <%= rs.getInt("serviceID") == 0 ? "No service booked" : rs.getInt("serviceID") %>
                </td>
                <td><%= rs.getBigDecimal("serviceCharge") != null ? rs.getBigDecimal("serviceCharge") : "No service booked" %></td>
                <td><%= rs.getBigDecimal("totalPayment") %></td>
                <td><%= rs.getDate("checkinDate") %></td>
                <td><%= rs.getDate("checkoutDate") %></td>
            </tr>
            <%
                }
            } catch (Exception e) {
                out.println("Error: " + e.getMessage());
                e.printStackTrace();
            } finally {
            	ConnectionManager.closeResources(rs, pstmt, conn);
            }
            %>
        </tbody>
    </table>
</body>
</html>
