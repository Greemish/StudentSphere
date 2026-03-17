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
import java.sql.PreparedStatement;

/**
 *
 * @author RESPOW MGOTSI
 */
public class SignupServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get parameters from signup form
        int studentNumber = Integer.parseInt(request.getParameter("student_number"));
        String name = request.getParameter("name");
        String surname = request.getParameter("surname");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phoneNumber = request.getParameter("phone_number");

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            // Get database connection
            conn = DBConnection.getConnection();

            // SQL query to insert new student
            String sql = "INSERT INTO student (student_number, name, surname, email, password, phone_number) VALUES (?, ?, ?, ?, ?, ?)";

            ps = conn.prepareStatement(sql);

            // Set parameters
            ps.setInt(1, studentNumber);
            ps.setString(2, name);
            ps.setString(3, surname);
            ps.setString(4, email);
            ps.setString(5, password); // Note: In production, hash the password!
            ps.setString(6, phoneNumber);

            // Execute the insert
            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                // Send values to JSP confirmation page
                request.setAttribute("studentNumber", studentNumber);
                request.setAttribute("name", name);
                request.setAttribute("surname", surname);
                request.setAttribute("email", email);
                request.setAttribute("message", "Signup successful! Please login.");

                RequestDispatcher disp = request.getRequestDispatcher("login.jsp");
                disp.forward(request, response);
            } else {
                // Handle failed insert
                request.setAttribute("error", "Signup failed. Please try again.");
                RequestDispatcher disp = request.getRequestDispatcher("failedSignup.jsp");
                disp.forward(request, response);
            }

        } catch (Exception e) {
           

             e.printStackTrace();

            PrintWriter out = response.getWriter();
            out.println("<h1 style= \"color:red \">Database Error</h1>");
            out.println("<h2>" + e.getMessage() + "</h2>");

//            RequestDispatcher disp = request.getRequestDispatcher("failedSignup.jsp");
//            disp.forward(request, response);

        } finally {
            try {
                if (ps != null) {
                    ps.close();
                }
                if (conn != null) {
                    conn.close();
                }
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



}