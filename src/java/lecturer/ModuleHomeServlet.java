/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package lecturer;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import student.DBConnection;

@WebServlet(name = "ModuleHomeServlet", urlPatterns = {"/ModuleHomeServlet"})
public class ModuleHomeServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Check if lecturer is logged in
        if (session == null || session.getAttribute("lecturerid") == null) {
            response.sendRedirect("lecturerLogin.jsp");
            return;
        }
        
        int lecturerId = (int) session.getAttribute("lecturerid");
        
        // Get modulecode instead of moduleid
        String moduleCode = request.getParameter("modulecode");
        
        if (moduleCode == null || moduleCode.trim().isEmpty()) {
            response.sendRedirect("LectureDashboardServlett");
            return;
        }
        
        // AUTHORIZATION CHECK COMMENTED OUT FOR NOW
        /*
        String verifySql = "SELECT 1 FROM lecturer_modules WHERE lecturerid = ? AND moduleid = ?";
        boolean isAuthorized = false;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(verifySql)) {
            ps.setInt(1, lecturerId);
            ps.setString(2, moduleCode);
            ResultSet rs = ps.executeQuery();
            isAuthorized = rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        if (!isAuthorized) {
            response.sendRedirect("LectureDashboardServlett");
            return;
        }
        */
        
        // Get module details using module_code
        String moduleName = "";
        String moduleId = "";
        String moduleColor = "#3b82f6";
        
        String moduleSql = "SELECT id, module_code, module_name, colour FROM modules WHERE module_code = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(moduleSql)) {
            ps.setString(1, moduleCode);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                moduleId = rs.getString("id");
                moduleName = rs.getString("module_name");
                String color = rs.getString("colour");
                if (color != null && !color.trim().isEmpty()) {
                    moduleColor = color;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        List<Map<String, String>> announcementList = new ArrayList<>();
        List<Map<String, String>> previewContent = new ArrayList<>();
        int studentCount = 0;
        int quizCount = 0;

        try (Connection conn = DBConnection.getConnection()) {
            
            // Get student count for this module
            String studentSql = "SELECT COUNT(*) FROM student_modules WHERE module_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(studentSql)) {
                ps.setInt(1, Integer.parseInt(moduleId));
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    studentCount = rs.getInt(1);
                }
            }
            
            // Get quiz count for this module
            String quizSql = "SELECT COUNT(*) FROM quizzes WHERE module_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(quizSql)) {
                ps.setInt(1, Integer.parseInt(moduleId));
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    quizCount = rs.getInt(1);
                }
            }
            
            // Get limited content for preview - module_content uses moduleid as TEXT (module_code)
            String previewSql = "SELECT id, file_url, file_type, chapter FROM module_content WHERE moduleid = ? ORDER BY created_at DESC LIMIT 5";
            try (PreparedStatement ps = conn.prepareStatement(previewSql)) {
                ps.setString(1, moduleCode);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    Map<String, String> item = new HashMap<>();
                    String fileUrl = rs.getString("file_url");
                    if (fileUrl != null && !fileUrl.isEmpty()) {
                        String fileName = fileUrl.substring(fileUrl.lastIndexOf("/") + 1);
                        item.put("fileName", fileName);
                        item.put("fileId", String.valueOf(rs.getInt("id")));
                        String fileType = rs.getString("file_type");
                        item.put("fileType", fileType != null ? fileType : "document");
                        String chapter = rs.getString("chapter");
                        item.put("chapter", chapter != null ? chapter : "General");
                    }
                    previewContent.add(item);
                }
            }

            // Get Announcements - module_announcements uses moduleid as TEXT (module_code)
            String announceSql = "SELECT id, heading, announcement, created_at FROM module_announcements WHERE moduleid = ? ORDER BY created_at DESC LIMIT 5";
            try (PreparedStatement ps = conn.prepareStatement(announceSql)) {
                ps.setString(1, moduleCode);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    Map<String, String> a = new HashMap<>();
                    a.put("id", String.valueOf(rs.getInt("id")));
                    a.put("title", rs.getString("heading"));
                    a.put("message", rs.getString("announcement"));
                    a.put("date", rs.getTimestamp("created_at").toString());
                    announcementList.add(a);
                }
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }

        request.setAttribute("currentModuleId", moduleId);
        request.setAttribute("currentModuleCode", moduleCode);
        request.setAttribute("moduleCode", moduleCode);
        request.setAttribute("moduleName", moduleName);
        request.setAttribute("moduleColor", moduleColor);
        request.setAttribute("studentCount", studentCount);
        request.setAttribute("quizCount", quizCount);
        request.setAttribute("announcementList", announcementList);
        request.setAttribute("contentPreview", previewContent);
        
        request.getRequestDispatcher("moduleHome.jsp").forward(request, response);
    }
}