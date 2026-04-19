<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Your Modules</title>
    <link rel="stylesheet" href="modulesStyle.css">
    <link rel="stylesheet" href="dashboardStyle.css">
    
</head>
<body>

<!-- SIDEBAR -->
<div class="sidebar">
    <h2>Student Panel</h2>
    <a href="DashboardServlet">Dashboard</a>
    <a href="ModuleServlet">Modules</a>
    <a href="TakeQuizServlet">Take Quiz</a>
    <a href="AdaptiveQuizServlet">Adaptive Quiz</a>
   
    <a href="#">Profile</a>
    <a href="LogoutServlet">Logout</a>
    
</div>

<!-- CONTENT -->
<div class="main-content">
    <h2>Your Modules</h2>
    <div class="modules-container">
        <%
            List<Map<String,String>> modules = (List<Map<String,String>>) request.getAttribute("modulesList");
            if (modules != null && !modules.isEmpty()) {
                for (Map<String,String> m : modules) {
                    String colour = m.get("colour").toLowerCase();
                    String start="#1e3c72", end="#2a5298";
                    if(colour.equals("green")) { start="#56ab2f"; end="#a8e063"; }
                    else if(colour.equals("cyan")) { start="#00c6ff"; end="#0072ff"; }
        %>
        <div class="module-card" style="--start:<%= start %>; --end:<%= end %>;">
            <h3><%= m.get("name") %></h3>
            <p>ID: <%= m.get("id") %></p>
            <form action="ModuleMessagesServlet" method="get">
                <input type="hidden" name="moduleid" value="<%= m.get("id") %>">
                <button type="submit">Open Module</button>
            </form>
        </div>
        <%
                }
            } else {
        %>
            <p>No modules found.</p>
        <%
            }
        %>
    </div>

    <div class="chatgpt-section">
        <h2>Need Help?</h2>
        <p>Ask ChatGPT for explanations, examples, or study tips.</p>
        <a href="https://chat.openai.com" target="_blank" class="chatgpt-btn">Open ChatGPT </a>
    </div>
</div>

</body>
</html>


<!--sk-proj-Ktxwylk5dI5s8ssnF_FHn-iDX0TVoLqbWCX2RNdkzgiHr0Lr5VnYotWy87jXeULgnwQx_fTOa0T3BlbkFJO-x7PbuFrdKsgO70PCyAKgeTRPGU4xevbKgYy2dmVsQwKUbneCWyN3oERxt75eYGL2BAFWOIEA-->