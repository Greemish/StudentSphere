<%@ page import="java.util.*" %>

<html>
<head>
    <title>Module Chat</title>

    <style>
        body {
            font-family: Arial;
            padding: 20px;
            background: #f4f6f9;
        }

        h2 {
            color: #1e3c72;
        }

        .chat-box {
            max-width: 600px;
            margin-bottom: 20px;
        }

        .message {
            background: #fff;
            padding: 12px;
            margin-bottom: 10px;
            border-radius: 8px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }

        .meta {
            font-size: 12px;
            color: #777;
            margin-bottom: 5px;
        }

        .content {
            font-size: 14px;
        }

        .form-box {
            max-width: 600px;
        }

        textarea {
            width: 100%;
            padding: 10px;
            border-radius: 8px;
            border: 1px solid #ccc;
            resize: none;
        }

        button {
            margin-top: 10px;
            padding: 10px 15px;
            border: none;
            background: #1e3c72;
            color: white;
            border-radius: 6px;
            cursor: pointer;
        }

        button:hover {
            background: #2a5298;
        }
    </style>
</head>

<body>

<h2>Module Chat: ${moduleId}</h2>

<div class="chat-box">

<%
    List<Map<String, String>> messages =
        (List<Map<String, String>>) request.getAttribute("messages");

    if (messages != null && !messages.isEmpty()) {
        for (Map<String, String> msg : messages) {
%>
        <div class="message">
            <div class="meta">
                Student: <%= msg.get("student") %> |
                <%= msg.get("time") %>
            </div>
            <div class="content">
                <%= msg.get("content") %>
            </div>
        </div>
<%
        }
    } else {
%>
    <p>No messages yet.</p>
<%
    }
%>

</div>

<!--  SEND MESSAGE -->
<div class="form-box">
    <form action="ModuleMessagesServlet" method="post">
        <input type="hidden" name="moduleid" value="${moduleId}">

        <textarea name="content" rows="3" placeholder="Type your message..." required></textarea>

        <button type="submit">Send</button>
    </form>
</div>

</body>
</html>