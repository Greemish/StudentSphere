package ai;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.file.Path;
import java.sql.Connection;
import java.sql.PreparedStatement;
import student.DBConnection;

public class ContentUploadManager {
    
    private static final String PROJECT_ID = "bosjudubjyevfcesromc";
    private static final String BUCKET_NAME = "moduleContent";
    private static final String SERVICE_ROLE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJvc2p1ZHVianlldmZjZXNyb21jIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3MzY2OTUyMSwiZXhwIjoyMDg5MjQ1NTIxfQ.RcMlDM_suDWjXBKGjueKcKxKr2sYa6jXiaKUAsrDIAM"; 

    // Original method for backward compatibility
    public static boolean runFullProcess(Path filePath, String fileName, String moduleId) throws Exception {
        return runFullProcess(filePath, fileName, moduleId, null);
    }
    
    // New method with chapter support
    public static boolean runFullProcess(Path filePath, String fileName, String moduleId, Integer chapter) throws Exception {
        // 1. Upload to Supabase
        boolean uploadSuccess = uploadToSupabase(filePath, fileName);
        if (!uploadSuccess) return false;

        // 2. Construct public URL
        String encodedFileName = java.net.URLEncoder.encode(fileName, "UTF-8").replace("+", "%20");
        String publicUrl = "https://" + PROJECT_ID + ".supabase.co/storage/v1/object/public/" + BUCKET_NAME + "/" + encodedFileName;
        
        // 3. Extract text locally from PDF
        ContentExtractor extractor = new ContentExtractor();
        String extractedText = extractor.extractTextFromPath(filePath);

        // 4. Save to database with chapter
        return saveToDatabase(moduleId, publicUrl, fileName, extractedText, chapter);
    }

    private static boolean uploadToSupabase(Path filePath, String fileName) throws Exception {
        String encodedName = java.net.URLEncoder.encode(fileName, "UTF-8").replace("+", "%20");
        String url = "https://" + PROJECT_ID + ".supabase.co/storage/v1/object/" + BUCKET_NAME + "/" + encodedName;

        HttpClient client = HttpClient.newHttpClient();
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .header("apikey", SERVICE_ROLE_KEY)
                .header("Authorization", "Bearer " + SERVICE_ROLE_KEY)
                .header("Content-Type", "application/pdf")
                .header("x-upsert", "true")
                .POST(HttpRequest.BodyPublishers.ofFile(filePath))
                .build();

        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
        return response.statusCode() == 200 || response.statusCode() == 201;
    }

    private static boolean saveToDatabase(String moduleId, String fileUrl, String fileName, String text, Integer chapter) {
        String sql = "INSERT INTO module_content (moduleid, file_url, file_type, extracted_text, chapter) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, moduleId);
            ps.setString(2, fileUrl);
            ps.setString(3, "PDF");
            ps.setString(4, text);
            
            // Handle chapter - if null, default to 0 or null based on your schema
            if (chapter != null) {
                ps.setInt(5, chapter);
            } else {
                ps.setNull(5, java.sql.Types.INTEGER);
            }
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}