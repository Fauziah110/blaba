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

    <section class="profile-header">
        <h2>Edit Profile</h2>
    </section>

    <!-- Edit Profile Form -->
    <section class="card">
        <form action="EditProfileServlet" method="POST">
            <input type="hidden" name="staffId" value="<c:out value='${sessionScope.staffId}' />" />
            <input type="hidden" name="field" value="<c:out value='${param.field}' />" />

            <div class="info">
                <label for="newValue">Enter New Values:</label>

                <!-- Dynamic input field based on the field parameter -->
                <c:choose>
                    <c:when test="${param.field == 'staffName'}">
                        <input type="text" name="newValue" id="newValue" required 
                               value="<c:out value='${sessionScope.staffName}' />" />
                    </c:when>
                    <c:when test="${param.field == 'staffEmail'}">
                        <input type="email" name="newValue" id="newValue" required 
                               value="<c:out value='${sessionScope.staffEmail}' />" />
                    </c:when>
                    <c:when test="${param.field == 'staffPhoneNo'}">
                        <input type="tel" name="newValue" id="newValue" required 
                               value="<c:out value='${sessionScope.staffPhoneNo}' />" />
                    </c:when>
                    <c:when test="${param.field == 'staffPassword'}">
                        <input type="password" name="newValue" id="newValue" required 
                               placeholder="Enter New Password" />
                    </c:when>
                    <c:otherwise>
                        <input type="text" name="newValue" id="newValue" required 
                               placeholder="Enter New Value" />
                    </c:otherwise>
                </c:choose>
            </div>

            <button type="submit">Update</button>
        </form>
    </section>

</body>
</html>
