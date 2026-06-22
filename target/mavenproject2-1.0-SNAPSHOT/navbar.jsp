<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String navUsername = null;
    boolean navIsLoggedIn = false;
    HttpSession navSession = request.getSession(false);
    if (navSession != null && navSession.getAttribute("username") != null) {
        navUsername = (String) navSession.getAttribute("username");
        navIsLoggedIn = true;
    }
%>
<div class="navbar-inner-frame">
    
    <a href="dashboard" class="nav-logo">
        <span class="logo-glow-dot"></span> HNS SERVICES
    </a>

    <nav class="nav-links-center">
        <a href="dashboard" class="nav-link">Home</a>
        <a href="dashboard#advantages-bento" class="nav-link">Solutions</a>
        <a href="products" class="nav-link">Hardware</a>
        <a href="software" class="nav-link">Software</a>
        <a href="dealer" class="nav-link">Dealer Program</a>
        <a href="contact" class="nav-link">Contact</a>
        <% if (navIsLoggedIn) { %>
            <a href="orders" class="nav-link">My Orders</a>
        <% } %>
        <a href="cart" class="nav-link nav-cart-item">
            Cart <span id="nav-cart-count" class="cart-badge-counter">0</span>
        </a>
    </nav>

    <div class="nav-actions-right">
        <% if (navIsLoggedIn) { %>
            <div class="user-profile-badge">
                <div class="user-avatar"><%= navUsername.substring(0, 1).toUpperCase() %></div>
                <span class="user-name-text"><%= navUsername %></span>
            </div>
            <a href="logout" class="nav-btn logout-btn">Logout</a>
        <% } else { %>
            <a href="login.jsp" class="nav-btn expert-btn">Login</a>
            <a href="register.jsp" class="nav-btn logout-btn" style="background: transparent; border: 1px solid var(--accent-cyan); color: var(--accent-cyan);">Register</a>
        <% } %>
    </div>

</div>

<script>
    // Live update cart item badge from localStorage quickly across clicks
    function syncNavbarCartCount() {
        try {
            const currentCart = JSON.parse(localStorage.getItem("cart")) || [];
            // Handle both format configurations (direct array length, or cumulative qtys)
            let totalQty = 0;
            currentCart.forEach(item => {
                totalQty += (item.qty || 1);
            });
            const badge = document.getElementById("nav-cart-count");
            if(badge) {
                badge.innerText = totalQty;
                badge.style.display = totalQty > 0 ? "inline-flex" : "none";
            }
        } catch(e) { console.error("Navbar storage error", e); }
    }
    syncNavbarCartCount();
    // Re-check periodically or map across clicks smoothly
    window.addEventListener('storage', syncNavbarCartCount);
    // Navbar active state highlighter
    function updateActiveNav() {
        const currentPath = window.location.pathname.toLowerCase();
        const currentHash = window.location.hash.toLowerCase();
        const navLinks = document.querySelectorAll('.nav-links-center .nav-link');
        
        navLinks.forEach(link => link.classList.remove('active'));
        
        let matched = false;

        // 1. Match by hash first (e.g. Solutions #advantages-bento)
        if (currentHash) {
            navLinks.forEach(link => {
                if (link.getAttribute('href').toLowerCase().includes(currentHash)) {
                    link.classList.add('active');
                    matched = true;
                }
            });
        }
        
        // 2. If no hash match, match by path
        if (!matched) {
            navLinks.forEach(link => {
                const href = link.getAttribute('href').toLowerCase();
                if (href.includes('#')) return; // skip hash links if we don't have a matching hash

                // Match base path exactly or check inclusion for nested paths
                if (currentPath.includes(href)) {
                    link.classList.add('active');
                    matched = true;
                }
            });
        }
        
        // 3. Fallback: if root or no match, select "Home"
        if (!matched && (currentPath.endsWith('/') || currentPath.includes('index'))) {
            navLinks.forEach(link => {
                if (link.getAttribute('href') === 'dashboard') {
                    link.classList.add('active');
                }
            });
        }
    }

    // Double check on DOM load
    document.addEventListener('DOMContentLoaded', () => {
        syncNavbarCartCount();
        updateActiveNav();
    });
    
    // Listen for hash changes
    window.addEventListener("hashchange", updateActiveNav);
</script>
