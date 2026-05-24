package com.shop.sportstore.controller.admin;

import com.shop.sportstore.dao.OrderDAO;
import com.shop.sportstore.model.Order;


import com.shop.sportstore.service.GhnOrderService;
import com.shop.sportstore.service.GhnShippingService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/orders")
public class OrdersServlet extends HttpServlet {
    private static final String GHN_TOKEN = "2eb2d430-50e9-11f1-a973-aee5264794df";
    private static final String GHN_SHOP_ID = "200323";
    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
    }
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        int id = Integer.parseInt(
                request.getParameter("id")
        );

        switch (action) {

            case "confirm":

                orderDAO.confirmOrder(id);

                request.getSession().setAttribute(
                        "toastMessage",
                        "Xác nhận đơn hàng thành công!"
                );

                request.getSession().setAttribute(
                        "toastColor",
                        "#198754"
                );

                break;

            case "cancel":

                orderDAO.cancelOrderByAdmin(id);

                request.getSession().setAttribute(
                        "toastMessage",
                        "Đã hủy đơn hàng!"
                );

                request.getSession().setAttribute(
                        "toastColor",
                        "#dc3545"
                );

                break;

            case "shipping":

                Order order = orderDAO.getOrderById(id);

                GhnOrderService ghnService =
                        new GhnOrderService(GHN_TOKEN, GHN_SHOP_ID);

                try {
                    String ghnCode = ghnService.createOrder(order);

                    System.out.println("GHN CODE RETURN: " + ghnCode);

                    if (ghnCode == null || ghnCode.isEmpty()) {
                        throw new RuntimeException("GHN không trả order_code");
                    }

                    // LƯU GHN CODE
                    orderDAO.updateGhnCode(id, ghnCode);

                    // UPDATE STATUS
                    orderDAO.shippingOrder(id);

                    request.getSession().setAttribute(
                            "toastMessage",
                            "Tạo GHN thành công: " + ghnCode
                    );

                    request.getSession().setAttribute(
                            "toastColor",
                            "#0d6efd"
                    );

                } catch (Exception e) {
                    e.printStackTrace();

                    request.getSession().setAttribute(
                            "toastMessage",
                            "Tạo GHN thất bại: " + e.getMessage()
                    );

                    request.getSession().setAttribute(
                            "toastColor",
                            "#dc3545"
                    );
                }

                break;

            case "complete":

                orderDAO.completeOrder(id);

                request.getSession().setAttribute(
                        "toastMessage",
                        "Hoàn thành đơn hàng!"
                );

                request.getSession().setAttribute(
                        "toastColor",
                        "#198754"
                );

                break;
        }

        response.sendRedirect(
                request.getContextPath() + "/admin/orders"
        );
    }
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String status = request.getParameter("status");

        List<Order> orders;
        if (status == null || status.isEmpty()) {

            orders = orderDAO.getAllOrders();

        } else {
            switch (status.toLowerCase()) {

                case "pending":
                    status = "PENDING";
                    break;

                case "pickup":
                    status = "CONFIRMED";
                    break;

                case "shipping":
                    status = "SHIPPING";
                    break;

                case "completed":
                    status = "COMPLETED";
                    break;

                case "cancelled":
                    status = "CANCELLED";
                    break;
            }

            orders = orderDAO.getOrdersByStatus(status);
        }
        request.setAttribute("orders", orders);

        request.setAttribute(
                "contentPage",
                "/WEB-INF/admin/order.jsp"
        );
        request.getRequestDispatcher(
                "/WEB-INF/admin/dashboard.jsp"
        ).forward(request, response);
    }
}
