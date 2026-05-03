package student;

import java.sql.Connection;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DashboardServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String studentNumber = (session != null) ? (String) session.getAttribute("studentNumber") : null;

        if (studentNumber == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Map<String, String>> modules = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();

            String sql = "SELECT m.id, m.module_name, m.colour " +
                         "FROM modules m " +
                         "JOIN student_modules sm ON m.id = sm.module_id " +
                         "WHERE sm.student_number = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, studentNumber);
            rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, String> module = new HashMap<>();
                module.put("id", rs.getString("id"));
                module.put("name", rs.getString("module_name"));
                module.put("colour", rs.getString("colour"));
                modules.add(module);
            }

            System.out.println("Modules retrieved for student " + studentNumber + ": " + modules.size());

        } catch (Exception e) {
            e.printStackTrace();

        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (conn != null) conn.close(); } catch (Exception ignored) {}
        }

        request.setAttribute("modulesList", modules);
        RequestDispatcher rd = request.getRequestDispatcher("studentDashboard.jsp");
        rd.forward(request, response);
    }
}
