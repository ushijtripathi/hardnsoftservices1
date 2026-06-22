package com.mycompany.mavenproject2;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/submitDealerInquiry")
public class submitDealerInquiry extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String fullName = request.getParameter("fullName");
        String companyName = request.getParameter("companyName");
        String email = request.getParameter("workEmail");
        String volumeRange = request.getParameter("volumeRange");
        String details = request.getParameter("additionalDetails");

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "INSERT INTO dealer_inquiries (full_name, company_name, email, volume_range, details) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, fullName);
            ps.setString(2, companyName);
            ps.setString(3, email);
            ps.setString(4, volumeRange);
            ps.setString(5, details);

            ps.executeUpdate();
            ps.close();
            conn.close();

            response.sendRedirect("dealer.jsp?success=true");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dealer.jsp?error=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        }
    }
}
