<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.mycompany.mavenproject2.DBConnection" %>
<%
    HttpSession softSession = request.getSession(false);
    boolean isLoggedIn = (softSession != null && softSession.getAttribute("username") != null);
    String username = isLoggedIn ? (String) softSession.getAttribute("username") : "Guest";
    
    // Check if category parameter exists in URL
    String selectedCat = request.getParameter("cat");
    if (selectedCat == null) {
        selectedCat = "all";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Software Solutions | HNS Services</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="software.css">
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
                <a href="software" class="menu-item active">
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
        <main class="main-content">
            
            <div class="catalog-master-container">

                <section class="catalog-hero" style="margin-top: 0; padding: 30px; border-radius: 12px;">
                    <h1>Software <span class="cyan-gradient-text">Solutions</span></h1>
                    <p>Secure your infrastructure with our enterprise-grade firewalls, endpoint protection, and automated cloud backup software suites.</p>
                    
                    <div class="search-bar-wrapper">
                        <span class="material-symbols-outlined search-icon">search</span>
                        <input type="text" id="softwareSearch" placeholder="Search enterprise license distributions...">
                    </div>
                </section>

                <div class="catalog-layout-grid">

                    <aside class="catalog-sidebar">
                        <div class="sidebar-block">
                            <h3>Licenses</h3>
                            <ul class="category-filter-list">
                                <li class="category-item <%= selectedCat.equals("all") ? "active" : "" %>" data-filter="all">
                                    <span class="material-symbols-outlined">terminal</span> All Software
                                </li>
                                <li class="category-item <%= selectedCat.equals("endpoint") ? "active" : "" %>" data-filter="endpoint">
                                    <span class="material-symbols-outlined">gpp_good</span> Endpoint Protection
                                </li>
                                <li class="category-item <%= selectedCat.equals("firewall") ? "active" : "" %>" data-filter="firewall">
                                    <span class="material-symbols-outlined">local_fire_department</span> Firewall OS
                                </li>
                                <li class="category-item <%= selectedCat.equals("cloud") ? "active" : "" %>" data-filter="cloud">
                                    <span class="material-symbols-outlined">cloud_sync</span> Cloud Backup
                                </li>
                            </ul>
                        </div>

                        <div class="licensing-quote-glass-box">
                            <span class="material-symbols-outlined quote-icon">corporate_fare</span>
                            <h4>Enterprise Licensing?</h4>
                            <p>Contact us for multi-year options and site-wide deployment configurations.</p>
                            <a href="contact" class="quote-action-btn">Contact Sales</a>
                        </div>
                    </aside>

                    <main class="software-feed-pane" id="softwareFeed">

                        <%
                            class SoftwareProduct {
                                String name, desc, category, imageUrl, themeClass, iconName;
                                double price;
                                public SoftwareProduct(String name, String desc, double price, String category, String imageUrl, String themeClass, String iconName) {
                                    this.name = name; this.desc = desc; this.price = price; this.category = category;
                                    this.imageUrl = imageUrl; this.themeClass = themeClass; this.iconName = iconName;
                                }
                            }
                            
                            java.util.List<SoftwareProduct> mockSoftware = new java.util.ArrayList<>();
                            mockSoftware.add(new SoftwareProduct("Enterprise Endpoint Protection", "Next-gen AI driven endpoint security and antivirus.", 4500.00, "endpoint", "pictures/cybersecurity_dashboard_1782115318015.png", "endpoint-theme", "shield_heart"));
                            mockSoftware.add(new SoftwareProduct("Next-Gen Firewall OS", "Advanced threat protection and routing firewall operating system.", 12000.00, "firewall", "firewall", "firewall-theme", "security_update_good"));
                            mockSoftware.add(new SoftwareProduct("Automated Cloud Backup", "Secure offsite cloud backup solution with 1TB enterprise storage per node.", 8500.00, "cloud", "cloud", "cloud-theme", "cloud_done"));
                            mockSoftware.add(new SoftwareProduct("Zero Trust Access Client", "Secure remote access for remote workers based on zero-trust principles.", 3200.00, "endpoint", "pictures/cybersecurity_dashboard_1782115318015.png", "endpoint-theme", "shield_heart"));

                            boolean hasData = !mockSoftware.isEmpty();
                            for (SoftwareProduct p : mockSoftware) {
                        %>
                        <div class="software-showcase-row" data-category="<%= p.category %>">
                            <div class="software-icon-dock <%= p.themeClass %>">
                                <span class="material-symbols-outlined software-graphic"><%= p.iconName %></span>
                            </div>
                            <div class="software-content-details">
                                <div class="software-meta-text">
                                    <span class="category-badge"><%= p.category.toUpperCase() %></span>
                                    <h3><%= p.name %></h3>
                                    <p><%= p.desc %></p>
                                </div>
                                <div class="software-pricing-action-row">
                                    <h4 class="software-currency-value">₹<%= String.format("%,.2f", p.price) %></h4>
                                    <div class="action-buttons-group">
                                        <button class="btn-cart-add" onclick="addToCart('<%= p.name.replace("'", "\\'") %>', <%= p.price %>, '<%= p.imageUrl %>')" style="margin-right: 8px;">
                                            <span class="material-symbols-outlined">add_shopping_cart</span> Add To Cart
                                        </button>
                                        <% if (isLoggedIn) { %>
                                        <a href="contact?product=<%= p.name.replace(" ", "_") %>" class="btn-cart-add" style="text-decoration: none;">
                                            <span class="material-symbols-outlined">support_agent</span> Inquire Now
                                        </a>
                                        <% } else { %>
                                        <a href="login.jsp" class="btn-cart-add" style="text-decoration: none;">
                                            <span class="material-symbols-outlined">login</span> Login to Inquire
                                        </a>
                                        <% } %>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <%
                            }
                            if (!hasData) {
                        %>
                        <div class="no-items-message">
                            <h3>No software solutions available.</h3>
                        </div>
                        <%
                            }
                        %>

                    </main>
                </div>
            </div>

        </main>
    </div>

    <script>
        // Synchronized Cart Engine Initialization
        function addToCart(name, price, imagePath) {
            let cart = JSON.parse(localStorage.getItem("cart")) || [];
            
            // Check if product already exists in cart to update qty
            let existingItem = cart.find(item => item.name === name);
            if (existingItem) {
                existingItem.qty = (existingItem.qty || 1) + 1;
            } else {
                cart.push({ name: name, price: price, image: imagePath, qty: 1 });
            }
            
            localStorage.setItem("cart", JSON.stringify(cart));
            
            // Update navbar count immediately if function exists
            if (window.syncNavbarCartCount) {
                window.syncNavbarCartCount();
            }
            alert(name + " successfully allocated to procurement list.");
        }

        // Live Asynchronous Filter Process
        const categoryItems = document.querySelectorAll('.category-item');
        const productRows = document.querySelectorAll('.software-showcase-row');
        const searchInput = document.getElementById('softwareSearch');

        function filterSoftware(activeFilter) {
            productRows.forEach(row => {
                if (activeFilter === 'all' || row.getAttribute('data-category') === activeFilter) {
                    row.style.display = 'flex';
                } else {
                    row.style.display = 'none';
                }
            });
        }

        categoryItems.forEach(item => {
            item.addEventListener('click', () => {
                categoryItems.forEach(i => i.classList.remove('active'));
                item.classList.add('active');

                const activeFilter = item.getAttribute('data-filter');
                filterSoftware(activeFilter);
            });
        });

        // Initialize with default category filter if specified via URL param
        const urlParams = new URLSearchParams(window.location.search);
        const urlCat = urlParams.get('cat');
        if (urlCat) {
            filterSoftware(urlCat);
        }

        // Real-Time Search Query Interceptor
        searchInput.addEventListener('input', (e) => {
            const query = e.target.value.toLowerCase();

            productRows.forEach(row => {
                const title = row.querySelector('h3').innerText.toLowerCase();
                const desc = row.querySelector('.software-meta-text p').innerText.toLowerCase();

                if (title.includes(query) || desc.includes(query)) {
                    row.style.display = 'flex';
                } else {
                    row.style.display = 'none';
                }
            });
        });
    </script>
</body>
</html>
