<%@page import="student.DBConnection"%>
<%@ page import="java.sql.*" %>

<h2>Student Dashboard ?</h2>

<%
String student = (String) session.getAttribute("studentNumber");

try (Connection conn = DBConnection.getConnection()) {

    PreparedStatement ps = conn.prepareStatement(
        "SELECT COUNT(*), AVG(percentage) FROM quiz_results WHERE student_number=?"
    );

    ps.setString(1, student);
    ResultSet rs = ps.executeQuery();

    if (rs.next()) {
%>

<p>Total Quizzes: <%= rs.getInt(1) %></p>
<p>Average Score: <%= rs.getInt(2) %>%</p>

<%
    }

} catch (Exception e) {
    out.println("Error loading dashboard");
}
%>