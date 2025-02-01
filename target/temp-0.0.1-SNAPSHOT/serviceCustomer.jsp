<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Service</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        .container {
            width: 50%;
            margin: auto;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
        }
        .form-group input, .form-group select {
            width: 100%;
            padding: 8px;
            box-sizing: border-box;
        }
        .form-group button {
            padding: 10px 20px;
            background-color: #000;
            color: #fff;
            border: none;
            cursor: pointer;
        }
        .service-list {
            margin-top: 30px;
        }
        .service-list table {
            width: 100%;
            border-collapse: collapse;
        }
        .service-list table, .service-list th, .service-list td {
            border: 1px solid #ddd;
        }
        .service-list th, .service-list td {
            padding: 10px;
            text-align: left;
        }
        .service-list th {
            background-color: #f2f2f2;
        }
        .service-list .delete-btn {
            background-color: #f44336;
            color: #fff;
            border: none;
            padding: 5px 10px;
            cursor: pointer;
        }
    </style>
    <script>
        function validateForm() {
            var quantity = document.getElementById("quantity").value;
            var duration = document.getElementById("duration").value;
            if (quantity <= 0 || duration <= 0) {
                alert("Quantity and Duration must be positive values.");
                return false;
            }
            return true;
        }
    </script>
</head>
<body>
    <div class="container">
        <h1>Add Service</h1>
        <form action="addService.jsp" method="post" onsubmit="return validateForm()">
            <div class="form-group">
                <label for="serviceName">Service Name </label>
                <select id="serviceName" name="serviceName">
                    <option value="SET A">SET A</option>
                    <option value="SET B">SET B</option>
                    <option value="SET C">SET C</option>
                </select>
            </div>
            <div class="form-group">
                <label for="quantity">Quantity</label>
                <input type="number" id="quantity" name="quantity" value="1" min="1">
            </div>
            <div class="form-group">
                <label for="duration">Duration (days)</label>
                <input type="number" id="duration" name="duration" value="2" min="1">
            </div>
            
            <div class="form-group">
                <button type="submit">Add</button>
            </div>
        </form>
        
        
        <form action="addService.jsp" method="post" onsubmit="return validateForm()">
            <div class="form-group">
                <label for="serviceName">Venu Name </label>
                <select id="serviceName" name="serviceName">
                    <option value="SET A">Dataran Pantai Siring</option>
                    <option value="SET B">Garden</option>
                </select>
            </div>
            
            <div class="form-group">
                <label for="type">Event Type</label>
                <input type="number" id="type" name="type" value="1" min="1">
            </div>
            <div class="form-group">
                <label for="quantity">Duration Hour</label>
                <input type="number" id="quantity" name="quantity" value="1" min="1">
            </div>
           
            <div class="form-group">
                <button type="submit">Add</button>
            </div>
        </form>
        
        
        <div class="service-list">
            <h2>Service List</h2>
            <table>
                <thead>
                    <tr>
                        <th>Service Name</th>
                        <th>Service Type</th>
                        <th>Service Price</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>SET A</td>
                        <td>Room Service</td>
                        <td>40.0</td>
                        <td><button class="delete-btn">Delete</button></td>
                    </tr>
                </tbody>
            </table>
            <div class="form-group">
                <button type="button">Confirm</button>
            </div>
            <div class="form-group">
                <label>Want to also reserve an event service?</label>
                <button type="button">Click Here</button>
            </div>
            
        </div>
    </div>
</body>
</html>