package com.shop.sportstore.controller.client;

import com.shop.sportstore.dao.BannerDAO;
import com.shop.sportstore.dao.CategoryDAO;
import com.shop.sportstore.dao.ProductDAO;

import com.shop.sportstore.model.Banner;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
@WebServlet("/home")
public class HomeServlet extends HttpServlet {

    private final BannerDAO bannerDAO = new BannerDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Banner> banners = bannerDAO.findAll();

        request.setAttribute("banners", banners);

        request.setAttribute(
                "categories",
                categoryDAO.buildTree(categoryDAO.getAllCategories())
        );

        request.getRequestDispatcher("/home.jsp").forward(request, response);
    }
}