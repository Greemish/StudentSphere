<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>

<html>
<head>
    <title>Upload Content</title>

```
<!-- Font -->
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">

<style>
    * {
        box-sizing: border-box;
        font-family: 'Poppins', sans-serif;
    }

    body {
        margin: 0;
        height: 100vh;

        background: linear-gradient(rgba(0,0,0,0.65), rgba(0,0,0,0.75)),
                    url('https://images.unsplash.com/photo-1523050854058-8df90110c9f1');
        background-size: cover;
        background-position: center;

        display: flex;
        align-items: center;
        justify-content: center;
    }

    .form-container {
        width: 400px;
        padding: 30px;

        background: rgba(255,255,255,0.12);
        backdrop-filter: blur(15px);
        border-radius: 20px;
        border: 1px solid rgba(255,255,255,0.3);

        color: white;
        text-align: center;

        box-shadow: 0 20px 40px rgba(0,0,0,0.4);
    }

    h2 {
        margin-bottom: 20px;
    }

    .form-group {
        margin-bottom: 20px;
        text-align: left;
    }

    label {
        font-weight: 500;
        font-size: 0.9rem;
    }

    input[type="file"] {
        width: 100%;
        padding: 10px;
        margin-top: 8px;

        border-radius: 10px;
        border: 1px dashed rgba(255,255,255,0.6);
        background: rgba(255,255,255,0.1);
        color: white;
        cursor: pointer;
    }

    .file-name {
        margin-top: 10px;
        font-size: 0.85rem;
        opacity: 0.8;
    }

    .btn-submit {
        width: 100%;
        padding: 12px;
        margin-top: 10px;

        border: none;
        border-radius: 10px;

        background: #27ae60;
        color: white;
        font-weight: 600;

        cursor: pointer;
        transition: 0.3s;
    }

    .btn-submit:hover {
        background: #1e8449;
        transform: scale(1.03);
    }

    .cancel-link {
        display: block;
        margin-top: 15px;
        color: #ddd;
        text-decoration: none;
        font-size: 0.9rem;
    }

    .cancel-link:hover {
        text-decoration: underline;
    }

</style>
```

</head>
<body>

<div class="form-container">
    <h2>📤 Upload to ${param.moduleid}</h2>

```
<form action="UploadContentServlett" method="POST" enctype="multipart/form-data">
    <input type="hidden" name="moduleid" value="${param.moduleid}">

    <div class="form-group">
        <label>Select File (PDF, ZIP, etc.)</label>
        <input type="file" name="file" id="fileInput" required>
        <div class="file-name" id="fileName">No file selected</div>
    </div>

    <button type="submit" class="btn-submit">Upload</button>
</form>

<a class="cancel-link" href="ModuleContentServlett?moduleid=${param.moduleid}">← Cancel</a>
```

</div>

<script>
    const fileInput = document.getElementById("fileInput");
    const fileName = document.getElementById("fileName");

    fileInput.addEventListener("change", function() {
        if (this.files.length > 0) {
            fileName.textContent = "Selected: " + this.files[0].name;
        } else {
            fileName.textContent = "No file selected";
        }
    });
</script>

</body>
</html>
