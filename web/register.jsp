<%@page import="student.DBConnection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Random, java.sql.*" %>
<%
    String action = request.getParameter("action");
    String message = null;
    String error = null;
    String email = request.getParameter("email");
    String displayedCode = null;

    if ("sendCode".equals(action)) {
        if (email == null || !email.matches("^[a-zA-Z0-9._%+-]+@tut4life\\.ac\\.za$")) {
            error = "Invalid email address. Must end with @tut4life.ac.za";
        } else {
            Random rand = new Random();
            int code = 100000 + rand.nextInt(900000);
            String codeStr = String.valueOf(code);
            displayedCode = codeStr;

            Connection conn = null;
            PreparedStatement ps = null;
            try {
                conn = DBConnection.getConnection();
                String deleteSql = "DELETE FROM verification_codes WHERE email = ? AND used = FALSE";
                ps = conn.prepareStatement(deleteSql);
                ps.setString(1, email);
                ps.executeUpdate();
                ps.close();
                String insertSql = "INSERT INTO verification_codes (email, code) VALUES (?, ?)";
                ps = conn.prepareStatement(insertSql);
                ps.setString(1, email);
                ps.setString(2, codeStr);
                ps.executeUpdate();
                session.setAttribute("signupEmail", email);
                message = "Verification code generated successfully!";
            } catch (Exception e) {
                e.printStackTrace();
                error = "Database error: " + e.getMessage();
            } finally {
                try { if (ps != null) ps.close(); } catch (Exception e) {}
                try { if (conn != null) conn.close(); } catch (Exception e) {}
            }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Registration</title>
    <link rel="stylesheet" type="text/css" href="signupStyle.css">
</head>
<body>
    <a href="login.jsp" class="back-button">← Back</a>
    <div class="container">
        <div class="signup-form">
            <h2>Grow Your Mind</h2>

            <% if (error != null) { %>
                <div class="error-message"><%= error %></div>
            <% } %>
            <% if (message != null) { %>
                <div class="success-message"><%= message %></div>
            <% } %>
            <% if (displayedCode != null) { %>
                <div class="code-box">Verification Code: <%= displayedCode %></div>
            <% } %>

            <!-- Step 1: Request code -->
            <form method="post">
                <input type="hidden" name="action" value="sendCode">
                <label for="email">TUT4Life Email</label>
                <input type="email" id="email" name="email" required
       pattern="[0-9]{9}@tut4life\.ac\.za"
       placeholder="123456789@tut4life.ac.za"
       value="<%= email != null ? email : "" %>">
                <button type="submit">Send Verification Code</button>
            </form>

            <!-- Step 2: Complete signup (only if code generated) -->
            <%
                String sessionEmail = (String) session.getAttribute("signupEmail");
                if (sessionEmail != null && error == null && displayedCode != null) {
            %>
            <form action="${pageContext.request.contextPath}/SignupServlet" method="post">
                <input type="hidden" name="csrfToken" value="${csrfToken}">
                <label for="verification_code">Verification Code</label>
                <input type="text" id="verification_code" name="verification_code" required pattern="[0-9]{6}">

                <label for="student_number">Student Number (9 digits, same as email prefix)</label>
<input type="text" id="student_number" name="student_number" required
       pattern="\d{9}" maxlength="9" 
       title="Student number must be exactly 9 digits and match the numeric prefix of your email">

                <label for="name">Name</label>
                <input type="text" id="name" name="name" required pattern="[A-Za-z\s\-']+">

                <label for="surname">Surname</label>
                <input type="text" id="surname" name="surname" required pattern="[A-Za-z\s\-']+">

                <label for="email">Email (same as above)</label>
                <input type="email" id="email_signup" name="email" required readonly value="<%= sessionEmail %>">

                <label for="password">Password</label>
                <input type="password" id="password" name="password" required>

                <label for="phone_number">Phone Number</label>
                <input type="tel" id="phone_number" name="phone_number" required pattern="\d{10}">

                <div class="terms">
                    <label>
                        <input type="checkbox" name="terms" required> I agree to the <a href="terms.jsp">Terms and Conditions</a>
                    </label>
                </div>

                <button type="submit">Complete Signup</button>
            </form>
            <% } else if (sessionEmail == null && action == null) { %>
                <p style="text-align:center; margin-top:1rem;">Enter your TUT4Life email above and click "Send Verification Code".</p>
            <% } %>
        </div>
    </div>
</body>
</html>