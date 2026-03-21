package student;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class ModuleMessagesServlet extends HttpServlet {

    // GET: Load messages + tutors
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        Integer studentNumber = (Integer) session.getAttribute("student_number");
        String moduleId = request.getParameter("moduleid");

        List<Map<String, String>> messages = new ArrayList<>();
        List<Map<String, String>> tutors = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {

            // --- Fetch messages ---
            String sqlMsg = "SELECT content, student_number, created_at FROM messages "
                          + "WHERE UPPER(moduleid) = UPPER(?) ORDER BY created_at ASC";
            PreparedStatement psMsg = conn.prepareStatement(sqlMsg);
            psMsg.setString(1, moduleId);
            ResultSet rsMsg = psMsg.executeQuery();

            while (rsMsg.next()) {
                Map<String, String> msg = new HashMap<>();
                msg.put("content", rsMsg.getString("content"));
                msg.put("student", String.valueOf(rsMsg.getInt("student_number")));
                msg.put("time", rsMsg.getString("created_at"));
                messages.add(msg);
            }

            // --- Fetch tutors directly from tutor table ---
            String sqlTut = "SELECT tutorid, name, email FROM tutor WHERE UPPER(moduleid) = UPPER(?)";
            PreparedStatement psTut = conn.prepareStatement(sqlTut);
            psTut.setString(1, moduleId);
            ResultSet rsTut = psTut.executeQuery();

            while (rsTut.next()) {
                Map<String, String> t = new HashMap<>();
                t.put("tutorid", String.valueOf(rsTut.getInt("tutorid")));
                t.put("name", rsTut.getString("name"));
                t.put("email", rsTut.getString("email"));
                tutors.add(t);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("messages", messages);
        request.setAttribute("tutors", tutors);
        request.setAttribute("moduleId", moduleId);

        RequestDispatcher rd = request.getRequestDispatcher("moduleMessages.jsp");
        rd.forward(request, response);
    }

    // POST: Insert message
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer studentNumber = (Integer) session.getAttribute("student_number");
        String moduleId = request.getParameter("moduleid");
        String content = request.getParameter("content");

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO messages(moduleid, student_number, content, created_at) VALUES (?, ?, ?, CURRENT_TIMESTAMP)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, moduleId);
            ps.setInt(2, studentNumber);
            ps.setString(3, content);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("ModuleMessagesServlet?moduleid=" + moduleId);
    }
}