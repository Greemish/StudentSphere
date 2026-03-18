<%@ page import="java.util.*" %>

<html>
<head>
    <title>Your Modules</title>

    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Arial, sans-serif;
            background: #eef2f7;
            display: flex;
        }

        /* SIDEBAR */
        .sidebar {
            width: 240px;
            height: 100vh;
            background: linear-gradient(180deg, #1e3c72, #2a5298);
            color: #fff;
            padding: 25px 20px;
        }

        .sidebar h2 {
            margin-bottom: 30px;
        }

        .sidebar a {
            display: block;
            color: #fff;
            text-decoration: none;
            margin: 15px 0;
            padding: 10px;
            border-radius: 8px;
            transition: 0.3s;
        }

        .sidebar a:hover {
            background: rgba(255,255,255,0.2);
        }

        /* MAIN */
        .main-content {
            flex: 1;
            padding: 30px;
        }

        .modules-container {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
        }

        .module-card {
            width: 220px;
            padding: 20px;
            border-radius: 12px;
            color: #fff;
            text-align: center;
            background: radial-gradient(circle at 30% 30%, var(--start), var(--end));
            box-shadow: 0 6px 16px rgba(0,0,0,0.2);
            transition: 0.3s;
        }

        .module-card:hover {
            transform: translateY(-5px);
        }

        .module-card button {
            margin-top: 10px;
            padding: 8px 14px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            background: #fff;
            color: #1e3c72;
            font-weight: bold;
        }
    </style>
</head>

<body>

<!-- SIDEBAR -->
<div class="sidebar">
    <h2>Student Panel</h2>
    <a href="DashboardServlet">Dashboard</a>
    <a href="#">Modules</a>
    <a href="TakeQuizServlet">Take Quiz</a>
    <a href="#">Profile</a>
    <a href="login.jsp">Logout</a>
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
</div>

</body>
</html>