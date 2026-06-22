<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.mycompany.mavenproject2.DBConnection" %>
<%
    HttpSession prodSession = request.getSession(false);
    boolean isLoggedIn = (prodSession != null && prodSession.getAttribute("username") != null);
    String username = isLoggedIn ? (String) prodSession.getAttribute("username") : "Guest";
    
    // Pagination parameters
    int currentPage = 1;
    int itemsPerPage = 4; // Show 4 items per page
    String pageParam = request.getParameter("page");
    if (pageParam != null) {
        try {
            currentPage = Integer.parseInt(pageParam);
        } catch (NumberFormatException e) {
            currentPage = 1;
        }
    }
    
    // Check if a category parameter is specified in the URL (e.g. from the dashboard operation sectors)
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
    <title>Security Products | HNS Services</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="products.css">
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
                <a href="products" class="menu-item active">
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

        <!-- MAIN LAYOUT DIVISION -->
        <main class="main-content">
            
            <div class="catalog-master-container">

                <section class="catalog-hero" style="margin-top: 0; padding: 30px; border-radius: 12px;">
                    <h1>Security <span class="cyan-gradient-text">Products</span></h1>
                    <p>Explore our collection of CCTV cameras, storage devices, networking equipment, smart locks and enterprise security solutions.</p>
                    
                    <div class="search-bar-wrapper">
                        <span class="material-symbols-outlined search-icon">search</span>
                        <input type="text" id="productSearch" placeholder="Search enterprise hardware solutions...">
                    </div>
                </section>

                <div class="catalog-layout-grid">

                    <aside class="catalog-sidebar">
                        <div class="sidebar-block">
                            <h3>Categories</h3>
                            <ul class="category-filter-list">
                                <li class="category-item <%= selectedCat.equals("all") ? "active" : "" %>" data-filter="all">
                                    <span class="material-symbols-outlined">grid_view</span> All Hardware
                                </li>
                                <li class="category-item <%= selectedCat.equals("cctv") ? "active" : "" %>" data-filter="cctv">
                                    <span class="material-symbols-outlined">videocam</span> CCTV Cameras
                                </li>
                                <li class="category-item <%= selectedCat.equals("nvr") ? "active" : "" %>" data-filter="nvr">
                                    <span class="material-symbols-outlined">dns</span> NVR / DVR Systems
                                </li>
                                <li class="category-item <%= selectedCat.equals("vdp") ? "active" : "" %>" data-filter="vdp">
                                    <span class="material-symbols-outlined">meeting_room</span> Video Door Phones
                                </li>
                                <li class="category-item <%= selectedCat.equals("biometrics") ? "active" : "" %>" data-filter="biometrics">
                                    <span class="material-symbols-outlined">fingerprint</span> Biometric Devices
                                </li>
                            </ul>
                        </div>

                        <div class="bulk-quote-glass-box">
                            <span class="material-symbols-outlined quote-icon">request_quote</span>
                            <h4>Need Bulk Pricing?</h4>
                            <p>Get custom configurations and project volume quotations.</p>
                            <a href="contact" class="quote-action-btn">Request Quote</a>
                        </div>
                    </aside>

                    <main class="products-feed-pane" id="productsFeed">

                        <%
                            class Product {
                                String brand, model, name, desc, category, imageUrl;
                                String[] features;
                                double price;
                                public Product(String brand, String model, String name, String desc, String[] features, double price, String imageUrl, String category) {
                                    this.brand = brand; this.model = model; this.name = name; this.desc = desc;
                                    this.features = features; this.price = price; this.imageUrl = imageUrl; this.category = category;
                                }
                            }
                            
                            java.util.List<Product> mockProducts = new java.util.ArrayList<>();
                            mockProducts.add(new Product("CP Plus", "CP-UNC-TA81L3", "8MP 4K IP Bullet Camera", "High-definition motorized bullet camera with starlight technology.", new String[]{"8MP 4K Resolution", "30m IR Range", "Starlight Technology"}, 6500.00, "pictures/cctv_camera_1782115286727.png", "cctv"));
                            mockProducts.add(new Product("Prama", "PT-NC2143I-I", "2MP IP Dome Camera", "Vandal-proof dome camera suitable for indoor corporate setups.", new String[]{"2MP 1080p", "Vandal-Proof IK10", "PoE Support"}, 2800.00, "pictures/cam.jpg", "cctv"));
                            mockProducts.add(new Product("Secureye", "S-B100CB", "Biometric Time & Attendance", "Fingerprint and RFID access control system with cloud reporting.", new String[]{"1000 Fingerprint Capacity", "RFID Card Access", "TCP/IP & USB"}, 4500.00, "pictures/lock.jpg", "biometrics"));
                            mockProducts.add(new Product("Godrej", "Seethru Pro", "Video Door Phone", "Premium 7-inch touchscreen video door phone with remote unlock feature.", new String[]{"7-inch Touch Display", "2-Way Audio", "Night Vision"}, 12500.00, "pictures/cam.jpg", "vdp"));
                            mockProducts.add(new Product("CP Plus", "CP-UNR-4K4162-V2", "16 Channel 4K NVR", "Enterprise Network Video Recorder supporting up to 8MP resolution per channel.", new String[]{"16 Channel Output", "4K Display Support", "2 SATA Ports up to 16TB"}, 14200.00, "pictures/nvr_system_1782115305091.png", "nvr"));
                            mockProducts.add(new Product("Godrej", "Smart Lock Advantis", "Advantis Digital Door Lock", "Advanced biometric and keypad door lock for high-security areas.", new String[]{"Fingerprint + PIN", "Low Battery Alarm", "Auto Locking"}, 18500.00, "pictures/lock.jpg", "biometrics"));

                            // Additional mockup data to show pagination
                            mockProducts.add(new Product("Sandisk", "SDSQXAV-256G", "256GB Surveillance MicroSD", "High endurance memory card designed for continuous recording in security cameras.", new String[]{"256GB Capacity", "Class 10 U3", "High Endurance"}, 2200.00, "pictures/hdd.jpg", "storage"));
                            mockProducts.add(new Product("Kores", "K-500", "Note Counting Machine", "Heavy duty currency counting machine with counterfeit detection.", new String[]{"1000 Notes/Min", "UV & MG Detection", "Batch/Add Modes"}, 11500.00, "pictures/cam.jpg", "office"));

                            int totalProducts = mockProducts.size();
                            int totalPages = (int) Math.ceil((double) totalProducts / itemsPerPage);
                            
                            // Adjust current page bounds
                            if (currentPage < 1) currentPage = 1;
                            if (currentPage > totalPages) currentPage = totalPages;
                            
                            int startIndex = (currentPage - 1) * itemsPerPage;
                            int endIndex = Math.min(startIndex + itemsPerPage, totalProducts);
                            
                            java.util.List<Product> pagedProducts = (totalProducts > 0) ? mockProducts.subList(startIndex, endIndex) : mockProducts;
                            boolean hasData = !pagedProducts.isEmpty();
                            
                            for (Product p : pagedProducts) {
                        %>
                        <div class="product-showcase-row" data-category="<%= p.category %>">
                            <div class="product-image-dock">
                                <img src="<%= p.imageUrl %>" alt="<%= p.name %>" onerror="this.src='pictures/cam.jpg'">
                            </div>
                            <div class="product-content-details">
                                <div class="product-meta-text">
                                    <span class="category-badge"><%= p.brand.toUpperCase() %> | <%= p.category.toUpperCase() %></span>
                                    <h3><%= p.name %> <span style="font-size: 14px; color: var(--text-muted); font-weight: 500;">(Model: <%= p.model %>)</span></h3>
                                    <p><%= p.desc %></p>
                                    <ul class="product-features-list">
                                        <% for (String feature : p.features) { %>
                                            <li><span class="material-symbols-outlined">check_circle</span> <%= feature %></li>
                                        <% } %>
                                    </ul>
                                </div>
                                <div class="product-pricing-action-row">
                                    <h4 class="product-currency-value">₹<%= String.format("%,.2f", p.price) %></h4>
                                    <div class="action-buttons-group">
                                        <button class="btn-cart-add" onclick="addToCart('<%= p.name.replace("'", "\\'") %>', <%= p.price %>, '<%= p.imageUrl %>')" style="margin-right: 8px;">
                                            <span class="material-symbols-outlined">add_shopping_cart</span> Add To Cart
                                        </button>
                                        <% if (isLoggedIn) { %>
                                        <a href="contact?product=<%= p.model %>" class="btn-cart-add" style="text-decoration: none;">
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
                            <h3>No hardware products available.</h3>
                        </div>
                        <%
                            }
                        %>
                        
                        <!-- Pagination Controls -->
                        <% if (totalPages > 1) { %>
                        <div class="pagination-controls" style="display: flex; justify-content: center; gap: 10px; margin-top: 30px; padding-bottom: 20px;">
                            <% if (currentPage > 1) { %>
                                <a href="?page=<%= currentPage - 1 %>&cat=<%= selectedCat %>" class="btn btn-outlined" style="padding: 8px 16px; border: 1px solid var(--border-glass); border-radius: 6px; text-decoration: none; color: var(--text-primary);">Previous</a>
                            <% } %>
                            
                            <% for (int i = 1; i <= totalPages; i++) { %>
                                <a href="?page=<%= i %>&cat=<%= selectedCat %>" class="btn" style="padding: 8px 16px; border-radius: 6px; text-decoration: none; <%= (i == currentPage) ? "background-color: var(--accent-cyan); color: #fff;" : "border: 1px solid var(--border-glass); color: var(--text-primary);" %>"><%= i %></a>
                            <% } %>
                            
                            <% if (currentPage < totalPages) { %>
                                <a href="?page=<%= currentPage + 1 %>&cat=<%= selectedCat %>" class="btn btn-outlined" style="padding: 8px 16px; border: 1px solid var(--border-glass); border-radius: 6px; text-decoration: none; color: var(--text-primary);">Next</a>
                            <% } %>
                        </div>
                        <% } %>

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
        const productRows = document.querySelectorAll('.product-showcase-row');
        const searchInput = document.getElementById('productSearch');

        function filterProducts(activeFilter) {
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
                filterProducts(activeFilter);
            });
        });

        // Initialize with default category filter if specified via URL param
        const urlParams = new URLSearchParams(window.location.search);
        const urlCat = urlParams.get('cat');
        if (urlCat) {
            filterProducts(urlCat);
        }

        // Real-Time Search Query Interceptor
        searchInput.addEventListener('input', (e) => {
            const query = e.target.value.toLowerCase();

            productRows.forEach(row => {
                const title = row.querySelector('h3').innerText.toLowerCase();
                const desc = row.querySelector('.product-meta-text p').innerText.toLowerCase();

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
