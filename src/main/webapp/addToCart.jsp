<%@ page import="java.util.*, java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>
<%@ page session="true" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Adding to Cart</title>
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
        .success-message {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
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
    int id = Integer.parseInt(request.getParameter("id"));
    int qty = Integer.parseInt(request.getParameter("qty"));

    Connection con = products.db.DBUtil.getConnection();
    PreparedStatement ps = con.prepareStatement("SELECT * FROM products WHERE id=?");
    ps.setInt(1, id);
    ResultSet rs = ps.executeQuery();

    if (rs.next()) {
        String name = rs.getString("name");
        String model = rs.getString("model");
        double price = rs.getDouble("price");

        Map<Integer, Map<String, Object>> cart = (Map<Integer, Map<String, Object>>) session.getAttribute("cart");
        if (cart == null) cart = new HashMap<>();

        if (cart.containsKey(id)) {
            int existingQty = (int) cart.get(id).get("qty");
            cart.get(id).put("qty", existingQty + qty);
        } else {
            Map<String, Object> item = new HashMap<>();
            item.put("name", name);
            item.put("model", model);
            item.put("price", price);
            item.put("qty", qty);
            cart.put(id, item);
        }

        session.setAttribute("cart", cart);

        // Cookie for guest
        String guestID = null;
        Cookie[] cookies = request.getCookies();
        for (Cookie c : cookies) {
            if (c.getName().equals("guestID")) {
                guestID = c.getValue();
                break;
            }
        }

        if (guestID == null) {
            guestID = UUID.randomUUID().toString();
            Cookie cookie = new Cookie("guestID", guestID);
            cookie.setMaxAge(60 * 60 * 24 * 30); // 30 days
            response.addCookie(cookie);
        }

        application.setAttribute(guestID, cart); // for restoring later
%>
        <!-- Success Message -->
        <div class="success-message">
            <h2>Item Added to Cart</h2>
            <p>"<%= name %>" (Qty: <%= qty %>) has been added to your shopping cart.</p>
            <a href="products.jsp" class="button">Continue Shopping</a>
            <a href="cart.jsp" class="button">View Cart</a>
        </div>
<%
    } else {
%>
        <!-- Error Message -->
        <div class="error-message">
            <h2>Product Not Found</h2>
            <p>The product you tried to add is no longer available.</p>
            <a href="index.jsp" class="button">Back to Products</a>
        </div>
<%
    }
    rs.close();
    con.close();
%>
</div>

</body>
</html>