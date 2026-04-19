package student;

import java.sql.Connection;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/SignupServlet")
public class SignupServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // CSRF protection (optional)
        String sessionToken = (String) session.getAttribute("csrfToken");
        String requestToken = request.getParameter("csrfToken");
        if (sessionToken != null && !sessionToken.equals(requestToken)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid CSRF token");
            return;
        }

        // Get parameters
        String studentNumberStr = request.getParameter("student_number");
        String name = request.getParameter("name");
        String surname = request.getParameter("surname");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phoneNumber = request.getParameter("phone_number");
        String codeInput = request.getParameter("verification_code");

        // ========== VALIDATIONS ==========

        // 1. Email domain
        if (email == null || !email.matches("^[a-zA-Z0-9._%+-]+@tut4life\\.ac\\.za$")) {
            request.setAttribute("error", "Email must end with @tut4life.ac.za");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // 2. Phone number (exactly 10 digits)
        if (phoneNumber == null || !phoneNumber.matches("\\d{10}")) {
            request.setAttribute("error", "Phone number must be exactly 10 digits");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // 3. Name & surname (no digits)
        if (!name.matches("[A-Za-z\\s\\-']+") || !surname.matches("[A-Za-z\\s\\-']+")) {
            request.setAttribute("error", "Name and surname cannot contain digits");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

     // 4. Student number: exactly 9 digits
if (studentNumberStr == null || !studentNumberStr.matches("\\d{9}")) {
    request.setAttribute("error", "Student number must be exactly 9 digits");
    request.getRequestDispatcher("register.jsp").forward(request, response);
    return;
}

// 5. Student number must match email prefix (first 9 digits of email)
String emailPrefix = email.split("@")[0];
if (!emailPrefix.matches("\\d{9}")) {
    request.setAttribute("error", "Your email prefix must be exactly 9 digits (e.g., 123456789@tut4life.ac.za)");
    request.getRequestDispatcher("register.jsp").forward(request, response);
    return;
}
if (!studentNumberStr.equals(emailPrefix)) {
    request.setAttribute("error", "Student number must match the first 9 digits of your email. Expected: " + emailPrefix);
    request.getRequestDispatcher("register.jsp").forward(request, response);
    return;
}
        // Verify code from database
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        boolean codeValid = false;
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT code FROM verification_codes WHERE email = ? AND used = FALSE ORDER BY created_at DESC LIMIT 1";
            ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            rs = ps.executeQuery();
            if (rs.next()) {
                String dbCode = rs.getString("code");
                if (dbCode.equals(codeInput)) {
                    codeValid = true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error during verification");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }

        if (!codeValid) {
            request.setAttribute("error", "Invalid or expired verification code");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Insert student (student_number stored as VARCHAR or BIGINT – using String here)
        Connection conn2 = null;
        PreparedStatement psInsert = null;
        PreparedStatement psUpdate = null;
        try {
            conn2 = DBConnection.getConnection();
            conn2.setAutoCommit(false);

            // Note: student_number is stored as VARCHAR(13) in the database
            String insertSql = "INSERT INTO student (student_number, name, surname, email, password, phone_number) VALUES (?, ?, ?, ?, ?, ?)";
            psInsert = conn2.prepareStatement(insertSql);
            psInsert.setString(1, studentNumberStr);   // now String, not int
            psInsert.setString(2, name);
            psInsert.setString(3, surname);
            psInsert.setString(4, email);
            psInsert.setString(5, password);
            psInsert.setString(6, phoneNumber);
            int rows = psInsert.executeUpdate();

            if (rows > 0) {
                String updateSql = "UPDATE verification_codes SET used = TRUE WHERE email = ? AND code = ?";
                psUpdate = conn2.prepareStatement(updateSql);
                psUpdate.setString(1, email);
                psUpdate.setString(2, codeInput);
                psUpdate.executeUpdate();

                conn2.commit();
                session.removeAttribute("signupEmail");
                request.setAttribute("message", "Signup successful! Please login.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } else {
                conn2.rollback();
                request.setAttribute("error", "Signup failed. Please try again.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            try { if (conn2 != null) conn2.rollback(); } catch (Exception ex) {}
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("register.jsp").forward(request, response);
        } finally {
            try { if (psInsert != null) psInsert.close(); } catch (Exception e) {}
            try { if (psUpdate != null) psUpdate.close(); } catch (Exception e) {}
            try { if (conn2 != null) conn2.close(); } catch (Exception e) {}
        }
    }
}