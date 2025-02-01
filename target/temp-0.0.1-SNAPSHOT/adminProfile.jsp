<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Profile</title>
    <link rel="stylesheet" href="AdminProfile.css">
</head>
<body>
    <header>
        <img src="ResortLogo.png" alt="MD Resort Logo"  style=" width: 75px; height: auto;">
        <div class="logo" style="margin-left: -200px;">MD Resort Pantai Siring Melaka</div>        
        <nav>
            <a href="AdminDashboard.jsp">Dashboard</a>
            <a href="SalesReport.jsp">Sales Report</a>
            <a href="Rooms.jsp">Room</a>
            <a href="Facilities.jsp">Facilities</a>
        </nav>
        <div class="profile-icon">
            <img src="Profile.png" alt="MD Resort Logo"  style=" width: 45px; height: auto;">
        </div>
    </header>

    <!-- Success Message after Profile Update -->
    <c:if test="${param.update == 'success'}">
        <div class="success-message">
            <p>Your profile was successfully updated!</p>
        </div>
    </c:if>

    <!-- Error Handling for Empty Field or Update Failure -->
    <c:if test="${param.error != null}">
        <div class="error-message">
            <p style="color: red;">
                <c:choose>
                    <c:when test="${param.error == 'emptyField'}">Please fill in the field.</c:when>
                    <c:when test="${param.error == 'updateFailed'}">Failed to update profile. Please try again.</c:when>
                    <c:when test="${param.error == 'exception'}">An error occurred while updating your profile.</c:when>
                    <c:otherwise>Unknown error occurred.</c:otherwise>
                </c:choose>
            </p>
        </div>
    </c:if>

    <!-- Profile Header -->
    <section class="profile-header">
        <img src="Profile.png" alt="MD Resort Logo"  style=" width: 45px; height: auto;">
        <!-- Displaying staffName from session or request scope -->
        <h2>@<c:out value="${sessionScope.staffName}" default="N/A" /></h2>
        <p><c:out value="${staffEmail}" default="N/A" /></p>
    </section>

    <!-- User Profile Section -->
    <section class="card">
        <h3>Admin Profile</h3>
        <div class="info">
            <span>Username:</span>
            <span>
                <c:out value="${staffName}" default="N/A" />
                <a href="EditProfile.jsp?field=staffName">Edit</a>
            </span>
        </div>
        <div class="info">
            <span>Email Address:</span>
            <span>
                <c:out value="${staffEmail}" default="N/A" />
                <a href="EditProfile.jsp?field=staffEmail">Edit</a>
            </span>
        </div>
        <div class="info">
            <span>Phone Number:</span>
            <span>
                <c:out value="${staffPhoneNo}" default="N/A" />
                <a href="EditProfile.jsp?field=staffPhoneNo">Edit</a>
            </span>
        </div>
    </section>

    <!-- Security Section -->
    <section class="card">
        <h3>Security</h3>
        <div class="info">
            <span>Password:</span>
            <span>**** <a href="ChangePassword.jsp">Change Password</a></span>
        </div>
        <div class="info">
            <span>Delete Account:</span>
            <a href="DeleteAccount.jsp" style="color: red;">Delete Account</a>
        </div>
    </section>

    <!-- Logout Button -->
    <form action="AdminProfile.jsp?logout=true" method="post">
        <button type="submit" class="btn-logout">LOG OUT</button>
    </form>

    <%
        // Invalidate session if logout parameter is present
        String logout = request.getParameter("logout");
        if ("true".equals(logout)) {
            session.invalidate(); // Invalidate the session
            response.sendRedirect("AdminLogin.jsp"); // Redirect to Admin Register page
        }
    %>

</body>
</html>
