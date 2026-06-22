<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    HttpSession registerSession = request.getSession(false);
    if (registerSession != null && registerSession.getAttribute("username") != null) {
        response.sendRedirect("dashboard");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>hardnsoft Services - Register</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="style2.css">
</head>
<body>

    <div class="login-container">
        <div class="brand-side">
            <div class="brand-content">
                <div class="logo">
                    <span class="logo-dot"></span> hardnsoft Services
                </div>
                <h1>Scale Your Infrastructure Securely.</h1>
                <p>Join enterprise partners managing top-tier physical deployments, smart asset protections, and robust networking solutions.</p>
            </div>
            <div class="brand-footer">
                <p>© 2026 hardnsoft Services. All rights reserved.</p>
            </div>
        </div>

        <div class="form-side">
            <div class="form-wrapper">
                <div class="form-header">
                    <h2>Client Portal</h2>
                    <p>Register your organization to begin managing deployments.</p>
                </div>

                <div id="error-banner" class="error-banner" style="display:none;"></div>

                <form id="registerForm">
                    <div class="input-group">
                        <label for="orgName">Organization Name</label>
                        <input type="text" id="orgName" name="orgName" placeholder="e.g., Security Corp LLC" required>
                    </div>

                    <div class="input-group">
                        <label for="fullName">Contact Person Name</label>
                        <input type="text" id="fullName" name="fullName" placeholder="John Doe" required>
                    </div>

                    <div class="input-group">
                        <label for="email">Work Email</label>
                        <input type="email" id="email" name="email" placeholder="name@company.com" required>
                    </div>

                    <div class="input-group">
                        <label for="password">Password</label>
                        <input type="password" id="password" name="password" placeholder="••••••••" required>
                    </div>

                    <div class="input-group">
                        <label for="confirmPassword">Confirm Password</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" placeholder="••••••••" required>
                    </div>

                    <button type="submit" class="submit-btn" id="submitBtn">Register Organization</button>
                </form>

                <p class="register-text" style="margin-top: 24px;">
                    Already registered? <a href="login.jsp">Sign In</a>
                </p>
            </div>
        </div>
    </div>

    <script>
        function handleRegister(event) {
            event.preventDefault();

            const orgName = document.getElementById("orgName").value;
            const fullName = document.getElementById("fullName").value;
            const email = document.getElementById("email").value;
            const password = document.getElementById("password").value;
            const confirmPassword = document.getElementById("confirmPassword").value;
            const errorBanner = document.getElementById("error-banner");

            errorBanner.style.display = "none";
            errorBanner.innerText = "";

            if (password !== confirmPassword) {
                errorBanner.innerText = "Passwords do not match";
                errorBanner.style.display = "block";
                return;
            }

            const params = new URLSearchParams();
            params.append("orgName", orgName);
            params.append("fullName", fullName);
            params.append("email", email);
            params.append("password", password);

            fetch("register", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                body: params.toString()
            })
            .then(response => response.text())
            .then(data => {
                if (data.trim() === "success") {
                    alert("Registration successful! Settle details to sign in.");
                    window.location.href = "login.jsp";
                } else {
                    errorBanner.innerText = data.trim();
                    errorBanner.style.display = "block";
                }
            })
            .catch(error => {
                console.error(error);
                errorBanner.innerText = "Server error. Please try again.";
                errorBanner.style.display = "block";
            });
        }

        document.getElementById("registerForm").addEventListener("submit", handleRegister);
    </script>
</body>
</html>
