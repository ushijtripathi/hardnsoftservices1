<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.mycompany.mavenproject2.DBConnection" %>
<%
    HttpSession invoiceSession = request.getSession(false);
    if (invoiceSession == null || invoiceSession.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String email = (String) invoiceSession.getAttribute("email");
    String orderIdParam = request.getParameter("orderId");
    
    if (orderIdParam == null || orderIdParam.trim().isEmpty()) {
        out.println("Invalid Order ID.");
        return;
    }
    int orderId = Integer.parseInt(orderIdParam);
    
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    
    boolean isAuthorized = false;
    double grandTotal = 0;
    Timestamp createdAt = null;
    
    try {
        conn = DBConnection.getConnection();
        // Verify this order belongs to this user
        ps = conn.prepareStatement("SELECT * FROM orders WHERE id = ? AND user_email = ?");
        ps.setInt(1, orderId);
        ps.setString(2, email);
        rs = ps.executeQuery();
        
        if (rs.next()) {
            isAuthorized = true;
            grandTotal = rs.getDouble("total_amount");
            createdAt = rs.getTimestamp("created_at");
        } else {
            out.println("Unauthorized access or Order not found.");
            return;
        }
    } catch (Exception e) {
        out.println("Database error: " + e.getMessage());
        return;
    }
    
    double subtotal = grandTotal / 1.18;
    double tax = grandTotal - subtotal;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tax Invoice #HNS-<%= orderId %></title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-void: #f8fafc;
            --bg-surface: #ffffff;
            --text-primary: #333333;
            --text-secondary: #555555;
            --border-glass: #cbd5e1;
            --accent-cyan: #10b981;
            --font-main: 'Plus Jakarta Sans', sans-serif;
        }
        body {
            font-family: var(--font-main);
            background-color: #f1f5f9;
            margin: 0;
            padding: 40px;
            color: var(--text-primary);
        }
        .invoice-box {
            max-width: 800px;
            margin: auto;
            padding: 40px;
            border: 1px solid var(--border-glass);
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            background: #fff;
            border-radius: 8px;
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            border-bottom: 2px solid var(--border-glass);
            padding-bottom: 20px;
            margin-bottom: 30px;
        }
        .logo-section h1 {
            margin: 0;
            font-size: 24px;
            color: var(--text-primary);
        }
        .logo-section p {
            margin: 4px 0 0 0;
            font-size: 14px;
            color: var(--text-secondary);
            line-height: 1.5;
        }
        .invoice-details {
            text-align: right;
        }
        .invoice-details h2 {
            margin: 0 0 8px 0;
            font-size: 28px;
            color: var(--text-primary);
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .invoice-details p {
            margin: 2px 0;
            font-size: 14px;
            color: var(--text-secondary);
        }
        .billing-info {
            display: flex;
            justify-content: space-between;
            margin-bottom: 40px;
        }
        .billing-info div {
            width: 45%;
        }
        .billing-info h3 {
            font-size: 14px;
            text-transform: uppercase;
            color: var(--text-secondary);
            margin-bottom: 8px;
            letter-spacing: 0.5px;
        }
        .billing-info p {
            font-size: 15px;
            margin: 4px 0;
            line-height: 1.5;
        }
        table.items-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 30px;
        }
        table.items-table th {
            background-color: var(--bg-void);
            padding: 12px;
            text-align: left;
            font-size: 13px;
            text-transform: uppercase;
            color: var(--text-secondary);
            border-bottom: 2px solid var(--border-glass);
        }
        table.items-table td {
            padding: 14px 12px;
            border-bottom: 1px solid var(--border-glass);
            font-size: 14px;
        }
        .totals-section {
            display: flex;
            justify-content: flex-end;
        }
        .totals-box {
            width: 300px;
        }
        .totals-row {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            font-size: 14px;
            color: var(--text-secondary);
        }
        .totals-row.grand-total {
            border-top: 2px solid var(--border-glass);
            margin-top: 8px;
            padding-top: 12px;
            font-size: 18px;
            font-weight: 700;
            color: var(--text-primary);
        }
        .footer {
            margin-top: 50px;
            text-align: center;
            font-size: 12px;
            color: var(--text-secondary);
            border-top: 1px solid var(--border-glass);
            padding-top: 20px;
        }
        .print-btn {
            display: block;
            width: 200px;
            margin: 20px auto;
            padding: 12px;
            background-color: var(--text-primary);
            color: #fff;
            text-align: center;
            text-decoration: none;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            border: none;
        }
        @media print {
            body {
                background-color: #fff;
                padding: 0;
            }
            .invoice-box {
                box-shadow: none;
                border: none;
                padding: 0;
            }
            .print-btn {
                display: none;
            }
        }
    </style>
</head>
<body>

    <button class="print-btn" onclick="window.print()">Print Invoice</button>

    <div class="invoice-box">
        <div class="header">
            <div class="logo-section">
                <h1>HardNSoft Services</h1>
                <p>103 B Block, Silver Mall<br>Indore, Madhya Pradesh 452001<br>GSTIN: 23ABCDE1234F1Z5</p>
            </div>
            <div class="invoice-details">
                <h2>TAX INVOICE</h2>
                <p><strong>Invoice No:</strong> INV-HNS-<%= orderId %></p>
                <p><strong>Date:</strong> <%= createdAt != null ? createdAt.toString().split(" ")[0] : "" %></p>
            </div>
        </div>

        <div class="billing-info">
            <div>
                <h3>Billed To:</h3>
                <p><strong><%= email %></strong></p>
                <p>Enterprise Client</p>
                <p>India</p>
            </div>
            <div>
                <h3>Ship To / Deployment Site:</h3>
                <p>Same as Billing Address</p>
            </div>
        </div>

        <table class="items-table">
            <thead>
                <tr>
                    <th>Description</th>
                    <th style="text-align: center;">Qty</th>
                    <th style="text-align: right;">Unit Price</th>
                    <th style="text-align: right;">Total Amount</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try {
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
                    <td style="text-align: center;"><%= qty %></td>
                    <td style="text-align: right;">₹<%= String.format("%,.2f", price) %></td>
                    <td style="text-align: right;">₹<%= String.format("%,.2f", itemSub) %></td>
                </tr>
                <%
                        }
                        itemRs.close();
                        itemPs.close();
                    } catch (Exception e) {
                        out.println("<tr><td colspan='4'>Error loading items</td></tr>");
                    } finally {
                        if (rs != null) rs.close();
                        if (ps != null) ps.close();
                        if (conn != null) conn.close();
                    }
                %>
            </tbody>
        </table>

        <div class="totals-section">
            <div class="totals-box">
                <div class="totals-row">
                    <span>Subtotal</span>
                    <span>₹<%= String.format("%,.2f", subtotal) %></span>
                </div>
                <div class="totals-row">
                    <span>IGST (18%)</span>
                    <span>₹<%= String.format("%,.2f", tax) %></span>
                </div>
                <div class="totals-row grand-total">
                    <span>Grand Total</span>
                    <span>₹<%= String.format("%,.2f", grandTotal) %></span>
                </div>
            </div>
        </div>

        <div class="footer">
            <p><strong>Terms & Conditions:</strong> Goods once sold will not be taken back. Subject to Indore jurisdiction.</p>
            <p>Thank you for choosing HardNSoft Services for your enterprise security and networking needs.</p>
        </div>
    </div>

</body>
</html>
