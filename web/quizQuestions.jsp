<%@ page import="java.util.*" %>
<%
    String studentNumber = (String) session.getAttribute("studentNumber");
    if (studentNumber == null) response.sendRedirect("login.jsp");
    List<Map<String, String>> questions = (List<Map<String, String>>) request.getAttribute("questions");
    Integer quizId = (Integer) request.getAttribute("quizId");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Quiz Questions</title>
    <link rel="stylesheet" href="dashboardStyle.css">
    <style>
        .quiz-form { max-width: 800px; margin: 20px auto; background: white; padding: 20px; border-radius: 10px; }
        .question { margin-bottom: 25px; border-bottom: 1px solid #ccc; padding-bottom: 15px; }
        .options label { display: inline-block; margin-right: 15px; }
        button { background: #1e3c72; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; }
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
    <div class="quiz-form">
        <h2>Answer the Questions</h2>
        <form action="SubmitQuizServlet" method="post">
            <input type="hidden" name="quizId" value="<%= quizId %>">
            <input type="hidden" name="totalQuestions" value="<%= questions.size() %>">
            <% int idx = 1; for (Map<String, String> q : questions) { %>
                <div class="question">
                    <p><strong><%= idx %>. <%= q.get("text") %></strong></p>
                    <div class="options">
                        <label><input type="radio" name="q<%= q.get("id") %>" value="A" required> A. <%= q.get("a") %></label>
                        <label><input type="radio" name="q<%= q.get("id") %>" value="B"> B. <%= q.get("b") %></label>
                        <label><input type="radio" name="q<%= q.get("id") %>" value="C"> C. <%= q.get("c") %></label>
                        <label><input type="radio" name="q<%= q.get("id") %>" value="D"> D. <%= q.get("d") %></label>
                    </div>
                </div>
            <% idx++; } %>
            <button type="submit">Submit Quiz</button>
        </form>
    </div>
</div>
</body>
</html>