package ai; 

import org.apache.pdfbox.Loader;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;
import java.io.BufferedInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.nio.file.Path;

public class ContentExtractor {

    /**
     * EXTRACT FROM LOCAL PATH (Preferred for new uploads)
     * This reads the file directly from your server's temporary storage.
     */
    public String extractTextFromPath(Path filePath) {
        try (PDDocument document = Loader.loadPDF(filePath.toFile())) {
            PDFTextStripper stripper = new PDFTextStripper();
            String text = stripper.getText(document).trim();
            System.out.println("[Extractor] Successfully extracted " + text.length() + " characters locally.");
            return text;
        } catch (IOException e) {
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
            try (InputStream in = new BufferedInputStream(url.openStream())) {
                byte[] pdfBytes = in.readAllBytes();
                
                try (PDDocument document = Loader.loadPDF(pdfBytes)) {
                    PDFTextStripper stripper = new PDFTextStripper();
                    return stripper.getText(document).trim();
                }
            }
        } catch (Exception e) {
            System.err.println("[Extractor] Cloud extraction error: " + e.getMessage());
            return null;
        }
    }
}