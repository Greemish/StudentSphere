package lecturer;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import student.DBConnection;

@WebServlet(name = "ModuleContentServlett", urlPatterns = {"/ModuleContentServlet"})
public class ModuleContentServlett extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        
        // Check if lecturer is logged in
        if (session == null || session.getAttribute("lecturerid") == null) {
            response.sendRedirect("lecturerLogin.jsp");
            return;
        }
        
        int lecturerId = (int) session.getAttribute("lecturerid");
        String moduleIdParam = request.getParameter("moduleid");
        
        if (moduleIdParam == null || moduleIdParam.isEmpty()) {
            response.sendRedirect("LectureDashboardServlett");
            return;
        }
        
        int moduleId;
        try {
            moduleId = Integer.parseInt(moduleIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect("LectureDashboardServlett");
            return;
        }
        
        // Verify this lecturer actually teaches this module
        String verifySql = "SELECT 1 FROM lecturer_modules lm " +
                           "INNER JOIN modules m ON m.module_code = lm.moduleid " +
                           "WHERE lm.lecturerid = ? AND m.id = ?";
        boolean isAuthorized = false;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(verifySql)) {
            ps.setInt(1, lecturerId);
            ps.setInt(2, moduleId);
            ResultSet rs = ps.executeQuery();
            isAuthorized = rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        if (!isAuthorized) {
            response.sendRedirect("LectureDashboardServlett");
            return;
        }

        List<Map<String, String>> contentList = new ArrayList<>();
        String moduleName = "";
        String moduleCode = "";

        // Updated SQL using module id (numeric)
        String contentSql = "SELECT id, created_at, file_url, file_type, chapter, extracted_text " +
                            "FROM module_content WHERE moduleid = ? ORDER BY chapter ASC, created_at DESC";

        try (Connection conn = DBConnection.getConnection()) {
            
            // Get module details first
            String moduleSql = "SELECT module_code, module_name FROM modules WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(moduleSql)) {
                ps.setInt(1, moduleId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    moduleCode = rs.getString("module_code");
                    moduleName = rs.getString("module_name");
                }
            }
            
            // Get content with chapter info
            try (PreparedStatement ps = conn.prepareStatement(contentSql)) {
                ps.setInt(1, moduleId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, String> item = new HashMap<>();
                        item.put("id", rs.getString("id"));
                        item.put("type", rs.getString("file_type"));
                        item.put("date", rs.getString("created_at"));
                        item.put("chapter", rs.getString("chapter") != null ? rs.getString("chapter") : "Uncategorized");
                        
                        String url = rs.getString("file_url");
                        item.put("url", url != null ? url : "");
                        
                        String fileName = (url != null && url.contains("/")) 
                                          ? url.substring(url.lastIndexOf("/") + 1) 
                                          : (url != null ? url : "Unknown File");
                        
                        item.put("fileName", fileName);
                        
                        String extractedText = rs.getString("extracted_text");
                        if (extractedText != null && extractedText.length() > 100) {
                            extractedText = extractedText.substring(0, 100) + "...";
                        }
                        item.put("preview", extractedText != null ? extractedText : "No preview available");
                        
                        contentList.add(item);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
        }

        // Set attributes for the JSP
        request.setAttribute("contentList", contentList);
        request.setAttribute("currentModuleId", String.valueOf(moduleId));
        request.setAttribute("moduleCode", moduleCode);
        request.setAttribute("moduleName", moduleName);
        
        RequestDispatcher rd = request.getRequestDispatcher("moduleContent.jsp");
        rd.forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}