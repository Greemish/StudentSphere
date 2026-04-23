package ai;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import student.DBConnection;

import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.file.Path;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;


public class ContentManager {
    private static final String PROJECT_ID = "bosjudubjyevfcesromc";
    private static final String BUCKET_NAME = "moduleContent";
    private static final String SERVICE_ROLE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJvc2p1ZHVianlldmZjZXNyb21jIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3MzY2OTUyMSwiZXhwIjoyMDg5MjQ1NTIxfQ.RcMlDM_suDWjXBKGjueKcKxKr2sYa6jXiaKUAsrDIAM"; 


    public String uploadFile(Path filePath, String fileName) throws Exception {
        String encodedName = URLEncoder.encode(fileName, "UTF-8").replace("+", "%20");
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
        System.out.println("Supabase Status: " + response.statusCode());
        System.out.println("Supabase Response: " + response.body());

        if (response.statusCode() == 200) {
            return "https://" + PROJECT_ID +
                   ".storage.supabase.co/storage/v1/object/public/" +
                   BUCKET_NAME + "/" + encodedName;
        } else {
            throw new Exception("Upload failed: " + response.body());
        }
    }

    public String processFile(String publicUrl) throws Exception {
        ContentExtractor extractor = new ContentExtractor();
        String fileText = extractor.extractTextFromUrl(publicUrl);

        AIService aiService = new AIService();
        String rawAIResponse = aiService.generateQuizJson(fileText);
        return aiService.getCleanJson(rawAIResponse);
    }

    public void saveToDatabase(String moduleId, String publicUrl, String fileName, String processedAIResponse) throws Exception {
        try (Connection conn = DBConnection.getConnection()) {
            // Step 1: Insert into module_content
            String sql = "INSERT INTO module_content " +
                    "(moduleid, file_url, file_type, ai_processed, created_at, extracted_text) " +
                    "VALUES (?, ?, ?, ?, NOW(), ?) RETURNING id";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, moduleId);
            ps.setString(2, publicUrl);
            ps.setString(3, fileName.substring(fileName.lastIndexOf(".") + 1));
            ps.setBoolean(4, true);
            ps.setString(5, processedAIResponse);
            ResultSet rs = ps.executeQuery();
            rs.next();
            long moduleContentId = rs.getLong("id");

            // Step 2: Parse AI JSON into Topic objects
            Gson gson = new Gson();
            
        }
    }
}