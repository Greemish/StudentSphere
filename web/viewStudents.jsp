<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.*" %>

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
    <title>Manage Students - ${moduleCode}</title>
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
            max-width: 1200px;
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

        /* Page Header */
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 28px;
        }

        .page-header h1 {
            font-size: 28px;
            font-weight: 600;
            color: #0f172a;
            letter-spacing: -0.3px;
            margin-bottom: 8px;
        }

        .page-header p {
            color: #64748b;
            font-size: 14px;
        }

        .stats-badge {
            background: #eef2ff;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 500;
            color: #3b82f6;
        }

        /* Search Bar */
        .search-container {
            margin-bottom: 24px;
        }

        .search-input {
            width: 100%;
            max-width: 320px;
            padding: 10px 16px;
            font-size: 14px;
            font-family: 'Inter', sans-serif;
            border: 1.5px solid #e2e8f0;
            border-radius: 12px;
            background: white;
            transition: all 0.2s;
        }

        .search-input:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }

        /* Success/Error Messages */
        .alert {
            padding: 12px 16px;
            border-radius: 12px;
            margin-bottom: 24px;
            font-size: 13px;
        }

        .alert-success {
            background: #ecfdf5;
            border: 1px solid #a7f3d0;
            color: #059669;
        }

        .alert-error {
            background: #fef2f2;
            border: 1px solid #fecaca;
            color: #dc2626;
        }

        /* Table Card */
        .table-card {
            background: white;
            border-radius: 20px;
            border: 1px solid #e2e8f0;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background: #f8fafc;
            padding: 16px 20px;
            text-align: left;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #64748b;
            border-bottom: 1px solid #e2e8f0;
        }

        td {
            padding: 16px 20px;
            border-bottom: 1px solid #f1f5f9;
            font-size: 14px;
            color: #334155;
        }

        tr:last-child td {
            border-bottom: none;
        }

        tr:hover td {
            background: #fafbfc;
        }

        /* Badges */
        .badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
        }

        .badge-student {
            background: #eef2ff;
            color: #3b82f6;
        }

        .badge-tutor {
            background: #ecfdf5;
            color: #059669;
        }

        /* Action Buttons */
        .action-btn {
            padding: 6px 14px;
            border-radius: 8px;
            text-decoration: none;
            font-size: 12px;
            font-weight: 500;
            transition: all 0.2s;
            display: inline-block;
        }

        .btn-promote {
            background: #ecfdf5;
            color: #059669;
            border: 1px solid #a7f3d0;
        }

        .btn-promote:hover {
            background: #059669;
            color: white;
        }

        .btn-remove {
            background: #fef2f2;
            color: #dc2626;
            border: 1px solid #fecaca;
        }

        .btn-remove:hover {
            background: #dc2626;
            color: white;
        }

        .empty-state {
            text-align: center;
            padding: 60px;
            color: #94a3b8;
        }

        .empty-state p {
            font-size: 14px;
        }

        /* Student Code Styling */
        .student-code {
            font-family: 'Monaco', 'Menlo', monospace;
            font-size: 13px;
            color: #475569;
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
            <a href="ModuleHomeServlet?moduleid=${moduleId}">${moduleCode}</a>
            <span>/</span>
            <span class="current">Students</span>
        </div>

        <div class="page-header">
            <div>
                <h1>Manage Students</h1>
                <p>View and manage student enrollment for ${moduleName}</p>
            </div>
            <div class="stats-badge">
                ${students.size()} Students Enrolled
            </div>
        </div>

        <!-- Success/Error Messages -->
        <% if (request.getParameter("promote") != null) { %>
            <% if ("success".equals(request.getParameter("promote"))) { %>
                <div class="alert alert-success">Student has been promoted to tutor successfully.</div>
            <% } else if ("error".equals(request.getParameter("promote"))) { %>
                <div class="alert alert-error">Failed to promote student. They may already be a tutor.</div>
            <% } %>
        <% } %>

        <% if (request.getParameter("remove") != null) { %>
            <% if ("success".equals(request.getParameter("remove"))) { %>
                <div class="alert alert-success">Tutor privileges have been removed.</div>
            <% } else if ("error".equals(request.getParameter("remove"))) { %>
                <div class="alert alert-error">Failed to remove tutor privileges.</div>
            <% } %>
        <% } %>

        <!-- Search -->
        <div class="search-container">
            <input type="text" id="searchInput" class="search-input" placeholder="Search by name or student number...">
        </div>

        <div class="table-card">
            <table id="studentTable">
                <thead>
                    <tr>
                        <th>Full Name</th>
                        <th>Student Number</th>
                        <th>Email</th>
                        <th>Role</th>
                        <th style="text-align: right;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty students}">
                            <c:forEach var="student" items="${students}">
                                <c:set var="isTutor" value="${tutors.contains(student.num)}" />
                                <tr class="student-row">
                                    <td><strong>${student.name}</strong></td>
                                    <td><span class="student-code">${student.num}</span></td>
                                    <td>${student.email}</td>
                                    <td>
                                        <span class="badge ${isTutor ? 'badge-tutor' : 'badge-student'}">
                                            ${isTutor ? 'Tutor' : 'Student'}
                                        </span>
                                    </td>
                                    <td style="text-align: right;">
                                        <c:choose>
                                            <c:when test="${isTutor}">
                                                <a href="ViewStudentsServlet?moduleid=${moduleId}&action=remove&studentNum=${student.num}" 
                                                   class="action-btn btn-remove" 
                                                   onclick="return confirm('Remove tutor privileges from ${student.name}? The student will still be enrolled in the module.')">
                                                    Revoke Tutor
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="ViewStudentsServlet?moduleid=${moduleId}&action=promote&studentNum=${student.num}" 
                                                   class="action-btn btn-promote"
                                                   onclick="return confirm('Promote ${student.name} to tutor? They will be able to assist with module management.')">
                                                    Make Tutor
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="5" class="empty-state">
                                    <p>No students are enrolled in this module yet.</p>
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        const searchInput = document.getElementById('searchInput');
        const rows = document.querySelectorAll('.student-row');
        
        searchInput.addEventListener('keyup', function() {
            const searchTerm = searchInput.value.toLowerCase();
            
            rows.forEach(row => {
                const name = row.cells[0]?.innerText.toLowerCase() || '';
                const studentNum = row.cells[1]?.innerText.toLowerCase() || '';
                const email = row.cells[2]?.innerText.toLowerCase() || '';
                
                if (name.includes(searchTerm) || studentNum.includes(searchTerm) || email.includes(searchTerm)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        });
    </script>

</body>
</html>