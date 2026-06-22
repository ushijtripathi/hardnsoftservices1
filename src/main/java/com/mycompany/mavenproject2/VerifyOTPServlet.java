package com.mycompany.mavenproject2;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/verifyOTP")
public class VerifyOTPServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        String email = request.getParameter("email");
        String otp = request.getParameter("otp");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("otp") == null) {
            response.getWriter().write("error");
            return;
        }
        
        String savedOtp = (String) session.getAttribute("otp");
        String savedEmail = (String) session.getAttribute("otp_email");
        
        if (savedOtp != null && savedOtp.equals(otp) && savedEmail != null && savedEmail.equals(email)) {
            // Valid OTP.
            session.removeAttribute("otp"); // Clear OTP
            session.removeAttribute("otp_email");

            response.getWriter().write("success");
        } else {
            response.getWriter().write("error");
        }
    }
}
