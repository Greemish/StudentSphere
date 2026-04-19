<%@ page import="java.util.*" %>
<%
    String studentNumber = (String) session.getAttribute("studentNumber");
    if (studentNumber == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Map<String, String>> messages = (List<Map<String, String>>) request.getAttribute("messages");
    List<Map<String, String>> tutors = (List<Map<String, String>>) request.getAttribute("tutors");
    Integer moduleId = (Integer) request.getAttribute("moduleId");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Module Messages</title>
    <link rel="stylesheet" href="dashboardStyle.css">
    <style>
        .back-btn { position: fixed; top: 1rem; left: 1rem; background: #333; color: white; padding: 0.3rem 0.8rem; text-decoration: none; border-radius: 0.5rem; font-size: 0.8rem; z-index: 100; }
        .back-btn:hover { background: #555; }
    </style>
</head>
<body>
<a href="#" class="back-btn" onclick="history.back();return false;"> < Back</a>
<div class="sidebar">
    <h2>Student Panel</h2>
    <a href="ModuleServlet">Dashboard</a>
    <a href="TakeQuizServlet">Take Quiz</a>
    <a href="AdaptiveQuizServlet">Adaptive Quiz</a>
    <a href="profile.jsp">Profile</a>
    <a href="LogoutServlet">Logout</a>
</div>
<div class="main-content">
    <h2>Module Discussion</h2>
    <h3>Tutors:</h3>
    <% if (tutors != null && !tutors.isEmpty()) { %>
        <ul>
        <% for (Map<String, String> t : tutors) { %>
            <li><%= t.get("name") %> (<%= t.get("email") %>)</li>
        <% } %>
        </ul>
    <% } else { %>
        <p>No tutors assigned.</p>
    <% } %>

    <h3>Messages:</h3>
    <% if (messages != null && !messages.isEmpty()) { %>
        <% for (Map<String, String> msg : messages) { %>
            <div style="border:1px solid #ccc; margin:10px 0; padding:10px; border-radius:5px;">
                <strong>Student: <%= msg.get("student_number") %></strong>
                <small><%= msg.get("created_at") %></small>
                <p><%= msg.get("content") %></p>
            </div>
        <% } %>
    <% } else { %>
        <p>No messages yet. Be the first to ask!</p>
    <% } %>

    <h3>Post a New Message</h3>
    <form action="ModuleMessagesServlet" method="post">
        <input type="hidden" name="moduleid" value="<%=moduleId %>">
        <textarea name="content" rows="3" cols="50" required></textarea><br>
        <button type="submit">Send</button>
    </form>
</div>
</body>
</html>