<%@ page import="java.util.*" %>
<%
    String studentNumber = (String) session.getAttribute("studentNumber");
    if (studentNumber == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Map<String, String>> questions = (List<Map<String, String>>) request.getAttribute("questions");
    List<String> weakTopics = (List<String>) request.getAttribute("weakTopics");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Adaptive Quiz</title>
    <link rel="stylesheet" href="dashboardStyle.css">
    <style>
        .quiz-container { max-width: 800px; margin: 2rem auto; background: white; padding: 2rem; border-radius: 1rem; }
        .question { margin-bottom: 2rem; border-bottom: 1px solid #ccc; padding-bottom: 1rem; }
        .options label { display: inline-block; margin-right: 1rem; }
        button { background: #1e3c72; color: white; padding: 0.5rem 1rem; border: none; border-radius: 0.5rem; cursor: pointer; }
        .weak-topics { background: #e8f0fe; padding: 0.5rem; border-radius: 0.5rem; margin-bottom: 1rem; }
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
    <a href="profile.jsp">Profile</a>
    <a href="LogoutServlet">Logout</a>
</div>
<div class="main-content">
    <div class="quiz-container">
        <h2>? Adaptive Quiz</h2>
        <div class="weak-topics">
            <strong>Focusing on your weak areas:</strong> 
            <%= (weakTopics != null && !weakTopics.isEmpty()) ? String.join(", ", weakTopics) : "general" %>
        </div>
        <% if (questions != null && !questions.isEmpty()) { %>
            <form action="SubmitAdaptiveQuizServlet" method="post">
                <% int idx = 1; for (Map<String, String> q : questions) { %>
                    <div class="question">
                        <p><strong><%= idx %>. <%= q.get("text") %></strong></p>
                        <div class="options">
                            <label><input type="radio" name="q<%= idx %>" value="A" required> A. <%= q.get("A") %></label>
                            <label><input type="radio" name="q<%= idx %>" value="B"> B. <%= q.get("B") %></label>
                            <label><input type="radio" name="q<%= idx %>" value="C"> C. <%= q.get("C") %></label>
                            <label><input type="radio" name="q<%= idx %>" value="D"> D. <%= q.get("D") %></label>
                        </div>
                        <input type="hidden" name="correct<%= idx %>" value="<%= q.get("correct") %>">
                        <input type="hidden" name="topic<%= idx %>" value="<%= (weakTopics != null && !weakTopics.isEmpty()) ? weakTopics.get(0) : "general" %>">
                        <input type="hidden" name="questionText<%= idx %>" value="<%= q.get("text") %>">
                    </div>
                <% idx++; } %>
                <button type="submit">Submit Quiz</button>
            </form>
        <% } else { %>
            <p>No questions available. Please take some regular quizzes first to identify weak areas.</p>
        <% } %>
    </div>
</div>
</body>
</html>