package lecturer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import student.DBConnection;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet(name = "CreateAnnouncementServlet", urlPatterns = {"/CreateAnnouncementServlet"})
public class CreateAnnouncementServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Check if lecturer is logged in
        if (session == null || session.getAttribute("lecturerid") == null) {
            response.sendRedirect("lecturerLogin.jsp");
            return;
        }
        
        String moduleId = request.getParameter("moduleid");
        
        if (moduleId == null || moduleId.trim().isEmpty()) {
            response.sendRedirect("LectureDashboardServlett");
            return;
        }
        
        // Get module details for display
        String moduleName = "";
        String moduleCode = "";
        
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT module_code, module_name FROM modules WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, Integer.parseInt(moduleId));
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    moduleCode = rs.getString("module_code");
                    moduleName = rs.getString("module_name");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        request.setAttribute("currentModuleId", moduleId);
        request.setAttribute("moduleCode", moduleCode);
        request.setAttribute("moduleName", moduleName);
        
        // Forward to the announcement creation JSP
        request.getRequestDispatcher("createAnnouncement.jsp").forward(request, response);
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
        String moduleId = request.getParameter("moduleid");
        String heading = request.getParameter("heading");
        String message = request.getParameter("announcement");
        
        // Validate inputs
        if (moduleId == null || moduleId.trim().isEmpty()) {
            response.sendRedirect("LectureDashboardServlett");
            return;
        }
        
        if (heading == null || heading.trim().isEmpty()) {
            response.sendRedirect("CreateAnnouncementServlet?moduleid=" + moduleId + "&error=missing_heading");
            return;
        }
        
        if (message == null || message.trim().isEmpty()) {
            response.sendRedirect("CreateAnnouncementServlet?moduleid=" + moduleId + "&error=missing_message");
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
            ps.setInt(2, Integer.parseInt(moduleId));
            ResultSet rs = ps.executeQuery();
            isAuthorized = rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        if (!isAuthorized) {
            response.sendRedirect("LectureDashboardServlett");
            return;
        }
        
        // Insert the announcement
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO module_announcements (moduleid, heading, announcement) VALUES (?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, Integer.parseInt(moduleId));
                ps.setString(2, heading.trim());
                ps.setString(3, message.trim());
                ps.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("CreateAnnouncementServlet?moduleid=" + moduleId + "&error=database");
            return;
        }

        // Redirect back to the module home with success message
        response.sendRedirect("ModuleHomeServlet?moduleid=" + moduleId + "&announcement=success");
    }
}