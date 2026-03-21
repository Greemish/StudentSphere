package lecturer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import student.DBConnection;

@WebServlet("/UploadContentServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class UploadContentServlett extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String moduleId = request.getParameter("moduleid");
        Part filePart = request.getPart("file");
        String fileName = filePart.getSubmittedFileName();
        
        // 1. In a real app, you'd use your Supabase S3 endpoint here to upload.
        // For now, let's simulate the URL generated after a Supabase upload:
        String bucketName = "module-files"; 
        String fileUrl = "https://bosjudubjyevfcesromc.storage.supabase.co/storage/v1/object/public/" + bucketName + "/" + fileName;
        
        String fileType = fileName.substring(fileName.lastIndexOf(".") + 1);

        // 2. Save the metadata to your MySQL 'module_content' table
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO module_content (moduleid, file_url, file_type, created_at) VALUES (?, ?, ?, NOW())";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, moduleId);
            ps.setString(2, fileUrl);
            ps.setString(3, fileType);
            ps.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
        }

        // 3. Redirect back to the content page
        response.sendRedirect("ModuleContentServlett?moduleid=" + moduleId);
    }
}