package com.shop.sportstore.controller.admin;

import com.shop.sportstore.dao.CategoryDAO;
import com.shop.sportstore.model.Category;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/categories")
public class CategoryServlet extends HttpServlet {

    private CategoryDAO dao;

    @Override
    public void init() {
        dao = new CategoryDAO();
    }

    /* =============================
       GET
    ============================= */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {

            case "create":
                showCreateForm(request, response);
                break;

            case "delete":
                deleteCategory(request, response);
                break;

            default:
                listCategories(request, response);
                break;
        }
    }

    /* =============================
       POST
    ============================= */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if ("create".equals(action)) {
            insertCategory(request, response);
        }
    }

    /* =============================
       LIST
    ============================= */
    private void listCategories(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Category> all = dao.getAllCategories();
        List<Category> categories = dao.buildTree(all);

        request.setAttribute("categories", categories);
        request.setAttribute("contentPage", "/WEB-INF/admin/categoryList.jsp");

        request.getRequestDispatcher("/WEB-INF/admin/dashboard.jsp")
                .forward(request, response);
    }

    /* =============================
       SHOW CREATE
    ============================= */
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Category> categories = dao.buildTree(dao.getAllCategories());

        request.setAttribute("categories", categories);
        request.setAttribute("contentPage", "/WEB-INF/admin/createCategory.jsp");

        request.getRequestDispatcher("/WEB-INF/admin/dashboard.jsp")
                .forward(request, response);
    }

    /* =============================
       INSERT
    ============================= */
    private void insertCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            String name = request.getParameter("name");
            String parentId = request.getParameter("parentId");

            dao.insertCategory(name, parentId);

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/categories");
    }

    /* =============================
       DELETE
    ============================= */
    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.deleteCategory(id);

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/categories");
    }
}