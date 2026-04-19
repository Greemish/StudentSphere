package student;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;


public class SubmitQuizServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String studentNumber = (String) session.getAttribute("studentNumber");
        if (studentNumber == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        int quizId = Integer.parseInt(request.getParameter("quizId"));
        int total = Integer.parseInt(request.getParameter("totalQuestions"));
        int score = 0;
        List<Map<String, String>> results = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {
            java.util.Enumeration<String> paramNames = request.getParameterNames();
            while (paramNames.hasMoreElements()) {
                String param = paramNames.nextElement();
                if (param.startsWith("q")) {
                    String questionId = param.substring(1);
                    String userAnswer = request.getParameter(param);
                    // Fetch correct answer and question text
                    String sql = "SELECT question_text, correct_option, topic FROM quiz_questions WHERE id = ?";
                    PreparedStatement ps = conn.prepareStatement(sql);
                    ps.setInt(1, Integer.parseInt(questionId));
                    ResultSet rs = ps.executeQuery();
                    if (rs.next()) {
                        String correct = rs.getString("correct_option");
                        String questionText = rs.getString("question_text");
                        String topic = rs.getString("topic");
                        boolean isCorrect = userAnswer != null && userAnswer.equals(correct);
                        if (isCorrect) score++;

                        // Store result for display
                        Map<String, String> res = new HashMap<>();
                        res.put("question", questionText);
                        res.put("userAnswer", userAnswer == null ? "Not answered" : userAnswer);
                        res.put("correctAnswer", correct);
                        res.put("isCorrect", String.valueOf(isCorrect));
                        results.add(res);

                        // Update weak topics if incorrect
                        if (!isCorrect && topic != null && !topic.isEmpty()) {
                            String upsert = "INSERT INTO weak_topics (student_number, topic_name, weakness_count) VALUES (?, ?, 1) ON CONFLICT (student_number, topic_name) DO UPDATE SET weakness_count = weak_topics.weakness_count + 1";
                            PreparedStatement psWeak = conn.prepareStatement(upsert);
                            psWeak.setString(1, studentNumber);
                            psWeak.setString(2, topic);
                            psWeak.executeUpdate();
                            psWeak.close();
                        }
                    }
                    rs.close();
                    ps.close();
                }
            }
            // Insert quiz attempt
            String insert = "INSERT INTO quiz_attempts (student_number, quiz_id, score, total_questions) VALUES (?, ?, ?, ?)";
            PreparedStatement psInsert = conn.prepareStatement(insert);
            psInsert.setString(1, studentNumber);
            psInsert.setInt(2, quizId);
            psInsert.setInt(3, score);
            psInsert.setInt(4, total);
            psInsert.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Store results in session for the result page
        session.setAttribute("quizResults", results);
        session.setAttribute("quizScore", score);
        session.setAttribute("quizTotal", total);
        response.sendRedirect("quizResultDetails.jsp");
    }
}