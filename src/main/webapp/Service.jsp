<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="resort.utils.DatabaseUtility"%>

<!DOCTYPE html>
<html>
<head>
<title>Service Details</title>
<link rel="stylesheet"
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css">
<style>
/* ===== STYLE ASAL DENGAN NAVIGATION ===== */
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
}

nav ul li {
    margin: 0 30px;
    font-weight: bold;
    position: relative;
}

nav ul li a {
    text-decoration: none;
    color: #5f7268;
    font-size: 16px;
    padding: 5px 10px;
}

nav ul li a:hover {
    text-decoration: underline;
}

/* Submenu Styling */
nav ul .submenu {
    display: none;
    position: absolute;
    top: 100%;
    left: 0;
    background-color: white;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    list-style: none;
    z-index: 10;
}

nav ul li:hover .submenu {
    display: block;
}

h1 {
    font-size: 18px;
    font-weight: bold;
    margin: 40px 40px 10px;
    color: #5f7268;
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
    background-color: #4b5c53;
}

table {
    width: 90%;
    margin: 10px auto;
    border-collapse: collapse;
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
    position: relative;
}

.modal-content label {
    font-size: 16px;
    font-weight: bold;
    display: block;
    margin-top: 10px;
}

.modal-content input {
    width: 100%;
    padding: 8px;
    margin: 5px 0 10px;
    border: 1px solid #ccc;
    border-radius: 5px;
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

.close {
    position: absolute;
    top: 15px;
    right: 20px;
    color: #5f7268;
    font-size: 24px;
    cursor: pointer;
}

.close:hover {
    color: #4b5c53;
}

.error-message {
    color: red;
    font-size: 13px;
    margin-top: -8px;
    margin-bottom: 10px;
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

<h1>Service Details</h1>
<button id="addServiceBtn" onclick="showModal()">+ Add Service</button>

<table>
    <thead>
        <tr>
            <th>No Service</th>
            <th>Service Type</th>
            <th>Service Charge</th>
            <th>Service Date</th>
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
            <td>
                <button class="btn btn-sm btn-secondary">Edit</button>
                <button class="btn btn-sm btn-danger">Delete</button>
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
        <form action="Service.jsp" method="post" onsubmit="return validateForm()">
            <label for="serviceType">Type Service:</label>
            <input type="text" id="serviceType" name="serviceType" required>

            <label for="serviceCharge">Service Charge:</label>
            <input type="text" id="serviceCharge" name="serviceCharge" required>
            <div id="chargeError" class="error-message"></div>

            <label for="serviceDate">Service Date:</label>
            <input type="date" id="serviceDate" name="serviceDate" required>

            <button type="submit">Add Service</button>
        </form>
    </div>
</div>

<script>
function showModal() {
    document.getElementById("addServiceModal").style.display = "block";
}

function closeModal() {
    document.getElementById("addServiceModal").style.display = "none";
    document.getElementById("chargeError").innerText = "";
}

function validateForm() {
    const charge = document.getElementById("serviceCharge").value.trim();
    const chargeError = document.getElementById("chargeError");
    chargeError.innerText = "";

    if (charge === "" || isNaN(charge)) {
        chargeError.innerText = "Service Charge must be a number.";
        return false;
    }
    return true;
}
</script>
</body>
</html>
