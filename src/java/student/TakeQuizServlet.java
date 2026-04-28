package student;

import ai.AIService;
import ai.ContentExtractor;
import com.google.gson.Gson;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;


public class TakeQuizServlet extends HttpServlet {
    
    // CHANGE THIS TO YOUR PDF URL
    private static final String PDF_URL = "https://bosjudubjyevfcesromc.supabase.co/storage/v1/object/public/moduleContent/LU-3%20Software%20Project%20Management1.pdf";
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String studentNumber = (String) session.getAttribute("studentNumber");
        if (studentNumber == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Check if this is an AI quiz request
        String type = request.getParameter("type");
        
        if ("ai".equals(type)) {
            // Generate AI quiz from PDF
            generateAIQuiz(request, response);
        } else {
            // Original: Show existing quizzes from database
            showExistingQuizzes(request, response, studentNumber);
        }
    }
    
    private void showExistingQuizzes(HttpServletRequest request, HttpServletResponse response, String studentNumber)
            throws ServletException, IOException {
        
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
    
    private void generateAIQuiz(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        try {
            ContentExtractor extractor = new ContentExtractor();
            String extractedText = extractor.extractTextFromUrl(PDF_URL);
            
            if (extractedText == null || extractedText.isEmpty()) {
                request.setAttribute("error", "Failed to extract text from PDF");
                request.getRequestDispatcher("takeQuiz.jsp").forward(request, response);
                return;
            }
            
            AIService aiService = new AIService();
            String rawResponse = aiService.generateQuizJson(extractedText);
            String cleanQuizJson = aiService.getCleanJson(rawResponse);
            
            Gson gson = new Gson();
            List<Map<String, Object>> topics = gson.fromJson(cleanQuizJson, List.class);
            
            session.setAttribute("aiQuiz", topics);
            request.setAttribute("isAIQuiz", true);
            request.getRequestDispatcher("takeQuiz.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "AI Error: " + e.getMessage());
            request.getRequestDispatcher("takeQuiz.jsp").forward(request, response);
        }
    }
}