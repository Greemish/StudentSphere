<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Signup</title>
    <link rel="stylesheet" type="text/css" href="signupStyle.css">
</head>
<body>
    <div class="container">
        <div class="signup-form">
            <h2>Grow Your Mind</h2>
            <form action="SignupServlet" method="post">
                <label for="student_number">Student Number</label>
                <input type="number" id="student_number" name="student_number" required>

                <label for="name">Name</label>
                <input type="text" id="name" name="name" required>

                <label for="surname">Surname</label>
                <input type="text" id="surname" name="surname" required>

                <label for="email">Email</label>
                <input type="email" id="email" name="email" required>

                <label for="password">Password</label>
                <input type="password" id="password" name="password" required>

                <label for="phone_number">Phone Number</label>
                <input type="text" id="phone_number" name="phone_number">
                
                <div class="terms">
                     
                        <label for="terms">
                            <input  style="width: 10px;margin-left:50px " type="checkbox" id="terms" name="terms" required>
                         I agree to the 
                         <a href="terms.jsp" target="_blank">Terms and Conditions</a>
                          </label>
                 </div>
                
                <button type="submit" id="signupBtn">Sign Up</button>
            </form>
            <p class="login-link">
                Already have an account? <a href="login.jsp">Login</a>
            </p>
        </div>
    </div>
</body>
</html>