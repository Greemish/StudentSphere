<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Module - ${currentModuleId}</title>

    <style>
        :root { --primary: #3498db; --danger: #e74c3c; --success: #27ae60; --bg: #f4f7f9; }
        body { font-family: 'Segoe UI', sans-serif; background-color: var(--bg); margin: 0; padding: 40px; }

        .section { display: none; }
        .section.active { display: block; }

        .hub {
            max-width: 900px;
            margin: auto;
            background: white;
            padding: 40px;
            border-radius: 12px;
            text-align: center;
            box-shadow: 0 5px 20px rgba(0,0,0,0.05);
        }

        .hub-buttons {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 30px;
        }

        .btn {
            padding: 14px 28px;
            border-radius: 8px;
            border: none;
            font-weight: 600;
            cursor: pointer;
            transition: 0.2s;
        }

        .btn-primary { background: var(--primary); color: white; }
        .btn-success { background: var(--success); color: white; }
        .btn-back { background: #ecf0f1; color: #555; margin-bottom: 20px; }

        .btn:hover { opacity: 0.9; transform: translateY(-2px); }
    </style>

    <!-- ✅ Your original styles stay exactly as-is below -->
    <style>
        .container { max-width: 1000px; margin: auto; background: white; padding: 30px; border-radius: 12px; box-shadow: 0 5px 20px rgba(0,0,0,0.05); }

        .header-section { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #eee; padding-bottom: 15px; margin-bottom: 20px; }
        .btn-back-link { text-decoration: none; color: var(--primary); font-weight: bold; font-size: 0.9rem; }

        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 15px; text-align: left; border-bottom: 1px solid #f0f0f0; }
        th { background-color: #f8f9fa; color: #666; text-transform: uppercase; font-size: 0.8rem; }

        .file-type { padding: 4px 8px; border-radius: 4px; font-size: 0.75rem; font-weight: bold; color: white; }
        .pdf { background: #e74c3c; }
        .zip { background: #f1c40f; color: #333; }
        .doc { background: #2980b9; }
        .default-type { background: #95a5a6; }

        .actions-footer { margin-top: 40px; display: flex; gap: 15px; padding-top: 20px; border-top: 1px solid #eee; }

        .btn-add { background: var(--success); color: white; }
        .btn-remove { background: #ecf0f1; color: #7f8c8d; }
        .btn-delete-row { color: var(--danger); font-size: 0.85rem; text-decoration: none; font-weight: bold; }

        .delete-col { display: none; }
    </style>
</head>

<body>

<!-- ================= MODULE HUB ================= -->
<div id="hub" class="section active">
    <div class="hub">
        <h1>Module: ${currentModuleId}</h1>
        <p>What would you like to manage?</p>

        <div class="hub-buttons">
            <button class="btn btn-primary" onclick="showSection('management')">
                Module Management
            </button>
            <button class="btn btn-success" onclick="showSection('announcements')">
                Announcements
            </button>
        </div>
    </div>
</div>

<!-- ================= MODULE MANAGEMENT (YOUR ORIGINAL LAYOUT) ================= -->
<div id="management" class="section">
    <button class="btn btn-back" onclick="goBack()">← Back</button>

    <!-- ✅ YOUR PAGE STARTS HERE (layout unchanged) -->
    <div class="container">
        <div class="header-section">
            <div>
                <a href="#" class="btn-back-link">Content Management</a>
                <h1 style="margin: 10px 0 0 0;">Module: ${currentModuleId}</h1>
            </div>
            <span style="color: #95a5a6;">Content Management</span>
        </div>

        <table>
            <thead>
            <tr>
                <th>Date Added</th>
                <th>File Name</th>
                <th>Format</th>
                <th>Access</th>
                <th class="delete-col">Admin</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="file" items="${contentList}">
                <tr>
                    <td>${file.date}</td>
                    <td style="font-weight: 500;">${file.fileName}</td>
                    <td>
                        <span class="file-type">
                            ${file.type}
                        </span>
                    </td>
                    <td>
                        <a href="${file.url}" target="_blank" class="btn-back-link">Download</a>
                    </td>
                    <td class="delete-col">
                        <a href="DeleteContentServlett?id=${file.id}&moduleid=${currentModuleId}"
                           class="btn-delete-row"
                           onclick="return confirm('Permanent delete: Are you sure?')">
                            Delete
                        </a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>

        <div class="actions-footer">
            <a href="uploadForm.jsp?moduleid=${currentModuleId}" class="btn btn-add">+ Add Content</a>
            <button type="button" class="btn btn-remove" onclick="toggleDeleteMode()">Manage / Remove Content</button>
        </div>
    </div>
</div>

<!-- ================= ANNOUNCEMENTS ================= -->
<div id="announcements" class="section">
    <button class="btn btn-back" onclick="goBack()">← Back</button>

    <div class="container">

        <!-- Header -->
        <div class="header-section">
            <div>
                <h1 style="margin:0;">Create Announcement</h1>
                <p style="margin:6px 0 0; color:#95a5a6;">
                    Post an update that all students in this module can see
                </p>
            </div>
            <span style="color:#95a5a6;">Announcements</span>
        </div>

        <!-- Form -->
        <form action="CreateAnnouncementServlet"
              method="post"
              enctype="multipart/form-data">

            <input type="hidden" name="moduleid" value="${currentModuleId}" />

            <!-- Title -->
            <div style="margin-bottom:20px;">
                <label style="font-weight:600; display:block; margin-bottom:8px;">
                    Announcement Title
                </label>
                <input type="text"
                       name="title"
                       required
                       placeholder="e.g. Test postponed, New material uploaded"
                       style="width:100%; padding:14px; border-radius:8px; border:1px solid #ccc;">
            </div>

            <!-- Message -->
            <div style="margin-bottom:25px;">
                <label style="font-weight:600; display:block; margin-bottom:8px;">
                    Announcement Message
                </label>
                <textarea name="message"
                          rows="7"
                          required
                          placeholder="Write the announcement message here..."
                          style="width:100%; padding:14px; border-radius:8px; border:1px solid #ccc; resize:vertical;"></textarea>
            </div>

            <!-- Attachments -->
            <div style="margin-bottom:30px;">
                <label style="font-weight:600; display:block; margin-bottom:8px;">
                    Optional Attachments
                </label>
                <div style="background:#f8f9fa; padding:15px; border-radius:8px; border:1px dashed #ccc;">
                    <input type="file"
                           name="attachments"
                           multiple
                           accept=".pdf,.doc,.docx,image/*">
                    <p style="margin:8px 0 0; font-size:0.85rem; color:#7f8c8d;">
                        You may attach documents or images related to this announcement
                    </p>
                </div>
            </div>

            <!-- Actions -->
            <div class="actions-footer">
                <button type="submit" class="btn btn-add">
                    Post Announcement
                </button>
            </div>
        </form>

    </div>
</div>

<script>
    function showSection(id) {
        document.querySelectorAll('.section').forEach(s => s.classList.remove('active'));
        document.getElementById(id).classList.add('active');
    }

    function goBack() {
        document.querySelectorAll('.section').forEach(s => s.classList.remove('active'));
        document.getElementById('hub').classList.add('active');
    }

    let deleteMode = false;
    function toggleDeleteMode() {
        deleteMode = !deleteMode;
        document.querySelectorAll('.delete-col')
            .forEach(col => col.style.display = deleteMode ? 'table-cell' : 'none');
    }
</script>

</body>
</html>