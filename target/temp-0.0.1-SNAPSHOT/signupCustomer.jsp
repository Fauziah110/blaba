<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up - MD Resort</title>
    <style>
        /* General styles */
        body {
            font-family: 'Arial', sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f7fa;
        }

        /* Header */
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

        header .logo {
            display: flex;
            align-items: center;
        }

        header .logo img {
            height: 40px;
            margin-right: 10px;
        }

        header .logo a {
            font-size: 18px;
            color: #728687;
            text-decoration: none;
            font-weight: bold;
        }

        header nav ul {
            list-style: none;
            display: flex;
            margin: 0;
            padding: 0;
        }

        header nav ul li {
            margin-left: 20px;
        }

        header nav ul li a {
            text-decoration: none;
            color: #728687;
            font-weight: bold;
            padding: 5px 20px;
        }

        header nav ul li a:hover {
            color: black;
        }

        /* Sign up form styles */
        .signup-container {
            max-width: 400px;
            margin: 50px auto;
            background-color: #fff;
            padding: 30px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
        }

        .signup-container h1 {
            text-align: center;
            font-size: 24px;
            margin-bottom: 20px;
        }

        .signup-form input, .signup-btn {
            width: 100%; /* Match input and button widths */
            padding: 12px;
            margin: 10px 0;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
            box-sizing: border-box;
        }

        .signup-btn {
            background-color: #728687;
            color: white;
            border: none;
            cursor: pointer;
        }

        .signup-btn:hover {
            background-color: #728687;
        }

        .privacy-text {
            font-size: 12px;
            text-align: center;
            color: #888;
            margin-top: 10px;
        }

        .login-text {
            text-align: center;
            font-size: 14px;
            margin-top: 20px;
        }

        .login-text a {
            color: #007bff;
            text-decoration: none;
        }

        .login-text a:hover {
            text-decoration: underline;
        }

        /* Footer */
        footer {
            background: #728687;
            color: white;
            text-align: center;
            padding: 10px 0;
            margin-top: auto;
        }

        .footer-container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .footer-logo img {
            max-width: 100px;
            margin-bottom: 5px;
        }

        .social-icons {
            margin: 10px 0;
        }

        .social-icons a {
            margin: 0 10px;
            display: inline-block;
        }

        .social-icons a img {
            width: 30px;
            height: 30px;
        }

        .footer-links {
            list-style: none;
            padding: 0;
            margin-top: 10px;
            border-top: 1px solid #8B6A50;
            display: flex;
            justify-content: center;
            gap: 20px;
            padding-top: 10px;
        }

        .footer-links a {
            color: black;
            text-decoration: none;
            font-size: 14px;
        }

        .footer-links a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <!-- header -->
    <header>
        <div class="logo">
            <a href="index.jsp">
                <img src="Images/MDResort.PNG" alt="MD Resort Logo">
            </a>
            <a href="index.jsp">MD Resort Pantai Siring Melaka</a>
        </div>
        <nav>
            <ul>
                <li><a href="index.jsp">Home</a></li>
                <li><a href="RoomCustomer.jsp">Room</a></li>
                <li><a href="FacilitiesCustomer.jsp">Facilities</a></li>
            </ul>
        </nav>
    </header>

    <!-- Sign up form -->
    <div class="signup-container">
        <h1>Create Your Account</h1>
        <form action="/mdresortmanagementsystem/model/SignUpCustomerServlet" method="post" class="signup-form">
		    <input type="text" placeholder="Name" name="name" required aria-label="Customer Name">
		    <input type="email" placeholder="Email" name="email" required aria-label="Email Address">
		    <input type="password" placeholder="Password" name="password" required aria-label="Password">
		    <input type="tel" placeholder="Phone Number" name="phone" required aria-label="Phone Number" pattern="^\+?[0-9]{10,15}$" title="Please enter a valid phone number">
		    <button type="submit" class="signup-btn">Sign Up</button>
		</form>


        
        <p class="login-text">Already have an account? <a href="Login.jsp">Log In</a></p>
    </div>

    <!-- Footer -->
    <footer>
        <div class="footer-container">
            <div class="footer-logo">
                <a href="index.jsp">
    <img src="Images/MdResort_logo.png" alt="Logo">
</a>
            </div>
            <div class="social-icons">
                <a href="https://facebook.com"><img src="Images/facebook_icon.png" alt="Facebook"></a>
                <a href="https://instagram.com"><img src="Images/insta_icon.png" alt="Instagram"></a>
                <a href="https://whatsapp.com"><img src="Images/whatsapp_icon.png" alt="WhatsApp"></a>
            </div>
            <ul class="footer-links">
                <li><a href="index.jsp">Home</a></li>
                <li><a href="RoomCustomer.jsp">Room</a></li>
                <li><a href="FacilitiesCustomer.jsp">Facilities</a></li>
            </ul>
        </div>
    </footer>
</body>
</html>


