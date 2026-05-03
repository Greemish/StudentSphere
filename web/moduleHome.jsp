<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    if (session.getAttribute("lecturerid") == null) {
        response.sendRedirect("lecturerLogin.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${moduleName} - Module Management</title>
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

        .user-info {
            display: flex;
            align-items: center;
            gap: 20px;
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
            max-width: 1400px;
            margin: 0 auto;
            padding: 32px;
        }

        /* Breadcrumb */
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

        /* Module Header */
        .module-header {
            background: white;
            border-radius: 24px;
            padding: 32px;
            margin-bottom: 32px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
        }

        .module-code-badge {
            display: inline-block;
            padding: 4px 12px;
            background: #eef2ff;
            color: #3b82f6;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
            margin-bottom: 16px;
        }

        .module-header h1 {
            font-size: 32px;
            font-weight: 700;
            color: #0f172a;
            letter-spacing: -0.5px;
            margin-bottom: 12px;
        }

        .module-stats {
            display: flex;
            gap: 24px;
            margin-top: 20px;
        }

        .module-stat {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            color: #64748b;
        }

        .module-stat strong {
            color: #0f172a;
            font-weight: 600;
        }

        /* Dashboard Grid */
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(380px, 1fr));
            gap: 28px;
        }

        /* Cards */
        .card {
            background: white;
            border-radius: 20px;
            border: 1px solid #e2e8f0;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
        }

        .card-header {
            padding: 20px 24px;
            border-bottom: 1px solid #f1f5f9;
        }

        .card-header h2 {
            font-size: 18px;
            font-weight: 600;
            color: #0f172a;
        }

        .card-body {
            padding: 20px 24px;
        }

        .card-footer {
            padding: 16px 24px;
            border-top: 1px solid #f1f5f9;
            background: #fafbfc;
        }

        /* Item Lists */
        .item-list {
            list-style: none;
        }

        .item-list li {
            padding: 12px 0;
            border-bottom: 1px solid #f1f5f9;
        }

        .item-list li:last-child {
            border-bottom: none;
        }

        .item-title {
            font-weight: 600;
            color: #0f172a;
            font-size: 14px;
            margin-bottom: 4px;
        }

        .item-meta {
            font-size: 12px;
            color: #94a3b8;
        }

        .item-message {
            font-size: 13px;
            color: #475569;
            margin-top: 8px;
            line-height: 1.5;
        }

        .empty-state {
            text-align: center;
            padding: 40px 20px;
            color: #94a3b8;
            font-size: 14px;
        }

        /* Buttons */
        .btn {
            display: inline-block;
            padding: 10px 20px;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 500;
            font-family: 'Inter', sans-serif;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.2s;
            border: none;
            text-align: center;
        }

        .btn-primary {
            background: #3b82f6;
            color: white;
        }

        .btn-primary:hover {
            background: #2563eb;
        }

        .btn-outline {
            background: transparent;
            border: 1px solid #e2e8f0;
            color: #475569;
        }

        .btn-outline:hover {
            border-color: #cbd5e1;
            background: #f8fafc;
        }

        .btn-success {
            background: #10b981;
            color: white;
        }

        .btn-success:hover {
            background: #059669;
        }

        .btn-block {
            width: 100%;
        }

        .btn-sm {
            padding: 6px 14px;
            font-size: 12px;
        }

        /* Quick Actions */
        .actions-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 12px;
            margin-top: 8px;
        }
    </style>
</head>
<body>

    <nav class="navbar">
        <a href="LectureDashboardServlett" class="logo">Student<span>Sphere</span></a>
        <div class="user-info">
            <span class="user-name">${sessionScope.name}</span>
            <a href="LogoutServlet" class="logout-btn">Sign out</a>
        </div>
    </nav>

    <div class="container">
        <div class="breadcrumb">
            <a href="LectureDashboardServlett">Dashboard</a>
            <span>/</span>
            <a href="LectureDashboardServlett">My Modules</a>
            <span>/</span>
            <span class="current">${moduleCode}</span>
        </div>

        <div class="module-header">
            <span class="module-code-badge">${moduleCode}</span>
            <h1>${moduleName}</h1>
            <div class="module-stats">
                <div class="module-stat"><strong>${studentCount}</strong> Enrolled Students</div>
                <div class="module-stat"><strong>${quizCount}</strong> Quizzes</div>
                <div class="module-stat"><strong>${contentPreview.size()}</strong> Resources</div>
            </div>
        </div>

        <div class="dashboard-grid">
            
            <!-- Quick Actions Card -->
            <div class="card">
                <div class="card-header">
                    <h2>Quick Actions</h2>
                </div>
                <div class="card-body">
                    <div class="actions-grid">
                        <a href="CreateAnnouncementServlet?moduleid=${currentModuleId}" class="btn btn-primary btn-sm">Post Announcement</a>
                        <a href="ModuleContentServlett?moduleid=${currentModuleId}" class="btn btn-outline btn-sm">Manage Content</a>
                        <a href="ViewStudentsServlet?moduleid=${currentModuleId}" class="btn btn-outline btn-sm">View Students</a>
                        <a href="ManageQuizzesServlet?moduleid=${currentModuleId}" class="btn btn-outline btn-sm">Manage Quizzes</a>
                    </div>
                </div>
            </div>

            <!-- Recent Announcements Card -->
            <div class="card">
                <div class="card-header">
                    <h2>Recent Announcements</h2>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty announcementList}">
                            <ul class="item-list">
                                <c:forEach var="ann" items="${announcementList}">
                                    <li>
                                        <div class="item-title">${ann.title}</div>
                                        <div class="item-meta">Posted on ${ann.date}</div>
                                        <div class="item-message">${ann.message}</div>
                                    </li>
                                </c:forEach>
                            </ul>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                No announcements yet. Click "Post Announcement" to create one.
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="card-footer">
                    <a href="CreateAnnouncementServlet?moduleid=${currentModuleId}" class="btn btn-primary btn-block">+ New Announcement</a>
                </div>
            </div>

            <!-- Recent Resources Card -->
            <div class="card">
                <div class="card-header">
                    <h2>Recent Resources</h2>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty contentPreview}">
                            <ul class="item-list">
                                <c:forEach var="res" items="${contentPreview}">
                                    <li>
                                        <div class="item-title">${res.fileName}</div>
                                        <div class="item-meta">${res.fileType} • ${res.chapter}</div>
                                    </li>
                                </c:forEach>
                            </ul>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                No resources uploaded yet. Click "Manage Content" to add files.
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="card-footer">
                    <a href="ModuleContentServlett?moduleid=${currentModuleId}" class="btn btn-outline btn-block">Manage Resources</a>
                </div>
            </div>

            <!-- Student Progress Card -->
            <div class="card">
                <div class="card-header">
                    <h2>Student Progress</h2>
                </div>
                <div class="card-body">
                    <div class="empty-state">
                        View and track student performance, grades, and quiz results.
                    </div>
                </div>
                <div class="card-footer">
                    <a href="ViewStudentsServlet?moduleid=${currentModuleId}" class="btn btn-outline btn-block">View Student List</a>
                </div>
            </div>
        </div>
    </div>

</body>
</html>