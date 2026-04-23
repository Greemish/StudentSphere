package lecturer;

import ai.ContentUploadManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;

@WebServlet(name = "UploadContentServlett", urlPatterns = {"/UploadContentServlett"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 50)
public class UploadContentServlett extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Check if lecturer is logged in
        if (session == null || session.getAttribute("lecturerid") == null) {
            response.sendRedirect("lecturerLogin.jsp");
            return;
        }
        
        int lecturerId = (int) session.getAttribute("lecturerid");
        String moduleId = request.getParameter("moduleid");
        String chapterParam = request.getParameter("chapter");
        
        Part filePart = request.getPart("file");
        String fileName = (filePart != null) ? filePart.getSubmittedFileName() : null;
        
        // Validate inputs
        if (moduleId == null || moduleId.trim().isEmpty()) {
            response.sendRedirect("LectureDashboardServlet");
            return;
        }
        
        if (chapterParam == null || chapterParam.trim().isEmpty()) {
            response.sendRedirect("ModuleContentServlet?moduleid=" + moduleId + "&upload=error&reason=missing_chapter");
            return;
        }
        
        int chapter;
        try {
            chapter = Integer.parseInt(chapterParam);
        } catch (NumberFormatException e) {
            response.sendRedirect("ModuleContentServlet?moduleid=" + moduleId + "&upload=error&reason=invalid_chapter");
            return;
        }
        
        if (filePart == null || fileName == null || fileName.isEmpty()) {
            response.sendRedirect("ModuleContentServlet?moduleid=" + moduleId + "&upload=error&reason=missing_file");
            return;
        }
        
        // Verify this lecturer actually teaches this module
        boolean isAuthorized = false;
        String verifySql = "SELECT 1 FROM lecturer_modules lm " +
                           "INNER JOIN modules m ON m.module_code = lm.moduleid " +
                           "WHERE lm.lecturerid = ? AND m.id = ?";
        
        try (java.sql.Connection conn = student.DBConnection.getConnection();
             java.sql.PreparedStatement ps = conn.prepareStatement(verifySql)) {
            ps.setInt(1, lecturerId);
            ps.setInt(2, Integer.parseInt(moduleId));
            java.sql.ResultSet rs = ps.executeQuery();
            isAuthorized = rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        if (!isAuthorized) {
            response.sendRedirect("LectureDashboardServlet");
            return;
        }
        
        // Validate file type
        if (!fileName.toLowerCase().endsWith(".pdf")) {
            response.sendRedirect("ModuleContentServlet?moduleid=" + moduleId + "&upload=error&reason=invalid_type");
            return;
        }
        
        Path tempPath = null;
        
        try {
            tempPath = Files.createTempFile("upload_", "_" + System.currentTimeMillis() + "_" + fileName);
            
            try (InputStream is = filePart.getInputStream()) {
                Files.copy(is, tempPath, StandardCopyOption.REPLACE_EXISTING);
            }
            
            // Execute the pipeline with chapter information
            boolean success = ContentUploadManager.runFullProcess(tempPath, fileName, moduleId, chapter);
            
            if (success) {
                response.sendRedirect("ModuleContentServlet?moduleid=" + moduleId + "&upload=success");
            } else {
                response.sendRedirect("ModuleContentServlet?moduleid=" + moduleId + "&upload=error&reason=processing_failed");
            }
            
        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendRedirect("ModuleContentServlet?moduleid=" + moduleId + "&upload=error&reason=exception");
        } finally {
            if (tempPath != null) {
                try {
                    Files.deleteIfExists(tempPath);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}