package student;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;


public class SubmitAdaptiveQuizServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String studentNumber = (String) session.getAttribute("studentNumber");
        if (studentNumber == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int score = 0;
        int total = 0;
        List<Map<String, String>> results = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {
            for (int i = 1; i <= 10; i++) {
                String answer = request.getParameter("q" + i);
                if (answer == null) break;
                total++;
                String correct = request.getParameter("correct" + i);
                String topic = request.getParameter("topic" + i);
                String questionText = request.getParameter("questionText" + i); // you need to pass this from JSP
                boolean isCorrect = answer.equals(correct);
                if (isCorrect) score++;

                // Store result
                Map<String, String> res = new HashMap<>();
                res.put("question", questionText != null ? questionText : "Question " + i);
                res.put("userAnswer", answer);
                res.put("correctAnswer", correct);
                res.put("isCorrect", String.valueOf(isCorrect));
                results.add(res);

                if (!isCorrect && topic != null && !topic.isEmpty()) {
                    String upsert = "INSERT INTO weak_topics (student_number, topic_name, weakness_count) VALUES (?, ?, 1) ON CONFLICT (student_number, topic_name) DO UPDATE SET weakness_count = weak_topics.weakness_count + 1";
                    PreparedStatement ps = conn.prepareStatement(upsert);
                    ps.setString(1, studentNumber);
                    ps.setString(2, topic);
                    ps.executeUpdate();
                    ps.close();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        session.setAttribute("quizResults", results);
        session.setAttribute("quizScore", score);
        session.setAttribute("quizTotal", total);
        response.sendRedirect("quizResultDetails.jsp");
    }
}