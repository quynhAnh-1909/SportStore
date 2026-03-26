package com.shop.sportstore.controller.client;

import com.shop.sportstore.dao.CategoryDAO;
import com.shop.sportstore.dao.ProductDAO;
import com.shop.sportstore.model.Category;
import com.shop.sportstore.model.Product;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;


@WebServlet("/products")
public class ProductServlet extends HttpServlet {
    private static final int LIMIT = 40; // 5 sản phẩm * 8 hàng
    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;


    @Override
    public void init() {
        productDAO = new ProductDAO();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            String keyword = request.getParameter("keyword");
            String categoryIdParam = request.getParameter("categoryId");
            String pageParam = request.getParameter("page");

            int categoryId = 0;
            int page = 1;

            try {
                if (categoryIdParam != null && !categoryIdParam.isEmpty()) {
                    categoryId = Integer.parseInt(categoryIdParam);
                }
            } catch (Exception e) {
                categoryId = 0;
            }

            try {
                if (pageParam != null && !pageParam.isEmpty()) {
                    page = Integer.parseInt(pageParam);
                }
            } catch (Exception e) {
                page = 1;
            }

            int offset = (page - 1) * LIMIT;

            List<Product> productList =
                    productDAO.searchProducts(keyword, categoryId, offset, LIMIT);

            int totalProduct = productDAO.countProducts(keyword, categoryId);
            int totalPage = (int) Math.ceil((double) totalProduct / LIMIT);

            List<Category> categoryList = categoryDAO.getAllCategories();
            List<Category> all = categoryDAO.getAllCategories();
            List<Category> categories = categoryDAO.buildTree(all);

            request.setAttribute("categories", categories);
            // chống null
            if (productList == null) productList = List.of();
            if (categoryList == null) categoryList = List.of();

            request.setAttribute("products", productList);


            // 🔥 FIX QUAN TRỌNG
            request.getRequestDispatcher("/products.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();

            request.setAttribute("errorMessage", "Lỗi tải sản phẩm!");
            request.getRequestDispatcher("/error.jsp")
                    .forward(request, response);
        }
    }
}


