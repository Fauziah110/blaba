<%@ page session="true" %>
<%@ page import="java.util.*" %>
<%@ page import="resort.model.Room" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Available Rooms</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: white;
        }
        header, footer {
            background: #728687;
            color: white;
            text-align: center;
            padding: 20px 0;
        }
        .stay-details, .room-container {
            max-width: 900px;
            margin: 20px auto;
            padding: 15px;
        }
        .stay-details {
            background: #f4f4f4;
            border-radius: 10px;
            margin-bottom: 20px;
            padding: 20px;
        }
        .stay-details p {
            margin: 5px 0;
            font-size: 16px;
        }
        .room-card {
            display: flex; /* Enables Flexbox */
            align-items: center;
            border: 1px solid #ddd;
            padding: 20px;
            margin-bottom: 20px;
            border-radius: 10px;
            background: #f4f4f4;
        }
        .room-card img {
            width: 200px;
            height: 200px;
            object-fit: cover;
            border-radius: 8px;
            margin-right: 20px; /* Adds spacing between image and text */
        }
        .room-details {
            flex: 1; /* Allows details section to take remaining space */
        }
        .room-card h3 {
            margin: 10px 0;
        }
        .room-card p {
            margin: 5px 0;
        }
        button {
            background: #728687;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
    </style>
</head>
<body>
<header>
    <h1>Available Rooms</h1>
</header>
<main>
    <div class="stay-details">
        <h2>Stay Details</h2>
        <p><strong>Check-In Date:</strong> <%= session.getAttribute("checkInDate") %></p>
        <p><strong>Check-Out Date:</strong> <%= session.getAttribute("checkOutDate") %></p>
        <p><strong>Adults:</strong> <%= session.getAttribute("adults") %></p>
        <p><strong>Kids:</strong> <%= session.getAttribute("kids") %></p>
    </div>
    <div class="room-container">
        <%
            List<Room> availableRooms = (List<Room>) request.getAttribute("availableRooms");
            
            // Mapping roomID to image path
            Map<Integer, String> roomImages = new HashMap<>();
            roomImages.put(101, "images/family_room.jpeg");
            roomImages.put(102, "images/cabin_room.jpg");
            roomImages.put(103, "images/wood_room.jpg");

            if (availableRooms != null && !availableRooms.isEmpty()) {
                for (Room room : availableRooms) {
                    String roomImage = roomImages.getOrDefault(room.getRoomID(), "images/default.jpg"); // Default image fallback
        %>
        <div class="room-card">
            <img src="<%= roomImage %>" alt="Room Image">
            <div class="room-details">
                <h3><%= room.getRoomType() %></h3>
                <p><strong>Price:</strong> RM<%= room.getRoomPrice() %> per night</p>
                <form action="ConfirmBookingController" method="POST">
                    <input type="hidden" name="roomID" value="<%= room.getRoomID() %>">
                    <input type="hidden" name="roomType" value="<%= room.getRoomType() %>">
                    <input type="hidden" name="price" value="<%= room.getRoomPrice() %>">
                    <label for="quantity">Quantity:</label>
                    <select name="quantity" id="quantity">
                        <option value="1">1</option>
                        <option value="2">2</option>
                    </select>
                    <button type="submit">Add to Booking</button>
                </form>
            </div>
        </div>
        <%
                }
            } else {
        %>
        <p style="color: red; text-align: center;">No rooms available for the selected criteria.</p>
        <%
            }
        %>
    </div>
</main>
<footer>
    <p>&copy; 2025 MD Resort</p>
</footer>
</body>
</html>
