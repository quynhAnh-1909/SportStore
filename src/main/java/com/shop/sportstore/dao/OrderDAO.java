package com.shop.sportstore.dao;

import com.shop.sportstore.enums.OrderStatus;
import com.shop.sportstore.enums.RefundStatus;
import com.shop.sportstore.model.*;
import com.shop.sportstore.untils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static com.shop.sportstore.untils.DBConnection.getConnection;

public class OrderDAO extends DBConnection {
    public int countOrdersByStatus(String status) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM orders WHERE Status = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status.trim().toUpperCase());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }
    public long calculateMonthlyRevenue(int month, int year) {
        long total = 0;
        String sql = "SELECT SUM(TotalPrice) FROM orders WHERE Status = 'COMPLETED' AND MONTH(CreatedAt) = ? AND YEAR(CreatedAt) = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, month);
            ps.setInt(2, year);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    total = (long) rs.getDouble(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return total;
    }
    private Order mapOrder(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setId(rs.getInt("Id"));
        o.setUserId(rs.getInt("UserId"));
        o.setOrderCode(rs.getString("OrderCode"));
        o.setTotalPrice(rs.getDouble("TotalPrice"));
        o.setPaymentMethod(rs.getString("PaymentMethod"));
        o.setStatus(rs.getString("Status"));
        o.setReceiverName(rs.getString("ReceiverName"));
        o.setReceiverPhone(rs.getString("ReceiverPhone"));
        o.setAddress(rs.getString("Address"));
        o.setNote(rs.getString("Note"));

        try { o.setVoucherId(rs.getObject("VoucherId") != null ? rs.getInt("VoucherId") : null); } catch (Exception ignored) {}
        try { o.setDistrictId(rs.getInt("district_id")); } catch (Exception ignored) { try { o.setDistrictId(rs.getInt("DistrictId")); } catch (Exception ignored2) {} }
        try { o.setWardCode(rs.getString("ward_code")); } catch (Exception ignored) { try { o.setWardCode(rs.getString("WardCode")); } catch (Exception ignored2) {} }
        try { o.setShippingFee(rs.getDouble("shipping_fee")); } catch (Exception ignored) { try { o.setShippingFee(rs.getDouble("ShippingFee")); } catch (Exception ignored2) {} }
        try { o.setDiscountAmount(rs.getDouble("DiscountAmount")); } catch (Exception ignored) { try { o.setDiscountAmount(rs.getDouble("discount_amount")); } catch (Exception ignored2) {} }
        try { o.setGhnCode(rs.getString("ghn_code")); } catch (Exception ignored) { try { o.setGhnCode(rs.getString("GhnCode")); } catch (Exception ignored2) {} }

        o.setCreatedAt(rs.getTimestamp("CreatedAt"));
        o.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
        o.setConfirmedAt(rs.getTimestamp("ConfirmedAt"));
        o.setShippingAt(rs.getTimestamp("ShippingAt"));
        o.setCompletedAt(rs.getTimestamp("CompletedAt"));
        o.setCancelledAt(rs.getTimestamp("CancelledAt"));
        o.setCancelReason(rs.getString("CancelReason"));

        try { o.setRefundStatus(rs.getString("refund_status")); } catch (Exception ignored) {}
        try { o.setRefundReason(rs.getString("refund_reason")); } catch (Exception ignored) {}
        try { o.setRefundRequestedAt(rs.getTimestamp("refund_requested_at")); } catch (Exception ignored) {}
        try { o.setRefundedAt(rs.getTimestamp("refunded_at")); } catch (Exception ignored) {}
        try { o.setRefundRejectedAt(rs.getTimestamp("refund_rejected_at")); } catch (Exception ignored) {}
        try { o.setUserFullName(rs.getString("userFullName")); } catch (Exception ignored) {}

        if ("VNPAY".equalsIgnoreCase(o.getPaymentMethod())) {
            o.setPaid(!"CANCELLED".equalsIgnoreCase(o.getStatus()));
        } else {
            o.setPaid("COMPLETED".equalsIgnoreCase(o.getStatus()));
        }


        return o;
    }

    public void updateOrderStatus(String orderCode, String status) throws SQLException {
        if (orderCode == null || status == null) {
            throw new IllegalArgumentException("Mã đơn hàng hoặc trạng thái không được để trống!");
        }

        String sql = "UPDATE orders SET Status = ?, UpdatedAt = ? WHERE OrderCode = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status.trim().toUpperCase());
            ps.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            ps.setString(3, orderCode.trim());

            ps.executeUpdate();
        }
    }

    public void updatePaymentStatus(String orderCode, boolean isPaid) throws SQLException {
    }

    public Map<String, String> getOrderDetailForEmail(String orderCode) throws SQLException {
        Map<String, String> data = new HashMap<>();
        String sql = "SELECT o.Id, o.OrderCode, o.TotalPrice, o.Address, o.ReceiverName, " +
                "u.user_id AS userId, u.full_name, u.email " +
                "FROM orders o JOIN users u ON o.UserId = u.user_id WHERE o.OrderCode = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, orderCode);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    data.put("orderId", rs.getString("Id"));
                    data.put("orderCode", rs.getString("OrderCode"));
                    data.put("totalPrice", rs.getString("TotalPrice"));
                    data.put("address", rs.getString("Address"));
                    data.put("receiverName", rs.getString("ReceiverName"));
                    data.put("fullName", rs.getString("full_name"));
                    data.put("email", rs.getString("email"));
                }
            }
        }
        return data;
    }

    public String getOrderStatus(String orderCode) throws SQLException {
        String status = null;
        String sql = "SELECT Status FROM orders WHERE OrderCode = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, orderCode);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    status = rs.getString("Status");
                }
            }
        }
        return status;
    }

    public void createOrder(Integer userId, String orderCode, double total, String paymentMethod, String status,
                            String receiverName, String receiverPhone, String address, int districtId, String wardCode,
                            String note, Integer voucherId, double discountAmount, double shippingFee, List<CartItem> cart) throws SQLException {
        String insertOrderSQL = "INSERT INTO orders (UserId, OrderCode, TotalPrice, PaymentMethod, Status, " +
                "ReceiverName, ReceiverPhone, Address, district_id, ward_code, Note, VoucherId, DiscountAmount, " +
                "shipping_fee, CreatedAt, UpdatedAt) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        String insertDetailSQL = "INSERT INTO orderdetails (OrderId, ProductId, Quantity, Price) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false);

            int orderId;
            try (PreparedStatement psOrder = conn.prepareStatement(insertOrderSQL, Statement.RETURN_GENERATED_KEYS)) {
                psOrder.setInt(1, userId);
                psOrder.setString(2, orderCode);
                psOrder.setDouble(3, total);
                psOrder.setString(4, paymentMethod);
                psOrder.setString(5, status);
                psOrder.setString(6, receiverName);
                psOrder.setString(7, receiverPhone);
                psOrder.setString(8, address);
                psOrder.setInt(9, districtId);
                psOrder.setString(10, wardCode);
                psOrder.setString(11, note);

                if (voucherId != null) {
                    psOrder.setInt(12, voucherId);
                } else {
                    psOrder.setNull(12, Types.INTEGER);
                }

                psOrder.setDouble(13, discountAmount);
                psOrder.setDouble(14, shippingFee);

                Timestamp currentLocalTime = new Timestamp(System.currentTimeMillis());
                psOrder.setTimestamp(15, currentLocalTime);
                psOrder.setTimestamp(16, currentLocalTime);

                psOrder.executeUpdate();

                try (ResultSet rs = psOrder.getGeneratedKeys()) {
                    if (rs.next()) orderId = rs.getInt(1);
                    else throw new SQLException("Không lấy được Order ID");
                }
            }

            try (PreparedStatement psDetail = conn.prepareStatement(insertDetailSQL)) {
                for (CartItem item : cart) {
                    psDetail.setInt(1, orderId);
                    psDetail.setInt(2, item.getProduct().getId());
                    psDetail.setInt(3, item.getQuantity());
                    psDetail.setDouble(4, item.getProduct().getPrice());
                    psDetail.addBatch();
                }
                psDetail.executeBatch();
            }
            conn.commit();
        } catch (Exception e) {
            if (conn != null) conn.rollback();
            throw new SQLException("Lỗi tạo đơn hàng: " + e.getMessage());
        } finally {
            if (conn != null) conn.close();
        }
    }

    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.full_name AS userFullName FROM orders o " +
                "JOIN users u ON o.UserId = u.user_id ORDER BY o.CreatedAt DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                orders.add(mapOrder(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

    public List<OrderItem> getOrderItems(String orderCode) throws SQLException {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT p.id AS productId, p.name AS productName, p.price, od.Quantity " +
                "FROM orderdetails od JOIN orders o ON od.OrderId = o.Id " +
                "JOIN products p ON od.ProductId = p.id WHERE o.OrderCode = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, orderCode);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setProductId(rs.getInt("productId"));
                    item.setProductName(rs.getString("productName"));
                    item.setPrice(rs.getDouble("price"));
                    item.setQuantity(rs.getInt("Quantity"));
                    items.add(item);
                }
            }
        }
        return items;
    }

    public boolean cancelOrder(String orderCode, int userId, String cancelReason) {
        String sql = "UPDATE orders SET Status = 'CANCELLED', CancelReason = ?, refund_reason = ?, " +
                "refund_status = ?, refund_requested_at = CASE WHEN ? = 'PENDING_REFUND' THEN NOW() ELSE NULL END, " +
                "CancelledAt = NOW(), UpdatedAt = NOW() " +
                "WHERE OrderCode = ? AND UserId = ? AND Status IN ('PENDING', 'CONFIRMED', '0', 'CHỜ XÁC NHẬN')";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            Order order = getOrderByCode(orderCode);
            if (order == null) return false;

            boolean isPaid = "VNPAY".equalsIgnoreCase(order.getPaymentMethod());
            String targetRefundStatus = isPaid ? "PENDING_REFUND" : null;

            ps.setString(1, cancelReason);
            ps.setString(2, isPaid ? cancelReason : null);
            if (targetRefundStatus != null) {
                ps.setString(3, targetRefundStatus);
            } else {
                ps.setNull(3, Types.VARCHAR);
            }
            ps.setString(4, targetRefundStatus != null ? targetRefundStatus : "");
            ps.setString(5, orderCode);
            ps.setInt(6, userId);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public int countCanceledOrdersInLastHour(int userId) {
        String sql = "SELECT COUNT(*) FROM orders WHERE UserId = ? AND Status = 'CANCELLED' " +
                "AND UpdatedAt >= NOW() - INTERVAL 1 HOUR";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean updateStatusByGhnCode(String ghnCode, String status) throws SQLException {
        String timeColumn = "";
        String dbStatus = status;

        switch (status.toLowerCase()) {
            case "ready_to_pick": case "picking": case "picked":
                dbStatus = "CONFIRMED"; timeColumn = ", ConfirmedAt = NOW()"; break;
            case "delivering": case "transporting": case "sorting":
                dbStatus = "SHIPPING"; timeColumn = ", ShippingAt = NOW()"; break;
            case "delivered":
                dbStatus = "COMPLETED"; timeColumn = ", CompletedAt = NOW()"; break;
            case "cancel": case "delivery_fail": case "returned":
                dbStatus = "CANCELLED"; timeColumn = ", CancelledAt = NOW()"; break;
        }

        String sql = "UPDATE orders SET Status = ?, UpdatedAt = NOW() " + timeColumn + " WHERE ghn_code = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, dbStatus);
            ps.setString(2, ghnCode);
            return ps.executeUpdate() > 0;
        }
    }

    public List<Order> getOrdersByStatus(String status) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.full_name AS userFullName FROM orders o " +
                "JOIN users u ON o.UserId = u.user_id WHERE o.Status = ? ORDER BY o.CreatedAt DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    orders.add(mapOrder(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

    public List<Order> getOrdersByUser(int userId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE UserId = ? ORDER BY CreatedAt DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                OrderDetailDAO detailDAO = new OrderDetailDAO();
                while (rs.next()) {
                    Order order = mapOrder(rs);
                    order.setOrderDetails(detailDAO.getOrderDetailsByOrderId(order.getId()));
                    orders.add(order);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return orders;
    }

    public List<Order> getOrdersByUserAndStatus(int userId, String status) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE UserId = ? AND Status = ? ORDER BY CreatedAt DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    orders.add(mapOrder(rs));
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return orders;
    }

    public Order getOrderById(int id) {
        String sql = "SELECT * FROM orders WHERE Id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order order = mapOrder(rs);
                    OrderDetailDAO detailDAO = new OrderDetailDAO();
                    order.setOrderDetails(detailDAO.getOrderDetailsByOrderId(id));
                    return order;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean confirmOrder(int id) {
        String sql = "UPDATE orders SET Status = 'CONFIRMED', ConfirmedAt = NOW(), UpdatedAt = NOW() WHERE Id = ? AND Status = 'PENDING'";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean shippingOrder(int id) {
        String sql = "UPDATE orders SET Status = 'SHIPPING', ShippingAt = NOW(), UpdatedAt = NOW() WHERE Id = ? AND Status = 'CONFIRMED'";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean completeOrder(int id) {
        String sql = "UPDATE orders SET Status = ?, CompletedAt = NOW(), UpdatedAt = NOW() WHERE Id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, OrderStatus.COMPLETED.name());
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateCancelReason(int orderId, String reason) {
        String sql = "UPDATE orders SET CancelReason = ?, CancelledAt = NOW(), UpdatedAt = NOW(), Status = 'CANCELLED' WHERE Id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, reason);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<CartItem> buyAgain(int orderId) {
        List<CartItem> cartItems = new ArrayList<>();
        String sql = "SELECT od.Quantity, p.* FROM orderdetails od JOIN products p ON od.ProductId = p.id WHERE od.OrderId = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CartItem item = new CartItem();
                    item.setQuantity(rs.getInt("Quantity"));
                    Product p = new Product();
                    p.setId(rs.getInt("id"));
                    p.setName(rs.getString("name"));
                    p.setPrice(rs.getDouble("price"));
                    p.setImageUrl(rs.getString("image_url"));
                    item.setProduct(p);
                    cartItems.add(item);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return cartItems;
    }

    public Order findOrderByCodeOrPhone(String keyword) {
        String sql = "SELECT * FROM orders WHERE OrderCode = ? OR ReceiverPhone = ? OR Id = ? ORDER BY CreatedAt DESC LIMIT 1";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String cleanKeyword = keyword.trim();
            ps.setString(1, cleanKeyword);
            ps.setString(2, cleanKeyword);

            int idSearch = -1;
            try { idSearch = Integer.parseInt(cleanKeyword); } catch (NumberFormatException ignored) {}
            ps.setInt(3, idSearch);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapOrder(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public Order getOrderByCode(String orderCode) {

        String sql = "SELECT * FROM orders WHERE OrderCode = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, orderCode);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    Order order = mapOrder(rs);

                    OrderDetailDAO detailDAO =
                            new OrderDetailDAO();

                    order.setOrderDetails(
                            detailDAO.getOrderDetailsByOrderId(
                                    order.getId()
                            )
                    );

                    return order;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean cancelOrderByAdmin(int id) {
        String sql = "UPDATE orders SET Status = 'CANCELLED', CancelledAt = NOW(), UpdatedAt = NOW() " +
                "WHERE Id = ? AND Status IN ('PENDING','CONFIRMED', '0', 'CHỜ XÁC NHẬN')";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void updateGhnCode(int id, String ghnCode) {
        String sql = "UPDATE orders SET ghn_code = ? WHERE Id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, ghnCode);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean requestRefund(int orderId, String reason) {
        String sql = "UPDATE orders SET refund_status = ?, refund_reason = ?, refund_requested_at = NOW(), UpdatedAt = NOW() " +
                "WHERE Id = ? AND refund_status IS NULL";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, RefundStatus.PENDING_REFUND.name());
            ps.setString(2, reason);
            ps.setInt(3, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean approveRefund(int id) {
        String sql = "UPDATE orders SET refund_status = 'REFUNDED', refunded_at = NOW(), UpdatedAt = NOW() WHERE Id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean rejectRefund(int id) {
        String sql = "UPDATE orders SET refund_status = 'REJECTED', refund_rejected_at = NOW(), UpdatedAt = NOW() WHERE Id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Order> getOrdersByRefundStatus(String refundStatus) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.full_name AS userFullName FROM orders o " +
                "JOIN users u ON o.UserId = u.user_id WHERE o.refund_status = ? ORDER BY o.CreatedAt DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, refundStatus);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    orders.add(mapOrder(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

    public int confirmAllPendingOrders() {

        String sql = """
        UPDATE Orders
        SET status = 'CONFIRMED'
        WHERE status = 'PENDING'
    """;

        try (
                Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            return ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }
}