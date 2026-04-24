package ai;
import javax.net.ssl.HttpsURLConnection;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import com.google.gson.JsonObject;
import com.google.gson.JsonArray;
import com.google.gson.JsonParser;
import com.google.gson.Gson;
import java.io.IOException;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;
import java.security.cert.X509Certificate;
import java.security.SecureRandom;

public class AIService {
    
    private static final String API_KEY = "AIzaSyD76KPh5CRfuDgGKtoRFZziTIyPNWoRiSE"; 
    private static final String API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateContent?key=" + API_KEY;

    // SSL Bypass for development - ADD THIS BLOCK
    static {
        try {
            TrustManager[] trustAllCerts = new TrustManager[] {
                new X509TrustManager() {
                    public X509Certificate[] getAcceptedIssuers() { return null; }
                    public void checkClientTrusted(X509Certificate[] certs, String authType) { }
                    public void checkServerTrusted(X509Certificate[] certs, String authType) { }
                }
            };
            SSLContext sc = SSLContext.getInstance("TLS");
            sc.init(null, trustAllCerts, new SecureRandom());
            SSLContext.setDefault(sc);
            HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());
            HttpsURLConnection.setDefaultHostnameVerifier((hostname, session) -> true);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static final String instructions = "You are an educational assistant. Analyze the provided text and identify between 3 and 7 distinct topics covered. "
      + "For each topic, generate exactly five multiple-choice questions with four labeled options (A, B, C, D) and a single correct answer.\n\n"
      + "Requirements:\n"
      + "- Topics: Return 3–7 topics depending on how much content is available. Do not invent topics not supported by the text.\n"
      + "- Quizzes per topic: Exactly 5 quizzes questions per topic.\n"
      + "- Questions per quiz: Exactly 5 questions per quiz.\n"
      + "- Difficulty: Make the questions challenging, requiring careful reading, synthesis, and deeper understanding of the text. Do not use outside knowledge.\n"
      + "- Options: Provide four plausible options labeled \"A\", \"B\", \"C\", \"D\".\n"
      + "- Correct answer: Use the option label (\"A\", \"B\", \"C\", or \"D\").\n"
      + "- Output format: Return only valid JSON, no extra text. Use this exact structure:\n\n"
      + "[\n"
      + "  {\n"
      + "    \"topic\": \"Topic name string\",\n"
      + "    \"quizzes\": [\n"
      + "      {\n"
      + "        \"question\": \"Question text string\",\n"
      + "        \"options\": {\n"
      + "          \"A\": \"Option A text\",\n"
      + "          \"B\": \"Option B text\",\n"
      + "          \"C\": \"Option C text\",\n"
      + "          \"D\": \"Option D text\"\n"
      + "        },\n"
      + "        \"answer\": \"B\"\n"
      + "      }\n"
      + "    ]\n"
      + "  }\n"
      + "]\n\n"
      + "- No commentary: Do not include explanations, notes, or text outside the JSON.\n"
      + "- Validity: Ensure the JSON is valid and parsable, with no trailing commas or ellipses.\n"
      + "please pay attention to the results i get on this topic so you adapt to my and measure my progress to send me questions that i struggle with";

    // Add this import at top: import java.net.http.HttpClient;
    // And this: import java.net.http.HttpRequest;
    // And this: import java.net.http.HttpResponse;

    public String getProcessedJson(String content) {
        String rawData = generateQuizJson(content);
        if (rawData != null) {
            return getCleanJson(rawData);
        }
        return null;
    }

    public String generateQuizJson(String content) {
        try {
            JsonObject generationConfig = new JsonObject();
            generationConfig.addProperty("response_mime_type", "application/json");

            JsonObject textPart = new JsonObject();
            textPart.addProperty("text", instructions + "\n\nContent: " + content);

            JsonArray parts = new JsonArray();
            parts.add(textPart);

            JsonObject contentNode = new JsonObject();
            contentNode.add("parts", parts);

            JsonArray contents = new JsonArray();
            contents.add(contentNode);

            JsonObject requestBody = new JsonObject();
            requestBody.add("contents", contents);
            requestBody.add("generationConfig", generationConfig);

            String jsonRequest = requestBody.toString();

            HttpClient client = HttpClient.newBuilder()
                    .connectTimeout(Duration.ofSeconds(30))
                    .build();

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(API_URL))
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(jsonRequest))
                    .build();

            System.out.println("Sending request to Gemini API...");
            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
            
            System.out.println("HTTP Status Code: " + response.statusCode());
            
            if (response.statusCode() != 200) {
                System.err.println("API Error Response: " + response.body());
                return null;
            }

            return response.body();

        } catch (IOException | InterruptedException e) {
            System.err.println("Exception during API call:");
            e.printStackTrace(); 
            return null;
        }
    }

    public String getCleanJson(String rawGeminiResponse) {
        try {
            JsonObject jsonObject = JsonParser.parseString(rawGeminiResponse).getAsJsonObject();
            return jsonObject.getAsJsonArray("candidates")
                             .get(0).getAsJsonObject()
                             .getAsJsonObject("content")
                             .getAsJsonArray("parts")
                             .get(0).getAsJsonObject()
                             .get("text").getAsString();
        } catch (Exception e) {
            System.err.println("Error cleaning JSON: " + e.getMessage());
            return null;
        }
    }
    
    public void saveToDatabase(String cleanJson, long moduleContentId) {
        // Implementation here
    }
}