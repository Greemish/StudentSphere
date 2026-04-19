<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login - Student Sphere</title>
    <link rel="stylesheet" type="text/css" href="loginStyle.css">
</head>
<body>

<div class="login-container">
    <div class="login-card">
        <h2>Student Sphere Login</h2>

        <!-- Student Login Form - Fixed broken attribute -->
        <form action="StudentLoginServlet" method="post">
            <input type="text" name="student_number" placeholder="Student Number" required aria-label="Student Number">
            <input type="password" name="password" placeholder="Password" required aria-label="Password">
            <button type="submit" name="role" value="student" id="studentBtn">Student Login</button>
        </form>

        <!-- Mentor Login Form - added hidden role for consistency -->
        <form action="mentorLogin.jsp" method="post">
            <button type="submit" name="role" value="mentor" id="mentorBtn">Mentor Login</button>
        </form>

        <!-- Lecturer Login Form - added method and role -->
        <form action="lecturerLogin.jsp" method="post">
            <button type="submit" name="role" value="lecturer" id="lecturerBtn">Lecturer Login</button>
        </form>

        <!-- Back button - preserved functionality, added data attribute for Java -->
        <form action="index.html" method="post">
            <input type="submit" value="← Back" data-back-url="index.html">
        </form>

        <p>Don’t have an account? <a href="register.jsp" data-page="register">Register here</a></p>
    </div>
</div>

</body>
</html>