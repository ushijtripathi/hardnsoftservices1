<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.mycompany.mavenproject2.DBConnection" %>
<%
    HttpSession ordersSession = request.getSession(false);
    if (ordersSession == null || ordersSession.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String username = (String) ordersSession.getAttribute("username");
    String email = (String) ordersSession.getAttribute("email");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders | HNS Services</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="navbar.css">
    <link rel="stylesheet" href="dashboard.css">
    <style>
        .orders-container {
            max-width: 1000px;
            margin: 0 auto;
        }
        .order-card {
            background-color: var(--bg-surface);
            border: 1px solid var(--border-glow);
            border-radius: 12px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(15, 23, 42, 0.01);
            overflow: hidden;
            transition: border-color 0.2s;
        }
        .order-card:hover {
            border-color: var(--accent-cyan);
        }
        .order-summary-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 24px;
            cursor: pointer;
            user-select: none;
            background-color: #fcfcfc;
        }
        .order-meta-info {
            display: flex;
            gap: 40px;
        }
        .meta-col h5 {
            font-size: 11px;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 4px;
        }
        .meta-col p {
            font-size: 14px;
            font-weight: 600;
        }
        .order-status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            background-color: #fef3c7;
            color: #d97706;
        }
        .order-details-drawer {
            display: none; /* Controlled by JS toggle */
            padding: 24px;
            border-top: 1px solid var(--border-glow);
            background-color: #ffffff;
        }
        .drawer-table {
            width: 100%;
            border-collapse: collapse;
        }
        .drawer-table th {
            text-align: left;
            padding: 8px 12px;
            font-size: 12px;
            color: var(--text-muted);
            text-transform: uppercase;
            border-bottom: 1px solid var(--border-glow);
        }
        .drawer-table td {
            padding: 12px;
            font-size: 14px;
            border-bottom: 1px solid var(--border-glow);
        }
    </style>
