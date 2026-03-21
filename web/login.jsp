<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login - Student Sphere</title>
    <link rel="stylesheet" type="text/css" href="loginStyle.css">
</head>
<body>

<div class="login-container">

    <div class="login-card">
        <h2>Student Sphere Login</h2>

        <form action="StudentLoginServlet" method="post">

           
            <input type="text" name="student_number" placeholder="Username" required>
            <input type="password" name="password" placeholder="Password" required>

            <button type="submit" name="value="student" id="studentBtn">Student Login</button>
          

        </form>
        <form action="mentorLogin.jsp">
            <button type="submit" value="mentor" id="mentorBtn">Mentor Login</button>
        </form>
        <form action="lecturerLogin.jsp">
            <button type="submit"  value="lecturer" id="lecturerBtn">Lecturer Login</button>
        </form>
          
            

        <p>Don’t have an account? <a href="register.jsp">Register here</a></p>   
    </div>
     
</div>

</body>
</html>