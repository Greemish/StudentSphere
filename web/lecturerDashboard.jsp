<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lecturer Dashboard</title>
    <style>
        :root { 
            --bg-color: #f4f7f9; 
            --card-white: #ffffff; 
            --text-dark: #2c3e50;
            --text-muted: #7f8c8d;
        }
        
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            background-color: var(--bg-color); 
            margin: 0; 
            padding: 40px; 
        }

        .header { 
            margin-bottom: 40px; 
            border-bottom: 2px solid #ddd; 
            padding-bottom: 15px; 
        }

        /* Responsive Grid */
        .module-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 25px;
        }

        /* Card Design */
        .module-card {
            background: var(--card-white);
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            cursor: pointer;
            overflow: hidden;
            border: 1px solid transparent;
        }

        .module-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 25px rgba(0,0,0,0.15);
            border-color: #3498db;
        }

        .color-tab { 
            height: 100px; 
            width: 100%; 
        }
        
        .card-body { 
            padding: 20px; 
            text-align: center; 
        }

        .module-code { 
            font-weight: bold; 
            color: var(--text-muted); 
            font-size: 0.85rem; 
            letter-spacing: 1px; 
            display: block;
        }

        .module-title { 
            display: block; 
            margin-top: 10px; 
            font-size: 1.3rem; 
            color: var(--text-dark); 
            font-weight: 600; 
        }

        .empty-state { 
            grid-column: 1/-1; 
            text-align: center; 
            color: var(--text-muted); 
            padding: 80px; 
        }
    </style>
</head>
<body>

    <div class="header">
        <h1>Welcome, Lecturer</h1>
        <p>Select a module card below to manage content and students.</p>
    </div>

    <div class="module-grid">
        <%-- Loop through the modulesList passed from LectureDashboardServlet --%>
        <c:forEach var="item" items="${modulesList}">
            <div class="module-card" onclick="handleModuleSelection('${item.id}')">
                <%-- Uses the 'colour' field from your database --%>
                <div class="color-tab" style="background-color: ${item.colour};"></div>
                <div class="card-body">
                    <span class="module-code">MODULE ID: ${item.id}</span>
                    <span class="module-title">${item.name}</span>
                </div>
            </div>
        </c:forEach>

        <%-- Fallback if the database list is empty --%>
        <c:if test="${empty modulesList}">
            <div class="empty-state">
                <h2>No modules found.</h2>
                <p>If you expected to see modules here, please check your database connection.</p>
            </div>
        </c:if>
    </div>


    <script>
        function handleModuleSelection(id) {
            console.log("Module Selected:", id);

            // 1. Get the context path (e.g., /ProjectName)
            const contextPath = "${pageContext.request.contextPath}";

            // 2. Build the full URL to the Content Servlet
            // We use 'moduleid' to match the request.getParameter("moduleid") in your Servlet
            const targetURL = contextPath + "/ModuleContentServlett?moduleid=" + id;

            // 3. Redirect the browser
            window.location.href = targetURL;
        }
    </script>
</body>
</html>