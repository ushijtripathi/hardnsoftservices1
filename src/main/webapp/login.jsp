<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    HttpSession loginSession = request.getSession(false);
    if (loginSession != null && loginSession.getAttribute("username") != null) {
        response.sendRedirect("dashboard");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>hardnsoft Services - Login</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
</head>
<body>

    <div class="login-container">
        <div class="brand-side">
            <div class="brand-content">
                <div class="logo">
                    <span class="logo-dot"></span> hardnsoft Services
                </div>
                <h1>Next-Gen Enterprise Security.</h1>
                <p>Securing your business infrastructure with unshakeable digital and physical architectures.</p>
            </div>
            <div class="brand-footer">
                <p>© 2026 hardnsoft Services. All rights reserved.</p>
            </div>
        </div>

        <div class="form-side">
            <div class="form-wrapper">
                <div class="form-header">
                    <h2>Client Portal</h2>
                    <p>Sign in to manage your technical services and hardware deployments.</p>
                </div>

                <div id="error-banner" class="error-banner" style="display:none;"></div>

                <form id="loginForm">
                    <div class="input-group">
                        <label for="email">Work Email</label>
                        <input type="email" id="email" name="email" placeholder="name@company.com" required>
                    </div>

                    <div class="input-group">
                        <div class="label-row">
                            <label for="password">Password</label>
                            <button type="button" class="toggle-link" onclick="togglePassword()" id="toggleBtn">Show</button>
                        </div>
                        <input type="password" id="password" name="password" placeholder="••••••••" required>
                    </div>

                    <div class="form-options">
                        <div class="forgot">
                            <a href="#">Forgot Password?</a>
                        </div>
                    </div>

                    <button type="submit" class="submit-btn" id="submitBtn">Access Portal</button>
                </form>

                <p class="register-text" style="margin-top: 24px;">
                    New organization? <a href="register.jsp">Register</a>
                </p>
            </div>
        </div>
    </div>

    <script>
        function togglePassword() {
            const passwordField = document.getElementById("password");
            const toggleBtn = document.getElementById("toggleBtn");

            if (passwordField.type === "password") {
                passwordField.type = "text";
                toggleBtn.innerText = "Hide";
            } else {
                passwordField.type = "password";
                toggleBtn.innerText = "Show";
            }
        }

        document.getElementById("loginForm").addEventListener("submit", (e) => {
            e.preventDefault();
            
            const email = document.getElementById("email").value.trim();
            const password = document.getElementById("password").value;
            const errorBanner = document.getElementById("error-banner");

            errorBanner.style.display = "none";
            errorBanner.innerText = "";
            const submitBtn = document.getElementById("submitBtn");
            submitBtn.innerText = "Logging in...";
            submitBtn.disabled = true;

            const params = new URLSearchParams();
            params.append("email", email);
            params.append("password", password);

            fetch("login", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: params.toString()
            })
            .then(res => res.text())
            .then(data => {
                if (data.trim() === "success") {
                    localStorage.removeItem("cart");
                    window.location.href = "dashboard";
                } else {
                    errorBanner.innerText = data.trim().startsWith("error") ? data.trim() : "Invalid email or password";
                    errorBanner.style.display = "block";
                    submitBtn.innerText = "Access Portal";
                    submitBtn.disabled = false;
                }
            })
            .catch(err => {
                console.error(err);
                errorBanner.innerText = "Server error. Please try again.";
                errorBanner.style.display = "block";
                submitBtn.innerText = "Access Portal";
                submitBtn.disabled = false;
            });
        });
    </script>
</body>
</html>
