package com.shop.sportstore.controller.admin;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.shop.sportstore.dao.OrderDAO;
import com.shop.sportstore.dao.NotificationDAO; // Tích hợp DAO thông báo
import com.shop.sportstore.model.Order;
import com.shop.sportstore.service.GhnOrderService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/orders")
public class OrdersServlet extends HttpServlet {

    private static final String GHN_TOKEN = "2eb2d430-50e9-11f1-a973-aee5264794df";
    private static final String GHN_SHOP_ID = "200403";
    private OrderDAO orderDAO;
    private NotificationDAO notificationDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
        notificationDAO = new NotificationDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        response.setContentType("application/json;charset=UTF-8");

        try {
            if ("tracking".equals(action)) {
                String trackingCode = request.getParameter("ghnCode");

                if (trackingCode == null || trackingCode.isEmpty() || "null".equals(trackingCode)) {
                    throw new RuntimeException("Đơn hàng chưa có mã vận đơn GHN!");
                }

                GhnOrderService trackingService = new GhnOrderService(GHN_TOKEN, GHN_SHOP_ID);
                String jsonGHN = trackingService.getOrderTracking(trackingCode);

                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write(jsonGHN);
                return;
            }

            if ("confirmAll".equals(action)) {
                int updatedRows = orderDAO.confirmAllPendingOrders();

                if (updatedRows > 0) {
                    response.setStatus(HttpServletResponse.SC_OK);
                    response.getWriter().write(
                            "{\"success\":true,\"message\":\"Đã xác nhận thành công và cập nhật kho " + updatedRows + " đơn hàng!\"}"
                    );
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write(
                            "{\"success\":false,\"message\":\"Không tìm thấy đơn hàng nào đang ở trạng thái chờ xử lý!\"}"
                    );
                }
                return;
            }

            String idParam = request.getParameter("id");
            if (idParam == null || idParam.isEmpty()) {
                throw new RuntimeException("Thiếu ID đơn hàng!");
            }

            int id = Integer.parseInt(idParam);

            switch (action) {
                case "confirm":
                    orderDAO.confirmOrder(id);

                    Order orderConfirm = orderDAO.getOrderById(id);
                    if (orderConfirm != null) {
                        notificationDAO.insertNotification(
                                orderConfirm.getUserId(),
                                "🛒 Đơn hàng đã được xác nhận",
                                "Đơn hàng #" + orderConfirm.getOrderCode() + " của bạn đã được SportStore xác nhận thành công.",
                                "/account"
                        );
                    }
                    break;

                case "cancel":
                    orderDAO.cancelOrderByAdmin(id);

                    Order orderCancel = orderDAO.getOrderById(id);
                    if (orderCancel != null) {
                        notificationDAO.insertNotification(
                                orderCancel.getUserId(),
                                " Đơn hàng đã bị hủy",
                                "Đơn hàng #" + orderCancel.getOrderCode() + " đã bị hủy bởi hệ thống. Vui lòng liên hệ hỗ trợ nếu có thắc mắc.",
                                "/account"
                        );
                    }
                    break;

                case "shipping":
                    Order order = orderDAO.getOrderById(id);
                    if (order == null) {
                        throw new RuntimeException("Không tìm thấy thông tin đơn hàng này!");
                    }

                    GhnOrderService ghnService = new GhnOrderService(GHN_TOKEN, GHN_SHOP_ID);
                    String ghnCode = ghnService.createOrder(order);

                    if (ghnCode == null || ghnCode.isEmpty()) {
                        throw new RuntimeException("GHN đang bận hoặc thông tin địa chỉ đơn hàng không hợp lệ!");
                    }

                    orderDAO.updateGhnCode(id, ghnCode);
                    orderDAO.shippingOrder(id);


                    notificationDAO.insertNotification(
                            order.getUserId(),
                            " Đơn hàng đang được giao",
                            "Đơn hàng #" + order.getOrderCode() + " đã bàn giao cho đối tác GHN. Mã vận đơn: " + ghnCode,
                            "/account"
                    );
                    break;

                case "complete":
                    orderDAO.completeOrder(id);

                    Order orderComplete = orderDAO.getOrderById(id);
                    if (orderComplete != null) {
                        notificationDAO.insertNotification(
                                orderComplete.getUserId(),
                                " Đơn hàng hoàn thành",
                                "Đơn hàng #" + orderComplete.getOrderCode() + " đã giao thành công. Cảm ơn bạn đã mua sắm tại SportStore!",
                                "/account"
                        );
                    }
                    break;

                case "approveRefund":
                case "approve_refund":
                    Order refundOrder = orderDAO.getOrderById(id);
                    if (refundOrder == null) {
                        throw new RuntimeException("Không tìm thấy đơn hàng cần phê duyệt hoàn tiền!");
                    }
                    orderDAO.approveRefund(id);
                    orderDAO.updateOrderStatus(refundOrder.getOrderCode(), "REFUNDED");


                    notificationDAO.insertNotification(
                            refundOrder.getUserId(),
                            " Phê duyệt hoàn tiền",
                            "Yêu cầu hoàn tiền cho đơn hàng #" + refundOrder.getOrderCode() + " đã được phê duyệt thành công.",
                            "/account"
                    );
                    break;

                case "rejectRefund":
                case "reject_refund":
                    Order rejectOrder = orderDAO.getOrderById(id);
                    if (rejectOrder == null) {
                        throw new RuntimeException("Không tìm thấy đơn hàng cần từ chối hoàn tiền!");
                    }
                    orderDAO.rejectRefund(id);
                    orderDAO.updateOrderStatus(rejectOrder.getOrderCode(), "REFUND_REJECTED");


                    notificationDAO.insertNotification(
                            rejectOrder.getUserId(),
                            "⚠ Từ chối hoàn tiền",
                            "Yêu cầu hoàn tiền cho đơn hàng #" + rejectOrder.getOrderCode() + " đã bị từ chối.",
                            "/account"
                    );
                    break;

                default:
                    throw new RuntimeException("Hành động xử lý (Action) không hợp lệ!");
            }

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("{\"success\":true,\"message\":\"Thao tác xử lý thành công!\"}");

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\":false,\"message\":\"" + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("sync".equals(action)) {
            try {
                List<Order> shippingOrders = orderDAO.getOrdersByStatus("SHIPPING");
                if (shippingOrders != null && !shippingOrders.isEmpty()) {
                    GhnOrderService ghnService = new GhnOrderService(GHN_TOKEN, GHN_SHOP_ID);
                    Gson gson = new Gson();

                    for (Order order : shippingOrders) {
                        String ghnCode = order.getGhnCode();
                        if (ghnCode != null && !ghnCode.isEmpty()) {
                            String jsonResponse = ghnService.getOrderTracking(ghnCode);
                            JsonObject result = gson.fromJson(jsonResponse, JsonObject.class);

                            if (result.has("code") && result.get("code").getAsInt() == 200) {
                                String ghnStatus = result.getAsJsonObject("data").get("status").getAsString().toLowerCase();

                                if ("delivered".equals(ghnStatus)) {
                                    orderDAO.updateStatusByGhnCode(ghnCode, "COMPLETED");

                                    notificationDAO.insertNotification(order.getUserId(), " Đơn hàng hoàn thành", "Đơn hàng #" + order.getOrderCode() + " đã giao thành công bởi GHN.", "/account");
                                } else if ("cancel".equals(ghnStatus)) {
                                    java.sql.Connection conn = null;
                                    try {
                                        conn = com.shop.sportstore.untils.DBConnection.getConnection();
                                        conn.setAutoCommit(false);
                                        orderDAO.updateStatusByGhnCode(ghnCode, "CANCELLED");
                                        orderDAO.increaseProductStock(order.getId(), conn);
                                        conn.commit();

                                        notificationDAO.insertNotification(order.getUserId(), " Đơn hàng đã bị hủy", "Đơn hàng #" + order.getOrderCode() + " đã bị hủy tự động trên hệ thống giao hàng.", "/account");
                                    } catch (Exception ex) {
                                        if (conn != null) conn.rollback();
                                        throw ex;
                                    } finally {
                                        if (conn != null) conn.close();
                                    }
                                } else if (ghnStatus.contains("return") || ghnStatus.contains("refund")
                                        || "damage".equals(ghnStatus) || "lost".equals(ghnStatus)) {
                                    orderDAO.requestRefund(order.getId(), "Đơn hàng bị trả về hoặc gặp sự cố từ đối tác giao hàng GHN.");
                                    orderDAO.updateOrderStatus(order.getOrderCode(), "PENDING_REFUND");
                                    // BẮN THÔNG BÁO: Trục trặc vận chuyển
                                    notificationDAO.insertNotification(order.getUserId(), "⚠ Đơn hàng gặp sự cố", "Đơn hàng #" + order.getOrderCode() + " đang được hoàn trả lại do lỗi vận chuyển.", "/account");
                                }
                            }
                        }
                    }
                }

                response.sendRedirect(request.getContextPath() + "/admin/orders");
                return;
            } catch (Exception e) {
                e.printStackTrace();
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.setContentType("text/plain;charset=UTF-8");
                response.getWriter().write("Lỗi hệ thống đồng bộ GHN: " + e.getMessage());
                return;
            }
        }

        String status = request.getParameter("status");
        List<Order> orders;

        if (status == null || status.isEmpty()) {
            orders = orderDAO.getAllOrders();
        } else {
            switch (status.toLowerCase()) {
                case "pending": status = "PENDING"; break;
                case "pickup": status = "CONFIRMED"; break;
                case "shipping": status = "SHIPPING"; break;
                case "completed": status = "COMPLETED"; break;
                case "cancelled": status = "CANCELLED"; break;
                case "refund_pending":
                case "refund":
                case "pending_refund": status = "PENDING_REFUND"; break;
                case "refunded": status = "REFUNDED"; break;
                case "refund_rejected": status = "REFUND_REJECTED"; break;
                default: status = "PENDING";
            }
            orders = orderDAO.getOrdersByStatus(status);
        }

        int pendingCount = 0;
        List<Order> pendingList = orderDAO.getOrdersByStatus("PENDING");
        if (pendingList != null) {
            pendingCount = pendingList.size();
        }

        request.setAttribute("pendingCount", pendingCount);
        request.setAttribute("orders", orders);
        request.setAttribute("contentPage", "/WEB-INF/admin/order.jsp");
        request.getRequestDispatcher("/WEB-INF/admin/layout-admin.jsp").forward(request, response);
    }
}