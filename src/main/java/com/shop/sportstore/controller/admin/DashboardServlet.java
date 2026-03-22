package com.shop.sportstore.controller.admin;

import com.shop.sportstore.dao.OrderDAO;
import com.shop.sportstore.dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/dashboard")
public class DashboardServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ProductDAO productDAO = new ProductDAO();
        OrderDAO orderDAO = new OrderDAO();

//		request.setAttribute("productCount", productDAO.countProducts(null, null));
//		request.setAttribute("orderCount", orderDAO.countOrders());
//		request.setAttribute("revenue", orderDAO.totalRevenue());

        request.getRequestDispatcher("/WEB-INF/admin/dashboard.jsp")
                .forward(request, response);
    }
}