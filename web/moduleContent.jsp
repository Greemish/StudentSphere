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
    <title>Module Content - ${moduleCode}</title>
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
            max-width: 1280px;
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
            align-items: center;
            margin-bottom: 32px;
        }

        .page-header h1 {
            font-size: 28px;
            font-weight: 600;
            color: #0f172a;
            letter-spacing: -0.3px;
        }

        .page-header p {
            color: #64748b;
            font-size: 14px;
            margin-top: 4px;
        }

        /* Upload Card */
        .upload-card {
            background: white;
            border-radius: 20px;
            border: 1px solid #e2e8f0;
            padding: 28px;
            margin-bottom: 40px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
        }

        .upload-card h2 {
            font-size: 18px;
            font-weight: 600;
            color: #0f172a;
            margin-bottom: 20px;
        }

        .form-row {
            display: grid;
            grid-template-columns: 200px 1fr auto;
            gap: 20px;
            align-items: flex-end;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .form-group label {
            font-size: 13px;
            font-weight: 500;
            color: #334155;
        }

        .form-group input, .form-group select {
            padding: 10px 14px;
            border: 1.5px solid #e2e8f0;
            border-radius: 10px;
            font-family: 'Inter', sans-serif;
            font-size: 14px;
            transition: all 0.2s;
            background: #fafbfc;
        }

        .form-group input:focus, .form-group select:focus {
            outline: none;
            border-color: #3b82f6;
            background: white;
        }

        /* Chapter Sections */
        .chapter-section {
            margin-bottom: 32px;
        }

        .chapter-title {
            font-size: 18px;
            font-weight: 600;
            color: #0f172a;
            padding-bottom: 12px;
            border-bottom: 2px solid #e2e8f0;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .chapter-badge {
            background: #eef2ff;
            color: #3b82f6;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
        }

        /* Content Table */
        .content-table {
            width: 100%;
            background: white;
            border-radius: 16px;
            overflow: hidden;
            border: 1px solid #e2e8f0;
            border-collapse: collapse;
        }

        .content-table th {
            background: #f8fafc;
            padding: 14px 20px;
            text-align: left;
            font-size: 12px;
            font-weight: 600;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-bottom: 1px solid #e2e8f0;
        }

        .content-table td {
            padding: 16px 20px;
            border-bottom: 1px solid #f1f5f9;
            vertical-align: middle;
        }

        .content-table tr:last-child td {
            border-bottom: none;
        }

        .file-name {
            font-weight: 500;
            color: #0f172a;
            font-size: 14px;
        }

        .file-meta {
            font-size: 12px;
            color: #94a3b8;
            margin-top: 4px;
        }

        .file-type-badge {
            display: inline-block;
            padding: 4px 10px;
            background: #f1f5f9;
            border-radius: 6px;
            font-size: 11px;
            font-weight: 600;
            color: #475569;
            text-transform: uppercase;
        }

        .action-link {
            color: #3b82f6;
            text-decoration: none;
            font-size: 13px;
            font-weight: 500;
        }

        .action-link:hover {
            text-decoration: underline;
        }

        .delete-link {
            color: #dc2626;
            text-decoration: none;
            font-size: 13px;
            font-weight: 500;
        }

        .delete-link:hover {
            text-decoration: underline;
        }

        /* Buttons */
        .btn {
            padding: 10px 20px;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 500;
            font-family: 'Inter', sans-serif;
            border: none;
            cursor: pointer;
            transition: all 0.2s;
            text-decoration: none;
            display: inline-block;
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
            background: #f8fafc;
            border-color: #cbd5e1;
        }

        .btn-danger-outline {
            background: transparent;
            border: 1px solid #fecaca;
            color: #dc2626;
        }

        .btn-danger-outline:hover {
            background: #fef2f2;
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

        /* Loading Overlay */
        #loadingOverlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.95);
            z-index: 1000;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }

        .spinner {
            width: 48px;
            height: 48px;
            border: 3px solid #e2e8f0;
            border-top-color: #3b82f6;
            border-radius: 50%;
            animation: spin 0.8s linear infinite;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        .loading-text {
            margin-top: 16px;
            font-size: 14px;
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

    <div id="loadingOverlay">
        <div class="spinner"></div>
        <div class="loading-text">Uploading and processing file...</div>
    </div>

    <div class="container">
        <div class="breadcrumb">
            <a href="LectureDashboardServlett">Dashboard</a>
            <span>/</span>
            <a href="ModuleHomeServlet?moduleid=${currentModuleId}">${moduleCode}</a>
            <span>/</span>
            <span class="current">Content Management</span>
        </div>

        <div class="page-header">
            <div>
                <h1>Module Content</h1>
                <p>Manage learning materials for ${moduleName}</p>
            </div>
        </div>

        <div class="upload-card">
            <h2>Upload New Resource</h2>
            <form action="UploadContentServlett" method="POST" enctype="multipart/form-data" onsubmit="showLoading()">
                <input type="hidden" name="moduleid" value="${currentModuleId}">
                <div class="form-row">
                    <div class="form-group">
                        <label for="chapter">Chapter Number</label>
                        <input type="number" id="chapter" name="chapter" min="1" placeholder="e.g., 1" required>
                    </div>
                    <div class="form-group">
                        <label for="file">PDF Document</label>
                        <input type="file" id="file" name="file" accept="application/pdf" required>
                    </div>
                    <button type="submit" class="btn btn-primary">Upload File</button>
                </div>
            </form>
        </div>

        <c:set var="lastChapter" value="" />

        <c:forEach var="file" items="${contentList}">
            <c:if test="${file.chapter != lastChapter}">
                <c:if test="${not empty lastChapter}">
                        </tbody>
                    </table>
                </div>
                </c:if>
                <c:set var="lastChapter" value="${file.chapter}" />
                <div class="chapter-section">
                    <div class="chapter-title">
                        <span>Chapter ${file.chapter}</span>
                        <span class="chapter-badge">${file.chapter}</span>
                    </div>
                    <table class="content-table">
                        <thead>
                            <tr>
                                <th style="width: 45%">Resource Name</th>
                                <th style="width: 20%">Date Uploaded</th>
                                <th style="width: 15%">Format</th>
                                <th style="width: 20%">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
            </c:if>
            <tr>
                <td>
                    <div class="file-name">${file.fileName}</div>
                    <div class="file-meta">ID: ${file.id}</div>
                </td>
                <td class="file-meta">${file.date}</td>
                <td><span class="file-type-badge">${file.type}</span></td>
                <td>
                    <a href="${file.url}" target="_blank" class="action-link">View</a>
                    <span style="color: #cbd5e1; margin: 0 8px;">|</span>
                    <a href="DeleteContentServlett?id=${file.id}&moduleid=${currentModuleId}" 
                       class="delete-link" 
                       onclick="return confirm('Are you sure you want to delete this file? This action cannot be undone.')">Delete</a>
                </td>
            </tr>
        </c:forEach>

        <c:if test="${not empty lastChapter}">
                        </tbody>
                    </table>
                </div>
        </c:if>

        <c:if test="${empty contentList}">
            <div class="empty-state">
                <h3>No content uploaded yet</h3>
                <p>Use the upload form above to add your first learning resource.</p>
            </div>
        </c:if>
    </div>

    <script>
        function showLoading() {
            const fileInput = document.getElementById('file');
            if (fileInput && fileInput.files.length > 0) {
                document.getElementById('loadingOverlay').style.display = 'flex';
            }
        }
    </script>

</body>
</html>