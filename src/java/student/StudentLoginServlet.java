package student;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;


public class StudentLoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String studentNumber = request.getParameter("student_number");
        String password = request.getParameter("password");

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT student_number, name, surname, email, phone_number FROM student WHERE student_number = ? AND password = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, studentNumber);  // ← use setString, not setInt
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("studentNumber", rs.getString("student_number"));
                session.setAttribute("studentName", rs.getString("name"));
                session.setAttribute("studentSurname", rs.getString("surname"));
                session.setAttribute("studentEmail", rs.getString("email"));
                session.setAttribute("studentPhone", rs.getString("phone_number"));
                response.sendRedirect("studentDashboard.jsp");
            } else {
                request.setAttribute("error", "Invalid credentials");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}