package com.mycompany.mavenproject2;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/submitContactForm")
public class submitContactForm extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String inquiryType = request.getParameter("inquiryType");
        String message = request.getParameter("message");

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "INSERT INTO contact_messages (name, email, inquiry_type, message) VALUES (?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, inquiryType);
            ps.setString(4, message);

            ps.executeUpdate();
            ps.close();
            conn.close();

            response.sendRedirect("contact.jsp?success=true");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("contact.jsp?error=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        }
    }
}
