package com.shop.sportstore.controller.client;

import com.shop.sportstore.dao.ReviewDAO;
import com.shop.sportstore.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/review")
public class ReviewServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        int productId =
                Integer.parseInt(request.getParameter("productId"));

        int rating =
                Integer.parseInt(request.getParameter("rating"));

        String comment =
                request.getParameter("comment");

        User user =
                (User) request.getSession()
                        .getAttribute("user");

        if (user == null) {

            String currentUrl =
                    request.getHeader("Referer");

            request.getSession()
                    .setAttribute(
                            "redirectAfterLogin",
                            currentUrl
                    );

            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);

            return;
        }

        ReviewDAO dao = new ReviewDAO();

        dao.addReview(
                productId,
                user.getUserId(),
                rating,
                comment
        );

        response.setContentType("text/html;charset=UTF-8");

        PrintWriter out = response.getWriter();

        out.println(
                "<div class='border-top pt-3 pb-3'>"
                        + "<div class='fw-bold'>"
                        + user.getFullName()
                        + "</div>"

                        + "<div class='text-warning'>"
                        + rating + " ★"
                        + "</div>"

                        + "<div class='mt-2'>"
                        + comment
                        + "</div>"

                        + "</div>"
        );
    }
}
