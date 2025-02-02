<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Register</title>
    <link rel="stylesheet" href="style.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script> <!-- For jQuery -->
</head>
<body>
    <div class="form-container">
        <form action="RegisterController" method="post">
            <h2>Admin Sign Up</h2>
            <input type="text" name="staffName" placeholder="Enter Name" required />
            <input type="email" name="staffEmail" placeholder="Enter Email" required />
            <input type="text" name="staffPhoneNo" placeholder="Enter Phone Number" required />
            <input type="password" name="staffPassword" placeholder="Enter Password" required />
            <button type="submit">Sign Up</button>
        </form>
    </div>

    <!-- Success Popup -->
    <div id="popup" class="popup" style="display: none;">
        <div class="popup-content">
            <h2>Registration Successful!</h2>
            <p>You will be redirected to the login page.</p>
        </div>
    </div>

    <script>
        // Function to show the popup
        function showPopup() {
            document.getElementById('popup').style.display = 'block';
            setTimeout(function() {
                window.location.href = 'AdminLogin.jsp'; // Redirect to login page after 2 seconds
            }, 2000); // 2000 milliseconds = 2 seconds
        }

        // Wait for the page to load and check if the URL has a success parameter
        $(document).ready(function() {
            var urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get('success') === 'true') {
                showPopup(); // Show the popup on success
            } else if (urlParams.get('error')) {
                alert("Error: " + urlParams.get('error')); // Display error message if any
            }
        });
    </script>
</body>
</html>
