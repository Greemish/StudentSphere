package student;

import java.sql.Connection;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DashboardServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Map<String, String>> modules = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // Get database connection
            conn = DBConnection.getConnection();

            // Prepare and execute query
            String sql = "SELECT moduleid, module_name, colour FROM modules";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            // Loop through results
            while (rs.next()) {
                Map<String, String> module = new HashMap<>();
                module.put("id", rs.getString("moduleid"));
                module.put("name", rs.getString("module_name"));
                module.put("colour", rs.getString("colour"));
                modules.add(module);
            }

            System.out.println("Modules retrieved: " + modules.size()); // Debug
            
        } catch (Exception e) {
            e.printStackTrace();
            
        } finally {
         
            
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (conn != null) conn.close(); } catch (Exception ignored) {}
        }

        // Pass data to JSP
        request.setAttribute("modulesList", modules);
        RequestDispatcher rd = request.getRequestDispatcher("studentDashboard.jsp");
        rd.forward(request, response);
    }
}
