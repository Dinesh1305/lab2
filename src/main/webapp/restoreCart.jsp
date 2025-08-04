<%@ page import="java.util.*, jakarta.servlet.http.*, jakarta.servlet.*" %>
<%@ page session="true" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Restoring Cart</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            text-align: center;
        }
        h2 {
            color: #333;
        }
        .message {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .button {
            display: inline-block;
            padding: 10px 15px;
            margin: 5px;
            border: none;
            border-radius: 5px;
            text-decoration: none;
            color: white;
            background-color: #007bff;
            transition: background-color 0.3s;
        }
        .button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>

<div class="container">
<%
    Cookie[] cookies = request.getCookies();
    String guestID = null;

    if (cookies != null) {
        for (Cookie c : cookies) {
            if (c.getName().equals("guestID")) {
                guestID = c.getValue();
                break;
            }
        }
    }

    if (guestID != null) {
        Map<Integer, Map<String, Object>> oldCart = (Map<Integer, Map<String, Object>>) application.getAttribute(guestID);
        if (oldCart != null) {
            session.setAttribute("cart", oldCart);
%>
            <h2>Cart Restored</h2>
            <div class="message">
                Your previous cart has been successfully restored!
            </div>
            <a href="index.jsp" class="button">Continue Shopping</a>
<%
        } else {
%>
            <h2>No Previous Cart Found</h2>
            <div class="message">
                It seems you don't have any previous cart data.
            </div>
            <a href="index.jsp" class="button">Start Shopping</a>
<%
        }
    } else {
%>
        <h2>No Guest ID Found</h2>
        <div class="message">
            It seems you don't have a guest ID. Please start shopping.
        </div>
        <a href="index.jsp" class="button">Start Shopping</a>
<%
    }
%>
</div>

</body>
</html>