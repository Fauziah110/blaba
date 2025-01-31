package resort.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import resort.connection.ConnectionManager;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Servlet implementation class AddRoomController
 */
public class AddRoomController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    static Connection con = null;
    static PreparedStatement ps = null;
    int roomId;
    String roomType, roomStatus, staffName;
    double roomPrice;

    public AddRoomController() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve input from HTML form
        roomId = Integer.parseInt(request.getParameter("roomId"));
        roomType = request.getParameter("roomType");
        roomStatus = request.getParameter("roomStatus");
        roomPrice = Double.parseDouble(request.getParameter("roomPrice"));
        staffName = request.getParameter("staffInCharge");

        try {
            // Call getConnection() method
            con = ConnectionManager.getConnection();
            if (con != null) {
                System.out.println("Database connection established successfully.");
            } else {
                System.out.println("Failed to establish database connection.");
            }

            // Retrieve staffid based on staffname
            String getStaffIdSql = "SELECT staffid FROM staff WHERE staffname = ?";
            ps = con.prepareStatement(getStaffIdSql);
            ps.setString(1, staffName);
            ResultSet rs = ps.executeQuery();

            int staffId = 0;
            if (rs.next()) {
                staffId = rs.getInt("staffid");
            }
            rs.close();
            ps.close();

            // Create statement to insert room
            String insertRoomSql = "INSERT INTO room(roomid, roomtype, roomstatus, roomprice, staffid) VALUES(?, ?, ?, ?, ?)";
            ps = con.prepareStatement(insertRoomSql);

            ps.setInt(1, roomId);
            ps.setString(2, roomType);
            ps.setString(3, roomStatus);
            ps.setDouble(4, roomPrice);
            ps.setInt(5, staffId);

            System.out.println("SQL Query: " + ps);

            // Execute query
            int rowsInserted = ps.executeUpdate();
            if (rowsInserted > 0) {
                System.out.println("A new room was inserted successfully!");
            }

            // Close connection
            con.close();

        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("SQLException: " + e.getMessage());
        }

        // Dispatch the request to Room.jsp
        RequestDispatcher req = request.getRequestDispatcher("Room.jsp");
        req.forward(request, response);
    }
}
