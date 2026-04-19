<%@ page import="java.util.*" %>
<%
    String studentNumber = (String) session.getAttribute("studentNumber");
    if (studentNumber == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Map<String, String>> results = (List<Map<String, String>>) session.getAttribute("quizResults");
    int score = (Integer) session.getAttribute("quizScore");
    int total = (Integer) session.getAttribute("quizTotal");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Quiz Results</title>
    <link rel="stylesheet" href="dashboardStyle.css">
    <style>
        .result-container { max-width: 800px; margin: 2rem auto; background: white; padding: 2rem; border-radius: 1rem; }
        .question-feedback { border-bottom: 1px solid #ddd; padding: 1rem 0; }
        .correct { color: green; font-weight: bold; }
        .incorrect { color: red; font-weight: bold; }
        .your-answer { background: #f0f0f0; padding: 0.2rem 0.5rem; border-radius: 0.3rem; }
        .summary { background: #e8f0fe; padding: 1rem; border-radius: 0.5rem; margin-bottom: 1rem; }
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
    <div class="result-container">
        <h2>? Quiz Results</h2>
        <div class="summary">
            <strong>Your Score: <%= score %> / <%= total %></strong><br>
            Percentage: <%= (score * 100 / total) %>% 
        </div>
        <% if (results != null) { 
            int idx = 1;
            for (Map<String, String> res : results) { %>
                <div class="question-feedback">
                    <p><strong>Q<%= idx %>. <%= res.get("question") %></strong></p>
                    <p>Your answer: <span class="your-answer"><%= res.get("userAnswer") %></span></p>
                    <p>Correct answer: <%= res.get("correctAnswer") %></p>
                    <% if ("true".equals(res.get("isCorrect"))) { %>
                        <p class="correct">? Correct</p>
                    <% } else { %>
                        <p class="incorrect">? Incorrect</p>
                    <% } %>
                </div>
        <% idx++; } 
        } else { %>
            <p>No results found.</p>
        <% } %>
        <br>
        <a href="TakeQuizServlet">Take another quiz</a> | 
        <a href="AdaptiveQuizServlet">Adaptive Quiz</a>
    </div>
</div>
</body>
</html>