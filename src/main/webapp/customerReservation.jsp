<%@ page session="true" %>
<%@ page import="java.util.*, resort.model.Reservation" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    if (session.getAttribute("customerID") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Reservation> reservations = (List<Reservation>) request.getAttribute("reservations");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Your Reservations</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f8f8;
            color: #333;
            margin: 0; padding: 0;
        }
        header {
            background: #728687;
            color: white;
            padding: 15px;
            text-align: center;
            font-size: 22px;
        }
        .container {
            max-width: 900px;
            margin: 30px auto;
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        th, td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: center;
        }
        th {
            background: #728687;
            color: white;
        }
        .edit-btn {
            background: #007bff;
            color: white;
            padding: 5px 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .edit-btn:hover {
            background: #0056b3;
        }
        .save-btn {
            background: #04aa6d;
            color: white;
            padding: 5px 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .save-btn:hover {
            background: #03784d;
        }
    </style>
</head>
<body>
    <header>Your Reservations</header>

    <div class="container">
        <h2>Hello, <%= session.getAttribute("customerName") %>!</h2>

        <table>
            <thead>
                <tr>
                    <th>Reservation ID</th>
                    <th>Room</th>
                    <th>Check-In</th>
                    <th>Check-Out</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="res" items="${reservations}">
                    <tr>
                        <td>${res.reservationID}</td>
                        <td>${res.roomType}</td>
                        <td>
                            <span id="checkin-${res.reservationID}">${res.checkInDate}</span>
                            <form id="checkin-form-${res.reservationID}" action="UpdateReservationController" method="post" style="display:none;">
                                <input type="hidden" name="reservationID" value="${res.reservationID}" />
                                <input type="date" name="checkInDate" value="${res.checkInDate}" required />
                                <button type="submit" class="save-btn">Save</button>
                            </form>
                        </td>
                        <td>
                            <span id="checkout-${res.reservationID}">${res.checkOutDate}</span>
                            <form id="checkout-form-${res.reservationID}" action="UpdateReservationController" method="post" style="display:none;">
                                <input type="hidden" name="reservationID" value="${res.reservationID}" />
                                <input type="date" name="checkOutDate" value="${res.checkOutDate}" required />
                                <button type="submit" class="save-btn">Save</button>
                            </form>
                        </td>
                        <td>
                            <button class="edit-btn" onclick="enableEdit(<%=res.getReservationID()%>)">Edit</button>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <script>
        function enableEdit(reservationID) {
            document.getElementById('checkin-' + reservationID).style.display = "none";
            document.getElementById('checkout-' + reservationID).style.display = "none";
            document.getElementById('checkin-form-' + reservationID).style.display = "block";
            document.getElementById('checkout-form-' + reservationID).style.display = "block";
        }
    </script>
</body>
</html>
