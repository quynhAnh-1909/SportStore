package com.shop.sportstore.controller.client;

import com.shop.sportstore.dao.ProductDAO;
import com.shop.sportstore.model.CartItem;
import com.shop.sportstore.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/buy-now")
public class BuyNowServlet extends HttpServlet {

    private ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        int productId =
                Integer.parseInt(
                        request.getParameter("productId"));

        int quantity =
                Integer.parseInt(
                        request.getParameter("quantity"));

        Product product =
                productDAO.getProductById(productId);

        CartItem item = new CartItem();

        item.setProduct(product);
        item.setQuantity(quantity);

        List<CartItem> buyNowItems =
                new ArrayList<>();

        buyNowItems.add(item);

        HttpSession session =
                request.getSession();

        session.setAttribute(
                "buyNowItems",
                buyNowItems
        );

        response.sendRedirect(
                request.getContextPath()
                        + "/checkout?type=buyNow");
    }
}