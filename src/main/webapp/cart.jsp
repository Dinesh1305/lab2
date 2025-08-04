<%@ page import="java.util.*" %>
<%@ page session="true" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Cart</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 20px;
        }
        h2 {
            text-align: center;
            color: #333;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #4CAF50;
            color: white;
        }
        tr:hover {
            background-color: #f1f1f1;
        }
        .total-row {
            font-weight: bold;
            background-color: #e7f3fe;
        }
        .empty-cart {
            text-align: center;
            font-size: 18px;
            color: #666;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Your Cart</h2>
    <%
        Map<Integer, Map<String, Object>> cart = (Map<Integer, Map<String, Object>>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
    %>
        <p class="empty-cart">Your cart is empty.</p>
    <%
        } else {
            double total = 0;
    %>
        <table>
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
                <td><%= price %></td>
                <td><%= qty %></td>
                <td><%= qty * price %></td>
            </tr>
            <% } %>
            <tr class="total-row"><td colspan="4" align="right"><strong>Total:</strong></td><td><%= total %></td></tr>
        </table>
    <% } %>
</div>

</body>
</html>