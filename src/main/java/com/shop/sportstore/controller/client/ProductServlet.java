package com.shop.sportstore.controller.client;

import com.shop.sportstore.dao.BannerDAO;
import com.shop.sportstore.dao.CategoryDAO;
import com.shop.sportstore.dao.ProductDAO;
import com.shop.sportstore.model.Category;
import com.shop.sportstore.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/products")
public class ProductServlet extends HttpServlet {

    private static final int LIMIT = 40;

    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;
    private BannerDAO bannerDAO = new BannerDAO();
    @Override
    public void init() {
        productDAO = new ProductDAO();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        try {

            String keyword = request.getParameter("keyword");
            String categoryIdParam = request.getParameter("categoryId");
            String pageParam = request.getParameter("page");

            int categoryId = 0;
            int page = 1;

            // CATEGORY
            try {
                if (categoryIdParam != null
                        && !categoryIdParam.isEmpty()) {

                    categoryId = Integer.parseInt(categoryIdParam);
                }
            } catch (Exception e) {
                categoryId = 0;
            }

            // PAGE
            try {
                if (pageParam != null
                        && !pageParam.isEmpty()) {

                    page = Integer.parseInt(pageParam);
                }
            } catch (Exception e) {
                page = 1;
            }

            if (page < 1) {
                page = 1;
            }

            int offset = (page - 1) * LIMIT;

            // BEST SELLER
            List<Product> bestSellerProducts =
                    productDAO.getBestSellerProducts(10);

            // SEARCH PRODUCTS
            List<Product> productList =
                    productDAO.searchProducts(
                            keyword,
                            categoryId,
                            offset,
                            LIMIT
                    );

            int totalProduct =
                    productDAO.countProducts(keyword, categoryId);

            int totalPage =
                    (int) Math.ceil((double) totalProduct / LIMIT);

            // NULL SAFETY
            if (productList == null) {
                productList = List.of();
            }

            // SET ATTRIBUTES
            request.setAttribute("products", productList);

            request.setAttribute(
                    "bestSellerProducts",
                    bestSellerProducts
            );

            List<Category> parentCategories =
                    categoryDAO.getParentCategories();

            List<Category> displayCategories =
                    new ArrayList<>();

            for(Category parent : parentCategories){

                displayCategories.addAll(
                        parent.getChildren()
                );
            }

            Map<Integer, List<Product>> categoryProducts =
                    new HashMap<>();

            for(Category c : displayCategories){

                List<Product> productsByCategory =
                        productDAO.getProductsByCategory(
                                c.getId(),
                                4
                        );

                categoryProducts.put(
                        c.getId(),
                        productsByCategory
                );
            }

            request.setAttribute(
                    "categoryProducts",
                    categoryProducts
            );

            request.setAttribute(
                    "categories",
                    displayCategories
            );

            request.setAttribute("currentPage", page);
            request.setAttribute("totalPage", totalPage);

            request.setAttribute("keyword", keyword);
            request.setAttribute("categoryId", categoryId);

            // ACTIVE BANNERS
            request.setAttribute(
                    "banners",
                    bannerDAO.findActiveBanners()
            );

            request.getRequestDispatcher("/products.jsp")
                    .forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "errorMessage",
                    "Lỗi tải sản phẩm!"
            );

            request.getRequestDispatcher("/error.jsp")
                    .forward(request, response);
        }
    }
}
