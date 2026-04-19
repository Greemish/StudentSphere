package student;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;


public class AdaptiveQuizServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String studentNumber = (String) session.getAttribute("studentNumber");
        if (studentNumber == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 1. Fetch weak topics from database
        List<String> weakTopics = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                "SELECT topic_name FROM weak_topics WHERE student_number = ? ORDER BY weakness_count DESC LIMIT 3");
            ps.setString(1, studentNumber);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                weakTopics.add(rs.getString("topic_name"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        if (weakTopics.isEmpty()) weakTopics.add("general programming");

        // 2. Build a large question bank (topic → list of questions)
        Map<String, List<Map<String, String>>> bank = new HashMap<>();

        // ----- Java Arrays (5 questions) -----
        List<Map<String, String>> javaQ = new ArrayList<>();
        javaQ.add(createQ("What is the correct way to declare an array in Java?",
            "int[] arr = new int[5];", "int arr = new int[5];", "int arr[5];", "array arr = new int[5];", "A"));
        javaQ.add(createQ("What is the index of the first element in an array?",
            "0", "1", "-1", "depends on the array type", "A"));
        javaQ.add(createQ("Which property gives the length of an array?",
            "length", "size()", "length()", "getLength()", "A"));
        javaQ.add(createQ("What happens when you access an index outside the array bounds?",
            "ArrayIndexOutOfBoundsException", "NullPointerException", "Compilation error", "No error", "A"));
        javaQ.add(createQ("Which of the following is a valid array declaration?",
            "int[] arr;", "int arr[];", "Both A and B", "None of the above", "C"));
        bank.put("Java Arrays", javaQ);

        // ----- SQL (5 questions) -----
        List<Map<String, String>> sqlQ = new ArrayList<>();
        sqlQ.add(createQ("Which SQL statement extracts data from a database?",
            "SELECT", "EXTRACT", "GET", "OPEN", "A"));
        sqlQ.add(createQ("Which clause filters records?",
            "WHERE", "HAVING", "FILTER", "CONDITION", "A"));
        sqlQ.add(createQ("Which keyword sorts the result?",
            "ORDER BY", "SORT BY", "GROUP BY", "ARRANGE", "A"));
        sqlQ.add(createQ("Which SQL function returns the number of rows?",
            "COUNT()", "SUM()", "TOTAL()", "ROWS()", "A"));
        sqlQ.add(createQ("What does SQL stand for?",
            "Structured Query Language", "Simple Query Language", "Standard Query Language", "Sequential Query Language", "A"));
        bank.put("SQL", sqlQ);

        // ----- General Programming (8 questions) -----
        List<Map<String, String>> genQ = new ArrayList<>();
        genQ.add(createQ("What does HTML stand for?",
            "Hyper Text Markup Language", "High Tech Modern Language", "Hyper Transfer Markup Language", "Home Tool Markup Language", "A"));
        genQ.add(createQ("What does CSS stand for?",
            "Cascading Style Sheets", "Creative Style Sheets", "Computer Style Sheets", "Colorful Style Sheets", "A"));
        genQ.add(createQ("What does 'REST API' stand for?",
            "Representational State Transfer", "Rapid Encrypted Service Tunnel", "Remote Execution Script Tool", "Reliable Event Stream Transport", "A"));
        genQ.add(createQ("Which data structure uses LIFO (Last In First Out)?",
            "Stack", "Queue", "Array", "List", "A"));
        genQ.add(createQ("Which data structure uses FIFO (First In First Out)?",
            "Queue", "Stack", "Array", "List", "A"));
        genQ.add(createQ("What is a primary key in a database?",
            "Uniquely identifies a row", "Foreign key reference", "Index column", "Sort column", "A"));
        genQ.add(createQ("What is a foreign key?",
            "References a primary key in another table", "A key that is not used", "A duplicate key", "A key with null values", "A"));
        genQ.add(createQ("Which HTTP method is used to retrieve data?",
            "GET", "POST", "PUT", "DELETE", "A"));
        bank.put("general programming", genQ);

        // 3. Collect questions based on weak topics (up to 10 total)
        List<Map<String, String>> selected = new ArrayList<>();
        for (String topic : weakTopics) {
            List<Map<String, String>> topicQuestions = bank.get(topic);
            if (topicQuestions != null) {
                selected.addAll(topicQuestions);
            }
        }
        if (selected.isEmpty()) {
            selected = bank.get("general programming");
        }

        // Shuffle the list so questions appear in random order each time
        Collections.shuffle(selected);

        // Take at most 10 questions (or all if fewer)
        if (selected.size() > 10) {
            selected = selected.subList(0, 10);
        }

        // 4. Forward to JSP
        request.setAttribute("questions", selected);
        request.setAttribute("weakTopics", weakTopics);
        request.getRequestDispatcher("adaptiveQuiz.jsp").forward(request, response);
    }

    private Map<String, String> createQ(String text, String a, String b, String c, String d, String correct) {
        Map<String, String> q = new HashMap<>();
        q.put("text", text);
        q.put("A", a);
        q.put("B", b);
        q.put("C", c);
        q.put("D", d);
        q.put("correct", correct);
        return q;
    }
}