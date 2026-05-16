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

    // =========================
    // GET
    // =========================
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        // =========================
        // ADD PAGE
        // =========================
        if ("add".equals(action)) {

            ProductDAO productDAO = new ProductDAO();

            request.setAttribute("products",
                    productDAO.getAllProducts());

            request.setAttribute(
                    "contentPage",
                    "/WEB-INF/admin/bannerCreate.jsp"
            );

            request.getRequestDispatcher(
                    "/WEB-INF/admin/dashboard.jsp"
            ).forward(request, response);
            return;
        }

        // =========================
        // DELETE
        // =========================
        if ("delete".equals(action)) {

            int id = Integer.parseInt(request.getParameter("id"));

            bannerDAO.delete(id);

            response.sendRedirect(
                    request.getContextPath() + "/admin/banners"
            );
            return;
        }

        // =========================
        // TOGGLE STATUS
        // =========================
        if ("toggle".equals(action)) {

            int id = Integer.parseInt(request.getParameter("id"));

            Banner banner = bannerDAO.findById(id);

            if (banner != null) {
                bannerDAO.updateStatus(id, !banner.isStatus());
            }

            response.sendRedirect(
                    request.getContextPath() + "/admin/banners"
            );
            return;
        }

        // =========================
        // LIST
        // =========================
        List<Banner> banners = bannerDAO.findAll();

        request.setAttribute("banners", banners);
        request.setAttribute("contentPage",
                "/WEB-INF/admin/banner.jsp");

        request.getRequestDispatcher(
                "/WEB-INF/admin/dashboard.jsp"
        ).forward(request, response);
    }

    // =========================
    // POST (ADD BANNER)
    // =========================
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String title = request.getParameter("title");
        String productIdRaw = request.getParameter("productId");

        Part imagePart = request.getPart("image");

        if (imagePart == null ||
                imagePart.getSubmittedFileName() == null ||
                imagePart.getSubmittedFileName().isEmpty()) {

            response.sendRedirect(
                    request.getContextPath() + "/admin/banners"
            );
            return;
        }

        String fileName = imagePart.getSubmittedFileName();

        // upload folder
        String uploadPath =
                getServletContext().getRealPath("/resources");

        File dir = new File(uploadPath);
        if (!dir.exists()) dir.mkdirs();

        // save file
        imagePart.write(uploadPath + File.separator + fileName);

        // create banner
        Banner banner = new Banner();
        banner.setTitle(title);
        banner.setImage(fileName);
        banner.setStatus(true);

        // product link
        if (productIdRaw != null && !productIdRaw.isEmpty()) {
            banner.setProductId(Integer.parseInt(productIdRaw));
        }

        bannerDAO.insert(banner);

        response.sendRedirect(
                request.getContextPath() + "/admin/banners"
        );
    }
}