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

@WebServlet("/DeleteContentServlet")
public class DeleteContentServlett extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String contentId = request.getParameter("id");
        String moduleId = request.getParameter("moduleid");

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "DELETE FROM module_content WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(contentId));
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }

        response.sendRedirect("ModuleContentServlett?moduleid=" + moduleId);
    }
}