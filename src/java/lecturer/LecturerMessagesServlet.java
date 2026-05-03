package lecturer;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import student.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "LecturerMessagesServlet", urlPatterns = {"/LecturerMessagesServlet"})
public class LecturerMessagesServlet extends HttpServlet {

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
        
        if (moduleIdParam == null || moduleIdParam.trim().isEmpty()) {
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
        boolean isAuthorized = false;
        String verifySql = "SELECT 1 FROM lecturer_modules lm " +
                           "INNER JOIN modules m ON m.module_code = lm.moduleid " +
                           "WHERE lm.lecturerid = ? AND m.id = ?";
        
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
        
        // Get module details
        String moduleCode = "";
        String moduleName = "";
        String moduleSql = "SELECT module_code, module_name FROM modules WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(moduleSql)) {
            ps.setInt(1, moduleId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                moduleCode = rs.getString("module_code");
                moduleName = rs.getString("module_name");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        List<Map<String, String>> messages = new ArrayList<>();
        
        // Use module_messages table (correct from schema)
        String sql = "SELECT mm.id, mm.content, mm.created_at, s.name, s.surname, s.student_number " +
                     "FROM module_messages mm " +
                     "LEFT JOIN student s ON mm.student_number = s.student_number " +
                     "WHERE mm.module_id = ? " +
                     "ORDER BY mm.created_at ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, moduleId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Map<String, String> msg = new HashMap<>();
                String studentName = rs.getString("name") + " " + rs.getString("surname");
                msg.put("sender", studentName != null && !studentName.trim().isEmpty() ? studentName : "Student");
                msg.put("studentNumber", rs.getString("student_number"));
                msg.put("text", rs.getString("content"));
                msg.put("date", rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toString() : "");
                messages.add(msg);
            }
            
            request.setAttribute("messageList", messages);
            request.setAttribute("moduleId", String.valueOf(moduleId));
            request.setAttribute("moduleCode", moduleCode);
            request.setAttribute("moduleName", moduleName);
            request.getRequestDispatcher("lecturerMessages.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ModuleHomeServlet?moduleid=" + moduleId + "&error=messages");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Check if lecturer is logged in
        if (session == null || session.getAttribute("lecturerid") == null) {
            response.sendRedirect("lecturerLogin.jsp");
            return;
        }
        
        int lecturerId = (int) session.getAttribute("lecturerid");
        String moduleIdParam = request.getParameter("moduleid");
        String studentNumber = request.getParameter("student_number");
        String messageText = request.getParameter("content");
        
        // Validate inputs
        if (moduleIdParam == null || moduleIdParam.trim().isEmpty()) {
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
        
        if (studentNumber == null || studentNumber.trim().isEmpty()) {
            response.sendRedirect("LecturerMessagesServlet?moduleid=" + moduleId + "&error=missing_student");
            return;
        }
        
        if (messageText == null || messageText.trim().isEmpty()) {
            response.sendRedirect("LecturerMessagesServlet?moduleid=" + moduleId + "&error=missing_message");
            return;
        }
        
        // Verify this lecturer actually teaches this module
        boolean isAuthorized = false;
        String verifySql = "SELECT 1 FROM lecturer_modules lm " +
                           "INNER JOIN modules m ON m.module_code = lm.moduleid " +
                           "WHERE lm.lecturerid = ? AND m.id = ?";
        
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
        
        // Verify student exists and is enrolled in this module
        boolean studentExists = false;
        String studentSql = "SELECT 1 FROM student_modules WHERE student_number = ? AND module_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(studentSql)) {
            ps.setString(1, studentNumber);
            ps.setInt(2, moduleId);
            ResultSet rs = ps.executeQuery();
            studentExists = rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        if (!studentExists) {
            response.sendRedirect("LecturerMessagesServlet?moduleid=" + moduleId + "&error=invalid_student");
            return;
        }
        
        // Insert message into module_messages table
        String sql = "INSERT INTO module_messages (module_id, student_number, content) VALUES (?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, moduleId);
            ps.setString(2, studentNumber);
            ps.setString(3, messageText.trim());
            
            ps.executeUpdate();
            response.sendRedirect("LecturerMessagesServlet?moduleid=" + moduleId + "&success=sent");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("LecturerMessagesServlet?moduleid=" + moduleId + "&error=database");
        }
    }
}