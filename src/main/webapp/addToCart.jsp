<%@ page import="java.util.*, java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*, products.db.DBUtil" %>
<%@ page session="true" %>

<!DOCTYPE html>
<html>
<head>
    <title>Adding to Cart</title>
    <style>
        /* your existing CSS... */
    </style>
</head>
<body>
<div class="container">
<%
    int id = Integer.parseInt(request.getParameter("id"));
    int qty = Integer.parseInt(request.getParameter("qty"));
    Integer userId = (Integer) session.getAttribute("userId"); // null if guest

    Connection con = products.db.DBUtil.getConnection();
    PreparedStatement ps = con.prepareStatement("SELECT * FROM products WHERE id=?");
    ps.setInt(1, id);
    ResultSet rs = ps.executeQuery();

    if (rs.next()) {
        String name = rs.getString("name");
        String model = rs.getString("model");
        double price = rs.getDouble("price");

        // Store in session cart
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

        // ✅ Store in DB if user is logged in
        if (userId != null) {
            PreparedStatement psCheck = con.prepareStatement("SELECT quantity FROM cart WHERE user_id=? AND product_id=?");
            psCheck.setInt(1, userId);
            psCheck.setInt(2, id);
            ResultSet checkRs = psCheck.executeQuery();

            if (checkRs.next()) {
                // Already in cart → update quantity
                int existingQty = checkRs.getInt("quantity");
                PreparedStatement psUpdate = con.prepareStatement("UPDATE cart SET quantity=? WHERE user_id=? AND product_id=?");
                psUpdate.setInt(1, existingQty + qty);
                psUpdate.setInt(2, userId);
                psUpdate.setInt(3, id);
                psUpdate.executeUpdate();
                psUpdate.close();
            } else {
                // Not in cart → insert
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
            // Guest logic → cookie-based session
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
            application.setAttribute(guestID, cart);
        }
%>

    <!-- Success Message -->
    <div class="success-message">
        <h2>Item Added to Cart</h2>
        <p>"<%= name %>" (Qty: <%= qty %>) has been added to your shopping cart.</p>
        <a href="index.jsp" class="button">Continue Shopping</a>
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
    ps.close();
    con.close();
%>
</div>
</body>
</html>
