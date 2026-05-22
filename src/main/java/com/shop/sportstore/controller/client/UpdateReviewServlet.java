package com.shop.sportstore.controller.client;

import com.shop.sportstore.dao.ReviewDAO;
import com.shop.sportstore.model.Review;
import com.shop.sportstore.model.User;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/updateReview")
public class UpdateReviewServlet
        extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws IOException {

        User user =
                (User) request.getSession()
                        .getAttribute("user");

        if (user == null) {

            response.setStatus(401);

            return;
        }

        int reviewId =
                Integer.parseInt(
                        request.getParameter("reviewId")
                );

        int rating =
                Integer.parseInt(
                        request.getParameter("rating")
                );

        String comment =
                request.getParameter("comment");

        ReviewDAO dao = new ReviewDAO();

        Review review =
                dao.getReviewById(reviewId);

        if (review == null
                || review.getUserId()
                != user.getUserId()) {

            response.setStatus(403);

            return;
        }

        dao.updateReview(
                reviewId,
                rating,
                comment
        );

        response.getWriter().print("success");
    }
}
