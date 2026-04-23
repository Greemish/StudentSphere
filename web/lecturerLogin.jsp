<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Lecturer Login - Student Sphere</title>
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
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .login-container {
            display: flex;
            width: 1000px;
            max-width: 90%;
            background: white;
            border-radius: 24px;
            box-shadow: 0 20px 35px -10px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .login-left {
            flex: 1;
            background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%);
            padding: 48px;
            color: white;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .login-left h1 {
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 16px;
            letter-spacing: -0.5px;
        }

        .login-left p {
            font-size: 14px;
            line-height: 1.6;
            color: #94a3b8;
            margin-bottom: 32px;
        }

        .feature-list {
            list-style: none;
            margin-top: 24px;
        }

        .feature-list li {
            margin-bottom: 16px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 12px;
            color: #cbd5e1;
        }

        .feature-list li::before {
            content: "✓";
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 22px;
            height: 22px;
            background: rgba(59, 130, 246, 0.2);
            border-radius: 50%;
            color: #3b82f6;
            font-size: 12px;
            font-weight: bold;
        }

        .login-right {
            flex: 1;
            padding: 48px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .login-right h2 {
            font-size: 28px;
            font-weight: 600;
            color: #0f172a;
            margin-bottom: 8px;
            letter-spacing: -0.3px;
        }

        .login-right .subtitle {
            color: #64748b;
            font-size: 14px;
            margin-bottom: 32px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-size: 13px;
            font-weight: 500;
            color: #334155;
            margin-bottom: 8px;
        }

        .form-group input {
            width: 100%;
            padding: 12px 16px;
            font-size: 14px;
            border: 1.5px solid #e2e8f0;
            border-radius: 12px;
            font-family: 'Inter', sans-serif;
            transition: all 0.2s ease;
            background: #fafbfc;
        }

        .form-group input:focus {
            outline: none;
            border-color: #3b82f6;
            background: white;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }

        .login-btn {
            width: 100%;
            padding: 12px;
            background: #3b82f6;
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 15px;
            font-weight: 600;
            font-family: 'Inter', sans-serif;
            cursor: pointer;
            transition: all 0.2s ease;
            margin-top: 8px;
        }

        .login-btn:hover {
            background: #2563eb;
            transform: translateY(-1px);
        }

        .back-link {
            text-align: center;
            margin-top: 24px;
        }

        .back-link a {
            color: #64748b;
            font-size: 13px;
            text-decoration: none;
            transition: color 0.2s;
        }

        .back-link a:hover {
            color: #3b82f6;
        }

        .error-message {
            background: #fef2f2;
            border: 1px solid #fecaca;
            border-radius: 12px;
            padding: 12px;
            margin-bottom: 20px;
            color: #dc2626;
            font-size: 13px;
            text-align: center;
        }

        hr {
            margin: 24px 0;
            border: none;
            border-top: 1px solid #e2e8f0;
        }

        .info-text {
            font-size: 12px;
            color: #94a3b8;
            text-align: center;
            margin-top: 16px;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-left">
            <h1>Lecturer Portal</h1>
            <p>Manage your modules, create assessments, and engage with students from a single dashboard.</p>
            <ul class="feature-list">
                <li>Module content management</li>
                <li>Announcements and communication</li>
                <li>Quiz creation and grading</li>
                <li>Student progress tracking</li>
                <li>Study session coordination</li>
            </ul>
        </div>
        <div class="login-right">
            <h2>Welcome back</h2>
            <p class="subtitle">Sign in to access your lecturer dashboard</p>

            <% if (request.getParameter("error") != null) { %>
                <div class="error-message">
                    Invalid lecturer ID or password. Please try again.
                </div>
            <% } %>

            <form action="lecturerLoginServlett" method="post">
                <div class="form-group">
                    <label for="lecturerid">Lecturer ID</label>
                    <input type="text" id="lecturerid" name="lecturerid" placeholder="Enter your lecturer ID" required>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" placeholder="Enter your password" required>
                </div>

                <button type="submit" class="login-btn">Sign in</button>
            </form>

            <hr>

            <div class="back-link">
                <a href="login.jsp">← Back to portal selection</a>
            </div>
            <div class="info-text">
                Contact IT support if you forgot your lecturer ID
            </div>
        </div>
    </div>
</body>
</html>