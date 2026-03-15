package com.hagl.controller.admin;

import com.hagl.dao.ProductDAO;
import com.hagl.model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/products")
public class AdminProductServlet extends HttpServlet {

    private ProductDAO dao;

    @Override
    public void init() {
        dao = new ProductDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) action = "list";

        switch (action) {

            case "create":
                showCreateForm(request, response);
                break;

            case "edit":
                showEditForm(request, response);
                break;

            case "delete":
                deleteProduct(request, response);
                break;

            case "detail":
                showDetail(request, response);
                break;

            default:
                listProducts(request, response);
                break;
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	 request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("create".equals(action)) {
            insertProduct(request, response);
        } else if ("edit".equals(action)) {
            updateProduct(request, response);
        }
    }

    /* =============================
       LIST PRODUCT
    ============================= */

    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Product> products = dao.getAllProducts();

        request.setAttribute("products", products);

        request.setAttribute("contentPage", "/WEB-INF/views/admin/productList.jsp");

        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp")
               .forward(request, response);
    }
    /* =============================
       SHOW CREATE
    ============================= */

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/WEB-INF/views/admin/productCreate.jsp")
                .forward(request, response);
    }

    /* =============================
       INSERT PRODUCT
    ============================= */

    private void insertProduct(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {

            Product p = new Product();

            p.setName(request.getParameter("name"));
            p.setPrice(Double.parseDouble(request.getParameter("price")));
            p.setStockQuantity(Integer.parseInt(request.getParameter("stockQuantity")));
            p.setUnit(request.getParameter("unit"));
            p.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));

            dao.insertProduct(p);

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/products");
    }

    /* =============================
       SHOW EDIT
    ============================= */

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            int id = Integer.parseInt(request.getParameter("id"));

            Product product = dao.getProductById(id);

            request.setAttribute("product", product);

            request.getRequestDispatcher("/WEB-INF/views/admin/productEdit.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /* =============================
       UPDATE PRODUCT
    ============================= */

    private void updateProduct(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {

            Product p = new Product();

            p.setId(Integer.parseInt(request.getParameter("id")));
            p.setName(request.getParameter("name"));
            p.setPrice(Double.parseDouble(request.getParameter("price")));
            p.setStockQuantity(Integer.parseInt(request.getParameter("stockQuantity")));
           
            p.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
            p.setUnit(request.getParameter("unit"));
            dao.updateProduct(p);

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/products");
    }

    /* =============================
       DELETE PRODUCT
    ============================= */

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {

            int id = Integer.parseInt(request.getParameter("id"));

            dao.deleteProduct(id);

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/products");
    }

    /* =============================
       DETAIL PRODUCT
    ============================= */

    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            int id = Integer.parseInt(request.getParameter("id"));

            Product product = dao.getProductById(id);

            request.setAttribute("product", product);

            request.getRequestDispatcher("/WEB-INF/views/admin/productDetail.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}