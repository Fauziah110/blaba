<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@ page import="resort.utils.DatabaseUtility" %>

<!DOCTYPE html>
<html>
<head>
<title>Service Details</title>
<link rel="stylesheet"
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css">
<style>
/* ======= ASAL STYLE KAU ======= */
body {
    margin: 0;
    font-family: Arial, Helvetica, sans-serif;
}

header {
    background-color: #5f7268; /* Dark greenish color */
    color: white;
    padding: 10px;
    text-align: center;
    font-size: 18px;
}

nav {
    display: flex;
    align-items: center;
    padding: 10px 20px;
    background-color: white;
    border-bottom: 1px solid #ddd;
    width: 100%;
}

nav .logo-link {
    display: flex;
    align-items: center;
    text-decoration: none;
    color: #5f7268;
}

.logo-image {
    height: 55px;
    margin-right: 10px;
}

.logo-text {
    font-size: 16px;
    font-weight: bold;
    margin-right: 200px;
}

nav .spacer {
    flex: 1;
}

nav ul {
    list-style: none;
    display: flex;
    margin: 0;
    padding: 0;
    position: relative;
}

nav ul li {
    position: relative;
    margin: 0 50px;
    font-weight: bold;
}

nav ul li a {
    text-decoration: none;
    color: #5f7268;
    font-size: 16px;
    padding: 5px 10px;
    display: inline-block;
}

nav ul li a:hover {
    text-decoration: underline;
}

nav ul .submenu {
    display: none;
    position: absolute;
    top: 100%;
    left: 0;
    background-color: white;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    padding: 10px 0;
    list-style: none;
    z-index: 10;
}

nav ul .submenu li {
    margin: 0;
}

nav ul .submenu li a {
    padding: 10px 20px;
    font-size: 14px;
    display: block;
    white-space: nowrap;
}

nav ul .submenu li a:hover {
    background-color: #f2f2f2;
}

nav ul li:hover>.submenu {
    display: block;
}

h1 {
    font-size: 18px;
    font-weight: bold;
    margin: 40px 40px 10px;
    color: #5f7268;
}

table {
    width: 100%;
    max-width: 90%;
    border-collapse: collapse;
    margin: 1px 40px 10px;
}

th,
td {
    border: 1px solid #000;
    padding: 10px;
    text-align: center;
    color: #5f7268;
}

th {
    background-color: #5f7268;
    color: white;
}

.centered-select {
    display: flex;
    justify-content: center;
}

.action-buttons a,
.action-buttons button {
    margin-right: 5px;
}

.modal {
    display: none;
    position: fixed;
    z-index: 10;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    overflow: auto;
    background-color: rgba(0, 0, 0, 0.4);
}

.modal-content {
    width: 400px;
    margin: 50px auto;
    background-color: #f3f3f3;
    color: #5f7268;
    border-radius: 10px;
    padding: 20px;
    box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
    position: relative;
}

.modal-content label {
    font-size: 16px;
    font-weight: bold;
    margin-bottom: 5px;
    display: inline-block;
}

.modal-content input,
.modal-content select,
.modal-content textarea {
    width: 100%;
    padding: 8px 10px;
    margin-bottom: 15px;
    border: 1px solid #ccc;
    border-radius: 5px;
    font-size: 14px;
}

.modal-content button {
    width: 100%;
    padding: 10px;
    background-color: #5f7268;
    color: white;
    border: none;
    border-radius: 5px;
    font-size: 16px;
    cursor: pointer;
}

.modal-content button:hover {
    background-color: #4b5c53;
}

.modal-header,
.modal-footer {
    border: none;
}

.modal-header h5 {
    color: #5f7268;
}

.close {
    position: absolute;
    top: 15px;
    right: 15px;
    color: #5f7268;
    font-size: 24px;
    font-weight: bold;
    cursor: pointer;
}

.close:hover {
    color: #4b5c53;
}

#addServiceBtn {
    background-color: #5f7268;
    color: white;
    padding: 10px 20px;
    border: none;
    cursor: pointer;
    margin: 40px;
}

#addServiceBtn:hover {
    background-color: #4b5c53;
}

.error-message {
    color: red;
    font-weight: bold;
    margin-top: -10px;
    margin-bottom: 10px;
}
</style>
</head>

