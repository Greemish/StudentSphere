package student;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;


public class TakeQuizServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String studentNumber = (String) session.getAttribute("studentNumber");
        if (studentNumber == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Map<String, String>> quizzes = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT q.id, q.title, q.description, m.module_name " +
                         "FROM quizzes q " +
                         "JOIN modules m ON q.module_id = m.id " +
                         "JOIN student_modules sm ON m.id = sm.module_id " +
                         "WHERE sm.student_number = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, studentNumber);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> quiz = new HashMap<>();
                quiz.put("id", String.valueOf(rs.getInt("id")));
                quiz.put("title", rs.getString("title"));
                quiz.put("description", rs.getString("description"));
                quiz.put("module", rs.getString("module_name"));
                quizzes.add(quiz);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        request.setAttribute("quizzes", quizzes);
        request.getRequestDispatcher("takeQuiz.jsp").forward(request, response);
    }
}