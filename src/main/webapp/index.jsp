<%@ page import="java.sql.*, java.util.*, jakarta.servlet.http.*, jakarta.servlet.*" %>
<%@ page session="true" %>


<%
    Connection con = products.db.DBUtil.getConnection();
    Statement stmt = con.createStatement();
    ResultSet rs = stmt.executeQuery("SELECT * FROM products");
%>

<h2>Product Catalog</h2>
<table border="1">
    <tr><th>Name</th><th>Model</th><th>Price</th><th>Action</th></tr>
    <%
        while(rs.next()) {
    %>
        <form action="addToCart.jsp" method="post">
        <tr>
            <td><%= rs.getString("name") %></td>
            <td><%= rs.getString("model") %></td>
            <td>₹<%= rs.getDouble("price") %></td>
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
