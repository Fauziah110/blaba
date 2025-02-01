<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="resort.utils.DatabaseUtility"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.text.SimpleDateFormat"%>

<%
int totalCustomer = 0;
int totalRoom = 0;
int totalCheckIn = 0;
int totalCheckOut = 0;
ArrayList<HashMap<String, String>> reservations = new ArrayList<>();
Map<String, Integer> monthlyBookings = new HashMap<>();

Connection con = null;
PreparedStatement psTotalCustomers = null;
PreparedStatement psTotalRooms = null;
PreparedStatement psTotalCheckIns = null;
PreparedStatement psTotalCheckOuts = null;
PreparedStatement psReservations = null;
PreparedStatement psMonthlyBookings = null;
ResultSet rsTotalCustomers = null;
ResultSet rsTotalRooms = null;
ResultSet rsTotalCheckIns = null;
ResultSet rsTotalCheckOuts = null;
ResultSet rsReservations = null;
ResultSet rsMonthlyBookings = null;

try {
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

	con = DatabaseUtility.getConnection();

	// Total customers
	psTotalCustomers = con.prepareStatement("SELECT COUNT(*) AS total_customers FROM Customer");
	rsTotalCustomers = psTotalCustomers.executeQuery();
	if (rsTotalCustomers.next()) {
		totalCustomer = rsTotalCustomers.getInt("total_customers");
	}

	// Total rooms
	psTotalRooms = con.prepareStatement("SELECT COUNT(*) AS total_rooms FROM Room");
	rsTotalRooms = psTotalRooms.executeQuery();
	if (rsTotalRooms.next()) {
		totalRoom = rsTotalRooms.getInt("total_rooms");
	}

	// Total check-ins
	psTotalCheckIns = con
	.prepareStatement("SELECT COUNT(*) AS total_checkins FROM Reservation WHERE checkinDate <= SYSDATE");
	rsTotalCheckIns = psTotalCheckIns.executeQuery();
	if (rsTotalCheckIns.next()) {
		totalCheckIn = rsTotalCheckIns.getInt("total_checkins");
	}

	// Total check-outs
	psTotalCheckOuts = con
	.prepareStatement("SELECT COUNT(*) AS total_checkouts FROM Reservation WHERE checkoutDate <= SYSDATE");
	rsTotalCheckOuts = psTotalCheckOuts.executeQuery();
	if (rsTotalCheckOuts.next()) {
		totalCheckOut = rsTotalCheckOuts.getInt("total_checkouts");
	}

	// Reservations
	psReservations = con.prepareStatement(
	"SELECT c.customerName, r.checkinDate, r.checkoutDate, r.totalAdult, r.totalKids FROM Reservation r JOIN Customer c ON r.customerID = c.customerID");
	rsReservations = psReservations.executeQuery();
	while (rsReservations.next()) {
		HashMap<String, String> reservation = new HashMap<>();
		reservation.put("customerName", rsReservations.getString("customerName"));
		reservation.put("checkinDate", sdf.format(rsReservations.getDate("checkinDate")));
		reservation.put("checkoutDate", sdf.format(rsReservations.getDate("checkoutDate")));
		reservation.put("totalAdult", rsReservations.getString("totalAdult"));
		reservation.put("totalKids", rsReservations.getString("totalKids"));
		reservations.add(reservation);
	}

	// Monthly bookings
	psMonthlyBookings = con.prepareStatement(
	"SELECT TO_CHAR(reservationDate, 'MONTH') AS month, COUNT(*) AS bookings FROM Reservation GROUP BY TO_CHAR(reservationDate, 'MONTH')");
	rsMonthlyBookings = psMonthlyBookings.executeQuery();
	while (rsMonthlyBookings.next()) {
		monthlyBookings.put(rsMonthlyBookings.getString("month"), rsMonthlyBookings.getInt("bookings"));
	}
} catch (SQLException | ClassNotFoundException e) {
	e.printStackTrace();
	out.println("<p>Error occurred while fetching data: " + e.getMessage() + "</p>");
} finally {
	DatabaseUtility.closeResources(rsTotalCustomers, psTotalCustomers, con);
	DatabaseUtility.closeResources(rsTotalRooms, psTotalRooms, null);
	DatabaseUtility.closeResources(rsTotalCheckIns, psTotalCheckIns, null);
	DatabaseUtility.closeResources(rsTotalCheckOuts, psTotalCheckOuts, null);
	DatabaseUtility.closeResources(rsReservations, psReservations, null);
	DatabaseUtility.closeResources(rsMonthlyBookings, psMonthlyBookings, null);
}
%>

