<%@ page session="true" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>

<%
    if (session.getAttribute("customerID") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String customerID = (String) session.getAttribute("customerID");
    String customerName = (String) session.getAttribute("customerName");
    String customerEmail = (String) session.getAttribute("customerEmail");
    String customerPhoneNo = (String) session.getAttribute("customerPhoneNo");
    boolean isLoggedIn = (customerName != null);
%>

<% if (request.getParameter("updateSuccess") != null) { %>
    <% String message = "true".equals(request.getParameter("updateSuccess")) 
            ? "Profile updated successfully!" 
            : "Failed to update profile. Please try again."; %>
    <p style="color: <%= "true".equals(request.getParameter("updateSuccess")) ? "green" : "red" %>; font-weight: bold;">
        <%= message %>
    </p>
<% } %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>MD Resort</title>
    <style>
        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            font-family: Arial, sans-serif;
            background-color: white;
            color: #728687;
        }
        header {
            background: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 25px;
            font-size: 18px;
            color: #728687;
            position: sticky;
            top: 0;
            z-index: 1000;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .logo {
            display: flex;
            align-items: center;
        }
        .logo img {
            height: 40px;
            margin-right: 10px;
        }
        .logo a {
            font-size: 18px;
            color: #728687;
            text-decoration: none;
            font-weight: bold;
        }
        nav ul {
            list-style: none;
            display: flex;
            margin: 0;
            padding: 0;
        }
        nav ul li {
            margin-left: 20px;
            position: relative;
        }
        nav ul li a {
            text-decoration: none;
            color: #728687;
            font-weight: bold;
            padding: 5px 20px;
        }
        nav ul li a.btn {
            background: #728687;
            color: white;
            border-radius: 10px;
            padding: 13px 25px;
        }
        nav ul li a.btn:hover {
            background: #04aa6d;
            color: white;
        }
        nav ul li .dropdown-menu {
            display: none;
            position: absolute;
            top: 30px;
            left: 0;
            background: #728687;
            padding: 10px 0;
            border-radius: 5px;
        }
        nav ul li .dropdown-menu a {
            display: block;
            padding: 10px 30px;
            color: white;
            text-decoration: none;
        }
        nav ul li:hover .dropdown-menu {
            display: block;
        }
        .profile-container {
            width: 80%;
            max-width: 600px;
            margin: 20px auto;
            background: #f4f4f4;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        h2 {
            margin: 0 0 20px;
            font-size: 24px;
            color: #333;
        }
        .section {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }
        .label {
            font-weight: bold;
            color: #555;
        }
        .value {
            color: #333;
            text-align: right;
            flex: 1;
        }
        .edit {
            color: #007bff;
            text-decoration: none;
            font-size: 14px;
            margin-left: 10px;
        }
        .edit:hover {
            text-decoration: underline;
        }
        footer {
            background: #728687;
            color: white;
            text-align: center;
            padding: 10px 0;
            margin-top: auto;
        }
    </style>
</head>
<body>
    <header>
        <div class="logo">
            <a href="index.jsp"><img src="images/MDResort.png" alt="Logo"></a>
            <a href="index.jsp">MD Resort Pantai Siring Melaka</a>
        </div>
        <nav>
            <ul>
                <li><a href="roomCustomer.jsp">Room</a></li>
                <li><a href="viewFacility.jsp">Facilities</a></li>
                <li><a href="serviceCustomer.jsp">Service</a></li>
                <li><a href="LogoutController">Logout</a></li>
            </ul>
        </nav>
    </header>

    <div class="profile-container">
        <h2>Personal Details</h2>

        <!-- Name Section -->
        <div class="section">
            <span class="label">Name:</span>
            <span class="value" id="name-value"><%= customerName %></span>
            <a href="#" class="edit" onclick="enableEdit(event, 'name-form')">Edit</a>
        </div>
        <form id="name-form" class="edit-form" style="display: none;" method="post" action="ProfileController">
            <input type="text" name="customerName" value="<%= customerName %>" required />
            <button type="submit">Save</button>
        </form>

        <!-- Email Section -->
        <div class="section">
            <span class="label">Email Address:</span>
            <span class="value" id="email-value"><%= customerEmail %></span>
            <a href="#" class="edit" onclick="enableEdit(event, 'email-form')">Edit</a>
        </div>
        <form id="email-form" class="edit-form" style="display: none;" method="post" action="ProfileController">
            <input type="email" name="customerEmail" value="<%= customerEmail %>" required />
            <button type="submit">Save</button>
        </form>

        <!-- Phone Section -->
        <div class="section">
            <span class="label">Phone Number: </span>
            <span class="value" id="phone-value"><%= customerPhoneNo %></span>
            <a href="#" class="edit" onclick="enableEdit(event, 'phone-form')">Edit</a>
        </div>
        <form id="phone-form" class="edit-form" style="display: none;" method="post" action="ProfileController">
            <input type="text" name="customerPhoneNo" value="<%= customerPhoneNo %>" required />
            <button type="submit">Save</button>
        </form>
    </div>

    <footer>
        <p>&copy; 2025 MD Resort. All rights reserved.</p>
    </footer>

    <script>
        function enableEdit(event, formId) {
            event.preventDefault();
            const valueSection = event.target.closest('.section').querySelector('.value');
            valueSection.style.display = 'none';
            const formSection = document.getElementById(formId);
            formSection.style.display = 'block';
        }

        // Validate phone number: digits only, max 10
        document.querySelectorAll("form input[name='customerPhoneNo']").forEach(input => {
            input.addEventListener("input", function () {
                this.value = this.value.replace(/\D/g, ""); // Remove non-digit characters
                if (this.value.length > 10) {
                    this.value = this.value.slice(0, 10); // Limit to 10 digits
                }
            });
        });
    </script>
</body>
</html>
