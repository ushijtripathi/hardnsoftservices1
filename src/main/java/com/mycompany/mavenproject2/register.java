package com.mycompany.mavenproject2;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class register extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String orgName = request.getParameter("orgName");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        response.setContentType("text/plain");
        PrintWriter out = response.getWriter();

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            out.print("Email and Password are required.");
            return;
        }

        try {
            Connection conn = DBConnection.getConnection();

            // Check if email already exists
            String checkSql = "SELECT * FROM users WHERE email=?";
            PreparedStatement checkPs = conn.prepareStatement(checkSql);
            checkPs.setString(1, email);
            ResultSet checkRs = checkPs.executeQuery();

            if (checkRs.next()) {
                out.print("An account with this email already exists.");
                checkRs.close();
                checkPs.close();
                conn.close();
                return;
            }
            checkRs.close();
            checkPs.close();

            // Insert new user
            String sql = "INSERT INTO users (username, password, email) VALUES (?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            // Use fullName for username
            ps.setString(1, fullName);
            ps.setString(2, password);
            ps.setString(3, email);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                out.print("success");
            } else {
                out.print("Failed to register. Please try again.");
            }

            ps.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
            out.print("Database error: " + e.getMessage());
        }
    }
}
