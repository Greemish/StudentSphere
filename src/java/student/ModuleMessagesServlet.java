package student;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class ModuleMessagesServlet extends HttpServlet {

    //  GET: Load messages
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    HttpSession session = request.getSession();

    Integer studentNumber = (Integer) session.getAttribute("student_number"); // FIXED
    String moduleId = request.getParameter("moduleid");

    List<Map<String, String>> messages = new ArrayList<>();

    try (Connection conn = DBConnection.getConnection()) {

        String sql = "SELECT content, student_number, created_at FROM messages WHERE UPPER(moduleid)=UPPER(?) ORDER BY created_at ASC";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, moduleId);

        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Map<String, String> msg = new HashMap<>();
            msg.put("content", rs.getString("content"));
            msg.put("student", String.valueOf(rs.getInt("student_number"))); // convert INT -> String
            msg.put("time", rs.getString("created_at"));
            messages.add(msg);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    request.setAttribute("messages", messages);
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

        //  Redirect back to GET (refresh messages)
        response.sendRedirect("ModuleMessagesServlet?moduleid=" + moduleId);
    }
}