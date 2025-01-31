package resort.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import resort.utils.DatabaseUtility;

public class RegisterStaffController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String staffName = request.getParameter("staffName");
		String staffEmail = request.getParameter("staffEmail");
		String staffPhoneNo = request.getParameter("staffPhoneNo");
		String staffPassword = request.getParameter("staffPassword");
		int adminId = Integer.parseInt(request.getParameter("manageByAdmin"));

		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			conn = DatabaseUtility.getConnection();

			// Check if staffEmail already exists
			String checkEmailQuery = "SELECT COUNT(*) FROM staff WHERE staffemail = ?";
			pstmt = conn.prepareStatement(checkEmailQuery);
			pstmt.setString(1, staffEmail);
			rs = pstmt.executeQuery();
			rs.next();
			if (rs.getInt(1) > 0) {
				System.out.println("Email already exists.");
				request.setAttribute("errorMessage", "Email already exists.");
				request.getRequestDispatcher("Error.jsp").forward(request, response);
				return;
			}

			// Insert new staff
			String sql = "INSERT INTO staff (STAFFNAME, STAFFEMAIL, STAFFPHONENO, STAFFPASSWORD, ADMINID) VALUES (?, ?, ?, ?, ?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, staffName);
			pstmt.setString(2, staffEmail);
			pstmt.setString(3, staffPhoneNo);
			pstmt.setString(4, staffPassword);
			pstmt.setInt(5, adminId);

			int rowsInserted = pstmt.executeUpdate();
			if (rowsInserted > 0) {
				response.sendRedirect("Succes.jsp"); // Redirect to a success page
			} else {
				System.out.println("No rows inserted.");
				request.setAttribute("errorMessage", "No rows inserted.");
				request.getRequestDispatcher("Error.jsp").forward(request, response);
			}
		} catch (SQLException e) {
			System.out.println("SQL Exception: " + e.getMessage());
			e.printStackTrace();
			request.setAttribute("errorMessage", "SQL Exception: " + e.getMessage());
			request.getRequestDispatcher("Error.jsp").forward(request, response);
		} catch (ClassNotFoundException e) {
			System.out.println("Class Not Found Exception: " + e.getMessage());
			e.printStackTrace();
			request.setAttribute("errorMessage", "Class Not Found Exception: " + e.getMessage());
			request.getRequestDispatcher("Error.jsp").forward(request, response);
		} catch (Exception e) {
			System.out.println("General Exception: " + e.getMessage());
			e.printStackTrace();
			request.setAttribute("errorMessage", "General Exception: " + e.getMessage());
			request.getRequestDispatcher("Error.jsp").forward(request, response);
		} finally {
			DatabaseUtility.closeResources(rs, pstmt, conn);
		}
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.sendRedirect("Profile.jsp"); // Redirect to a register page if accessed via GET
	}
}
