package com.shop.sportstore.controller.admin;

import com.shop.sportstore.dao.BannerDAO;
import com.shop.sportstore.model.Banner;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/banners")
public class BannerServlet extends HttpServlet {

    private BannerDAO dao;

    @Override
    public void init() {
        dao = new BannerDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if (action == null) {
            req.setAttribute("banners", dao.getAll());
            req.setAttribute("contentPage", "/WEB-INF/admin/banner.jsp");
            req.getRequestDispatcher("/WEB-INF/admin/dashboard.jsp").forward(req, resp);
        }

        // DELETE
        else if ("delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            dao.delete(id);
            resp.sendRedirect("banners");
        }

        // TOGGLE
        else if ("toggle".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            dao.toggleStatus(id);
            resp.sendRedirect("banners");
        }

        // ADD FORM
        else if ("add".equals(action)) {
            req.setAttribute("contentPage", "/admin/banner-form.jsp");
            req.getRequestDispatcher("/admin/dashboard.jsp").forward(req, resp);
        }

        // EDIT FORM
        else if ("edit".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            req.setAttribute("banner", dao.getById(id));
            req.setAttribute("contentPage", "/admin/banner-form.jsp");
            req.getRequestDispatcher("/admin/dashboard.jsp").forward(req, resp);
        }
    }
}