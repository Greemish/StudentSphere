<%@ page import="java.util.*" %>
<html>
<head>
    <title>Module Messages & Tutors</title>
    <style>
        body { font-family: Arial; padding: 20px; background: #f4f6f9; }
        .container { display: flex; gap: 30px; }
        .messages, .tutors { padding: 20px; background: #fff; border-radius: 8px; box-shadow: 0 3px 8px rgba(0,0,0,0.1); }
        .messages { flex: 2; max-height: 600px; overflow-y: auto; }
        .tutors { flex: 1; max-height: 600px; overflow-y: auto; }
        .message { padding: 10px; border-bottom: 1px solid #eee; margin-bottom: 8px; }
        .message:last-child { border-bottom: none; }
        .tutor { margin-bottom: 10px; }
        textarea { width: 100%; padding: 8px; margin-top: 8px; border-radius: 5px; border: 1px solid #ccc; }
        button { margin-top: 8px; padding: 6px 12px; border-radius: 5px; border: none; background: #1e3c72; color: #fff; cursor: pointer; }
    </style>
</head>
<body>
    <h2>Module: <%= request.getAttribute("moduleId") %></h2>
    <div class="container">

        <!-- Messages Section -->
        <div class="messages">
            <h3>Messages</h3>
            <%
                List<Map<String,String>> messages = (List<Map<String,String>>) request.getAttribute("messages");
                if (messages != null && !messages.isEmpty()) {
                    for (Map<String,String> msg : messages) {
            %>
                        <div class="message">
                            <strong>Student: <%= msg.get("student") %></strong> | <em><%= msg.get("time") %></em>
                            <p><%= msg.get("content") %></p>
                        </div>
            <%
                    }
                } else {
            %>
                    <p>No messages found.</p>
            <%
                }
            %>

            <!-- Send new message -->
            <form action="ModuleMessagesServlet" method="post">
                <input type="hidden" name="moduleid" value="<%= request.getAttribute("moduleId") %>">
                <textarea name="content" rows="3" placeholder="Type your message..." required></textarea>
                <button type="submit">Send</button>
            </form>
        </div>

        <!-- Tutors Section -->
        <div class="tutors">
            <h3>Tutors</h3>
            <%
                List<Map<String,String>> tutors = (List<Map<String,String>>) request.getAttribute("tutors");
                if (tutors != null && !tutors.isEmpty()) {
                    for (Map<String,String> t : tutors) {
            %>
                        <div class="tutor">
                            <strong><%= t.get("name") %></strong><br>
                            <em><%= t.get("email") %></em>
                        </div>
            <%
                    }
                } else {
            %>
                    <p>No tutors assigned to this module.</p>
            <%
                }
            %>
        </div>

    </div>
</body>
</html>