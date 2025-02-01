<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Error</title>
</head>
<body>
    <h2>Registration Failed!</h2>
    <p>There was an error processing the registration. Please try again.</p>
    <p>Error Message: <%= request.getAttribute("errorMessage") != null ? request.getAttribute("errorMessage") : "No additional information available." %></p>
    <a href="Dashboard.jsp">Go to Dashboard</a>
</body>
</html>
