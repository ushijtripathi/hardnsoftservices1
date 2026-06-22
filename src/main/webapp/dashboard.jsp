<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    HttpSession dashSession = request.getSession(false);
    boolean isLoggedIn = (dashSession != null && dashSession.getAttribute("username") != null);
    String username = isLoggedIn ? (String) dashSession.getAttribute("username") : "Guest";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enterprise Portal | hardnsoft Services</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="dashboard.css">
    <link rel="stylesheet" href="navbar.css">
</head>
<body>

    <!-- UNIVERSAL NAVBAR FETCH -->
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
                <a href="dashboard" class="menu-item active">
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
                <% if (isLoggedIn) { %>
                <a href="orders" class="menu-item">
                    <span class="material-symbols-outlined">receipt_long</span> My Orders
                </a>
                <% } %>
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

        <!-- MAIN CONTENT CONTAINER -->
        <main class="main-content">
            
            <!-- HERO BANNER SECTION WITH HIGH-END BACKGROUND -->
            <section class="hero-section">
                <div class="hero-content">
                    <p class="hero-tagline">TRUSTED SECURITY PARTNER</p>
                    <h1>Welcome Back, <span class="highlight"><%= username %></span>.</h1>
                    <p class="hero-subtext">India's Premier B2B/B2C Distributor for Enterprise Security Solutions, CCTV Systems, and Access Control.</p>
                    <div class="hero-actions">
                        <a href="products" class="btn btn-filled">Browse Hardware</a>
                        <a href="contact" class="btn btn-outlined">Request Consultation</a>
                    </div>
                </div>
            </section>

            <!-- Workspace Header Bar -->
            <header class="content-header">
                <div class="header-title">
                    <h1>Command Center</h1>
                    <p>Real-time technical services and corporate asset distributions.</p>
                </div>
                <div class="header-actions">
                    <a href="products" class="action-btn-primary" style="text-decoration: none;">
                        <span class="material-symbols-outlined">add_circle</span> Initiate Deployment
                    </a>
                </div>
            </header>

            <!-- STREAMLINED LEGACY PANEL -->
            <section class="info-panel">
                <div class="panel-container">
                    <div class="icon-glow-box">
                        <span class="material-symbols-outlined panel-icon">verified_user</span>
                    </div>
                    <div class="panel-text">
                        <h2>Our Legacy</h2>
                        <p>Established in 1996, HardNSoft Services stands as Madhya Pradesh's dominant distributor for integrated CCTV configurations, core industrial networking, and high-capacity storage architectures.</p>
                    </div>
                </div>
            </section>

            <!-- OPERATION SECTORS (Aesthetic Floating Glass Cards) -->
            <section class="section-block">
                <h2 class="section-heading">Operation Sectors</h2>
                <div class="services-grid">
                    
                    <a href="products?cat=cctv" class="service-card">
                        <div class="card-icon-frame"><span class="material-symbols-outlined">videocam</span></div>
                        <p>CCTV Surveillance</p>
                    </a>
                    
                    <a href="products?cat=vdp" class="service-card">
                        <div class="card-icon-frame"><span class="material-symbols-outlined">meeting_room</span></div>
                        <p>Video Door Phones</p>
                    </a>
                    
                    <a href="products?cat=biometrics" class="service-card">
                        <div class="card-icon-frame"><span class="material-symbols-outlined">fingerprint</span></div>
                        <p>Biometric Devices</p>
                    </a>
                    
                    <a href="products?cat=access" class="service-card">
                        <div class="card-icon-frame"><span class="material-symbols-outlined">badge</span></div>
                        <p>Access Control</p>
                    </a>
                    
                    <a href="software?cat=ai" class="service-card">
                        <div class="card-icon-frame"><span class="material-symbols-outlined">memory</span></div>
                        <p>AI Analytics</p>
                    </a>
                    
                    <a href="products?cat=nvr" class="service-card">
                        <div class="card-icon-frame"><span class="material-symbols-outlined">dns</span></div>
                        <p>NVR/DVR Systems</p>
                    </a>
                    
                    <a href="products?cat=network" class="service-card">
                        <div class="card-icon-frame"><span class="material-symbols-outlined">lan</span></div>
                        <p>Networking</p>
                    </a>
                    
                </div>
            </section>

            <!-- PREMIUM AUTHORIZED BRAND CHIPS -->
            <section class="section-block">
                <h2 class="section-heading">Authorized Brand Distribution</h2>
                <div class="brands-logo-bar">
                    <div class="brand-chip">CP Plus</div>
                    <div class="brand-chip">Godrej Security</div>
                    <div class="brand-chip">Secureye</div>
                    <div class="brand-chip">Prama</div>
                    <div class="brand-chip special">HNS Certified</div>
                </div>
            </section>

            <!-- CLIENT FEEDBACK FLOW -->
            <section class="section-block">
                <h2 class="section-heading">Enterprise Case Reviews</h2>
                <div class="testimonials-grid">
                    
                    <div class="testimonial-card">
                        <div class="testimonial-header">
                            <div class="client-avatar">MC</div>
                            <div class="client-info">
                                <p class="client-name">Malwa Corp Logistics</p>
                                <div class="star-rating">★★★★★</div>
                            </div>
                        </div>
                        <p class="testimonial-body">"HardNSoft optimized our entire warehouse network layout. Impeccable industrial-grade CCTV deployment and expert support responses."</p>
                    </div>

                    <div class="testimonial-card">
                        <div class="testimonial-header">
                            <div class="client-avatar">CH</div>
                            <div class="client-info">
                                <p class="client-name">Indore Central Hub</p>
                                <div class="star-rating">★★★★★</div>
                            </div>
                        </div>
                        <p class="testimonial-body">"Unmatched expertise in biometric access control. Their implementation reduced our entry delays by 60%."</p>
                    </div>

                    <div class="testimonial-card">
                        <div class="testimonial-header">
                            <div class="client-avatar">TL</div>
                            <div class="client-info">
                                <p class="client-name">TechLabs Industries</p>
                                <div class="star-rating">★★★★★</div>
                            </div>
                        </div>
                        <p class="testimonial-body">"Reliable networking solutions. Their team deployed high-capacity wireless bridges across our multi-building campus."</p>
                    </div>

                </div>
            </section>

            <!-- INTERACTIVE MAP & DETAILS FOOTER -->
            <footer class="contact-summary-footer">
                <div class="contact-grid">
                    <div class="map-container">
                        <iframe 
                            src="https://maps.google.com/maps?q=Silver%20Mall,%20Indore&t=&z=15&ie=UTF8&iwloc=&output=embed" 
                            width="100%" height="260" style="border:0;" allowfullscreen="" loading="lazy">
                        </iframe>
                    </div>

                    <div class="contact-details-block">
                        <h3>HardNSoft Services HQ</h3>
                        <p class="address">103 B Block, Silver Mall<br>Indore, Madhya Pradesh</p>
                        <a href="tel:+919826628028" class="contact-link phone">
                            <span class="material-symbols-outlined" style="font-size: 18px;">call</span> +91 9826628028
                        </a>
                        <a href="mailto:contact@hns-services.com" class="contact-link email">
                            <span class="material-symbols-outlined" style="font-size: 18px;">mail</span> contact@hns-services.com
                        </a>
                    </div>
                </div>
                <div class="legal-footer">
                    <p>© 2026 HardNSoft Services. All Rights Reserved.</p>
                </div>
            </footer>

        </main>
    </div>

</body>
</html>
