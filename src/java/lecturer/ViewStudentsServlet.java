package lecturer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import student.DBConnection;

@WebServlet(name = "ViewStudentsServlet", urlPatterns = {"/ViewStudentsServlet"})
public class ViewStudentsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Check if lecturer is logged in
        if (session == null || session.getAttribute("lecturerid") == null) {
            response.sendRedirect("lecturerLogin.jsp");
            return;
        }
        
        int lecturerId = (int) session.getAttribute("lecturerid");
        String moduleIdParam = request.getParameter("moduleid");
        
        if (moduleIdParam == null || moduleIdParam.trim().isEmpty()) {
            response.sendRedirect("LectureDashboardServlet");
            return;
        }
        
        int moduleId;
        try {
            moduleId = Integer.parseInt(moduleIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect("LectureDashboardServlet");
            return;
        }
        
        // Verify this lecturer actually teaches this module
        boolean isAuthorized = false;
        String verifySql = "SELECT 1 FROM lecturer_modules lm " +
                           "INNER JOIN modules m ON m.module_code = lm.moduleid " +
                           "WHERE lm.lecturerid = ? AND m.id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(verifySql)) {
            ps.setInt(1, lecturerId);
            ps.setInt(2, moduleId);
            ResultSet rs = ps.executeQuery();
            isAuthorized = rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        if (!isAuthorized) {
            response.sendRedirect("LectureDashboardServlet");
            return;
        }
        
        String action = request.getParameter("action");
        String targetStudent = request.getParameter("studentNum");
        String successParam = "";
        
        try (Connection conn = DBConnection.getConnection()) {
            
            // Get module code for display
            String moduleCode = "";
            String moduleName = "";
            String moduleSql = "SELECT module_code, module_name FROM modules WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(moduleSql)) {
                ps.setInt(1, moduleId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    moduleCode = rs.getString("module_code");
                    moduleName = rs.getString("module_name");
                }
            }
            
            // Handle actions
            if ("promote".equals(action) && targetStudent != null && !targetStudent.trim().isEmpty()) {
                boolean promoted = promoteToTutor(conn, targetStudent, moduleId);
                successParam = promoted ? "&promote=success" : "&promote=error";
            } else if ("remove".equals(action) && targetStudent != null && !targetStudent.trim().isEmpty()) {
                boolean removed = removeTutor(conn, targetStudent, moduleId);
                successParam = removed ? "&remove=success" : "&remove=error";
            }
            
            // Fetch data
            request.setAttribute("moduleId", String.valueOf(moduleId));
            request.setAttribute("moduleCode", moduleCode);
            request.setAttribute("moduleName", moduleName);
            request.setAttribute("students", getStudentsByModule(conn, moduleId));
            request.setAttribute("tutors", getTutorsByModule(conn, moduleId));
            
            request.getRequestDispatcher("viewStudents.jsp?" + successParam).forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ModuleHomeServlet?moduleid=" + moduleId + "&error=students");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

    private boolean promoteToTutor(Connection conn, String studentNum, int moduleId) throws SQLException {
        // Check if already a tutor
        String checkSql = "SELECT 1 FROM module_tutors WHERE student_number = ? AND module_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
            ps.setString(1, studentNum);
            ps.setInt(2, moduleId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return false; // Already a tutor
            }
        }
        
        String sql = "INSERT INTO module_tutors (module_id, tutor_name, tutor_email, student_number) " +
                     "SELECT ?, s.name || ' ' || s.surname, s.email, s.student_number " +
                     "FROM student s " +
                     "WHERE s.student_number = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, moduleId);
            ps.setString(2, studentNum);
            int rows = ps.executeUpdate();
            return rows > 0;
        }
    }

    private boolean removeTutor(Connection conn, String studentNum, int moduleId) throws SQLException {
        String sql = "DELETE FROM module_tutors WHERE student_number = ? AND module_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, studentNum);
            ps.setInt(2, moduleId);
            int rows = ps.executeUpdate();
            return rows > 0;
        }
    }

    private List<Map<String, String>> getStudentsByModule(Connection conn, int moduleId) throws SQLException {
        List<Map<String, String>> list = new ArrayList<>();
        
        String sql = "SELECT s.student_number, s.name, s.surname, s.email " +
                     "FROM student s " +
                     "INNER JOIN student_modules sm ON s.student_number = sm.student_number " +
                     "WHERE sm.module_id = ? " +
                     "ORDER BY s.surname, s.name";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, moduleId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> map = new HashMap<>();
                map.put("num", rs.getString("student_number"));
                map.put("name", rs.getString("name") + " " + rs.getString("surname"));
                map.put("email", rs.getString("email"));
                list.add(map);
            }
        }
        return list;
    }

    private Set<String> getTutorsByModule(Connection conn, int moduleId) throws SQLException {
        Set<String> tutors = new HashSet<>();
        String sql = "SELECT student_number FROM module_tutors WHERE module_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, moduleId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                tutors.add(rs.getString("student_number"));
            }
        }
        return tutors;
    }
}