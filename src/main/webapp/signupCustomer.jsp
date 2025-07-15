<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up - MD Resort</title>
    <style>
        /* [same CSS as before] */
        body {
            font-family: 'Arial', sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f7fa;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .container { text-align: center; }
        .signup-box {
            width: 400px;
            background: white;
            border-radius: 10px;
            padding: 40px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }
        .logo img { width: 80px; height: auto; }
        .logo h1 { font-size: 20px; margin-top: 10px; color: #5f7268; }
        .form-group { text-align: left; margin-bottom: 15px; }
        .form-group label { display: block; font-weight: bold; font-size: 14px; }
        .form-group input {
            width: 100%;
            padding: 12px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 14px;
        }
        .signup-button, .google-button {
            width: 100%;
            padding: 12px;
            margin-top: 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }
        .signup-button { background-color: #5f7268; color: white; font-weight: bold; }
        .google-button { background-color: #4285f4; color: white; font-weight: bold; }
        .separator { margin: 15px 0; font-size: 14px; color: #999; font-weight: bold; }
        .error-message { color: red; font-size: 14px; margin-bottom: 10px; }
        .account-link { margin-top: 10px; font-size: 14px; }
        .account-link a {
            color: #007bff;
            text-decoration: none;
            font-weight: bold;
        }
        .account-link a:hover { text-decoration: underline; }
        footer {
            margin-top: 20px;
            font-size: 12px;
            color: #5f7268;
        }
    </style>
    <script>
        function checkPasswordStrength(event) {
            const passwordInput = document.getElementById('password');
            const password = passwordInput.value;

            // Password strength regex: at least 8 chars, 1 uppercase, 1 lowercase, 1 number, 1 symbol
            const strongPassword = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$/;

            if (!strongPassword.test(password)) {
                // Prevent form submission
                event.preventDefault();
                alert("⚠️ Weak Password!\nYour password must:\n- Be at least 8 characters\n- Include uppercase, lowercase, number, and symbol.");
                passwordInput.focus();
                return false;
            }
            return true;
        }
    </script>
</head>
<body>
    <div class="container">
        <div class="signup-box">
            <div class="logo">
                <img src="images/MDResort.png" alt="Resort Logo">
                <h1>MD Resort Pantai Siring Melaka</h1>
            </div>

            <!-- Error Message -->
            <% String errorMessage = (String) request.getAttribute("errorMessage"); 
               if (errorMessage != null) { %>
                <div class="error-message"><%=errorMessage%></div>
            <% } %>

            <!-- Sign-Up Form -->
            <form action="SignupCustomerController" method="POST" onsubmit="return checkPasswordStrength(event);">
                <div class="form-group">
                    <label for="customer-name">Full Name</label>
                    <input type="text" id="customer-name" name="customer-name" placeholder="Enter your full name" required>
                </div>

                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" placeholder="Enter your email" required>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" placeholder="Create a password" required>
                </div>

                <div class="form-group">
                    <label for="phone-no">Phone Number</label>
                    <input type="text" id="phone-no" name="phone-no" placeholder="Enter your phone number" required>
                </div>

                <button type="submit" class="signup-button">Sign Up</button>
            </form>

            <p class="account-link">
                Already have an account? <a href="login.jsp">Log In</a>
            </p>

            <footer>
                <p>Contact Us</p>
                <p>MD Resort: 03 - 5644 8969 / 03 - 5644 8177</p>
            </footer>
        </div>
    </div>
</body>
</html>
