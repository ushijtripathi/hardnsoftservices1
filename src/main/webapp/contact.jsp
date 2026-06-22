<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    HttpSession contactSession = request.getSession(false);
    boolean isLoggedIn = (contactSession != null && contactSession.getAttribute("username") != null);
    String username = isLoggedIn ? (String) contactSession.getAttribute("username") : "Guest";
    
    String isSuccess = request.getParameter("success");
    String errorMessage = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us | HNS Services</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="contact.css">
    <link rel="stylesheet" href="navbar.css">
    <link rel="stylesheet" href="dashboard.css">
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
                <a href="contact" class="menu-item active">
                    <span class="material-symbols-outlined">support_agent</span> Support Desk
                </a>
                <a href="orders" class="menu-item">
                    <span class="material-symbols-outlined">receipt_long</span> My Orders
                </a>
            </nav>

            <div class="sidebar-footer">
                <% if (isLoggedIn) { %>
                    <p class="role-badge">ENTERPRISE ADMIN</p>
                    <div style="margin-bottom: 12px; color: var(--text-secondary); font-size: 13px; font-weight: 600;">
                        <%= username %>
                    </div>
                    <a href="logout" class="logout-btn">
                        <span class="material-symbols-outlined" style="font-size: 16px;">logout</span> Log Out
                    </a>
                <% } else { %>
                    <p class="role-badge">GUEST USER</p>
                    <div style="margin-bottom: 12px; color: var(--text-secondary); font-size: 13px; font-weight: 600;">
                        Welcome to HNS
                    </div>
                    <a href="login.jsp" class="logout-btn" style="color: var(--accent-green); border-color: rgba(16,185,129,0.4); background-color: rgba(16,185,129,0.05);">
                        <span class="material-symbols-outlined" style="font-size: 16px;">login</span> Log In
                    </a>
                <% } %>
            </div>
        </aside>

        <!-- MAIN LAYOUT DIVISION -->
        <main class="main-content" style="padding: 40px;">
            
            <div class="contact-master-container" style="margin-top:0;">
                
                <!-- INTRO HEADER -->
                <header class="contact-page-header">
                    <h1>Get in <span class="cyan-gradient-text">Touch</span></h1>
                    <p>Whether you need a custom security quote, technical support, or partnership details, our team is ready to help.</p>
                </header>
                
                <% if (isSuccess != null && isSuccess.equals("true")) { %>
                    <div class="success-banner" style="background-color: #d1fae5; color: #065f46; border: 1px solid #a7f3d0; padding: 20px; border-radius: 8px; font-weight: 600; margin-bottom: 30px; display: flex; align-items: center; gap:12px; max-width:1200px; margin-left:auto; margin-right:auto;">
                        <span class="material-symbols-outlined">check_circle</span>
                        <span>Your message has been delivered to HNS support desk. We will respond via email shortly.</span>
                    </div>
                <% } %>
                
                <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
                    <div class="error-banner" style="display:block; margin-bottom:30px; max-width:1200px; margin-left:auto; margin-right:auto;">
                        Error: <%= errorMessage %>
                    </div>
                <% } %>

                <!-- MAIN CORE DUAL-PANE GRID -->
                <div class="contact-workspace-grid">
                    
                    <!-- LEFT PANE: HIGH-END CORPORATE DETAILS -->
                    <aside class="corporate-details-pane">
                        <div class="detail-card-group">
                            <h2>Headquarters</h2>
                            <p class="pane-subtitle">Reach out to us directly or drop by our office.</p>
                        </div>

                        <div class="info-link-stack">
                            
                            <!-- Address Block -->
                            <div class="info-icon-card">
                                <div class="icon-frame">
                                    <span class="material-symbols-outlined">location_on</span>
                                </div>
                                <div class="info-text">
                                    <h4>Address</h4>
                                    <p>103 B Block, Silver Mall<br>Indore, Madhya Pradesh<br>India</p>
                                </div>
                            </div>

                            <!-- Direct Lines Block -->
                            <div class="info-icon-card">
                                <div class="icon-frame">
                                    <span class="material-symbols-outlined">call</span>
                                </div>
                                <div class="info-text">
                                    <h4>Direct Lines</h4>
                                    <p>Sales: <a href="tel:+919826628028" class="inline-link">+91 9826628028</a></p>
                                    <p>Support: <a href="tel:1800HNSELP" class="inline-link">1800-HNS-HELP</a></p>
                                </div>
                            </div>

                            <!-- Email Block -->
                            <div class="info-icon-card">
                                <div class="icon-frame">
                                    <span class="material-symbols-outlined">mail</span>
                                </div>
                                <div class="info-text">
                                    <h4>Email Addresses</h4>
                                    <p><a href="mailto:sales@hnsservices.in" class="inline-link">sales@hnsservices.in</a></p>
                                    <p><a href="mailto:support@hnsservices.in" class="inline-link">support@hnsservices.in</a></p>
                                </div>
                            </div>

                        </div>
                    </aside>

                    <!-- RIGHT PANE: GLASSMORPHIC INTERACTIVE INPUT HUB -->
                    <main class="message-form-pane">
                        <div class="glass-form-card">
                            <h3>Send a Message</h3>
                            
                            <form id="contactForm" action="submitContactForm" method="POST" class="hns-interactive-form">
                                
                                <div class="input-field-group">
                                    <label for="name">Name</label>
                                    <input type="text" id="name" name="name" placeholder="ushij tripathi" required>
                                </div>

                                <div class="input-field-group">
                                    <label for="email">Email</label>
                                    <input type="email" id="email" name="email" placeholder="uzi@example.com" required>
                                </div>

                                <div class="input-field-group">
                                    <label for="inquiryType">Inquiry Type</label>
                                    <input type="text" id="inquiryType" name="inquiryType" placeholder="e.g. Bulk Pricing" required>
                                </div>

                                <div class="input-field-group">
                                    <label for="message">Message</label>
                                    <textarea id="message" name="message" rows="5" placeholder="How can we help you?" required></textarea>
                                </div>

                                <button type="submit" class="premium-submit-action">
                                    <span>Submit Request</span>
                                    <span class="material-symbols-outlined">send</span>
                                </button>

                            </form>
                        </div>
                    </main>

                </div>

                <!-- CORPORATE LEGAL FOOTER -->
                <footer class="contact-footer-brand">
                    <h4>HardNSoft Services</h4>
                    <p>103 B Block, Silver Mall, Indore | +91 9826628028</p>
                </footer>

            </div>

        </main>
    </div>

    <script>
        const IS_LOGGED_IN = <%= isLoggedIn %>;
        
        document.getElementById("contactForm").addEventListener("submit", function(event) {
            if (!IS_LOGGED_IN) {
                event.preventDefault();
                alert("You must log in to submit a corporate inquiry.");
                window.location.href = "login.jsp";
            }
        });
    </script>
</body>
</html>
