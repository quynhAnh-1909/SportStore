package com.hagl.controller.client;

import com.hagl.dao.ProductDAO;
import com.hagl.model.Product;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/productDetail")
public class ProductDetailServlet extends HttpServlet {

    private ProductDAO productDAO;

    @Override
    public void init() {
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            int id = Integer.parseInt(request.getParameter("id"));

            Product product = productDAO.getProductById(id);

            if(product == null){

                request.setAttribute("errorMessage", "Không tìm thấy sản phẩm");
                request.getRequestDispatcher("/WEB-INF/views/client/error.jsp")
                       .forward(request,response);
                return;
            }

            request.setAttribute("product", product);

            request.getRequestDispatcher("/WEB-INF/views/client/productDetail.jsp")
                   .forward(request,response);

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute("errorMessage", "Lỗi tải chi tiết sản phẩm");
            request.getRequestDispatcher("/WEB-INF/views/client/error.jsp")
                   .forward(request,response);
        }
    }
}