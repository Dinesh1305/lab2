<%@ page import="java.util.*, jakarta.servlet.http.*, jakarta.servlet.*" %>
<%@ page session="true" %>

<%
    Cookie[] cookies = request.getCookies();
    String guestID = null;

    for (Cookie c : cookies) {
        if (c.getName().equals("guestID")) {
            guestID = c.getValue();
            break;
        }
    }

    if (guestID != null) {
        Map<Integer, Map<String, Object>> oldCart = (Map<Integer, Map<String, Object>>) application.getAttribute(guestID);
        if (oldCart != null) {
            session.setAttribute("cart", oldCart);
        }
    }

    response.sendRedirect("index.jsp");
%>
