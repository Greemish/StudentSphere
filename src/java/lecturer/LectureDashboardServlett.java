package lecturer;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import student.DBConnection;

@WebServlet(name = "LectureDashboardServlett", urlPatterns = {"/LectureDashboardServlet"})
public class LectureDashboardServlett extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Map<String, String>> modules = new ArrayList<>();
        
        // Use try-with-resources to ensure connections CLOSE automatically
        // This prevents the "Sometimes works/Sometimes doesn't" connection leaks
        String sql = "SELECT moduleid, module_name, colour FROM modules";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, String> module = new HashMap<>();
                module.put("id", rs.getString("moduleid"));
                module.put("name", rs.getString("module_name"));
                // Fallback color if null in DB
                String color = rs.getString("colour");
                module.put("colour", (color != null && !color.isEmpty()) ? color : "#3498db");
                
                modules.add(module);
            }

            System.out.println("Modules found: " + modules.size());

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
        }

        // IMPORTANT: Forward to the DASHBOARD, not the LOGIN page
        request.setAttribute("modulesList", modules);
        RequestDispatcher rd = request.getRequestDispatcher("lecturerDashboard.jsp");
        rd.forward(request, response);
    }
}