</head>
<body>

    <header id="navbar">
        <%@ include file="navbar.jsp" %>
    </header>

    <div class="dashboard-container">
        
        <!-- Left Sidebar Navigation -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <div class="logo">
                    <span class="logo-dot"></span> HNS PORTAL
                </div>
            </div>
            
            <nav class="sidebar-menu">
                <a href="dashboard" class="menu-item">
                    <span class="material-symbols-outlined">dashboard</span> Overview
                </a>
                <a href="products" class="menu-item">
                    <span class="material-symbols-outlined">router</span> Hardware Fleet
                </a>
                <a href="software" class="menu-item">
                    <span class="material-symbols-outlined">terminal</span> Software Assets
                </a>
                <a href="contact" class="menu-item">
                    <span class="material-symbols-outlined">support_agent</span> Support Desk
                </a>
                <a href="orders" class="menu-item active">
                    <span class="material-symbols-outlined">receipt_long</span> My Orders
                </a>
            </nav>

            <div class="sidebar-footer">
                <p class="role-badge">ENTERPRISE ADMIN</p>
                <div style="margin-bottom: 12px; color: var(--text-secondary); font-size: 13px; font-weight: 600;">
                    <%= username %>
                </div>
                <a href="logout" class="logout-btn">
                    <span class="material-symbols-outlined" style="font-size: 16px;">logout</span> Log Out
                </a>
            </div>
        </aside>

        <!-- MAIN LAYOUT DIVISION -->
        <main class="main-content">
            
            <div class="orders-container">
                
                <header class="content-header" style="border-top: none; padding-top: 0; margin-bottom: 30px;">
                    <div class="header-title">
                        <h1>Procurement History</h1>
                        <p>View previous hardware and software allocations associated with this corporate account.</p>
                    </div>
                </header>
                
                <%
                    Connection conn = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;
                    
                    try {
                        conn = DBConnection.getConnection();
                        String sql = "SELECT * FROM orders WHERE user_email = ? ORDER BY id DESC";
                        ps = conn.prepareStatement(sql);
                        ps.setString(1, email);
                        rs = ps.executeQuery();
                        
                        boolean hasOrders = false;
                        while (rs.next()) {
                            hasOrders = true;
                            int orderId = rs.getInt("id");
                            double grandTotal = rs.getDouble("total_amount");
                            String status = rs.getString("status");
                            Timestamp createdAt = rs.getTimestamp("created_at");
                            
                            double subtotal = grandTotal / 1.18;
                            double tax = grandTotal - subtotal;
                %>
                <div class="order-card" id="order-<%= orderId %>">
                    
                    <div class="order-summary-header" onclick="toggleOrderDrawer(<%= orderId %>)">
                        <div class="order-meta-info">
                            <div class="meta-col">
                                <h5>Order ID</h5>
                                <p>#HNS-<%= orderId %></p>
                            </div>
                            <div class="meta-col">
                                <h5>Date Logged</h5>
                                <p><%= createdAt.toString().split(" ")[0] %></p>
                            </div>
                            <div class="meta-col">
                                <h5>Grand Total</h5>
                                <p style="color: var(--accent-cyan); font-weight:700;">₹<%= String.format("%,.2f", grandTotal) %></p>
                            </div>
                        </div>
                        <div style="display:flex; align-items:center; gap:16px;">
                            <span class="order-status-badge"><%= status %></span>
                            <span class="material-symbols-outlined expand-icon" id="expand-icon-<%= orderId %>">expand_more</span>
                        </div>
                    </div>
                    
                    <div class="order-details-drawer" id="drawer-<%= orderId %>">
                        <h4 style="font-size:14px; text-transform:uppercase; letter-spacing:0.5px; margin-bottom:12px;">Component Allocation Items</h4>
                        <table class="drawer-table">
                            <thead>
                                <tr>
                                    <th>Item name</th>
                                    <th style="text-align: right;">Unit price</th>
                                    <th style="text-align: center;">Quantity</th>
                                    <th style="text-align: right;">Subtotal</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    PreparedStatement itemPs = conn.prepareStatement("SELECT * FROM order_items WHERE order_id = ?");
                                    itemPs.setInt(1, orderId);
                                    ResultSet itemRs = itemPs.executeQuery();
                                    while (itemRs.next()) {
                                        String name = itemRs.getString("item_name");
                                        double price = itemRs.getDouble("price");
                                        int qty = itemRs.getInt("quantity");
                                        double itemSub = price * qty;
                                %>
                                <tr>
                                    <td><%= name %></td>
                                    <td style="text-align: right;">₹<%= String.format("%,.2f", price) %></td>
                                    <td style="text-align: center;"><%= qty %></td>
                                    <td style="text-align: right;">₹<%= String.format("%,.2f", itemSub) %></td>
                                </tr>
                                <%
                                    }
                                    itemRs.close();
                                    itemPs.close();
                                %>
                            </tbody>
                        </table>
                        
                        <div style="display:flex; justify-content:space-between; align-items:flex-end; margin-top:20px;">
                            <a href="invoice.jsp?orderId=<%= orderId %>" target="_blank" class="btn btn-outlined" style="padding: 8px 16px; border-radius: 6px; text-decoration: none; color: var(--accent-cyan); border-color: var(--accent-cyan); display: flex; align-items: center; gap: 6px;">
                                <span class="material-symbols-outlined" style="font-size: 18px;">download</span> View / Print Invoice
                            </a>
                            <div style="text-align: right; font-size:14px; gap:8px; color:var(--text-secondary); display:flex; flex-direction:column;">
                                <div>Items Subtotal: <strong>₹<%= String.format("%,.2f", subtotal) %></strong></div>
                                <div>GST / Tax (18%): <strong>₹<%= String.format("%,.2f", tax) %></strong></div>
                                <div style="color:var(--text-pure); font-size: 16px; margin-top: 4px;">Grand Total: <strong>₹<%= String.format("%,.2f", grandTotal) %></strong></div>
                            </div>
                        </div>
                    </div>
                    
                </div>
                <%
                        }
                        if (!hasOrders) {
                %>
                <div class="cart-empty-fallback" style="background-color: var(--bg-surface); padding: 40px; border-radius: 12px; border: 1px solid var(--border-glow); text-align:center;">
                    <span class="material-symbols-outlined fallback-icon" style="font-size:48px; color:var(--text-muted);">receipt_long</span>
                    <h3 style="margin-top:12px;">No orders logged</h3>
                    <p style="color:var(--text-secondary); margin-bottom: 20px;">You have not made any hardware or software procurement deployments yet.</p>
                    <a href="products" class="btn btn-filled" style="text-decoration:none;">Shop Products</a>
                </div>
                <%
                        }
                    } catch (Exception e) {
                        out.println("<p>Error loading orders: " + e.getMessage() + "</p>");
                    } finally {
                        if (rs != null) rs.close();
                        if (ps != null) ps.close();
                        if (conn != null) conn.close();
                    }
                %>
                
            </div>

        </main>
    </div>

    <script>
        function toggleOrderDrawer(orderId) {
            const drawer = document.getElementById(`drawer-${orderId}`);
            const icon = document.getElementById(`expand-icon-${orderId}`);
            
            if (drawer.style.display === "block") {
                drawer.style.display = "none";
                icon.innerText = "expand_more";
            } else {
                drawer.style.display = "block";
                icon.innerText = "expand_less";
            }
        }
    </script>
</body>
</html>
