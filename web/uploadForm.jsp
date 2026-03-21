<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Upload Content</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #f4f7f9; padding: 50px; }
        .form-container { background: white; padding: 30px; border-radius: 10px; max-width: 500px; margin: auto; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
        .form-group { margin-bottom: 20px; }
        label { display: block; margin-bottom: 8px; font-weight: bold; }
        input[type="file"] { width: 100%; padding: 10px; border: 1px dashed #3498db; border-radius: 5px; }
        .btn-submit { background: #27ae60; color: white; border: none; padding: 12px 20px; border-radius: 5px; cursor: pointer; width: 100%; font-size: 1rem; }
    </style>
</head>
<body>

<div class="form-container">
    <h2>Add Content to ${param.moduleid}</h2>
    
    <form action="UploadContentServlett" method="POST" enctype="multipart/form-data">
        <input type="hidden" name="moduleid" value="${param.moduleid}">
        
        <div class="form-group">
            <label>Select File (PDF, ZIP, etc.)</label>
            <input type="file" name="file" required>
        </div>

        <button type="submit" class="btn-submit">Upload to Module</button>
    </form>
    <br>
    <a href="ModuleContentServlett?moduleid=${param.moduleid}">Cancel</a>
</div>

</body>
</html>