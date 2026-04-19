package student;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;


public class ModuleServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String studentNumber = (String) session.getAttribute("studentNumber");
        
        if (studentNumber == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Map<String, String>> modules = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT m.id, m.module_name, m.colour " +
                         "FROM modules m " +
                         "JOIN student_modules sm ON m.id = sm.module_id " +
                         "WHERE sm.student_number = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, studentNumber);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> mod = new HashMap<>();
                mod.put("id", String.valueOf(rs.getInt("id")));
                mod.put("name", rs.getString("module_name"));
                mod.put("colour", rs.getString("colour"));
                modules.add(mod);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        request.setAttribute("modulesList", modules);
        request.getRequestDispatcher("studentDashboard.jsp").forward(request, response);
    }
}