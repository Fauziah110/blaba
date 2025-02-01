<%@ page import="java.sql.*" %>
<%@ page import="resort.utils.DatabaseUtility" %>
<%@ page contentType="application/json" %>

<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        conn = DatabaseUtility.getConnection();

        String sql = "SELECT TO_CHAR(reservationdate, 'MM') AS month, COUNT(*) AS reservation_count " +
                     "FROM reservations " +
                     "GROUP BY TO_CHAR(reservationdate, 'MM') " +
                     "ORDER BY TO_CHAR(reservationdate, 'MM')";

        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();

        StringBuilder labels = new StringBuilder("[");
        StringBuilder counts = new StringBuilder("[");

        while (rs.next()) {
            labels.append("\"").append(rs.getString("month")).append("\"").append(",");
            counts.append(rs.getInt("reservation_count")).append(",");
        }

        if (labels.length() > 1) {
            labels.deleteCharAt(labels.length() - 1); // Remove trailing comma
            counts.deleteCharAt(counts.length() - 1); // Remove trailing comma
        }

        labels.append("]");
        counts.append("]");

        out.print("{");
        out.print("\"labels\": " + labels.toString() + ",");
        out.print("\"counts\": " + counts.toString());
        out.print("}");

    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
    } finally {
        DatabaseUtility.closeResources(rs, pstmt, conn);
    }
%>
