<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    HttpSession dealerSession = request.getSession(false);
    if (dealerSession == null || dealerSession.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String username = (String) dealerSession.getAttribute("username");
    
    String isSuccess = request.getParameter("success");
    String errorMessage = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dealer Partner Program | HNS Services</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="dealer.css">
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
                <a href="contact" class="menu-item">
                    <span class="material-symbols-outlined">support_agent</span> Support Desk
                </a>
                <a href="orders" class="menu-item">
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
        <main class="main-content" style="padding: 40px;">
            
            <div class="page-master-wrapper" style="margin-top:0;">

                <!-- CINEMATIC HERO SECTION -->
                <section class="dealer-hero-showcase" style="border-radius:12px; border:1px solid var(--border-glow); padding:50px;">
                    <div class="hero-inner-frame">
                        <div class="badge-pill">
                            <span class="pulse-indicator"></span> GLOBAL PARTNERSHIP PROGRAM
                        </div>
                        <h1>Become a <span class="cyan-gradient-text">Dealer Partner</span></h1>
                        <p class="hero-description">Scale your security business with Hard & Soft Services' elite Dealer Program. Access enterprise-grade hardware and software solutions at exclusive wholesale rates with dedicated support.</p>
                        <div class="hero-button-matrix">
                            <a href="#partnership-gate" class="action-button primary-glow" style="text-decoration:none;">Apply Now</a>
                            <a href="#advantages-bento" class="action-button secondary-glass" style="text-decoration:none;">View Benefits</a>
                        </div>
                    </div>
                </section>

                <!-- HIGH-END BENTO GRID ADVANTAGES -->
                <section class="advantages-bento-workspace" id="advantages-bento" style="margin-top:40px;">
                    <div class="workspace-header">
                        <h2>Partner Advantages</h2>
                        <p>Engineered layers built to drive your enterprise scalability forward.</p>
                    </div>

                    <div class="bento-grid-container">
                        <!-- Bento Card 1: Bulk Pricing -->
                        <div class="bento-card large-span">
                            <div class="card-glow-overlay"></div>
                            <div class="bento-card-content">
                                <div class="icon-vector-box">
                                    <span class="material-symbols-outlined">analytics</span>
                                </div>
                                <div class="text-vector-box">
                                    <h3>Bulk pricing</h3>
                                    <p>Maximize your margins with tiered volume discounts. Gain access to exclusive wholesale price lists designed for high-volume enterprise deployment and sustainable scaling.</p>
                                </div>
                            </div>
                        </div>

                        <!-- Bento Card 2: Priority Support -->
                        <div class="bento-card">
                            <div class="card-glow-overlay"></div>
                            <div class="bento-card-content vertical">
                                <div class="icon-vector-box accent-glow">
                                    <span class="material-symbols-outlined">headset_mic</span>
                                </div>
                                <div>
                                    <h3>Priority support</h3>
                                    <p>Bypass standard queues with a direct line to our senior engineering team. Get rapid hardware diagnostics and software troubleshooting to keep your clients secure.</p>
                                </div>
                            </div>
                        </div>

                        <!-- Bento Card 3: Dedicated Account Management -->
                        <div class="bento-card full-row-span">
                            <div class="card-glow-overlay"></div>
                            <div class="bento-card-content horizontal-split">
                                <div class="icon-vector-box amber-glow">
                                    <span class="material-symbols-outlined">shield_person</span>
                                </div>
                                <div class="split-text-block">
                                    <h3>Dedicated account management</h3>
                                    <p>A single point of contact for all your logistical and technical needs. Your dedicated manager ensures seamless procurement and helps you navigate complex security architectures.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- MODERN DUAL-PANE APPLICATION HUB -->
                <section class="partnership-application-gate" id="partnership-gate" style="margin-top:60px;">
                    
                    <% if (isSuccess != null && isSuccess.equals("true")) { %>
                        <div class="success-banner" style="background-color: #d1fae5; color: #065f46; border: 1px solid #a7f3d0; padding: 20px; border-radius: 8px; font-weight: 600; margin-bottom: 30px; display: flex; align-items: center; gap:12px;">
                            <span class="material-symbols-outlined">check_circle</span>
                            <span>Your inquiry has been logged successfully. An account executive will reach out to you within 24 hours.</span>
                        </div>
                    <% } %>
                    
                    <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
                        <div class="error-banner" style="display:block; margin-bottom:30px;">
                            Error: <%= errorMessage %>
                        </div>
                    <% } %>

                    <div class="gate-grid-framework">
                        
                        <!-- Left Control Block -->
                        <div class="gate-text-pane">
                            <div class="sticky-pane-wrap">
                                <h2>Inquiry for Partnership</h2>
                                <p class="pane-lead">Fill out the details below, and our business development team will contact you within 24 hours to begin the verification process.</p>
                                
                                <div class="compliance-row-stack">
                                    <div class="compliance-item">
                                        <span class="material-symbols-outlined">verified_user</span>
                                        <div>
                                            <h5>CORPORATE VERIFICATION</h5>
                                            <p>Standard 24-hour turnaround for all enterprise applications.</p>
                                        </div>
                                    </div>
                                    <div class="compliance-item">
                                        <span class="material-symbols-outlined">language</span>
                                        <div>
                                            <h5>GLOBAL REACH</h5>
                                            <p>We support logistics and regional compliance across 40+ countries.</p>
                                        </div>
                                    </div>
                                </div>

                                <!-- INTEGRATED COMMS SPLIT -->
                                <div class="integrated-comms-module">
                                    <h4>Direct Communications</h4>
                                    <div class="comms-buttons-row">
                                        <a href="tel:9826628028" class="comm-trigger call">
                                            <span class="material-symbols-outlined">phone_in_talk</span> Call Team
                                        </a>
                                        <a href="https://wa.me/919826628028" target="_blank" class="comm-trigger whatsapp">
                                            <span class="material-symbols-outlined">chat_bubble</span> WhatsApp Us
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Right Premium Input Card -->
                        <div class="gate-form-pane">
                            <form action="submitDealerInquiry" method="POST" class="glass-engineered-form">
                                
                                <div class="form-input-row">
                                    <div class="interactive-field">
                                        <label for="fullName">Full Name</label>
                                        <input type="text" id="fullName" name="fullName" placeholder="John Doe" required>
                                    </div>
                                    <div class="interactive-field">
                                        <label for="companyName">Company Name</label>
                                        <input type="text" id="companyName" name="companyName" placeholder="Security Corp LLC" required>
                                    </div>
                                </div>

                                <div class="interactive-field">
                                    <label for="workEmail">Work Email</label>
                                    <input type="email" id="workEmail" name="workEmail" placeholder="john@securitycorp.com" required>
                                </div>

                                <div class="interactive-field">
                                    <label for="volumeRange">Projected Annual Volume</label>
                                    <div class="custom-select-wrapper">
                                        <select id="volumeRange" name="volumeRange" required>
                                            <option value="" disabled selected hidden>Select expected procurement range</option>
                                            <option value="low">$10k - $50k</option>
                                            <option value="mid" selected>$50k - $250k</option>
                                            <option value="high">$250k - $1M</option>
                                            <option value="enterprise">$1M+</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="interactive-field">
                                    <label for="additionalDetails">Additional Details</label>
                                    <textarea id="additionalDetails" name="additionalDetails" rows="5" placeholder="Outline specific hardware infrastructure or brand fleet allocations needed..."></textarea>
                                </div>

                                <button type="submit" class="submit-action-btn">
                                    <span>Submit Partnership Request</span>
                                    <span class="material-symbols-outlined">arrow_right_alt</span>
                                </button>
                            </form>
                        </div>

                    </div>
                </section>

                <!-- PREMIUM LEGAL FOOTER -->
                <footer class="portal-footer">
                    <p>© 2026 HardNSoft Services. All Rights Reserved.</p>
                </footer>

            </div>

        </main>
    </div>

</body>
</html>
