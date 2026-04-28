<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Adaptive Quiz</title>
    <link rel="stylesheet" href="dashboardStyle.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #f5f5f5; }
        
        .sidebar {
            width: 250px;
            background: #2c3e50;
            color: white;
            height: 100vh;
            position: fixed;
            padding: 20px;
        }
        
        .sidebar h2 {
            margin-bottom: 30px;
            font-size: 20px;
        }
        
        .sidebar a {
            display: block;
            color: white;
            padding: 10px;
            margin: 5px 0;
            text-decoration: none;
            border-radius: 5px;
        }
        
        .sidebar a:hover {
            background: #34495e;
        }
        
        .main-content {
            margin-left: 260px;
            padding: 20px;
        }
        
        .quiz-container {
            max-width: 900px;
            margin: 0 auto;
        }
        
        h2 {
            color: #2c3e50;
            margin-bottom: 20px;
        }
        
        .adaptive-badge {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            text-align: center;
        }
        
        .adaptive-badge h3 {
            margin-bottom: 5px;
        }
        
        .weak-topics {
            background: #fff3cd;
            color: #856404;
            padding: 10px;
            border-radius: 5px;
            margin-top: 10px;
            font-size: 14px;
        }
        
        .topic {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 30px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        
        .topic h3 {
            color: #2c3e50;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #3498db;
        }
        
        .question {
            margin: 20px 0;
            padding: 15px;
            background: #fafafa;
            border-radius: 8px;
            border-left: 4px solid #3498db;
        }
        
        .question p {
            font-weight: bold;
            margin-bottom: 10px;
            color: #333;
        }
        
        .options {
            margin-left: 20px;
        }
        
        .options label {
            display: block;
            margin: 8px 0;
            cursor: pointer;
            padding: 8px;
            border-radius: 5px;
        }
        
        .options label:hover {
            background: #e8e8e8;
        }
        
        .options input {
            margin-right: 10px;
        }
        
        .submit-btn {
            background: #27ae60;
            color: white;
            padding: 15px 30px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            margin-top: 20px;
            width: 100%;
        }
        
        .submit-btn:hover {
            background: #219a52;
        }
        
        .error {
            color: red;
            background: #ffe6e6;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        
        .question-counter {
            color: #666;
            font-size: 12px;
            margin-bottom: 5px;
        }
        
        .info-text {
            background: #e3f2fd;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
            color: #1565c0;
        }
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
            
            Boolean adaptiveMode = (Boolean) request.getAttribute("adaptiveMode");
            List<String> weakTopics = (List<String>) request.getAttribute("weakTopics");
            
            if (adaptiveMode != null && adaptiveMode && weakTopics != null && !weakTopics.isEmpty()) {
        %>
            <div class="adaptive-badge">
                <h3>? ADAPTIVE LEARNING MODE</h3>
                <p>This quiz focuses on topics you previously struggled with</p>
                <div class="weak-topics">
                    <strong>? Weak topics being reviewed:</strong> <%= String.join(", ", weakTopics) %>
                </div>
            </div>
        <%
            } else if (adaptiveMode != null && adaptiveMode) {
        %>
            <div class="info-text">
                ? First time taking adaptive quiz. Take quizzes to build your learning profile.
            </div>
        <%
            }
            
            List<Map<String, Object>> topics = (List<Map<String, Object>>) session.getAttribute("currentQuizTopics");
            if (topics == null || topics.isEmpty()) {
        %>
            <div class="error">No quiz available. Please try again.</div>
            <a href="DashboardServlet">? Back to Dashboard</a>
        <%
            } else {
        %>
        <form action="SubmitAdaptiveQuizServlet" method="post" id="quizForm">
            <%
                int qIndex = 0;
                for (Map<String, Object> topic : topics) {
                    String topicName = (String) topic.get("topic");
                    List<Map<String, Object>> quizzes = (List<Map<String, Object>>) topic.get("quizzes");
                    
                    if (quizzes == null) continue;
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
                    <div class="question-counter">Question <%= qIndex %></div>
                    <p><strong><%= qIndex %>. <%= question %></strong></p>
                    <div class="options">
                        <label>
                            <input type="radio" name="q<%= qIndex %>" value="A" required> 
                            <strong>A.</strong> <%= options.get("A") %>
                        </label>
                        <label>
                            <input type="radio" name="q<%= qIndex %>" value="B"> 
                            <strong>B.</strong> <%= options.get("B") %>
                        </label>
                        <label>
                            <input type="radio" name="q<%= qIndex %>" value="C"> 
                            <strong>C.</strong> <%= options.get("C") %>
                        </label>
                        <label>
                            <input type="radio" name="q<%= qIndex %>" value="D"> 
                            <strong>D.</strong> <%= options.get("D") %>
                        </label>
                    </div>
                    <input type="hidden" name="topic<%= qIndex %>" value="<%= topicName %>">
                    <input type="hidden" name="correct<%= qIndex %>" value="<%= answer %>">
                    <input type="hidden" name="questionText<%= qIndex %>" value="<%= question %>">
                </div>
                <% } %>
            </div>
            <%
                }
            }
            %>
            
            <button type="submit" class="submit-btn">Submit Quiz</button>
        </form>
    </div>
</div>

<script>
    var quizForm = document.getElementById('quizForm');
    if (quizForm) {
        quizForm.addEventListener('submit', function(e) {
            var radios = document.querySelectorAll('input[type="radio"]');
            var checked = false;
            for (var i = 0; i < radios.length; i++) {
                if (radios[i].checked) {
                    checked = true;
                    break;
                }
            }
            if (!checked) {
                if (!confirm('You haven\'t answered all questions. Submit anyway?')) {
                    e.preventDefault();
                }
            }
        });
    }
</script>

</body>
</html>