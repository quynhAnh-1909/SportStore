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
import java.util.List;

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
                    productDAO.getBestSellerProducts(4);

            // FOOTBALL
            List<Product> footballProducts =
                    productDAO.getProductsByCategory(4, 4);

            // BASKETBALL
            List<Product> basketballProducts =
                    productDAO.getProductsByCategory(5, 4);

            // BADMINTON
            List<Product> badmintonProducts =
                    productDAO.getProductsByCategory(14, 4);

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

            // CATEGORY TREE
            List<Category> allCategories =
                    categoryDAO.getAllCategories();
            List<Category> categories =
                    categoryDAO.buildTree(allCategories);

            // NULL SAFETY
            if (productList == null) {
                productList = List.of();
            }

            if (categories == null) {
                categories = List.of();
            }

            // SET ATTRIBUTES
            request.setAttribute("products", productList);

            request.setAttribute(
                    "bestSellerProducts",
                    bestSellerProducts
            );

            request.setAttribute(
                    "footballProducts",
                    footballProducts
            );

            request.setAttribute(
                    "basketballProducts",
                    basketballProducts
            );

            request.setAttribute(
                    "badmintonProducts",
                    badmintonProducts
            );

            request.setAttribute("categories", categories);

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
