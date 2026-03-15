package com.hagl.controller.client;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.hagl.dao.CategoryDAO;
import com.hagl.dao.ProductDAO;
import com.hagl.model.Category;
import com.hagl.model.Product;

@WebServlet("/productList")
public class ProductListServlet extends HttpServlet {

    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;

    private static final int LIMIT = 40; // số sản phẩm mỗi trang

    @Override
    public void init() {
        productDAO = new ProductDAO();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            // ===== 1. LẤY PARAM =====

            String keyword = request.getParameter("keyword");
            String categoryIdParam = request.getParameter("categoryId");
            String pageParam = request.getParameter("page");

            int categoryId = 0;
            int page = 1;

            if (categoryIdParam != null && !categoryIdParam.isEmpty()) {
                categoryId = Integer.parseInt(categoryIdParam);
            }

            if (pageParam != null) {
                page = Integer.parseInt(pageParam);
            }

            int offset = (page - 1) * LIMIT;

            // ===== 2. LẤY PRODUCT =====

            List<Product> products = productDAO.searchProducts(keyword, categoryId, offset, LIMIT);

            int totalProduct = productDAO.countProducts(keyword, categoryId);

            int totalPage = (int) Math.ceil((double) totalProduct / LIMIT);

            // ===== 3. CATEGORY =====

            List<Category> categories = categoryDAO.getAllCategories();

            // ===== 4. SET ATTRIBUTE =====

            request.setAttribute("productList", products);
            request.setAttribute("categoryList", categories);
            request.setAttribute("totalPage", totalPage);
            request.setAttribute("currentPage", page);

            // ===== 5. FORWARD =====
            
            request.getRequestDispatcher("/WEB-INF/views/client/productList.jsp")
                   .forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute("errorMessage", "Không thể tải danh sách sản phẩm.");

            request.getRequestDispatcher("/WEB-INF/views/client/error.jsp")
                   .forward(request, response);
        }
    }
}