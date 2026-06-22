package com.mycompany.mavenproject2;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Random;
import java.util.Properties;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.mail.*;
import javax.mail.internet.*;

@WebServlet("/sendOTP")
public class SendOTPServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        String email = request.getParameter("email");
        if (email == null || email.trim().isEmpty()) {
            response.getWriter().write("error: Email is required.");
            return;
        }

        // Generate 6-digit OTP
        Random rand = new Random();
        int otp = 100000 + rand.nextInt(900000);
        String otpString = String.valueOf(otp);

        // Store OTP in session
        HttpSession session = request.getSession(true);
        session.setAttribute("otp", otpString);
        session.setAttribute("otp_email", email);

        // Log to console for testing without email credentials
        System.out.println("=========================================");
        System.out.println("GENERATED OTP FOR " + email + " : " + otpString);
        System.out.println("=========================================");

        /*
        // SMTP Implementation (Uncomment and configure to send real emails)
        String to = email;
        String from = "your-email@gmail.com";
        final String username = "your-email@gmail.com"; // your email
        final String password = "your-app-password"; // your password

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session mailSession = Session.getInstance(props,
          new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
          });

        try {
            Message message = new MimeMessage(mailSession);
            message.setFrom(new InternetAddress(from));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject("Your HardNSoft Login OTP");
            message.setText("Your One-Time Password is: " + otpString + "\n\nDo not share this with anyone.");
            Transport.send(message);
        } catch (MessagingException e) {
            e.printStackTrace();
            response.getWriter().write("error: Failed to send email.");
            return;
        }
        */

        response.getWriter().write("success");
    }
}
