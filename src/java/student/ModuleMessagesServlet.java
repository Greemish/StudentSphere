package student;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class ModuleMessagesServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        String studentNumber = (String) session.getAttribute("student_number");
        String moduleId = request.getParameter("moduleid");

        List<String> messages = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {

            String sql = "SELECT content FROM messages WHERE moduleid =\"?\"";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, moduleId.toUpperCase());
            

            ResultSet rs = ps.executeQuery();
            for (int i = 0; i < 10; i++) {
                messages.add("HERE IS YOUR MESSAGE");
            }
            while (rs.next()) {
                messages.add(rs.getString("content"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        session.setAttribute("messages", messages);
        session.setAttribute("moduleId", moduleId);

        RequestDispatcher rd = request.getRequestDispatcher("moduleMessages.jsp");
        rd.forward(request, response);
    }
}