package resort.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import resort.connection.ConnectionManager;

import java.io.IOException;
import java.sql.*;

public class ProfileController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection conn = null;
        PreparedStatement updateStmt = null;
        HttpSession session = request.getSession(false); // Do not create a new session if it does not exist

        if (session == null || session.getAttribute("customerID") == null) {
            System.out.println("❌ DEBUG: customerID is null. Redirecting to login.");
            response.sendRedirect("login.jsp?sessionExpired=true");
            return;
        }

        // ✅ FIXED: Ensure customerID is an integer
        Object customerIDObj = session.getAttribute("customerID");
        int customerID;

        try {
            if (customerIDObj instanceof Integer) {
                customerID = (Integer) customerIDObj;
            } else if (customerIDObj instanceof String) {
                customerID = Integer.parseInt((String) customerIDObj);
            } else {
                System.out.println("❌ DEBUG: Invalid customerID type.");
                response.sendRedirect("login.jsp?sessionExpired=true");
                return;
            }
        } catch (NumberFormatException e) {
            System.out.println("❌ ERROR: customerID conversion failed.");
            response.sendRedirect("login.jsp?sessionExpired=true");
            return;
        }

        // ✅ Get updated values from the form
        String updatedName = request.getParameter("customerName");
        String updatedEmail = request.getParameter("customerEmail");
        String updatedPhoneNo = request.getParameter("customerPhoneNo");

        System.out.println("✅ DEBUG: Updating profile for customerID -> " + customerID);
        System.out.println("✅ DEBUG: New Name: " + updatedName);
        System.out.println("✅ DEBUG: New Email: " + updatedEmail);
        System.out.println("✅ DEBUG: New Phone: " + updatedPhoneNo);

        try {
            conn = ConnectionManager.getConnection();
            if (conn == null) {
                System.out.println("❌ ERROR: Database connection failed.");
                response.sendRedirect("profileCustomer.jsp?updateSuccess=false");
                return;
            }

            // ✅ Dynamically build update query
            StringBuilder updateSQL = new StringBuilder("UPDATE Customer SET ");
            boolean hasUpdate = false;

            if (updatedName != null && !updatedName.trim().isEmpty()) {
                updateSQL.append("customerName = ?, ");
                hasUpdate = true;
            }
            if (updatedEmail != null && !updatedEmail.trim().isEmpty()) {
                updateSQL.append("customerEmail = ?, ");
                hasUpdate = true;
            }
            if (updatedPhoneNo != null && !updatedPhoneNo.trim().isEmpty()) {
                updateSQL.append("customerPhoneNo = ?, ");
                hasUpdate = true;
            }

            if (!hasUpdate) {
                System.out.println("❌ ERROR: No fields provided for update.");
                response.sendRedirect("profileCustomer.jsp?updateSuccess=false");
                return;
            }

            // Remove last comma and add WHERE clause
            updateSQL.setLength(updateSQL.length() - 2);
            updateSQL.append(" WHERE customerID = ?");

            updateStmt = conn.prepareStatement(updateSQL.toString());

            int index = 1;
            if (updatedName != null && !updatedName.trim().isEmpty()) {
                updateStmt.setString(index++, updatedName);
            }
            if (updatedEmail != null && !updatedEmail.trim().isEmpty()) {
                updateStmt.setString(index++, updatedEmail);
            }
            if (updatedPhoneNo != null && !updatedPhoneNo.trim().isEmpty()) {
                updateStmt.setString(index++, updatedPhoneNo);
            }

            updateStmt.setInt(index, customerID);

            int rowsAffected = updateStmt.executeUpdate();
            System.out.println("✅ DEBUG: Rows affected -> " + rowsAffected);

            if (rowsAffected > 0) {
                // ✅ Update session attributes for changed fields
                if (updatedName != null && !updatedName.trim().isEmpty()) {
                    session.setAttribute("customerName", updatedName);
                }
                if (updatedEmail != null && !updatedEmail.trim().isEmpty()) {
                    session.setAttribute("customerEmail", updatedEmail);
                }
                if (updatedPhoneNo != null && !updatedPhoneNo.trim().isEmpty()) {
                    session.setAttribute("customerPhoneNo", updatedPhoneNo);
                }

                System.out.println("✅ DEBUG: Profile updated successfully.");
                response.sendRedirect("profileCustomer.jsp?updateSuccess=true");
            } else {
                System.out.println("❌ ERROR: No rows updated. Possible issue with SQL or customerID.");
                response.sendRedirect("profileCustomer.jsp?updateSuccess=false");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("❌ ERROR: SQL Exception - " + e.getMessage());
            response.sendRedirect("profileCustomer.jsp?updateSuccess=false");
        } finally {
            try {
                if (updateStmt != null) updateStmt.close();
                if (conn != null) conn.close();
            } catch (SQLException ignored) {}
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
