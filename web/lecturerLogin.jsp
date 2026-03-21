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

        <form action="lecturerLoginServlett" method="post">

           
            <input type="text" name="lecturerid" placeholder="Username" required>
            <input type="password" name="password" placeholder="Password" required>

            <button type="submit" name="value="student" id="studentBtn">Lecturer Login</button>
          
        </form>
        
          
            

        <p><a href="login.jsp">Click here to go back</a></p>
    </div>

</div>

</body>
</html>