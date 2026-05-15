package com.shop.sportstore.controller.client;


import com.shop.sportstore.dao.OrderDAO;
import com.shop.sportstore.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/cancel-order")
public class CancelOrderServlet extends HttpServlet {

    private final OrderDAO orderDAO =
            new OrderDAO();

    private final UserDAO userDAO =
            new UserDAO();

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);



        if (
                session == null ||
                        session.getAttribute("userId") == null
        ) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/products?showLogin=true"
            );

            return;
        }

        Integer userId =
                (Integer) session.getAttribute("userId");

        String orderCode =
                request.getParameter("orderCode");

        String cancelReason =
                request.getParameter("cancelReason");


        if (
                orderCode == null ||
                        orderCode.trim().isEmpty()
        ) {

            session.setAttribute(
                    "error",
                    "Mã đơn hàng không hợp lệ!"
            );

            response.sendRedirect(
                    request.getContextPath()
                            + "/order-history"
            );

            return;
        }



        if (
                cancelReason == null ||
                        cancelReason.trim().isEmpty()
        ) {

            cancelReason =
                    "Người dùng không nhập lý do hủy";
        }



        boolean isCanceled =
                orderDAO.cancelOrder(
                        orderCode,
                        userId,
                        cancelReason
                );

        if (isCanceled) {



            int cancelCount =
                    orderDAO.countCanceledOrdersInLastHour(
                            userId
                    );

            if (cancelCount >= 5) {

                userDAO.lockUserAccount(userId);

                session.invalidate();

                HttpSession newSession =
                        request.getSession(true);

                newSession.setAttribute(
                        "errorLogin",
                        "Tài khoản của bạn đã bị khóa do hủy đơn quá 5 lần trong 1 giờ!"
                );

                response.sendRedirect(
                        request.getContextPath()
                                + "/products?showLogin=true"
                );

                return;
            }



            session.setAttribute(
                    "message",
                    "Hủy đơn hàng thành công!"
            );

        } else {


            session.setAttribute(
                    "error",
                    "Không thể hủy đơn hàng này!"
            );
        }


        String referer =
                request.getHeader("Referer");

        response.sendRedirect(
                referer != null
                        ? referer
                        : request.getContextPath()
                        + "/order-history"
        );
    }
}
