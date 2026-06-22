<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.mycompany.mavenproject2.DBConnection" %>
<%
    HttpSession successSession = request.getSession(false);
    if (successSession == null || successSession.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String username = (String) successSession.getAttribute("username");
    String email = (String) successSession.getAttribute("email");
    
    String orderIdStr = request.getParameter("orderId");
    if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
        response.sendRedirect("dashboard");
        return;
    }
    
    int orderId = Integer.parseInt(orderIdStr);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmed | HNS Services</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="navbar.css">
    <link rel="stylesheet" href="dashboard.css">
    <style>
        .invoice-card {
            background-color: var(--bg-surface);
            border: 1px solid var(--border-glow);
            border-radius: 16px;
            padding: 40px;
            max-width: 800px;
            margin: 0 auto 40px auto;
            box-shadow: 0 4px 20px rgba(15, 23, 42, 0.05);
        }
        .success-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .success-icon {
            color: #10b981;
            font-size: 64px;
            margin-bottom: 16px;
        }
        .invoice-meta {
            display: flex;
            justify-content: space-between;
            border-bottom: 1px solid var(--border-glow);
            padding-bottom: 20px;
            margin-bottom: 20px;
        }
        .meta-group h4 {
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: var(--text-muted);
            margin-bottom: 6px;
        }
        .meta-group p {
            font-size: 15px;
            font-weight: 600;
        }
        .invoice-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 30px;
        }
        .invoice-table th {
            text-align: left;
            padding: 12px;
            border-bottom: 2px solid var(--border-glow);
            color: var(--text-secondary);
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .invoice-table td {
            padding: 14px 12px;
            border-bottom: 1px solid var(--border-glow);
            font-size: 14px;
        }
        .invoice-totals {
            width: 300px;
            margin-left: auto;
            margin-bottom: 30px;
        }
        .total-row {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            font-size: 14px;
            color: var(--text-secondary);
        }
        .total-row.grand-total {
            font-size: 18px;
            font-weight: 700;
            color: var(--text-pure);
            border-top: 1px solid var(--border-glow);
            padding-top: 12px;
            margin-top: 6px;
        }
        .invoice-actions {
            display: flex;
            justify-content: center;
            gap: 16px;
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
            
            <%
                Connection conn = null;
                PreparedStatement orderPs = null;
                ResultSet orderRs = null;
                
                try {
                    conn = DBConnection.getConnection();
                    
                    // Fetch order metadata
                    String orderSql = "SELECT * FROM orders WHERE id = ? AND user_email = ?";
                    orderPs = conn.prepareStatement(orderSql);
                    orderPs.setInt(1, orderId);
                    orderPs.setString(2, email);
                    orderRs = orderPs.executeQuery();
                    
                    if (orderRs.next()) {
                        double grandTotal = orderRs.getDouble("total_amount");
                        String status = orderRs.getString("status");
                        Timestamp createdAt = orderRs.getTimestamp("created_at");
                        
                        double subtotal = grandTotal / 1.18;
                        double tax = grandTotal - subtotal;
            %>
            <div class="invoice-card" style="margin-top: 20px;">
                
                <div class="success-header">
                    <span class="material-symbols-outlined success-icon">check_circle</span>
                    <h2>Order Confirmed!</h2>
                    <p style="color: var(--text-secondary);">Your deployment request has been logged successfully.</p>
                </div>
                
                <div class="invoice-meta">
                    <div class="meta-group">
                        <h4>Order ID</h4>
                        <p>#HNS-<%= orderId %></p>
                    </div>
                    <div class="meta-group">
                        <h4>Date & Time</h4>
                        <p><%= createdAt.toString() %></p>
                    </div>
                    <div class="meta-group">
                        <h4>Account</h4>
                        <p><%= email %></p>
                    </div>
                    <div class="meta-group">
                        <h4>Status</h4>
                        <p style="color: #d97706;"><%= status %></p>
                    </div>
                </div>
                
                <table class="invoice-table">
                    <thead>
                        <tr>
                            <th>Description</th>
                            <th style="text-align: right;">Unit Price</th>
                            <th style="text-align: center;">Qty</th>
                            <th style="text-align: right;">Subtotal</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            PreparedStatement itemsPs = conn.prepareStatement("SELECT * FROM order_items WHERE order_id = ?");
                            itemsPs.setInt(1, orderId);
                            ResultSet itemsRs = itemsPs.executeQuery();
                            
                            while (itemsRs.next()) {
                                String itemName = itemsRs.getString("item_name");
                                double price = itemsRs.getDouble("price");
                                int qty = itemsRs.getInt("quantity");
                                double itemSub = price * qty;
                        %>
                        <tr>
                            <td><%= itemName %></td>
                            <td style="text-align: right;">₹<%= String.format("%,.2f", price) %></td>
                            <td style="text-align: center;"><%= qty %></td>
                            <td style="text-align: right;">₹<%= String.format("%,.2f", itemSub) %></td>
                        </tr>
                        <%
                            }
                            itemsRs.close();
                            itemsPs.close();
                        %>
                    </tbody>
                </table>
                
                <div class="invoice-totals">
                    <div class="total-row">
                        <span>Items Subtotal</span>
                        <span>₹<%= String.format("%,.2f", subtotal) %></span>
                    </div>
                    <div class="total-row">
                        <span>GST / Tax (18%)</span>
                        <span>₹<%= String.format("%,.2f", tax) %></span>
                    </div>
                    <div class="total-row">
                        <span>Shipping & Logistics</span>
                        <span style="color: #10b981; font-weight:600;">FREE</span>
                    </div>
                    <div class="total-row grand-total">
                        <span>Total Paid</span>
                        <span>₹<%= String.format("%,.2f", grandTotal) %></span>
                    </div>
                </div>
                
                <div class="invoice-actions">
                    <a href="orders" class="btn btn-filled" style="text-decoration:none;">View All Orders</a>
                    <a href="dashboard" class="btn btn-outlined" style="text-decoration:none;">Back to Command Center</a>
                </div>
                
            </div>
            <%
                    } else {
            %>
            <div class="error-banner" style="display:block;">
                Order #<%= orderId %> not found or access is denied.
            </div>
            <%
                    }
                } catch (Exception e) {
                    out.println("<p>Error loading invoice: " + e.getMessage() + "</p>");
                } finally {
                    if (orderRs != null) orderRs.close();
                    if (orderPs != null) orderPs.close();
                    if (conn != null) conn.close();
                }
            %>

        </main>
    </div>

</body>
</html>
