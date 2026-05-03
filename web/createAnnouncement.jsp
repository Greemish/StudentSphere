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
    <title>Create Announcement - ${moduleCode}</title>
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
            max-width: 800px;
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

        /* Card */
        .card {
            background: white;
            border-radius: 24px;
            border: 1px solid #e2e8f0;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
        }

        .card-header {
            padding: 24px 32px;
            border-bottom: 1px solid #f1f5f9;
        }

        .card-header h1 {
            font-size: 24px;
            font-weight: 600;
            color: #0f172a;
            letter-spacing: -0.3px;
            margin-bottom: 8px;
        }

        .card-header p {
            font-size: 14px;
            color: #64748b;
        }

        .card-body {
            padding: 32px;
        }

        /* Form */
        .form-group {
            margin-bottom: 28px;
        }

        .form-group label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: #334155;
            margin-bottom: 8px;
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 12px 16px;
            font-size: 14px;
            font-family: 'Inter', sans-serif;
            border: 1.5px solid #e2e8f0;
            border-radius: 12px;
            transition: all 0.2s;
            background: #fafbfc;
        }

        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #3b82f6;
            background: white;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }

        .form-group textarea {
            resize: vertical;
            min-height: 150px;
        }

        .error-message {
            background: #fef2f2;
            border: 1px solid #fecaca;
            border-radius: 12px;
            padding: 12px 16px;
            margin-bottom: 24px;
            color: #dc2626;
            font-size: 13px;
        }

        .btn-group {
            display: flex;
            gap: 16px;
            margin-top: 8px;
        }

        .btn-primary {
            background: #3b82f6;
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 600;
            font-family: 'Inter', sans-serif;
            cursor: pointer;
            transition: all 0.2s;
            flex: 1;
        }

        .btn-primary:hover {
            background: #2563eb;
        }

        .btn-outline {
            background: transparent;
            border: 1.5px solid #e2e8f0;
            color: #64748b;
            padding: 12px 24px;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 500;
            font-family: 'Inter', sans-serif;
            cursor: pointer;
            transition: all 0.2s;
            text-decoration: none;
            text-align: center;
            flex: 1;
        }

        .btn-outline:hover {
            background: #f8fafc;
            border-color: #cbd5e1;
        }

        /* Info Box */
        .info-box {
            margin-top: 24px;
            padding: 16px 20px;
            background: #f8fafc;
            border-radius: 12px;
            border-left: 4px solid #3b82f6;
        }

        .info-box h4 {
            font-size: 13px;
            font-weight: 600;
            color: #0f172a;
            margin-bottom: 8px;
        }

        .info-box p {
            font-size: 13px;
            color: #64748b;
            line-height: 1.5;
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
            <a href="ModuleHomeServlet?moduleid=${currentModuleId}">${moduleCode}</a>
            <span>/</span>
            <span class="current">New Announcement</span>
        </div>

        <div class="card">
            <div class="card-header">
                <h1>Create Announcement</h1>
                <p>Post a message to all students enrolled in ${moduleName} (${moduleCode})</p>
            </div>
            <div class="card-body">
                <% if (request.getParameter("error") != null) { %>
                    <div class="error-message">
                        <% 
                            String error = request.getParameter("error");
                            if (error.equals("missing_heading")) {
                                out.print("Please enter a heading for your announcement.");
                            } else if (error.equals("missing_message")) {
                                out.print("Please enter the announcement message.");
                            } else {
                                out.print("An error occurred. Please try again.");
                            }
                        %>
                    </div>
                <% } %>

                <form action="CreateAnnouncementServlet" method="POST">
                    <input type="hidden" name="moduleid" value="${currentModuleId}">

                    <div class="form-group">
                        <label for="heading">Heading</label>
                        <input type="text" id="heading" name="heading" placeholder="e.g., Important Update on Assignment Submission" required>
                    </div>

                    <div class="form-group">
                        <label for="announcement">Message</label>
                        <textarea id="announcement" name="announcement" placeholder="Write your announcement message here. Students will see this immediately on their dashboard." required></textarea>
                    </div>

                    <div class="btn-group">
                        <a href="ModuleHomeServlet?moduleid=${currentModuleId}" class="btn-outline">Cancel</a>
                        <button type="submit" class="btn-primary">Post Announcement</button>
                    </div>
                </form>

                <div class="info-box">
                    <h4>Information</h4>
                    <p>Announcements appear instantly on student dashboards and are sorted with the most recent at the top. Students can view announcements directly from their module home page.</p>
                </div>
            </div>
        </div>
    </div>

</body>
</html>