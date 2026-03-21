<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Module Content - ${currentModuleId}</title>
    <style>
        :root { --primary: #3498db; --danger: #e74c3c; --success: #27ae60; --bg: #f4f7f9; }
        body { font-family: 'Segoe UI', sans-serif; background-color: var(--bg); margin: 0; padding: 40px; }
        .container { max-width: 1000px; margin: auto; background: white; padding: 30px; border-radius: 12px; box-shadow: 0 5px 20px rgba(0,0,0,0.05); }
        
        .header-section { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #eee; padding-bottom: 15px; margin-bottom: 20px; }
        .btn-back { text-decoration: none; color: var(--primary); font-weight: bold; font-size: 0.9rem; }
        
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 15px; text-align: left; border-bottom: 1px solid #f0f0f0; }
        th { background-color: #f8f9fa; color: #666; text-transform: uppercase; font-size: 0.8rem; }
        
        .file-type { padding: 4px 8px; border-radius: 4px; font-size: 0.75rem; font-weight: bold; color: white; }
        .pdf { background: #e74c3c; }
        .zip { background: #f1c40f; color: #333; }
        .doc { background: #2980b9; }
        .default-type { background: #95a5a6; }

        .actions-footer { margin-top: 40px; display: flex; gap: 15px; padding-top: 20px; border-top: 1px solid #eee; }
        
        .btn { padding: 12px 25px; border-radius: 8px; border: none; cursor: pointer; font-weight: 600; transition: 0.2s; text-decoration: none; display: inline-block; }
        .btn-add { background: var(--success); color: white; }
        .btn-remove { background: #ecf0f1; color: #7f8c8d; }
        .btn-delete-row { color: var(--danger); font-size: 0.85rem; text-decoration: none; font-weight: bold; }
        
        .btn:hover { opacity: 0.9; transform: translateY(-2px); }
        .delete-col { display: none; } /* Hidden by default, shown when "Remove Content" is clicked */
    </style>
</head>
<body>

<div class="container">
    <div class="header-section">
        <div>
            <a href="LectureDashboardServlett" class="btn-back">← Back to Dashboard</a>
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
                        <span class="file-type ${file.type.toLowerCase() == 'pdf' ? 'pdf' : (file.type.toLowerCase() == 'zip' ? 'zip' : 'default-type')}">
                            ${file.type.toUpperCase()}
                        </span>
                    </td>
                    <td>
                        <a href="${file.url}" target="_blank" class="btn-back" style="color: var(--primary);">Download</a>
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

    <c:if test="${empty contentList}">
        <div style="text-align: center; padding: 40px; color: #bdc3c7;">
            <p>No files have been uploaded for this module.</p>
        </div>
    </c:if>

    <div class="actions-footer">
        <%-- Link to the Upload Form, passing the moduleid --%>
        <a href="uploadForm.jsp?moduleid=${currentModuleId}" class="btn btn-add">+ Add Content</a>
        
        <%-- Toggles the visibility of the delete column --%>
        <button type="button" class="btn btn-remove" onclick="toggleDeleteMode()">Manage / Remove Content</button>
    </div>
</div>

<script>
    let deleteMode = false;

    function toggleDeleteMode() {
        deleteMode = !deleteMode;
        const deleteCols = document.querySelectorAll('.delete-col');
        const removeBtn = document.querySelector('.btn-remove');
        
        deleteCols.forEach(col => {
            col.style.display = deleteMode ? 'table-cell' : 'none';
        });

        if (deleteMode) {
            removeBtn.style.background = '#34495e';
            removeBtn.style.color = 'white';
            removeBtn.innerText = 'Exit Delete Mode';
        } else {
            removeBtn.style.background = '#ecf0f1';
            removeBtn.style.color = '#7f8c8d';
            removeBtn.innerText = 'Manage / Remove Content';
        }
    }
</script>

</body>
</html>