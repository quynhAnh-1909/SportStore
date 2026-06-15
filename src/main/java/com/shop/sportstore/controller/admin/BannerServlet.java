package com.shop.sportstore.controller.admin;

import com.shop.sportstore.dao.BannerDAO;
import com.shop.sportstore.dao.ProductDAO;
import com.shop.sportstore.model.Banner;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/banners")
@MultipartConfig
public class BannerServlet extends HttpServlet {

    private final BannerDAO bannerDAO = new BannerDAO();
    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            request.setAttribute("products", productDAO.getAllProducts());
            request.setAttribute("contentPage", "/WEB-INF/admin/bannerCreate.jsp");
            request.getRequestDispatcher("/WEB-INF/admin/layout-admin.jsp").forward(request, response);
            return;
        }

        if ("edit".equals(action)) {
            String idRaw = request.getParameter("id");
            if (idRaw != null && !idRaw.isEmpty()) {
                int id = Integer.parseInt(idRaw);
                Banner banner = bannerDAO.findById(id);

                if (banner != null) {
                    request.setAttribute("banner", banner);
                    request.setAttribute("products", productDAO.getAllProducts());
                    request.setAttribute("contentPage", "/WEB-INF/admin/bannerEdit.jsp");
                    request.getRequestDispatcher("/WEB-INF/admin/layout-admin.jsp").forward(request, response);
                    return;
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/banners");
            return;
        }

        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            bannerDAO.delete(id);
            response.sendRedirect(request.getContextPath() + "/admin/banners");
            return;
        }

        if ("toggle".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Banner banner = bannerDAO.findById(id);

            if (banner != null) {
                bannerDAO.updateStatus(id, !banner.isStatus());
            }

            response.sendRedirect(request.getContextPath() + "/admin/banners");
            return;
        }

        List<Banner> banners = bannerDAO.findAll();
        request.setAttribute("banners", banners);
        request.setAttribute("contentPage", "/WEB-INF/admin/banner.jsp");
        request.getRequestDispatcher("/WEB-INF/admin/layout-admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("update".equals(action)) {
            handleUpdateBanner(request, response);
        } else {
            handleCreateBanner(request, response);
        }
    }

    private void handleCreateBanner(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String title = request.getParameter("title");
        String productIdRaw = request.getParameter("productId");
        Part imagePart = request.getPart("image");

        if (imagePart == null || imagePart.getSubmittedFileName() == null || imagePart.getSubmittedFileName().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/banners");
            return;
        }
        String fileName = imagePart.getSubmittedFileName();
        String uploadPath = getServletContext().getRealPath("/resources");
        File dir = new File(uploadPath);
        if (!dir.exists()) dir.mkdirs();

        imagePart.write(uploadPath + File.separator + fileName);

        Banner banner = new Banner();
        banner.setTitle(title);
        banner.setImage(fileName);
        banner.setStatus(true);

        if (productIdRaw != null && !productIdRaw.isEmpty()) {
            banner.setProductId(Integer.parseInt(productIdRaw));
        }

        bannerDAO.insert(banner);
        response.sendRedirect(request.getContextPath() + "/admin/banners");
    }

    private void handleUpdateBanner(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String productIdRaw = request.getParameter("productId");
        Part imagePart = request.getPart("image");

        Banner banner = bannerDAO.findById(id);
        if (banner == null) {
            response.sendRedirect(request.getContextPath() + "/admin/banners");
            return;
        }

        banner.setTitle(title);
        if (productIdRaw != null && !productIdRaw.isEmpty()) {
            banner.setProductId(Integer.parseInt(productIdRaw));
        } else {
            banner.setProductId(null);
        }

        if (imagePart != null && imagePart.getSubmittedFileName() != null && !imagePart.getSubmittedFileName().isEmpty()) {
            String fileName = imagePart.getSubmittedFileName();
            String uploadPath = getServletContext().getRealPath("/resources");

            File dir = new File(uploadPath);
            if (!dir.exists()) dir.mkdirs();

            imagePart.write(uploadPath + File.separator + fileName);
            banner.setImage(fileName);
        }

        bannerDAO.update(banner);
        response.sendRedirect(request.getContextPath() + "/admin/banners");
    }
}