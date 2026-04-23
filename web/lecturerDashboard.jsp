<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    if (session.getAttribute("lecturerid") == null) {
        response.sendRedirect("lecturerLogin.jsp");
        return;
    }
    String lecturerName = (String) session.getAttribute("name");
    if (lecturerName == null || lecturerName.trim().isEmpty()) {
        lecturerName = "Lecturer";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Student Sphere</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: #f1f5f9;
            min-height: 100vh;
        }

        /* Navbar */
        .navbar {
            background: white;
            border-bottom: 1px solid #e2e8f0;
            padding: 0 32px;
            height: 64px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .logo {
            font-size: 20px;
            font-weight: 700;
            color: #0f172a;
            letter-spacing: -0.3px;
            text-decoration: none;
        }

        .logo span {
            color: #3b82f6;
        }

        .nav-links {
            display: flex;
            align-items: center;
            gap: 24px;
        }

        .nav-link {
            font-size: 14px;
            font-weight: 500;
            color: #64748b;
            text-decoration: none;
            transition: color 0.2s;
        }

        .nav-link:hover {
            color: #3b82f6;
        }

        .user-menu {
            display: flex;
            align-items: center;
            gap: 20px;
            border-left: 1px solid #e2e8f0;
            padding-left: 24px;
        }

        .user-name {
            font-size: 14px;
            font-weight: 500;
            color: #334155;
        }

        .logout-btn {
            background: #f1f5f9;
            border: none;
            padding: 8px 16px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 500;
            font-family: 'Inter', sans-serif;
            color: #64748b;
            cursor: pointer;
            transition: all 0.2s;
            text-decoration: none;
            display: inline-block;
        }

        .logout-btn:hover {
            background: #fee2e2;
            color: #dc2626;
        }

        /* Main Container */
        .container {
            max-width: 1280px;
            margin: 0 auto;
            padding: 32px;
        }

        /* Welcome Section */
        .welcome-section {
            background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%);
            border-radius: 24px;
            padding: 32px;
            margin-bottom: 32px;
            color: white;
        }

        .welcome-section h1 {
            font-size: 28px;
            font-weight: 600;
            letter-spacing: -0.3px;
            margin-bottom: 8px;
        }

        .welcome-section p {
            font-size: 14px;
            color: #94a3b8;
        }

        .breadcrumb {
            margin-bottom: 24px;
        }

        .breadcrumb a {
            color: #64748b;
            font-size: 13px;
            text-decoration: none;
        }

        .breadcrumb a:hover {
            color: #3b82f6;
        }

        .breadcrumb span {
            color: #94a3b8;
            font-size: 13px;
            margin: 0 8px;
        }

        .breadcrumb .current {
            color: #334155;
            font-weight: 500;
        }

        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }

        .stat-card {
            background: white;
            border-radius: 16px;
            padding: 20px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
            border: 1px solid #e2e8f0;
            transition: all 0.2s;
        }

        .stat-card:hover {
            border-color: #cbd5e1;
            box-shadow: 0 4px 6px -2px rgba(0, 0, 0, 0.05);
        }

        .stat-label {
            font-size: 13px;
            font-weight: 500;
            color: #64748b;
            margin-bottom: 8px;
        }

        .stat-value {
            font-size: 32px;
            font-weight: 700;
            color: #0f172a;
        }

        /* Module Grid */
        .section-title {
            font-size: 18px;
            font-weight: 600;
            color: #0f172a;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .module-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 24px;
        }

        .module-card {
            background: white;
            border-radius: 20px;
            border: 1px solid #e2e8f0;
            transition: all 0.2s ease;
            cursor: pointer;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
        }

        .module-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 24px -8px rgba(0, 0, 0, 0.1);
            border-color: #cbd5e1;
        }

        .color-bar {
            height: 6px;
            width: 100%;
        }

        .card-content {
            padding: 24px;
        }

        .module-code {
            font-size: 12px;
            font-weight: 500;
            color: #64748b;
            letter-spacing: 0.5px;
            text-transform: uppercase;
            margin-bottom: 8px;
        }

        .module-name {
            font-size: 18px;
            font-weight: 600;
            color: #0f172a;
            margin-bottom: 20px;
        }

        .card-footer {
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-top: 1px solid #f1f5f9;
            padding-top: 16px;
        }

        .module-action {
            font-size: 13px;
            font-weight: 500;
            color: #3b82f6;
        }

        .arrow {
            color: #94a3b8;
            font-size: 14px;
        }

        .empty-state {
            background: white;
            border-radius: 20px;
            padding: 60px;
            text-align: center;
            border: 1px solid #e2e8f0;
        }

        .empty-state h3 {
            font-size: 18px;
            font-weight: 500;
            color: #334155;
            margin-bottom: 8px;
        }

        .empty-state p {
            color: #94a3b8;
            font-size: 14px;
        }
    </style>
</head>
<body>

    <nav class="navbar">
        <a href="LectureDashboardServlett" class="logo">Student<span>Sphere</span></a>
        <div class="nav-links">
            <div class="user-menu">
                <span class="user-name"><%= lecturerName %></span>
                <a href="LogoutServlet" class="logout-btn">Sign out</a>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="breadcrumb">
            <a href="LectureDashboardServlett">Dashboard</a>
            <span>/</span>
            <span class="current">My Modules</span>
        </div>

        <div class="welcome-section">
            <h1>Welcome back, <%= lecturerName %></h1>
            <p>Manage your modules, track student progress, and create learning content from one place.</p>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-label">Assigned Modules</div>
                <div class="stat-value">${modulesList.size()}</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Enrolled Students</div>
                <div class="stat-value">-</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Pending Assessments</div>
                <div class="stat-value">-</div>
            </div>
        </div>

        <div class="section-title">
            <span>My Modules</span>
        </div>

        <div class="module-grid">
            <c:forEach var="module" items="${modulesList}">
                <div class="module-card" onclick="goToModule('${module.id}', '${module.code}')">
                    <div class="color-bar" style="background-color: ${module.colour};"></div>
                    <div class="card-content">
                        <div class="module-code">${module.code}</div>
                        <div class="module-name">${module.name}</div>
                        <div class="card-footer">
                            <span class="module-action">Manage module</span>
                            <span class="arrow">→</span>
                        </div>
                    </div>
                </div>
            </c:forEach>

            <c:if test="${empty modulesList}">
                <div class="empty-state">
                    <h3>No modules assigned</h3>
                    <p>You are not assigned to any modules yet. Please contact the administrator.</p>
                </div>
            </c:if>
        </div>
    </div>

    <script>
    function goToModule(moduleId, moduleCode) {
    const contextPath = "${pageContext.request.contextPath}";
        window.location.href = contextPath + "/ModuleHomeServlet?modulecode=" + encodeURIComponent(moduleCode);
    }
</script>

</body>
</html>