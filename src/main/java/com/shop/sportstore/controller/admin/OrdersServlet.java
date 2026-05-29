package com.shop.sportstore.controller.admin;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.shop.sportstore.dao.OrderDAO;
import com.shop.sportstore.model.Order;
import com.shop.sportstore.service.GhnOrderService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/orders")
public class OrdersServlet extends HttpServlet {

    private static final String GHN_TOKEN =
            "2eb2d430-50e9-11f1-a973-aee5264794df";

    private static final String GHN_SHOP_ID = "200403";

    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        String action = request.getParameter("action");

        try {

            /*
             * TRACKING GHN
             */
            if ("tracking".equals(action)) {

                String trackingCode = request.getParameter("ghnCode");

                if (
                        trackingCode == null
                                || trackingCode.isEmpty()
                                || "null".equals(trackingCode)
                ) {
                    throw new RuntimeException(
                            "Đơn hàng chưa có mã vận đơn GHN!"
                    );
                }

                GhnOrderService trackingService =
                        new GhnOrderService(
                                GHN_TOKEN,
                                GHN_SHOP_ID
                        );

                String jsonGHN =
                        trackingService.getOrderTracking(trackingCode);

                response.setContentType(
                        "application/json;charset=UTF-8"
                );

                response.setStatus(HttpServletResponse.SC_OK);

                response.getWriter().write(jsonGHN);

                return;
            }

            /*
             * VALIDATE ID
             */
            String idParam = request.getParameter("id");

            if (idParam == null || idParam.isEmpty()) {
                throw new RuntimeException(
                        "Thiếu ID đơn hàng!"
                );
            }

            int id = Integer.parseInt(idParam);

            /*
             * HANDLE ACTION
             */
            switch (action) {

                /*
                 * XÁC NHẬN ĐƠN
                 */
                case "confirm":

                    orderDAO.confirmOrder(id);

                    break;

                /*
                 * HỦY ĐƠN
                 */
                case "cancel":

                    orderDAO.cancelOrderByAdmin(id);

                    break;

                /*
                 * GIAO HÀNG
                 */
                case "shipping":

                    Order order =
                            orderDAO.getOrderById(id);

                    if (order == null) {
                        throw new RuntimeException(
                                "Không tìm thấy đơn hàng!"
                        );
                    }

                    GhnOrderService ghnService =
                            new GhnOrderService(
                                    GHN_TOKEN,
                                    GHN_SHOP_ID
                            );

                    String ghnCode =
                            ghnService.createOrder(order);

                    System.out.println(
                            "GHN CODE RETURN: " + ghnCode
                    );

                    if (
                            ghnCode == null
                                    || ghnCode.isEmpty()
                    ) {

                        throw new RuntimeException(
                                "GHN đang bận hoặc địa chỉ không hợp lệ!"
                        );
                    }

                    orderDAO.updateGhnCode(id, ghnCode);

                    orderDAO.shippingOrder(id);

                    break;

                //HOÀN THÀNH

                case "complete":

                    orderDAO.completeOrder(id);

                    break;

                /*
                 * DUYỆT HOÀN TIỀN
                 */
                case "approveRefund":

                    orderDAO.approveRefund(id);

                    break;

                /*
                 * TỪ CHỐI HOÀN TIỀN
                 */
                case "rejectRefund":

                    orderDAO.rejectRefund(id);

                    break;

                default:

                    throw new RuntimeException(
                            "Action không hợp lệ!"
                    );
            }

            response.setStatus(HttpServletResponse.SC_OK);

            response.getWriter().write("success");

        } catch (Exception e) {

            e.printStackTrace();

            response.setStatus(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR
            );

            response.getWriter().write(e.getMessage());
        }
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        /*
         * ĐỒNG BỘ GHN
         */
        String action = request.getParameter("action");

        if ("sync".equals(action)) {

            try {

                List<Order> shippingOrders =
                        orderDAO.getOrdersByStatus("SHIPPING");

                if (
                        shippingOrders != null
                                && !shippingOrders.isEmpty()
                ) {

                    GhnOrderService ghnService =
                            new GhnOrderService(
                                    GHN_TOKEN,
                                    GHN_SHOP_ID
                            );

                    Gson gson = new Gson();

                    for (Order order : shippingOrders) {

                        String ghnCode =
                                order.getGhnCode();

                        if (
                                ghnCode != null
                                        && !ghnCode.isEmpty()
                        ) {

                            String jsonResponse =
                                    ghnService.getOrderTracking(ghnCode);

                            JsonObject result =
                                    gson.fromJson(
                                            jsonResponse,
                                            JsonObject.class
                                    );

                            if (
                                    result.has("code")
                                            && result.get("code").getAsInt() == 200
                            ) {

                                String ghnStatus =
                                        result
                                                .getAsJsonObject("data")
                                                .get("status")
                                                .getAsString()
                                                .toLowerCase();

                                /*
                                 * GHN -> COMPLETED
                                 */
                                if ("delivered".equals(ghnStatus)) {

                                    orderDAO.updateStatusByGhnCode(
                                            ghnCode,
                                            "COMPLETED"
                                    );

                                    System.out.println(
                                            "GHN -> COMPLETED"
                                    );
                                }

                                /*
                                 * GHN -> CANCELLED
                                 */
                                else if ("cancel".equals(ghnStatus)) {

                                    orderDAO.updateStatusByGhnCode(
                                            ghnCode,
                                            "CANCELLED"
                                    );

                                    System.out.println(
                                            "GHN -> CANCELLED"
                                    );
                                }

                                /*
                                 * GHN -> REFUND
                                 */
                                else if (
                                        ghnStatus.contains("return")
                                                || ghnStatus.contains("refund")
                                                || "damage".equals(ghnStatus)
                                                || "lost".equals(ghnStatus)
                                ) {

                                    orderDAO.updateStatusByGhnCode(
                                            ghnCode,
                                            "REFUND"
                                    );

                                    System.out.println(
                                            "GHN -> REFUND"
                                    );
                                }
                            }
                        }
                    }
                }

                response.setContentType(
                        "text/plain;charset=UTF-8"
                );

                response.getWriter().write(
                        "sync_success"
                );

                return;

            } catch (Exception e) {

                e.printStackTrace();

                response.setStatus(
                        HttpServletResponse.SC_INTERNAL_SERVER_ERROR
                );

                response.getWriter().write(
                        "Lỗi đồng bộ GHN: "
                                + e.getMessage()
                );

                return;
            }
        }

        /*
         * FILTER STATUS
         */
        String status =
                request.getParameter("status");

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

                case "refund":

                    status = "REFUND";

                    break;

                default:

                    status = "PENDING";
            }

            orders =
                    orderDAO.getOrdersByStatus(status);
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