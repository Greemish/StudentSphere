/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package lecturer;

import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import student.DBConnection;

//@WebServlet(urlPatterns = {"/lecturerLoginServlett"})
public class lecturerLoginServlett extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get parameters from login form
        Integer lecturerid = Integer.parseInt(request.getParameter("lecturerid"));
        String password = request.getParameter("password");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // Get database connection
            conn = DBConnection.getConnection();

            // SQL query to check if lecturer exists
            String sql = "SELECT * FROM lecturer WHERE lecturerid = ? AND password = ?";

            ps = conn.prepareStatement(sql);
            ps.setInt(1, lecturerid);
            ps.setString(2, password);

            rs = ps.executeQuery();

            if (rs.next()) {
                // Lecturer found - login successful
                HttpSession session = request.getSession();
                session.setAttribute("lecturerid", rs.getInt("lecturerid"));
                session.setAttribute("name", rs.getString("name"));
                session.setAttribute("email", rs.getString("email"));
                session.setAttribute("role", "lecturer");
                
                // Set session timeout (30 minutes)
                session.setMaxInactiveInterval(30 * 60);
                
                // Redirect to lecture dashboard
                response.sendRedirect("LectureDashboardServlett");
                
            } else {
                // Lecturer not found - login failed
                response.sendRedirect("lecturerLogin.jsp?error=1");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("lecturerLogin.jsp?error=1");

        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Handles lecturer login authentication";
    }
}