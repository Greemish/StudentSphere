package student;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;


public class ModuleMessagesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String studentNumber = (String) session.getAttribute("studentNumber"); // String, not Integer
        if (studentNumber == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        String moduleIdStr = request.getParameter("moduleid");
        if (moduleIdStr == null || moduleIdStr.isEmpty()) {
            response.sendRedirect("ModuleServlet");
            return;
        }
        int moduleId = Integer.parseInt(moduleIdStr);

        List<Map<String, String>> messages = new ArrayList<>();
        List<Map<String, String>> tutors = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {
            // Fetch messages from module_messages table
            String sqlMsg = "SELECT content, student_number, created_at FROM module_messages WHERE module_id = ? ORDER BY created_at ASC";
            PreparedStatement psMsg = conn.prepareStatement(sqlMsg);
            psMsg.setInt(1, moduleId);
            ResultSet rsMsg = psMsg.executeQuery();
            while (rsMsg.next()) {
                Map<String, String> msg = new HashMap<>();
                msg.put("content", rsMsg.getString("content"));
                msg.put("student_number", rsMsg.getString("student_number"));
                msg.put("created_at", rsMsg.getString("created_at"));
                msg.put("student_number", rsMsg.getString("student_number"));
                messages.add(msg);
            }

            // Fetch tutors from module_tutors table
            String sqlTut = "SELECT tutor_name, tutor_email FROM module_tutors WHERE module_id = ?";
            PreparedStatement psTut = conn.prepareStatement(sqlTut);
            psTut.setInt(1, moduleId);
            ResultSet rsTut = psTut.executeQuery();
            while (rsTut.next()) {
                Map<String, String> tutor = new HashMap<>();
                tutor.put("name", rsTut.getString("tutor_name"));
                tutor.put("email", rsTut.getString("tutor_email"));
                tutors.add(tutor);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
        }

        request.setAttribute("messages", messages);
        request.setAttribute("tutors", tutors);
        request.setAttribute("moduleId", moduleId);
        request.getRequestDispatcher("moduleMessages.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String studentNumber = (String) session.getAttribute("studentNumber");
        if (studentNumber == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        String moduleIdStr = request.getParameter("moduleid");
        String content = request.getParameter("content");
        if (moduleIdStr == null || content == null || content.trim().isEmpty()) {
            response.sendRedirect("ModuleMessagesServlet?moduleid=" + moduleIdStr);
            return;
        }
        int moduleId = Integer.parseInt(moduleIdStr);

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO module_messages (module_id, student_number, content) VALUES (?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, moduleId);
            ps.setString(2, studentNumber);
            ps.setString(3, content.trim());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("ModuleMessagesServlet?moduleid=" + moduleId);
        
    }
}