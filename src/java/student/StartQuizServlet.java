package student;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;


public class StartQuizServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("studentNumber") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        int quizId = Integer.parseInt(request.getParameter("quizid"));
        List<Map<String, String>> questions = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT id, question_text, option_a, option_b, option_c, option_d FROM quiz_questions WHERE quiz_id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, quizId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> q = new HashMap<>();
                q.put("id", String.valueOf(rs.getInt("id")));
                q.put("text", rs.getString("question_text"));
                q.put("a", rs.getString("option_a"));
                q.put("b", rs.getString("option_b"));
                q.put("c", rs.getString("option_c"));
                q.put("d", rs.getString("option_d"));
                questions.add(q);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        request.setAttribute("questions", questions);
        request.setAttribute("quizId", quizId);
        request.getRequestDispatcher("quizQuestions.jsp").forward(request, response);
    }
}