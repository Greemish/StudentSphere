<%@ page import="java.util.*" %>
<%
    String studentNumber = (String) session.getAttribute("studentNumber");
    if (studentNumber == null) response.sendRedirect("login.jsp");
    List<Map<String, String>> quizzes = (List<Map<String, String>>) request.getAttribute("quizzes");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Take a Quiz</title>
    <link rel="stylesheet" href="dashboardStyle.css">
    <style>
        .back-btn { position: fixed; top: 1rem; left: 1rem; background: #333; color: white; padding: 0.3rem 0.8rem; text-decoration: none; border-radius: 0.5rem; font-size: 0.8rem; z-index: 100; }
        .back-btn:hover { background: #555; }
    </style>
</head>
<body>
<a href="#" class="back-btn" onclick="history.back();return false;">? Back</a>
<div class="sidebar">
    <h2>Student Panel</h2>
    <a href="ModuleServlet">Dashboard</a>
    <a href="TakeQuizServlet">Take Quiz</a>
    <a href="AdaptiveQuizServlet">Adaptive Quiz</a>
    <a href="LogoutServlet">Logout</a>
</div>
<div class="main-content">
    <h2>Available Quizzes</h2>
    <% if (quizzes != null && !quizzes.isEmpty()) { %>
        <ul>
        <% for (Map<String, String> quiz : quizzes) { %>
            <li>
                <strong><%= quiz.get("title") %></strong> (<%= quiz.get("module") %>)<br>
                <%= quiz.get("description") %><br>
                <a href="StartQuizServlet?quizid=<%= quiz.get("id") %>">Start Quiz</a>
            </li>
        <% } %>
        </ul>
    <% } else { %>
        <p>No quizzes available for your enrolled modules.</p>
    <% } %>
</div>
</body>
</html>