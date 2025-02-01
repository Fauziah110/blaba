<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Account Deleted</title>
    <style>
        /* Center the content */
        body, html {
            height: 100%;
            margin: 0;
            font-family: Arial, sans-serif;
        }
        .center-container {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100%;
            text-align: center;
            flex-direction: column;
        }
        .message {
            font-size: 18px;
            margin-bottom: 20px;
        }
        .btn-container {
            margin-top: 20px;
        }
        .btn-container a {
            padding: 10px 20px;
            text-decoration: none;
            background-color: #4CAF50;
            color: white;
            border-radius: 5px;
            font-weight: bold;
            transition: background-color 0.3s;
        }
        .btn-container a:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <div class="center-container">
        <div class="message">
            <p>Your account has been successfully deleted.</p><br>
            <p>You will be redirected to the login page shortly.</p>
        </div>
        <div class="btn-container">
            <a href="AdminLogin.jsp">Go to Login</a>
        </div>
    </div>
</body>
</html>
