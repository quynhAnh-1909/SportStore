package com.shop.sportstore.controller.client;

import com.shop.sportstore.dao.PromotionDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

    @WebServlet("/promotions")
    public class PromotionServlet extends HttpServlet {

        protected void doGet(HttpServletRequest request,
                             HttpServletResponse response)
                throws ServletException, IOException {

            PromotionDAO dao = new PromotionDAO();

            request.setAttribute(
                    "promotions",
                    dao.getAllPromotions()
            );

            request.getRequestDispatcher(
                    "/promotions.jsp"
            ).forward(request, response);
        }
    }

