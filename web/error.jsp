<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Error</title>
    <link rel="stylesheet" href="dashboardStyle.css">
    <style>
        .error-container {
            max-width: 600px;
            margin: 100px auto;
            padding: 30px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: center;
        }
        .error-icon {
            font-size: 60px;
            color: #e74c3c;
        }
        .error-message {
            color: #e74c3c;
            background: #fdecea;
            padding: 15px;
            border-radius: 5px;
            margin: 20px 0;
        }
        .back-btn {
            background: #3498db;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
            display: inline-block;
        }
        .back-btn:hover {
            background: #2980b9;
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
    <div class="error-container">
        <div class="error-icon">??</div>
        <h2>Something Went Wrong</h2>
        
        <div class="error-message">
            <%
                String error = (String) request.getAttribute("error");
                if (error == null) {
                    error = (String) request.getParameter("error");
                }
                if (error != null && !error.isEmpty()) {
                    out.println("<p>" + error + "</p>");
                } else {
                    out.println("<p>An unexpected error occurred. Please try again.</p>");
                }
            %>
        </div>
        
        <a href="javascript:history.back()" class="back-btn">< Go Back</a>
        &nbsp;
        <a href="DashboardServlet" class="back-btn">Go to Dashboard</a>
    </div>
</div>

</body>
</html>