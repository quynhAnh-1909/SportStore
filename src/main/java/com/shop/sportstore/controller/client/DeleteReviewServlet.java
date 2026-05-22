package com.shop.sportstore.controller.client;

import com.shop.sportstore.dao.ReviewDAO;
import com.shop.sportstore.model.Review;
import com.shop.sportstore.model.User;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/deleteReview")
public class DeleteReviewServlet
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

        ReviewDAO dao = new ReviewDAO();

        Review review =
                dao.getReviewById(reviewId);

        if (review == null
                || review.getUserId()
                != user.getUserId()) {

            response.setStatus(403);

            return;
        }

        dao.deleteReview(reviewId);

        response.getWriter().print("success");
    }
}
