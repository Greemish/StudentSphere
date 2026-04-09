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

@WebServlet(name = "ModuleContentServlett", urlPatterns = {"/ModuleContentServlet"})
public class ModuleContentServlett extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String moduleId = request.getParameter("moduleid");
        List<Map<String, String>> contentList = new ArrayList<>();

        String sql = "SELECT id, created_at, file_url, file_type FROM module_content WHERE moduleid = ? ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, moduleId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> item = new HashMap<>();
                    item.put("id", rs.getString("id"));
                    item.put("date", rs.getString("created_at"));
                    item.put("url", rs.getString("file_url"));
                    item.put("type", rs.getString("file_type"));
                    
                    // Logic to get a filename from the URL path
                    String url = rs.getString("file_url");
                    String fileName = url.substring(url.lastIndexOf("/") + 1);
                    item.put("fileName", fileName);
                    
                    contentList.add(item);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("contentList", contentList);
        request.setAttribute("currentModuleId", moduleId);
        
        RequestDispatcher rd = request.getRequestDispatcher("moduleHome.jsp");
        rd.forward(request, response);
    }
}