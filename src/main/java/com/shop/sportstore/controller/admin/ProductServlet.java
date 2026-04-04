package com.shop.sportstore.controller.admin;


import com.shop.sportstore.dao.CategoryDAO;
import com.shop.sportstore.dao.ProductDAO;
import com.shop.sportstore.model.Category;
import com.shop.sportstore.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.http.Part;

@WebServlet("/admin/products")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 10 * 1024 * 1024
)
public class ProductServlet extends HttpServlet {

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
        response.setContentType("text/html;charset=UTF-8");
        String action = request.getParameter("action");

        if ("create".equals(action)) {
            insertProduct(request, response);
        } else if ("edit".equals(action)) {
            updateProduct(request, response);
        }
    }

    // LIST PRODUCT


    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Product> products = dao.getAllProducts();

        CategoryDAO cdao = new CategoryDAO();
        List<Category> categories = cdao.buildTree(cdao.getAllCategories()); // ✅ FIX

        request.setAttribute("products", products);
        request.setAttribute("categories", categories);

        request.setAttribute("contentPage", "/WEB-INF/admin/products.jsp");
        request.getRequestDispatcher("/WEB-INF/admin/dashboard.jsp").forward(request, response);
    }

    //SHOW CREATE


    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        CategoryDAO cdao = new CategoryDAO();
        List<Category> categories = cdao.buildTree(cdao.getAllCategories()); // ✅ FIX
        String uploadPath = getServletContext().getRealPath("/resources");
        File folder = new File(uploadPath);

        List<String> imageList = new ArrayList<>();

        if (folder.exists()) {
            for (File f : folder.listFiles()) {
                imageList.add(f.getName());
            }
        }

        request.setAttribute("categories", categories);
        request.setAttribute("imageList", imageList);
        request.setAttribute("contentPage", "/WEB-INF/admin/productCreate.jsp");
        request.getRequestDispatcher("/WEB-INF/admin/dashboard.jsp")
                .forward(request, response);
    }

    //INSERT PRODUCT


    private void insertProduct(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        try {

            Product p = new Product();

            p.setName(request.getParameter("name"));
            p.setPrice(Double.parseDouble(request.getParameter("price")));
            p.setStockQuantity(Integer.parseInt(request.getParameter("stockQuantity")));
            p.setUnit(request.getParameter("unit"));


            String cateId = request.getParameter("categoryId");
            if (cateId != null && !cateId.isEmpty()) {
                p.setCategoryId(Integer.parseInt(cateId));
            }


            String imageUrl = request.getParameter("imageUrl");

            if (imageUrl != null && !imageUrl.isEmpty()) {

                String fileName = imageUrl.substring(imageUrl.lastIndexOf("/") + 1);
                p.setImageUrl(fileName);

            } else {


                Part filePart = request.getPart("imageFile");
                String fileName = filePart.getSubmittedFileName();

                if (fileName != null && !fileName.isEmpty()) {

                    String newFileName = System.currentTimeMillis() + "_" + fileName;

                    String uploadPath = getServletContext().getRealPath("/") + "resources";

                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) uploadDir.mkdirs();

                    filePart.write(uploadPath + File.separator + newFileName);

                    p.setImageUrl(newFileName);

                } else {

                    p.setImageUrl("no-image.png");
                }
            }


            dao.insertProduct(p);

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/products");
    }
    //SHOW EDIT


    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            int id = Integer.parseInt(request.getParameter("id"));

            Product product = dao.getProductById(id);

            CategoryDAO cdao = new CategoryDAO();
            List<Category> categories = cdao.buildTree(cdao.getAllCategories());

            String uploadPath = getServletContext().getRealPath("/resources");
            File folder = new File(uploadPath);

            List<String> imageList = new ArrayList<>();

            if (folder.exists()) {
                for (File f : folder.listFiles()) {
                    imageList.add(f.getName());
                }
            }

            request.setAttribute("product", product);
            request.setAttribute("categories", categories);
            request.setAttribute("imageList", imageList);

            request.setAttribute("contentPage", "/WEB-INF/admin/productEdit.jsp");

            request.getRequestDispatcher("/WEB-INF/admin/dashboard.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    // UPDATE PRODUCT

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

    //DELETE PRODUCT


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

    //DETAIL PRODUCT


    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            int id = Integer.parseInt(request.getParameter("id"));

            Product product = dao.getProductById(id);

            request.setAttribute("product", product);

            request.getRequestDispatcher("/WEB-INF/admin/productDetail.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}