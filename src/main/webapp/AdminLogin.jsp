<%@ page import="java.sql.*, java.io.*, jakarta.servlet.*, jakarta.servlet.http.*" %>
<%@ page import="resort.utils.DatabaseUtility" %>

<%
String username = request.getParameter("staffName");
String password = request.getParameter("staffPassword");

// Perform database validation for login
Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

try {
    con = DatabaseUtility.getConnection();
    ps = con.prepareStatement("SELECT * FROM Staff WHERE username=? AND password=?");
    ps.setString(1, username);
    ps.setString(2, password);
    rs = ps.executeQuery();

    if (rs.next()) {
        // Set session attributes
        HttpSession session1 = request.getSession();
        session.setAttribute("staffID", rs.getInt("staffID"));
        session.setAttribute("staffName", rs.getString("staffName"));
        session.setAttribute("staffEmail", rs.getString("staffEmail"));
        session.setAttribute("staffPhoneNo", rs.getString("staffPhoneNo"));
        
        // Redirect to Profile details page
        response.sendRedirect("Profile.jsp");
    } else {
        // Invalid login, redirect back to login page with an error message
        response.sendRedirect("AdminLogin.jsp?error=invalid");
    }
} catch (SQLException e) {
    e.printStackTrace();
} finally {
    DatabaseUtility.closeResources(rs, ps, con);
}
%>
