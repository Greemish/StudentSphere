package student;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class SubmitQuizServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String studentNumber = (String) session.getAttribute("studentNumber");
        if (studentNumber == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String quizType = request.getParameter("quizType");
        int score = 0;
        int total = 0;
        List<Map<String, String>> results = new ArrayList<>();
        
        if ("ai".equals(quizType)) {
            // AI quiz: no DB lookups
            int qIndex = 1;
            while (true) {
                String userAnswer = request.getParameter("q" + qIndex);
                String correctAnswer = request.getParameter("correct" + qIndex);
                if (userAnswer == null || correctAnswer == null) break;
                String questionText = request.getParameter("question" + qIndex);
                String topic = request.getParameter("topic" + qIndex);
                
                boolean isCorrect = userAnswer.equals(correctAnswer);
                if (isCorrect) score++;
                total++;
                
                Map<String, String> res = new HashMap<>();
                res.put("question", questionText != null ? questionText : "Question " + qIndex);
                res.put("userAnswer", userAnswer);
                res.put("correctAnswer", correctAnswer);
                res.put("isCorrect", String.valueOf(isCorrect));
                res.put("topic", topic != null ? topic : "General");
                results.add(res);
                
                if (topic != null && !topic.isEmpty()) {
                    if (!isCorrect) {
                        updateWeakTopic(studentNumber, topic);
                    } else {
                        reduceWeakTopic(studentNumber, topic);
                    }
                }
                qIndex++;
            }
        } else {
            // Regular quiz: batch fetch
            List<Integer> questionIds = new ArrayList<>();
            Map<String, String> userAnswersMap = new HashMap<>();
            Enumeration<String> paramNames = request.getParameterNames();
            while (paramNames.hasMoreElements()) {
                String param = paramNames.nextElement();
                if (param.startsWith("q")) {
                    String qid = param.substring(1);
                    questionIds.add(Integer.parseInt(qid));
                    userAnswersMap.put(qid, request.getParameter(param));
                }
            }
            
            if (!questionIds.isEmpty()) {
                try (Connection conn = DBConnection.getConnection()) {
                    String placeholders = String.join(",", Collections.nCopies(questionIds.size(), "?"));
                    String sql = "SELECT id, question_text, correct_option, topic FROM quiz_questions WHERE id IN (" + placeholders + ")";
                    PreparedStatement ps = conn.prepareStatement(sql);
                    for (int i = 0; i < questionIds.size(); i++) {
                        ps.setInt(i + 1, questionIds.get(i));
                    }
                    ResultSet rs = ps.executeQuery();
                    Map<Integer, Map<String, String>> questionMap = new HashMap<>();
                    while (rs.next()) {
                        Map<String, String> info = new HashMap<>();
                        info.put("text", rs.getString("question_text"));
                        info.put("correct", rs.getString("correct_option"));
                        info.put("topic", rs.getString("topic"));
                        questionMap.put(rs.getInt("id"), info);
                    }
                    rs.close();
                    ps.close();
                    
                    for (int qid : questionIds) {
                        Map<String, String> info = questionMap.get(qid);
                        if (info == null) continue;
                        String userAns = userAnswersMap.get(String.valueOf(qid));
                        String correct = info.get("correct");
                        boolean isCorrect = userAns != null && userAns.equals(correct);
                        if (isCorrect) score++;
                        total++;
                        
                        Map<String, String> res = new HashMap<>();
                        res.put("question", info.get("text"));
                        res.put("userAnswer", userAns == null ? "Not answered" : userAns);
                        res.put("correctAnswer", correct);
                        res.put("isCorrect", String.valueOf(isCorrect));
                        res.put("topic", info.get("topic"));
                        results.add(res);
                        
                        String topic = info.get("topic");
                        if (topic != null && !topic.isEmpty()) {
                            if (!isCorrect) {
                                updateWeakTopic(studentNumber, topic);
                            } else {
                                reduceWeakTopic(studentNumber, topic);
                            }
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        
        // Save attempt
        int quizId = "ai".equals(quizType) ? 999 : Integer.parseInt(request.getParameter("quizId"));
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO quiz_attempts (student_number, quiz_id, score, total_questions, attempt_date) VALUES (?, ?, ?, ?, NOW())";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, studentNumber);
            ps.setInt(2, quizId);
            ps.setInt(3, score);
            ps.setInt(4, total);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        session.setAttribute("quizResults", results);
        session.setAttribute("quizScore", score);
        session.setAttribute("quizTotal", total);
        response.sendRedirect("quizResultDetails.jsp");
    }
    
    private void updateWeakTopic(String studentNumber, String topic) {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO weak_topics (student_number, topic_name, weakness_count) VALUES (?, ?, 1) ON CONFLICT (student_number, topic_name) DO UPDATE SET weakness_count = weak_topics.weakness_count + 1";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, studentNumber);
            ps.setString(2, topic);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    private void reduceWeakTopic(String studentNumber, String topic) {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "UPDATE weak_topics SET weakness_count = weakness_count - 1 WHERE student_number = ? AND topic_name = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, studentNumber);
            ps.setString(2, topic);
            int updated = ps.executeUpdate();
            if (updated > 0) {
                String deleteSql = "DELETE FROM weak_topics WHERE student_number = ? AND topic_name = ? AND weakness_count <= 0";
                PreparedStatement psDel = conn.prepareStatement(deleteSql);
                psDel.setString(1, studentNumber);
                psDel.setString(2, topic);
                psDel.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}