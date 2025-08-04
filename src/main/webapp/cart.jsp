<%@ page import="java.util.*" %>
<%@ page session="true" %>

<h2>Your Cart</h2>
<%
    Map<Integer, Map<String, Object>> cart = (Map<Integer, Map<String, Object>>) session.getAttribute("cart");
    if (cart == null || cart.isEmpty()) {
%>
    <p>Your cart is empty.</p>
<%
    } else {
        double total = 0;
%>
    <table border="1">
        <tr><th>Name</th><th>Model</th><th>Price</th><th>Qty</th><th>Subtotal</th></tr>
        <%
            for (Map<String, Object> item : cart.values()) {
                int qty = (int) item.get("qty");
                double price = (double) item.get("price");
                total += qty * price;
        %>
        <tr>
            <td><%= item.get("name") %></td>
            <td><%= item.get("model") %></td>
            <td>₹<%= price %></td>
            <td><%= qty %></td>
            <td>₹<%= qty * price %></td>
        </tr>
        <% } %>
        <tr><td colspan="4" align="right"><strong>Total:</strong></td><td>₹<%= total %></td></tr>
    </table>
<% } %>
