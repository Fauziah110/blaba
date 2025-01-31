package resort.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import resort.utils.DatabaseUtility;

public class EditEventController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		Connection conn = null;
		PreparedStatement pstmt = null;

		try {
			String serviceIdStr = request.getParameter("serviceID");
			if (serviceIdStr == null || serviceIdStr.isEmpty()) {
				response.getWriter().println("Error: serviceID is required.");
				return;
			}

			int serviceId = Integer.parseInt(serviceIdStr);
			String venue = request.getParameter("venue");
			String eventType = request.getParameter("eventType");
			String durationStr = request.getParameter("duration");

			if (venue == null || eventType == null || durationStr == null || venue.isEmpty() || eventType.isEmpty()
					|| durationStr.isEmpty()) {
				response.getWriter().println("Error: All fields are required.");
				return;
			}

			int duration = Integer.parseInt(durationStr);

			conn = DatabaseUtility.getConnection();

			// Update existing eventservice
			String updateQuery = "UPDATE eventservice SET venue = ?, eventtype = ?, duration = ? WHERE serviceID = ?";
			pstmt = conn.prepareStatement(updateQuery);
			pstmt.setString(1, venue);
			pstmt.setString(2, eventType);
			pstmt.setInt(3, duration);
			pstmt.setInt(4, serviceId);

			int result = pstmt.executeUpdate();
			if (result > 0) {
				response.sendRedirect("EventService.jsp"); // Redirect to refresh page
			} else {
				response.getWriter().println("Failed to update event service details.");
			}
		} catch (SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			response.getWriter().println("Error: " + e.getMessage());
		} finally {
			DatabaseUtility.closeResources(null, pstmt, conn);
		}
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request, response);
	}
}
