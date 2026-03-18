<%@ page import="java.util.*" %>

<html>
<head>
    <title>Module Messages</title>

    <style>
        body {
            font-family: Arial;
            padding: 30px;
            background: #f4f6f9;
        }

        .message {
            background: #fff;
            padding: 15px;
            margin-bottom: 10px;
            border-radius: 8px;
            box-shadow: 0 3px 8px rgba(0,0,0,0.1);
        }
    </style>
</head>

<body>

<h2>Messages for Module: ${moduleId}</h2>

<%
    List<String> messages = (List<String>) request.getAttribute("messages");

    if (messages != null && !messages.isEmpty()) {
        for (String msg : messages) {
%>
            <div class="message"><%= msg %></div>
<%
        }
    } else {
%>
        <p>No messages found.</p>
<%
    }
%>

</body>
</html>