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
        Long quizSessionId = (Long) session.getAttribute("currentQuizSessionId");
        String moduleId = (String) session.getAttribute("moduleId");
        
        if (studentNumber == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int score = 0;
        int total = 0;
        List<Map<String, String>> results = new ArrayList<>();
        List<String> wrongTopics = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {
            // Get total number of questions from session
            List<Map<String, Object>> topics = (List<Map<String, Object>>) session.getAttribute("currentQuizTopics");
            if (topics != null) {
                total = 0;
                for (Map<String, Object> topic : topics) {
                    List<?> quizzes = (List<?>) topic.get("quizzes");
                    total += quizzes.size();
                }
            }
            
            // Process each question
            int questionCounter = 1;
            for (Map<String, Object> topic : topics) {
                String topicName = (String) topic.get("topic");
                List<Map<String, Object>> quizzes = (List<Map<String, Object>>) topic.get("quizzes");
                
                for (Map<String, Object> quiz : quizzes) {
                    String userAnswer = request.getParameter("q" + questionCounter);
                    String correctAnswer = (String) quiz.get("answer");
                    String questionText = (String) quiz.get("question");
                    
                    if (userAnswer == null) {
                        questionCounter++;
                        continue;
                    }
                    
                    boolean isCorrect = userAnswer.equals(correctAnswer);
                    if (isCorrect) {
                        score++;
                    } else {
                        wrongTopics.add(topicName);
                    }
                    
                    // Store result
                    Map<String, String> res = new HashMap<>();
                    res.put("question", questionText);
                    res.put("userAnswer", userAnswer);
                    res.put("correctAnswer", correctAnswer);
                    res.put("isCorrect", String.valueOf(isCorrect));
                    res.put("topic", topicName);
                    results.add(res);
                    
                    // Save individual answer to database
                    if (quizSessionId != null) {
                        saveStudentAnswer(conn, quizSessionId, questionCounter, questionText, userAnswer, isCorrect);
                    }
                    
                    questionCounter++;
                }
            }
            
            // Update weak_topics table
            for (String wrongTopic : wrongTopics) {
                updateWeakTopics(conn, studentNumber, wrongTopic);
            }
            
            // Update quiz session with final score
            if (quizSessionId != null) {
                updateQuizSessionScore(conn, quizSessionId, score, total);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }

        session.setAttribute("quizResults", results);
        session.setAttribute("quizScore", score);
        session.setAttribute("quizTotal", total);
        response.sendRedirect("quizResultDetails.jsp");
    }
    
    private void saveStudentAnswer(Connection conn, Long sessionId, int questionNum, String questionText, String userAnswer, boolean isCorrect) throws SQLException {
        String sql = "INSERT INTO student_answers (sessionid, questionid, student_choice, is_correct, answered_at) VALUES (?, ?, ?, ?, NOW())";
        
        // For now, store question text in student_choice as fallback
        // You should create a proper questions table
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, sessionId);
            ps.setInt(2, questionNum);
            ps.setString(3, userAnswer);
            ps.setBoolean(4, isCorrect);
            ps.executeUpdate();
        }
    }
    
    private void updateWeakTopics(Connection conn, String studentNumber, String topicName) throws SQLException {
        String sql = "INSERT INTO weak_topics (student_number, topic_name, weakness_count, updated_at) " +
                     "VALUES (?, ?, 1, NOW()) " +
                     "ON CONFLICT (student_number, topic_name) " +
                     "DO UPDATE SET weakness_count = weak_topics.weakness_count + 1, updated_at = NOW()";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, studentNumber);
            ps.setString(2, topicName);
            ps.executeUpdate();
        }
    }
    
    private void updateQuizSessionScore(Connection conn, Long sessionId, int score, int total) throws SQLException {
        String sql = "UPDATE quiz_session SET score = ?, completed_at = NOW() WHERE sessionid = ?";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, score);
            ps.setLong(2, sessionId);
            ps.executeUpdate();
        }
    }
}