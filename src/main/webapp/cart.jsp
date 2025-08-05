<%@ page import="java.sql.*, products.db.DBUtil" %>
<%@ page session="true" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");

%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Your Cart</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            padding: 20px;
        }
        .container {
            max-width: 800px;
            margin: auto;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        table {
            width: 100%;
            margin-top: 20px;
            border-collapse: collapse;
        }
        th, td {
            padding: 12px;
            border-bottom: 1px solid #ccc;
        }
        th {
            background-color: #4CAF50;
            color: white;
        }
        .total {
            font-weight: bold;
            background-color: #f1f1f1;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Your Cart</h2>

    <%
        double total = 0;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBUtil.getConnection();
            ps = con.prepareStatement("SELECT p.name, p.model, p.price, c.quantity FROM cart c JOIN products p ON c.product_id = p.id WHERE c.user_id = ?");
            ps.setInt(1, userId);
            rs = ps.executeQuery();

            boolean hasItems = false;
    %>
    <table>
        <tr>
            <th>Name</th>
            <th>Model</th>
            <th>Price</th>
            <th>Qty</th>
            <th>Subtotal</th>
        </tr>
        <%
            while (rs.next()) {
                hasItems = true;
                String name = rs.getString("name");
                String model = rs.getString("model");
                double price = rs.getDouble("price");
                int qty = rs.getInt("quantity");
                double subtotal = price * qty;
                total += subtotal;
        %>
        <tr>
            <td><%= name %></td>
            <td><%= model %></td>
            <td><%= price %></td>
            <td><%= qty %></td>
            <td><%= subtotal %></td>
        </tr>
        <% } %>

        <% if (hasItems) { %>
        <tr class="total">
            <td colspan="4" align="right">Total:</td>
            <td><%= total %></td>
        </tr>
        <% } else { %>
        </table>
        <p style="text-align: center; color: #777;">Your cart is empty.</p>
        <% } %>

    <%
        } catch (Exception e) {
            out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
            e.printStackTrace();
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
        }
    %>

</div>
</body>
</html>
