package com.mycompany.mavenproject2;

import java.io.IOException;
import java.io.StringReader;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import javax.json.Json;
import javax.json.JsonArray;
import javax.json.JsonObject;
import javax.json.JsonReader;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/checkout")
public class checkout extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("email") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String userEmail = (String) session.getAttribute("email");
        String cartData = request.getParameter("cartData");

        if (cartData == null || cartData.trim().isEmpty()) {
            response.sendRedirect("cart.jsp?error=empty");
            return;
        }

        try {
            // Parse JSON Cart Array
            JsonReader reader = Json.createReader(new StringReader(cartData));
            JsonArray cartArray = reader.readArray();
            reader.close();

            if (cartArray.isEmpty()) {
                response.sendRedirect("cart.jsp?error=empty");
                return;
            }

            Connection conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Enable transaction

            try {
                // Calculate Totals
                double subtotal = 0;
                for (int i = 0; i < cartArray.size(); i++) {
                    JsonObject item = cartArray.getJsonObject(i);
                    double price = item.getJsonNumber("price").doubleValue();
                    int qty = item.getInt("qty", 1);
                    subtotal += price * qty;
                }
                double gst = subtotal * 0.18;
                double total = subtotal + gst;

                // Insert Order
                String orderSql = "INSERT INTO orders (user_email, total_amount, status) VALUES (?, ?, 'Pending')";
                PreparedStatement orderPs = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS);
                orderPs.setString(1, userEmail);
                orderPs.setDouble(2, total);
                orderPs.executeUpdate();

                ResultSet rs = orderPs.getGeneratedKeys();
                int orderId = 0;
                if (rs.next()) {
                    orderId = rs.getInt(1);
                }
                rs.close();
                orderPs.close();

                if (orderId == 0) {
                    throw new Exception("Failed to generate order ID.");
                }

                // Insert Order Items
                String itemSql = "INSERT INTO order_items (order_id, item_name, price, quantity) VALUES (?, ?, ?, ?)";
                PreparedStatement itemPs = conn.prepareStatement(itemSql);

                for (int i = 0; i < cartArray.size(); i++) {
                    JsonObject item = cartArray.getJsonObject(i);
                    String name = item.getString("name");
                    double price = item.getJsonNumber("price").doubleValue();
                    int qty = item.getInt("qty", 1);

                    itemPs.setInt(1, orderId);
                    itemPs.setString(2, name);
                    itemPs.setDouble(3, price);
                    itemPs.setInt(4, qty);
                    itemPs.addBatch();
                }

                itemPs.executeBatch();
                itemPs.close();

                conn.commit(); // Commit transaction
                conn.close();

                // Redirect to checkout success
                response.sendRedirect("checkout_success.jsp?orderId=" + orderId);

            } catch (Exception ex) {
                conn.rollback(); // Rollback on error
                conn.close();
                throw ex;
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("cart.jsp?error=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        }
    }
}
