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
    <title>Module Messages - ${moduleCode}</title>
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
            max-width: 1000px;
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

        /* Alert Messages */
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

        /* Message Card */
        .message-card {
            background: white;
            border-radius: 20px;
            border: 1px solid #e2e8f0;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
        }

        .message-item {
            padding: 24px;
            border-bottom: 1px solid #f1f5f9;
            display: flex;
            gap: 16px;
            transition: background 0.2s;
        }

        .message-item:last-child {
            border-bottom: none;
        }

        .message-item:hover {
            background: #fafbfc;
        }

        /* Avatar */
        .avatar {
            width: 48px;
            height: 48px;
            background: #eef2ff;
            color: #3b82f6;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 18px;
            flex-shrink: 0;
        }

        /* Message Content */
        .message-content {
            flex: 1;
        }

        .sender-info {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 8px;
            flex-wrap: wrap;
        }

        .sender-name {
            font-weight: 600;
            font-size: 15px;
            color: #0f172a;
        }

        .message-date {
            font-size: 12px;
            color: #94a3b8;
        }

        .message-text {
            color: #475569;
            font-size: 14px;
            line-height: 1.5;
        }

        /* Reply Button */
        .reply-btn {
            background: #3b82f6;
            color: white;
            border: none;
            padding: 8px 20px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 500;
            font-family: 'Inter', sans-serif;
            cursor: pointer;
            transition: all 0.2s;
            white-space: nowrap;
        }

        .reply-btn:hover {
            background: #2563eb;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px;
            color: #94a3b8;
        }

        .empty-state p {
            font-size: 14px;
            margin-top: 8px;
        }

        /* Modal */
        #replyModal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 1000;
            align-items: center;
            justify-content: center;
        }

        .modal-content {
            background: white;
            border-radius: 24px;
            width: 90%;
            max-width: 500px;
            overflow: hidden;
        }

        .modal-header {
            padding: 20px 24px;
            border-bottom: 1px solid #f1f5f9;
        }

        .modal-header h2 {
            font-size: 20px;
            font-weight: 600;
            color: #0f172a;
        }

        .modal-body {
            padding: 24px;
        }

        .student-info {
            background: #f8fafc;
            padding: 12px 16px;
            border-radius: 12px;
            margin-bottom: 20px;
            font-size: 14px;
            color: #475569;
        }

        .student-info strong {
            color: #0f172a;
        }

        .modal-textarea {
            width: 100%;
            padding: 14px;
            font-size: 14px;
            font-family: 'Inter', sans-serif;
            border: 1.5px solid #e2e8f0;
            border-radius: 12px;
            resize: vertical;
            min-height: 120px;
            transition: all 0.2s;
        }

        .modal-textarea:focus {
            outline: none;
            border-color: #3b82f6;
        }

        .modal-footer {
            display: flex;
            gap: 12px;
            margin-top: 20px;
        }

        .btn-send {
            flex: 1;
            background: #3b82f6;
            color: white;
            border: none;
            padding: 12px;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 500;
            font-family: 'Inter', sans-serif;
            cursor: pointer;
        }

        .btn-send:hover {
            background: #2563eb;
        }

        .btn-cancel {
            flex: 1;
            background: #f1f5f9;
            color: #64748b;
            border: none;
            padding: 12px;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 500;
            font-family: 'Inter', sans-serif;
            cursor: pointer;
        }

        .btn-cancel:hover {
            background: #e2e8f0;
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
            <span class="current">Messages</span>
        </div>

        <div class="page-header">
            <h1>Module Messages</h1>
            <p>Conversations with students in ${moduleName}</p>
        </div>

        <!-- Success/Error Messages -->
        <% if (request.getParameter("success") != null) { %>
            <div class="alert alert-success">Message sent successfully.</div>
        <% } %>

        <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-error">
                <% 
                    String error = request.getParameter("error");
                    if (error.equals("missing_student")) {
                        out.print("Please select a student to message.");
                    } else if (error.equals("missing_message")) {
                        out.print("Please enter a message.");
                    } else if (error.equals("invalid_student")) {
                        out.print("Selected student is not enrolled in this module.");
                    } else {
                        out.print("An error occurred. Please try again.");
                    }
                %>
            </div>
        <% } %>

        <div class="message-card">
            <c:choose>
                <c:when test="${not empty messageList}">
                    <c:forEach var="msg" items="${messageList}">
                        <div class="message-item">
                            <div class="avatar">
                                S
                            </div>
                            <div class="message-content">
                                <div class="sender-info">
                                    <span class="sender-name">${msg.sender}</span>
                                    <span class="message-date">${msg.date}</span>
                                </div>
                                <div class="message-text">${msg.text}</div>
                            </div>
                            <div>
                                <button class="reply-btn" onclick="openReplyModal('${msg.studentNumber}', '${msg.sender}')">Reply</button>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <p>No messages yet</p>
                        <p style="font-size: 13px;">When students send messages, they will appear here.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Reply Modal -->
    <div id="replyModal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Reply to Student</h2>
            </div>
            <div class="modal-body">
                <div class="student-info" id="studentInfo">
                    <strong>Student:</strong> <span id="studentName"></span>
                </div>
                <form action="LecturerMessagesServlet" method="POST" id="replyForm">
                    <input type="hidden" name="moduleid" value="${moduleId}">
                    <input type="hidden" name="student_number" id="studentNumberInput">
                    <textarea name="content" class="modal-textarea" placeholder="Type your reply here..." required></textarea>
                    <div class="modal-footer">
                        <button type="button" class="btn-cancel" onclick="closeModal()">Cancel</button>
                        <button type="submit" class="btn-send">Send Reply</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        function openReplyModal(studentNumber, studentName) {
            document.getElementById('studentNumberInput').value = studentNumber;
            document.getElementById('studentName').innerText = studentName;
            document.getElementById('replyModal').style.display = 'flex';
        }

        function closeModal() {
            document.getElementById('replyModal').style.display = 'none';
            document.getElementById('replyForm').reset();
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            let modal = document.getElementById('replyModal');
            if (event.target === modal) {
                closeModal();
            }
        };
    </script>

</body>
</html>