<body>
    <nav>
        <a href="Dashboard.jsp" class="logo-link"> <img src="images/MDResort.png" alt="Resort Logo"
                class="logo-image"> <span class="logo-text">MD Resort Pantai Siring Melaka</span> </a>
        <div class="spacer"></div>
        <ul>
            <li><a href="Booking.jsp">Booking</a></li>
            <li><a href="Room.jsp">Room</a></li>
            <li><a href="Service.jsp">Service</a>
                <ul class="submenu">
                    <li><a href="FoodService.jsp">Food Service</a></li>
                    <li><a href="EventService.jsp">Event Service</a></li>
                </ul>
            </li>
            <li><a href="Profile.jsp">Profile</a></li>
        </ul>
    </nav>

    <h1>Service Details</h1>
    <button id="addServiceBtn" onclick="showAddModal()">+ Add Service</button>

    <table>
        <thead>
            <tr>
                <th>No Service</th>
                <th>Service Type</th>
                <th>Service Charge</th>
                <th>Service Date</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <%
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;
                try {
                    conn = DatabaseUtility.getConnection();
                    String sql = "SELECT * FROM service";
                    pstmt = conn.prepareStatement(sql);
                    rs = pstmt.executeQuery();
                    while (rs.next()) {
            %>
            <tr>
                <td><%= rs.getInt("SERVICEID") %></td>
                <td><%= rs.getString("SERVICETYPE") %></td>
                <td><%= rs.getBigDecimal("SERVICECHARGE") %></td>
                <td><%= rs.getDate("SERVICEDATE") %></td>
                <td class="action-buttons">
                    <button class="btn btn-sm btn-secondary" onclick="showEditModal('<%= rs.getInt("SERVICEID") %>', '<%= rs.getString("SERVICETYPE") %>', '<%= rs.getBigDecimal("SERVICECHARGE") %>', '<%= rs.getDate("SERVICEDATE") %>')">Edit</button>
                    <button class="btn btn-sm btn-danger" onclick="showDeleteModal('<%= rs.getInt("SERVICEID") %>')">Delete</button>
                </td>
            </tr>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    DatabaseUtility.closeResources(rs, pstmt, conn);
                }
            %>
        </tbody>
    </table>

    <!-- Add Service Modal -->
    <div id="addServiceModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeAddModal()">&times;</span>
            <h2>Add Service</h2>
            <form action="Service.jsp" method="post" onsubmit="return validateAddForm()">
                <label for="addServiceType">Type Service:</label>
                <input type="text" id="addServiceType" name="serviceType" required>

                <label for="addServiceCharge">Service Charge:</label>
                <input type="text" id="addServiceCharge" name="serviceCharge" required>
                <div id="addChargeError" class="error-message"></div>

                <label for="addServiceDate">Service Date:</label>
                <input type="date" id="addServiceDate" name="serviceDate" required>

                <button type="submit">Add Service</button>
            </form>
        </div>
    </div>

    <!-- Edit Service Modal -->
    <div id="editServiceModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeEditModal()">&times;</span>
            <h2>Edit Service</h2>
            <form action="EditServiceController" method="post" onsubmit="return validateEditForm()">
                <input type="hidden" id="editServiceId" name="serviceId">

                <label for="editServiceType">Type Service:</label>
                <input type="text" id="editServiceType" name="serviceType" required>

                <label for="editServiceCharge">Service Charge:</label>
                <input type="text" id="editServiceCharge" name="serviceCharge" required>
                <div id="editChargeError" class="error-message"></div>

                <label for="editServiceDate">Service Date:</label>
                <input type="date" id="editServiceDate" name="serviceDate" required>

                <button type="submit">Save Service</button>
            </form>
        </div>
    </div>

    <!-- Delete Service Modal -->
    <div id="deleteServiceModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeDeleteModal()">&times;</span>
            <h2>Delete Service</h2>
            <form id="deleteServiceForm" action="DeleteServiceController" method="post" onsubmit="return validateDeleteForm()">
                <input type="hidden" id="deleteServiceId" name="deleteServiceId" value="">

                <label for="staffPassword">Staff Password:</label>
                <input type="password" id="staffPassword" name="staffPassword" required>
                <div id="deletePasswordError" class="error-message"></div>

                <button type="submit">Delete Service</button>
            </form>
        </div>
    </div>

    <script>
        // Modal functions

        // ADD modal
        function showAddModal() {
            clearAddErrors();
            document.getElementById("addServiceModal").style.display = "block";
        }
        function closeAddModal() {
            document.getElementById("addServiceModal").style.display = "none";
        }

        // EDIT modal
        function showEditModal(id, type, charge, date) {
            clearEditErrors();
            document.getElementById('editServiceId').value = id;
            document.getElementById('editServiceType').value = type;
            document.getElementById('editServiceCharge').value = charge;
            document.getElementById('editServiceDate').value = date;
            document.getElementById("editServiceModal").style.display = "block";
        }
        function closeEditModal() {
            document.getElementById("editServiceModal").style.display = "none";
        }

        // DELETE modal
        function showDeleteModal(id) {
            clearDeleteErrors();
            document.getElementById("deleteServiceId").value = id;
            document.getElementById("staffPassword").value = '';
            document.getElementById("deleteServiceModal").style.display = "block";
        }
        function closeDeleteModal() {
            document.getElementById("deleteServiceModal").style.display = "none";
        }

        // Validation for Add Service form
        function validateAddForm() {
            clearAddErrors();
            const charge = document.getElementById('addServiceCharge').value.trim();
            const errorDiv = document.getElementById('addChargeError');

            if (charge === '' || isNaN(charge) || Number(charge) < 0) {
                errorDiv.innerText = 'Please enter number for Service Charge.';
                return false;
            }
            return true;
        }
        function clearAddErrors() {
            document.getElementById('addChargeError').innerText = '';
        }

        // Validation for Edit Service form
        function validateEditForm() {
            clearEditErrors();
            const charge = document.getElementById('editServiceCharge').value.trim();
            const errorDiv = document.getElementById('editChargeError');

            if (charge === '' || isNaN(charge) || Number(charge) < 0) {
                errorDiv.innerText = 'Please enter  number for Service Charge.';
                return false;
            }
            return true;
        }
        function clearEditErrors() {
            document.getElementById('editChargeError').innerText = '';
        }

        // Validation for Delete Service form
        function validateDeleteForm() {
            clearDeleteErrors();
            const password = document.getElementById('staffPassword').value.trim();
            const errorDiv = document.getElementById('deletePasswordError');

            if (password === '') {
                errorDiv.innerText = 'Please enter staff password to delete.';
                return false;
            }
            return true;
        }
        function clearDeleteErrors() {
            document.getElementById('deletePasswordError').innerText = '';
        }

        // Close modal if click outside modal content
        window.onclick = function(event) {
            const addModal = document.getElementById("addServiceModal");
            const editModal = document.getElementById("editServiceModal");
            const deleteModal = document.getElementById("deleteServiceModal");
            if (event.target === addModal) {
                closeAddModal();
            }
            if (event.target === editModal) {
                closeEditModal();
            }
            if (event.target === deleteModal) {
                closeDeleteModal();
            }
        }
    </script>
</body>
</html>
