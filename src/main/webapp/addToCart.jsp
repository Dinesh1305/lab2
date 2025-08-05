<%@ page import="java.util.*, java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*, products.db.DBUtil" %>
<%@ page session="true" %>

<!DOCTYPE html>
<html>
<head>
    <title>Adding to Cart</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            padding: 20px;
            margin: 0;
        }

        .container {
            max-width: 600px;
            margin: 50px auto;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.1);
            padding: 30px;
            text-align: center;
        }

        h2 {
            color: #333;
            margin-bottom: 15px;
        }

        .success-message,
        .error-message {
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 20px;
            font-size: 16px;
        }

        .success-message {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .button {
            display: inline-block;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            padding: 10px 20px;
            border-radius: 4px;
            margin: 10px 5px;
            transition: background-color 0.3s ease;
        }

        .button:hover {
            background-color: #0056b3;
        }

        p {
            margin: 10px 0;
        }
    </style>
</head>
<body>

<div class="container">
<%
    int id = Integer.parseInt(request.getParameter("id"));
    int qty = Integer.parseInt(request.getParameter("qty"));
    Integer userId = (Integer) session.getAttribute("userId");

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

        if (userId != null) {
            PreparedStatement psCheck = con.prepareStatement("SELECT quantity FROM cart WHERE user_id=? AND product_id=?");
            psCheck.setInt(1, userId);
            psCheck.setInt(2, id);
            ResultSet checkRs = psCheck.executeQuery();

            if (checkRs.next()) {
                int existingQty = checkRs.getInt("quantity");
                PreparedStatement psUpdate = con.prepareStatement("UPDATE cart SET quantity=? WHERE user_id=? AND product_id=?");
                psUpdate.setInt(1, existingQty + qty);
                psUpdate.setInt(2, userId);
                psUpdate.setInt(3, id);
                psUpdate.executeUpdate();
                psUpdate.close();
            } else {
                PreparedStatement psInsert = con.prepareStatement("INSERT INTO cart (user_id, product_id, quantity) VALUES (?, ?, ?)");
                psInsert.setInt(1, userId);
                psInsert.setInt(2, id);
                psInsert.setInt(3, qty);
                psInsert.executeUpdate();
                psInsert.close();
            }
            checkRs.close();
            psCheck.close();
        } else {
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
                cookie.setMaxAge(60 * 60 * 24 * 30);
                response.addCookie(cookie);
            }
            application.setAttribute(guestID, cart);
        }
%>
    <div class="success-message">
        <h2>Item Added to Cart</h2>
        <p>"<%= name %>" (Qty: <%= qty %>) has been added to your shopping cart.</p>
    </div>
    <a href="index.jsp" class="button">Continue Shopping</a>
    <a href="cart.jsp" class="button">View Cart</a>
<%
    } else {
%>
    <div class="error-message">
        <h2>Product Not Found</h2>
        <p>The product you tried to add is no longer available.</p>
    </div>
    <a href="index.jsp" class="button">Back to Products</a>
<%
    }
    rs.close();
    ps.close();
    con.close();
%>
</div>

</body>
</html>
