<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Take Quiz</title>
    <link rel="stylesheet" href="dashboardStyle.css">
    <style>
        .quiz-container { max-width: 900px; margin: 20px auto; }
        .topic { background: white; border-radius: 10px; padding: 20px; margin-bottom: 30px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        .question { margin: 20px 0; padding: 15px; background: #fafafa; border-radius: 8px; }
        .options { margin-left: 20px; }
        .options label { display: block; margin: 8px 0; cursor: pointer; }
        .submit-btn { background: #27ae60; color: white; padding: 15px 30px; border: none; border-radius: 5px; font-size: 16px; cursor: pointer; }
        .error { color: red; background: #ffe6e6; padding: 10px; border-radius: 5px; }
        .btn-ai { background: #9b59b6; color: white; padding: 10px 20px; text-decoration: none; display: inline-block; margin-bottom: 20px; border-radius: 5px; }
        .quiz-list { background: white; padding: 20px; border-radius: 10px; }
        .quiz-item { padding: 10px; border-bottom: 1px solid #ddd; }
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
    <div class="quiz-container">
        <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
            <div class="error"><%= error %></div>
        <%
            }
            
            Boolean isAIQuiz = (Boolean) request.getAttribute("isAIQuiz");
            
            if (isAIQuiz != null && isAIQuiz) {
                // Show AI generated quiz
                List<Map<String, Object>> topics = (List<Map<String, Object>>) session.getAttribute("aiQuiz");
                if (topics != null && !topics.isEmpty()) {
        %>
        <h2> AI Generated Quiz (From PDF)</h2>
        <form action="SubmitQuizServlet" method="post">
            <%
                int qIndex = 0;
                for (Map<String, Object> topic : topics) {
                    String topicName = (String) topic.get("topic");
                    List<Map<String, Object>> quizzes = (List<Map<String, Object>>) topic.get("quizzes");
            %>
            <div class="topic">
                <h3>? <%= topicName %></h3>
                <% for (Map<String, Object> quiz : quizzes) { 
                    String question = (String) quiz.get("question");
                    Map<String, String> options = (Map<String, String>) quiz.get("options");
                    String answer = (String) quiz.get("answer");
                    qIndex++;
                %>
                <div class="question">
                    <p><%= qIndex %>. <%= question %></p>
                    <div class="options">
                        <label><input type="radio" name="q<%= qIndex %>" value="A" required> A. <%= options.get("A") %></label>
                        <label><input type="radio" name="q<%= qIndex %>" value="B"> B. <%= options.get("B") %></label>
                        <label><input type="radio" name="q<%= qIndex %>" value="C"> C. <%= options.get("C") %></label>
                        <label><input type="radio" name="q<%= qIndex %>" value="D"> D. <%= options.get("D") %></label>
                        <input type="hidden" name="correct<%= qIndex %>" value="<%= answer %>">
                    </div>
                </div>
                <% } %>
            </div>
            <%      }
                } 
            } else {
                // Show existing quizzes from database
        %>
        <h2>Available Quizzes</h2>
        <a href="TakeQuizServlet?type=ai" class="btn-ai">Generate AI Quiz from PDF</a>
        
        <div class="quiz-list">
            <%
                List<Map<String, String>> quizzes = (List<Map<String, String>>) request.getAttribute("quizzes");
                if (quizzes != null && !quizzes.isEmpty()) {
                    for (Map<String, String> quiz : quizzes) {
            %>
            <div class="quiz-item">
                <h3><%= quiz.get("title") %></h3>
                <p><%= quiz.get("description") %></p>
                <p><strong>Module:</strong> <%= quiz.get("module") %></p>
                <a href="StartQuizServlet?quizId=<%= quiz.get("id") %>">Take This Quiz</a>
            </div>
            <%
                    }
                } else {
            %>
                <p>No quizzes available.</p>
            <%
                }
            %>
        </div>
        <%
            }
        %>
    </div>
</div>

</body>
</html>