package ai;

import org.apache.pdfbox.Loader;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;
import java.io.BufferedInputStream;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;
import java.security.cert.X509Certificate;

public class ContentExtractor {
    
    // Disable SSL verification for Supabase
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
            sc.init(null, trustAllCerts, new java.security.SecureRandom());
            HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());
            HttpsURLConnection.setDefaultHostnameVerifier((hostname, session) -> true);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * EXTRACT FROM LOCAL PATH (Preferred for new uploads)
     * This reads the file directly from your server's temporary storage.
     */
    public String extractTextFromPath(java.nio.file.Path filePath) {
        try (PDDocument document = Loader.loadPDF(filePath.toFile())) {
            PDFTextStripper stripper = new PDFTextStripper();
            String text = stripper.getText(document).trim();
            System.out.println("[Extractor] Successfully extracted " + text.length() + " characters locally.");
            return text;
        } catch (Exception e) {
            System.err.println("[Extractor] Local extraction error: " + e.getMessage());
            return null;
        }
    }

    /**
     * EXTRACT FROM CLOUD URL (Backup / For existing content)
     */
    public String extractTextFromUrl(String cloudUrl) {
        try {
            URL url = new URL(cloudUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(30000);
            conn.setReadTimeout(30000);
            
            try (InputStream in = new BufferedInputStream(conn.getInputStream())) {
                byte[] pdfBytes = in.readAllBytes();
                
                try (PDDocument document = Loader.loadPDF(pdfBytes)) {
                    PDFTextStripper stripper = new PDFTextStripper();
                    String text = stripper.getText(document).trim();
                    System.out.println("[Extractor] Successfully extracted " + text.length() + " characters from URL.");
                    return text;
                }
            }
        } catch (Exception e) {
            System.err.println("[Extractor] Cloud extraction error: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
}