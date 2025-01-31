<%@ page import="java.sql.*" %>
<%@ page import="resort.utils.DatabaseUtility" %>
<%@ page contentType="application/json" %>

<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        conn = DatabaseUtility.getConnection();

        // SQL query to fetch data
        String sql = "SELECT r.checkindate, r.checkoutdate, r.roomid, c.customername " +
                     "FROM reservation r " +
                     "JOIN customer c ON r.customerid = c.customerid";
        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();

        StringBuilder jsonBuilder = new StringBuilder("[");
        boolean firstRecord = true;

        while (rs.next()) {
            if (!firstRecord) {
                jsonBuilder.append(",");
            }

            // Adding Check-In Event
            jsonBuilder.append("{")
                       .append("\"title\":\"Check-In\",")
                       .append("\"start\":\"").append(rs.getString("checkindate")).append("\",")
                       .append("\"type\":\"check-in\",")
                       .append("\"description\":\"Room ").append(rs.getInt("roomid")).append(" - ").append(rs.getString("customername")).append("\"")
                       .append("},");

            // Adding Check-Out Event
            jsonBuilder.append("{")
                       .append("\"title\":\"Check-Out\",")
                       .append("\"start\":\"").append(rs.getString("checkoutdate")).append("\",")
                       .append("\"type\":\"check-out\",")
                       .append("\"description\":\"Room ").append(rs.getInt("roomid")).append(" - ").append(rs.getString("customername")).append("\"")
                       .append("}");

            firstRecord = false;
        }
        jsonBuilder.append("]");
        out.print(jsonBuilder.toString());
    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
    } finally {
        DatabaseUtility.closeResources(rs, pstmt, conn);
    }
%>
