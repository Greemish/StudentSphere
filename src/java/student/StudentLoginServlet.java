/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package student;

import java.sql.Connection;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 *
 * @author RESPOW MGOTSI
 */
public class StudentLoginServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get parameters from login form
        Integer studentNumber = Integer.parseInt(request.getParameter("student_number"));
        String password = request.getParameter("password");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // Get database connection
            conn = DBConnection.getConnection();

            // SQL query to check if student exists
            String sql = "SELECT * FROM student WHERE student_number = ? AND password = ?";

            ps = conn.prepareStatement(sql);
            ps.setInt(1, studentNumber);
            ps.setString(2, password); // Note: In production, verify hashed password!

            // Execute the query
            rs = ps.executeQuery();

            if (rs.next()) {
                // Student found - login successful
                HttpSession session = request.getSession();
                session.setAttribute("student_number", rs.getString("student_number"));
                session.setAttribute("name", rs.getString("name"));
                session.setAttribute("surname", rs.getString("surname"));
                session.setAttribute("email", rs.getString("email"));
                session.setAttribute("role", "student");
                
                // Set session timeout (30 minutes)
                session.setMaxInactiveInterval(30 * 60);
                
                // Redirect to student dashboard
                response.sendRedirect("DashboardServlet");
                
            } else {
                // Student not found - login failed
                request.setAttribute("error", "Invalid student number or password. Please try again.");
                RequestDispatcher disp = request.getRequestDispatcher("studentDashboard.jsp");
                disp.forward(request, response);
            }

        } catch (Exception e) {
        e.printStackTrace();

            PrintWriter out = response.getWriter();
            out.println("<h1 style= \"color:red \">Database Error</h1>");
            out.println("<h2>" + e.getMessage() + "</h2>");

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
        return "Handles student login authentication";
    }
}