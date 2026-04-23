package lecturer;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import student.DBConnection;

//@WebServlet(name = "LectureDashboardServlett", urlPatterns = {"/LectureDashboardServlett"})
public class LectureDashboardServlett extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        
        // Check if lecturer is logged in
        if (session == null || session.getAttribute("lecturerid") == null) {
            response.sendRedirect("lecturerLogin.jsp");
            return;
        }
        
        int lecturerId = (int) session.getAttribute("lecturerid");
        String lecturerName = (String) session.getAttribute("name");
        
        List<Map<String, String>> modules = new ArrayList<>();
        
        // Get only modules assigned to this lecturer
        String sql = "SELECT m.id, m.module_code, m.module_name, m.colour " +
                     "FROM modules m " +
                     "INNER JOIN lecturer_modules lm ON m.module_code = lm.moduleid " +
                     "WHERE lm.lecturerid = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, lecturerId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> module = new HashMap<>();
                    module.put("id", String.valueOf(rs.getInt("id")));
                    module.put("code", rs.getString("module_code"));
                    module.put("name", rs.getString("module_name"));
                    String color = rs.getString("colour");
                    module.put("colour", (color != null && !color.isEmpty()) ? color : "#3b82f6");
                    modules.add(module);
                }
            }
            
            System.out.println("Modules found for lecturer " + lecturerId + ": " + modules.size());
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
        }
        
        request.setAttribute("modulesList", modules);
        request.setAttribute("lecturerName", lecturerName);
        RequestDispatcher rd = request.getRequestDispatcher("lecturerDashboard.jsp");
        rd.forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}