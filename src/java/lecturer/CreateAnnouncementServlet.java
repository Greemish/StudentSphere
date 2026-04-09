package lecturer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import student.DBConnection;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

//@WebServlet("/CreateAnnouncementServlet")
public class CreateAnnouncementServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Read form parameters
        String moduleId = request.getParameter("moduleid");
        String heading = request.getParameter("title");
        String announcementText = request.getParameter("message");

        // Basic validation
        if (moduleId == null || moduleId.isBlank()
                || heading == null || heading.isBlank()
                || announcementText == null || announcementText.isBlank()) {

            response.sendRedirect(
                "moduleHome.jsp?moduleid=" + moduleId + "&error=missing"
            );
            return;
        }

        //  SQL (id + created_at handled by DB)
        String sql = "INSERT INTO announcements (moduleid, heading, announcement)"
                + "VALUES (?, ?, ?)";
                

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, moduleId);
            ps.setString(2, heading);
            ps.setString(3, announcementText);

            ps.executeUpdate();

        } catch (Exception e) {
            throw new ServletException("Failed to create announcement", e);
        }

        // Redirect back to module home (prevents resubmission)
        response.sendRedirect("moduleHome.jsp?moduleid=" + moduleId);
    }
}