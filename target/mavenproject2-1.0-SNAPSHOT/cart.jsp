<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    HttpSession cartSession = request.getSession(false);
    boolean isLoggedIn = (cartSession != null && cartSession.getAttribute("username") != null);
    String username = isLoggedIn ? (String) cartSession.getAttribute("username") : "Guest";
    String userEmail = isLoggedIn ? (String) cartSession.getAttribute("email") : "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Cart | HNS Services</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="cart.css">
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
            
            <div class="cart-master-container">
                
                <!-- TOP CONTROL ROW -->
                <header class="cart-page-header">
                    <div class="header-left">
                        <h1>My <span class="cyan-gradient-text">Cart</span></h1>
                        <p id="item-count-badge">Review your selected enterprise components before submission.</p>
                    </div>
                    <button class="clear-cart-trigger" onclick="clearFullCart()">
                        <span class="material-symbols-outlined">delete_sweep</span> Clear Cart
                    </button>
                </header>

                <!-- MAIN LAYOUT DIVISION -->
                <div class="cart-workspace-layout">
                    
                    <!-- LEFT PANE: LIST OF CHOSEN COMPONENT CARDS -->
                    <main class="cart-items-pane" id="cart-items-container">
                        <!-- Dynamic items loaded here by JavaScript -->
                    </main>

                    <!-- RIGHT PANE: GLASSMORPHIC ORDER SUMMARY -->
                    <aside class="cart-summary-pane">
                        <div class="summary-glass-card">
                            <h3>Procurement Summary</h3>
                            
                            <div class="summary-calculation-table">
                                <div class="calc-row">
                                    <span>Subtotal</span>
                                    <span id="summary-subtotal">₹0.00</span>
                                </div>
                                <div class="calc-row">
                                    <span>Estimated GST / Tax (18%)</span>
                                    <span id="summary-tax">₹0.00</span>
                                </div>
                                <div class="calc-row">
                                    <span>Logistics & Handling</span>
                                    <span class="status-free" id="summary-shipping">FREE</span>
                                </div>
                                
                                <div class="summary-divider"></div>
                                
                                <div class="calc-row total-highlight-row">
                                    <span class="total-main-title">Grand Total</span>
                                    <span class="total-main-value" id="cart-grand-total">₹0.00</span>
                                </div>
                            </div>

                            <button class="checkout-execution-btn" onclick="submitCheckout()">
                                <span>Proceed to Secure Checkout</span>
                                <span class="material-symbols-outlined">arrow_right_alt</span>
                            </button>
                            
                            <div class="secure-checkout-badge">
                                <span class="material-symbols-outlined">verified</span>
                                <span>HNS Secure Corporate Gateway Enforced</span>
                            </div>
                        </div>
                    </aside>

                </div>

            </div>

            <!-- Hidden form to POST cart data to servlet -->
            <form id="checkoutForm" action="checkout" method="POST" style="display:none;">
                <input type="hidden" name="cartData" id="cartDataInput">
            </form>

            <!-- OTP Verification Modal -->
            <div id="otpModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:10000; justify-content:center; align-items:center;">
                <div style="background:#fff; padding:30px; border-radius:12px; width:400px; max-width:90%; box-shadow:0 10px 25px rgba(0,0,0,0.2);">
                    <h3 style="margin-top:0; font-family:var(--font-main);">Secure Checkout Verification</h3>
                    <p style="color:var(--text-secondary); font-size:14px;">An OTP has been sent to <strong><%= userEmail %></strong>. Please enter it below to authorize this procurement.</p>
                    <div id="otp-error" style="color:#ef4444; font-size:13px; margin-bottom:10px; display:none;"></div>
                    <input type="text" id="checkoutOtp" placeholder="Enter 6-digit OTP" maxlength="6" style="width:100%; padding:10px; border:1px solid var(--border-glass); border-radius:6px; margin-bottom:20px; font-size:16px;">
                    <div style="display:flex; gap:10px; justify-content:flex-end;">
                        <button onclick="closeOtpModal()" style="padding:10px 16px; border:1px solid var(--border-glass); background:transparent; border-radius:6px; cursor:pointer;">Cancel</button>
                        <button id="verifyOtpBtn" onclick="confirmOtpAndCheckout()" style="padding:10px 16px; background:var(--accent-cyan); color:#fff; border:none; border-radius:6px; cursor:pointer; font-weight:600;">Verify & Pay</button>
                    </div>
                </div>
            </div>

        </main>
    </div>

    <script>
        const IS_LOGGED_IN = <%= isLoggedIn %>;
        const USER_EMAIL = "<%= userEmail %>";

        function formatRupee(amount) {
            return "₹" + amount.toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
        }

        function loadCartPage() {
            const cart = JSON.parse(localStorage.getItem("cart")) || [];
            const container = document.getElementById("cart-items-container");
            
            if (cart.length === 0) {
                container.innerHTML = `
                    <div class="cart-empty-fallback">
                        <span class="material-symbols-outlined fallback-icon">shopping_basket</span>
                        <h3>Your procurement cart is empty</h3>
                        <p>Browse our solution lines to add technical configurations.</p>
                        <a href="products" class="fallback-browse-btn" style="text-decoration:none; margin-top:20px; display:inline-block;">Browse Products</a>
                    </div>
                `;
                
                document.getElementById('summary-subtotal').innerText = '₹0.00';
                document.getElementById('summary-tax').innerText = '₹0.00';
                document.getElementById('cart-grand-total').innerText = '₹0.00';
                return;
            }

            let subtotal = 0;
            let outputHtml = "";

            cart.forEach((item, index) => {
                const qty = item.qty || 1;
                const itemTotal = item.price * qty;
                subtotal += itemTotal;

                // Determine fallback icon/image for display
                let visualHtml = "";
                if (item.image && (item.image.includes("/") || item.image.includes("."))) {
                    visualHtml = `<img src="${item.image}" alt="${item.name}" style="width:100%; height:100%; object-fit:cover; border-radius:8px;" onerror="this.outerHTML='<span class=\\'material-symbols-outlined\\'>videocam</span>'">`;
                } else {
                    let icon = "terminal";
                    if (item.image === "endpoint") icon = "shield_heart";
                    else if (item.image === "firewall") icon = "security_update_good";
                    else if (item.image === "cloud") icon = "cloud_done";
                    
                    visualHtml = `<span class="material-symbols-outlined">${icon}</span>`;
                }

                outputHtml += `
                    <div class="cart-item-card">
                        <div class="item-visual-fallback" style="display:flex; align-items:center; justify-content:center; overflow:hidden;">
                            \${visualHtml}
                        </div>
                        <div class="item-details">
                            <div class="item-meta">
                                <h3>\${item.name}</h3>
                                <p class="item-sku">SKU: HNS-ITEM-\${1000 + index}</p>
                            </div>
                            <div class="item-pricing-controls">
                                <div class="quantity-control-hub">
                                    <button class="qty-btn counter-minus" onclick="updateQty(\${index}, -1)">
                                        <span class="material-symbols-outlined" style="font-size:16px;">remove</span>
                                    </button>
                                    <span class="qty-display-value">\${qty}</span>
                                    <button class="qty-btn counter-plus" onclick="updateQty(\${index}, 1)">
                                        <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                                    </button>
                                </div>
                                <div class="item-price-block">
                                    <p class="unit-label">Bulk Unit Rate: \${formatRupee(item.price)}</p>
                                    <p class="subtotal-label">\${formatRupee(itemTotal)}</p>
                                </div>
                            </div>
                        </div>
                        <button class="remove-single-item" title="Remove Item" onclick="removeItem(\${index})">
                            <span class="material-symbols-outlined">close</span>
                        </button>
                    </div>
                `;
            });

            container.innerHTML = outputHtml;
            
            const gst = subtotal * 0.18;
            const grandTotal = subtotal + gst;

            document.getElementById('summary-subtotal').innerText = formatRupee(subtotal);
            document.getElementById('summary-tax').innerText = formatRupee(gst);
            document.getElementById('cart-grand-total').innerText = formatRupee(grandTotal);
        }

        function updateQty(index, delta) {
            let cart = JSON.parse(localStorage.getItem("cart")) || [];
            if (index >= 0 && index < cart.length) {
                let currentQty = cart[index].qty || 1;
                let newQty = currentQty + delta;
                if (newQty <= 0) {
                    cart.splice(index, 1);
                } else {
                    cart[index].qty = newQty;
                }
                localStorage.setItem("cart", JSON.stringify(cart));
                loadCartPage();
                if (window.syncNavbarCartCount) {
                    window.syncNavbarCartCount();
                }
            }
        }

        function removeItem(index) {
            let cart = JSON.parse(localStorage.getItem("cart")) || [];
            if (index >= 0 && index < cart.length) {
                cart.splice(index, 1);
                localStorage.setItem("cart", JSON.stringify(cart));
                loadCartPage();
                if (window.syncNavbarCartCount) {
                    window.syncNavbarCartCount();
                }
            }
        }

        function clearFullCart() {
            if (confirm("Are you sure you want to clear your cart?")) {
                localStorage.removeItem("cart");
                loadCartPage();
                if (window.syncNavbarCartCount) {
                    window.syncNavbarCartCount();
                }
            }
        }

        function submitCheckout() {
            const cart = JSON.parse(localStorage.getItem("cart")) || [];
            if (cart.length === 0) {
                alert("Please add items to your cart before proceeding.");
                return;
            }
            
            if (!IS_LOGGED_IN) {
                window.location.href = "login.jsp";
                return;
            }
            
            document.getElementById("cartDataInput").value = JSON.stringify(cart);
            
            // Trigger OTP logic
            const params = new URLSearchParams();
            params.append("email", USER_EMAIL);
            
            fetch("sendOTP", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: params.toString()
            }).then(res => res.text()).then(data => {
                if(data.trim() === "success") {
                    document.getElementById("otpModal").style.display = "flex";
                } else {
                    alert("Failed to send OTP for checkout verification.");
                }
            }).catch(e => {
                alert("Error communicating with authentication server.");
            });
        }

        function closeOtpModal() {
            document.getElementById("otpModal").style.display = "none";
            document.getElementById("checkoutOtp").value = "";
            document.getElementById("otp-error").style.display = "none";
        }

        function confirmOtpAndCheckout() {
            const otp = document.getElementById("checkoutOtp").value.trim();
            const errBox = document.getElementById("otp-error");
            if (!otp) {
                errBox.innerText = "Please enter the OTP.";
                errBox.style.display = "block";
                return;
            }
            
            const btn = document.getElementById("verifyOtpBtn");
            btn.innerText = "Verifying...";
            btn.disabled = true;

            const params = new URLSearchParams();
            params.append("email", USER_EMAIL);
            params.append("otp", otp);

            fetch("verifyOTP", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: params.toString()
            }).then(res => res.text()).then(data => {
                if (data.trim() === "success") {
                    // Clear cart from local storage so it doesn't double-charge/stay in cart
                    localStorage.removeItem("cart");
                    if (window.syncNavbarCartCount) {
                        window.syncNavbarCartCount();
                    }
                    document.getElementById("checkoutForm").submit();
                } else {
                    errBox.innerText = "Invalid or expired OTP.";
                    errBox.style.display = "block";
                    btn.innerText = "Verify & Pay";
                    btn.disabled = false;
                }
            }).catch(e => {
                errBox.innerText = "Error verifying OTP.";
                errBox.style.display = "block";
                btn.innerText = "Verify & Pay";
                btn.disabled = false;
            });
        }

        // Initialize page
        window.onload = function() {
            loadCartPage();
        }
    </script>

</body>
</html>
