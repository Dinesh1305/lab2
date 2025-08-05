


<%@ page import="java.sql.*, java.util.*, jakarta.servlet.http.*, jakarta.servlet.*" %>
<%@ page session="true" %>

<%
    Connection con = products.db.DBUtil.getConnection();
    Statement stmt = con.createStatement();
    ResultSet rs = stmt.executeQuery("SELECT * FROM products");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Catalog</title>
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
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
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
        input[type="number"] {
            width: 50px;
            padding: 5px;
            margin-right: 10px;
        }
        input[type="submit"] {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 10px 15px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        input[type="submit"]:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>

<h2>Product Catalog</h2>
<table>
    <tr><th>Name</th><th>Model</th><th>Price</th><th>Action</th></tr>
    <%
        while(rs.next()) {
    %>
        <form action="addToCart.jsp" method="post">
        <tr>
            <td><%= rs.getString("name") %></td>
            <td><%= rs.getString("model") %></td>
            <td><%= rs.getDouble("price") %></td>
            <td>
                Qty: <input type="number" name="qty" value="1" min="1"/>
                <input type="hidden" name="id" value="<%= rs.getInt("id") %>"/>
                <input type="submit" value="Add to Cart"/>
            </td>
        </tr>
        </form>
    <%
        }
        rs.close();
        con.close();
    %>
</table>

</body>
</html>