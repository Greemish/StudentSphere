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

public class AdaptiveQuizServlet extends HttpServlet {
    
    // HARDCODED PDF URL - CHANGE THIS TO YOUR PDF
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
        
        try {
            // STEP 1: Get student's weak topics from database
            List<String> weakTopics = getWeakTopics(studentNumber);
            
            // STEP 2: Extract text from PDF
            ContentExtractor extractor = new ContentExtractor();
            String extractedText = extractor.extractTextFromUrl(PDF_URL);
            
            if (extractedText == null || extractedText.isEmpty()) {
                request.setAttribute("error", "Failed to extract text from PDF");
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }
            
            // STEP 3: Generate quiz - ADAPTIVE if weak topics exist
            AIService aiService = new AIService();
            String cleanQuizJson;
            boolean isAdaptive = false;
            
            if (!weakTopics.isEmpty()) {
                // ADAPTIVE MODE: Focus on weak topics
                String weakTopicsStr = String.join(", ", weakTopics);
                cleanQuizJson = aiService.generateAdaptiveQuiz(extractedText, weakTopicsStr);
                isAdaptive = true;
                request.setAttribute("adaptiveMode", true);
                request.setAttribute("weakTopics", weakTopics);
                System.out.println("=== ADAPTIVE MODE ACTIVATED ===");
                System.out.println("Focusing on weak topics: " + weakTopicsStr);
            } else {
                // NORMAL MODE: First time user
                String rawResponse = aiService.generateQuizJson(extractedText);
                cleanQuizJson = aiService.getCleanJson(rawResponse);
                request.setAttribute("adaptiveMode", false);
                System.out.println("=== NORMAL MODE ===");
                System.out.println("No weak topics found - generating standard quiz");
            }
            
            // STEP 4: Parse JSON
            Gson gson = new Gson();
            List<Map<String, Object>> topics = gson.fromJson(cleanQuizJson, List.class);
            
            // STEP 5: Store in session
            session.setAttribute("currentQuizTopics", topics);
            
            // STEP 6: Forward to JSP
            request.getRequestDispatcher("adaptiveQuiz.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
    
    private List<String> getWeakTopics(String studentNumber) {
        List<String> weakTopics = new ArrayList<>();
        String sql = "SELECT topic_name FROM weak_topics WHERE student_number = ? ORDER BY weakness_count DESC LIMIT 5";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, studentNumber);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                weakTopics.add(rs.getString("topic_name"));
            }
            System.out.println("Found " + weakTopics.size() + " weak topics for student: " + studentNumber);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return weakTopics;
    }
}