<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Dashboard MD Resort</title>
<link rel="stylesheet"
    href="https://cdn.jsdelivr.net/npm/fullcalendar@5.10.2/main.min.css">
<script
    src="https://cdn.jsdelivr.net/npm/fullcalendar@5.10.2/main.min.js"></script>
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

.main-content {
    padding: 20px;
}

.stats {
    display: flex;
    justify-content: space-around;
    margin-bottom: 30px;
}

.stat-card {
    background: #f9f9f9;
    padding: 20px;
    border: 1px solid #ddd;
    text-align: center;
    width: 20%;
}

.flex-container {
    display: flex;
    justify-content: space-between;
}

#calendar, .table-container {
    width: 48%; /* Adjust as needed */
    box-sizing: border-box;
}

#calendar {
    height: auto;
}

.fc-daygrid-day-frame {
    height: auto !important;
    padding-bottom: 10px;
}

.fc-daygrid-day-number {
    margin-bottom: 10px;
}

table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
}

table, th, td {
    border: 1px solid #ddd;
    padding: 10px;
    text-align: left;
}

th {
    background: #f4f4f4;
}
</style>
</head>

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

    <div class="main-content">
        <section class="stats">
            <div class="stat-card">
                <h4>Total Customers</h4>
                <p><%=totalCustomer%></p>
            </div>
            <div class="stat-card">
                <h4>Total Rooms</h4>
                <p><%=totalRoom%></p>
            </div>
            <div class="stat-card">
                <h4>Total Check-Ins</h4>
                <p><%=totalCheckIn%></p>
            </div>
            <div class="stat-card">
                <h4>Total Check-Outs</h4>
                <p><%=totalCheckOut%></p>
            </div>
        </section>

        <section class="flex-container">
            <div id="calendar"></div>

            <div class="table-container">
                <h3>Monthly Booking</h3>
                <table>
                    <tr>
                        <th>Month</th>
                        <th>Bookings</th>
                    </tr>
                    <%
                    for (Map.Entry<String, Integer> entry : monthlyBookings.entrySet()) {
                    %>
                    <tr>
                        <td><%=entry.getKey()%></td>
                        <td><%=entry.getValue()%></td>
                    </tr>
                    <%
                    }
                    %>
                </table>
            </div>
        </section>
    </div>

    <script>
    document.addEventListener('DOMContentLoaded', function() {
        var calendarEl = document.getElementById('calendar');
        var calendar = new FullCalendar.Calendar(calendarEl, {
            initialView: 'dayGridMonth',
            events: [
                <%for (HashMap<String, String> reservation : reservations) {%>
                {
                    title: '<div><%=reservation.get("customerName")%></div><div>Adults: <%=reservation.get("totalAdult")%></div><div>Kids: <%=reservation.get("totalKids")%></div>',
                    start: '<%=reservation.get("checkinDate")%>',
                    end: '<%=reservation.get("checkoutDate")%>',
                    color: 'green'
                }<%=reservations.indexOf(reservation) < reservations.size() - 1 ? "," : ""%>
                <%}%>
            ],
            displayEventTime: false,
            eventContent: function(arg) {
                let title = arg.event.title;
                let titleElements = document.createElement('div');
                titleElements.innerHTML = title;
                return { domNodes: [titleElements] }
            }
        });
        calendar.render();
    });
    </script>

</body>
</html>
