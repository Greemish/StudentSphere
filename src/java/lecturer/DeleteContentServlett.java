package lecturer;

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
import student.DBConnection;

@WebServlet(name = "DeleteContentServlett", urlPatterns = {"/DeleteContentServlett"})
public class DeleteContentServlett extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Check if lecturer is logged in
        if (session == null || session.getAttribute("lecturerid") == null) {
            response.sendRedirect("lecturerLogin.jsp");
            return;
        }
        
        int lecturerId = (int) session.getAttribute("lecturerid");
        String contentIdParam = request.getParameter("id");
        String moduleIdParam = request.getParameter("moduleid");
        
        // Validate parameters
        if (contentIdParam == null || contentIdParam.trim().isEmpty()) {
            response.sendRedirect("LectureDashboardServlett");
            return;
        }
        
        if (moduleIdParam == null || moduleIdParam.trim().isEmpty()) {
            response.sendRedirect("LectureDashboardServlett");
            return;
        }
        
        int contentId;
        int moduleId;
        
        try {
            contentId = Integer.parseInt(contentIdParam);
            moduleId = Integer.parseInt(moduleIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect("ModuleContentServlet?moduleid=" + moduleIdParam + "&delete=error");
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
        
        // Get the file URL before deleting the record
        String fileUrl = null;
        String selectSql = "SELECT file_url FROM module_content WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(selectSql)) {
            ps.setInt(1, contentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                fileUrl = rs.getString("file_url");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        // Delete the database record
        boolean dbDeleted = false;
        String deleteSql = "DELETE FROM module_content WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(deleteSql)) {
            ps.setInt(1, contentId);
            int rowsAffected = ps.executeUpdate();
            dbDeleted = (rowsAffected > 0);
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        // If database record deleted successfully, try to delete the physical file
        if (dbDeleted && fileUrl != null && !fileUrl.isEmpty()) {
            try {
                // Get the absolute path to the file
                String uploadPath = getServletContext().getRealPath("/uploads");
                java.io.File file = new java.io.File(uploadPath, fileUrl);
                if (file.exists()) {
                    boolean fileDeleted = file.delete();
                    if (!fileDeleted) {
                        System.err.println("Failed to delete physical file: " + file.getAbsolutePath());
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        response.sendRedirect("ModuleContentServlet?moduleid=" + moduleId + "&delete=success");
    }
}