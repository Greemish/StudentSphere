<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quiz Results</title>
    <link rel="stylesheet" href="dashboardStyle.css">
    <style>
        .results-container { max-width: 800px; margin: 30px auto; background: white; padding: 20px; border-radius: 10px; }
        .score-box { text-align: center; background: #27ae60; color: white; padding: 20px; border-radius: 10px; margin-bottom: 30px; }
        .score { font-size: 48px; }
        .question-review { margin: 15px 0; padding: 15px; border-bottom: 1px solid #eee; background: #f9f9f9; border-radius: 8px; }
        .correct { color: green; font-weight: bold; }
        .wrong { color: red; font-weight: bold; }
        .back-btn { display: inline-block; margin-top: 20px; padding: 10px 20px; background: #3498db; color: white; text-decoration: none; border-radius: 5px; }
    </style>
</head>
<body>
<div class="sidebar">
    <h2>Student Panel</h2>
    <a href="DashboardServlet">Dashboard</a>
    <a href="ModuleServlet">Modules</a>
    <a href="TakeQuizServlet">Take Quiz</a>
    <a href="AdaptiveQuizServlet">Adaptive Quiz</a>
    <a href="LogoutServlet">Logout</a>
</div>
<div class="main-content">
    <div class="results-container">
        <div class="score-box">
            <h2>Your Score</h2>
            <div class="score"><%= session.getAttribute("quizScore") %> / <%= session.getAttribute("quizTotal") %></div>
            <%
                int score = (Integer) session.getAttribute("quizScore");
                int total = (Integer) session.getAttribute("quizTotal");
                int percent = total > 0 ? (score * 100 / total) : 0;
            %>
            <p>Percentage: <%= percent %>%</p>
        </div>
        <h3>Detailed Review</h3>
        <%
            List<Map<String, String>> results = (List<Map<String, String>>) session.getAttribute("quizResults");
            if (results != null && !results.isEmpty()) {
                int qNum = 1;
                for (Map<String, String> r : results) {
                    boolean isCorrect = Boolean.parseBoolean(r.get("isCorrect"));
        %>
        <div class="question-review">
            <p><strong>Question <%= qNum++ %>:</strong> <%= r.get("question") %></p>
            <p><strong>Your answer:</strong> <%= r.get("userAnswer") %></p>
            <p><strong>Correct answer:</strong> <%= r.get("correctAnswer") %></p>
            <p><strong>Status:</strong> <span class="<%= isCorrect ? "correct" : "wrong" %>"><%= isCorrect ? "Correct" : "Wrong" %></span></p>
            <p><strong>Topic:</strong> <%= r.get("topic") %></p>
        </div>
        <%      }
            } else { %>
            <p>No results found.</p>
        <% } %>
        <div style="text-align: center;">
            <a href="TakeQuizServlet" class="back-btn">Take Another Quiz</a>
        </div>
    </div>
</div>
</body>
</html>