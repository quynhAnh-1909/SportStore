package com.shop.sportstore.controller.admin;


import com.shop.sportstore.dao.BannerDAO;
import com.shop.sportstore.model.Banner;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/banners")
@MultipartConfig
public class BannerServlet extends HttpServlet {

    private final BannerDAO bannerDAO = new BannerDAO();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        // =========================
        // DELETE
        // =========================
        if ("delete".equals(action)) {

            int id = Integer.parseInt(
                    request.getParameter("id")
            );

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

            int id = Integer.parseInt(
                    request.getParameter("id")
            );

            Banner banner = bannerDAO.findById(id);

            if (banner != null) {

                boolean newStatus = !banner.isStatus();

                bannerDAO.updateStatus(id, newStatus);
            }

            response.sendRedirect(
                    request.getContextPath() + "/admin/banners"
            );
            return;
        }

        // =========================
        // SHOW ADD PAGE
        // =========================
        if ("add".equals(action)) {

            request.setAttribute(
                    "contentPage",
                    "/WEB-INF/admin/banner/bannerAdd.jsp"
            );

            request.getRequestDispatcher(
                    "/WEB-INF/admin/dashboard.jsp"
            ).forward(request, response);

            return;
        }

        // =========================
        // LIST
        // =========================
        List<Banner> banners = bannerDAO.findAll();

        request.setAttribute("banners", banners);

        request.setAttribute(
                "contentPage",
                "/WEB-INF/admin/banner.jsp"
        );

        request.getRequestDispatcher(
                "/WEB-INF/admin/dashboard.jsp"
        ).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        // =========================
        // ADD
        // =========================
        if ("add".equals(action)) {

            String title = request.getParameter("title");

            Part imagePart = request.getPart("image");

            String fileName =
                    imagePart.getSubmittedFileName();


            String uploadPath = getServletContext()
                    .getRealPath("/uploads");

            File uploadDir = new File(uploadPath);

            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }

            imagePart.write(
                    uploadPath + File.separator + fileName
            );


            Banner banner = new Banner();

            banner.setTitle(title);
            banner.setImage(fileName);
            banner.setStatus(true);

            bannerDAO.insert(banner);


            response.sendRedirect(
                    request.getContextPath() + "/admin/banners"
            );
        }
    }
}