package com.shop.sportstore.controller.client;

import com.shop.sportstore.dao.VoucherDAO;
import com.shop.sportstore.model.User;
import com.shop.sportstore.model.Promotion;
import com.shop.sportstore.untils.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;

@WebServlet("/promotions")
public class PromotionServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {


        Connection conn = DBConnection.getConnection();
        VoucherDAO dao = new VoucherDAO(conn);
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        String currentTier = (currentUser != null) ? currentUser.getTierName() : "Đồng";

        request.setAttribute(
                "promotions",
                dao.getActiveVouchersForPromotionPage(currentTier)
        );


        request.getRequestDispatcher(
                "promotions.jsp"
        ).forward(request, response);
    }
}