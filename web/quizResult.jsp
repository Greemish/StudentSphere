<%
    String studentNumber = (String) session.getAttribute("studentNumber");
    if (studentNumber == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    int score = Integer.parseInt(request.getParameter("score"));
    int total = Integer.parseInt(request.getParameter("total"));
%>
<!DOCTYPE html>
<html>
<head>
    <title>Quiz Result</title>
    <link rel="stylesheet" href="dashboardStyle.css">
</head>
<body>
    <a href="#" class="back-btn" onclick="history.back();return false;">&lt; Back</a>
<div class="sidebar">
    <h2>Student Panel</h2>
    <a href="ModuleServlet">Dashboard</a>
    <a href="TakeQuizServlet">Take Quiz</a>
    <a href="AdaptiveQuizServlet">Adaptive Quiz</a>
    <a href="LogoutServlet">Logout</a>
</div>
<div class="main-content">
    <h2>Your Score: <%= score %> / <%= total %></h2>
    <a href="AdaptiveQuizServlet">Take Another Adaptive Quiz</a> |
    <a href="TakeQuizServlet">Take a Regular Quiz</a>
</div>
</body>
</html>