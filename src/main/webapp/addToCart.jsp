<%@ page import="java.util.*, java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>
<%@ page session="true" %>

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
            cookie.setMaxAge(60*60*24*30); // 30 days
            response.addCookie(cookie);
        }

        application.setAttribute(guestID, cart); // for restoring later
    }

    response.sendRedirect("cart.jsp");
%>
