package com.shop.sportstore.dao;

import com.shop.sportstore.model.*;
import com.shop.sportstore.untils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static com.shop.sportstore.untils.DBConnection.getConnection;

public class OrderDAO extends DBConnection {

    public void updateOrderStatus(String orderCode, String status) throws SQLException {
        String sql = "UPDATE orders SET Status = ?, UpdatedAt = NOW() WHERE OrderCode = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, orderCode);
            ps.executeUpdate();
        }
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
    public void createOrder(
            Integer userId,
            String orderCode,
            double total,
            String paymentMethod,
            String status,
            String receiverName,
            String receiverPhone,
            String address,
            int districtId,
            String wardCode,
            String note,
            Integer voucherId,
            double discountAmount,
            double shippingFee,
            List<CartItem> cart
    ) throws SQLException {

        String insertOrderSQL =
                "INSERT INTO orders (" +
                        "UserId, " +
                        "OrderCode, " +
                        "TotalPrice, " +
                        "PaymentMethod, " +
                        "Status, " +
                        "ReceiverName, " +
                        "ReceiverPhone, " +
                        "Address, " +
                        "district_id, " +
                        "ward_code, " +
                        "Note, " +
                        "VoucherId, " +
                        "DiscountAmount, " +
                        "shipping_fee, " +
                        "CreatedAt" +
                        ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())";

        String insertDetailSQL =
                "INSERT INTO orderdetails (" +
                        "OrderId, ProductId, Quantity, Price" +
                        ") VALUES (?, ?, ?, ?)";

        Connection conn = null;

        try {

            conn = getConnection();
            conn.setAutoCommit(false);

            int orderId;
            try (
                    PreparedStatement psOrder =
                            conn.prepareStatement(
                                    insertOrderSQL,
                                    Statement.RETURN_GENERATED_KEYS
                            )
            ) {

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

                psOrder.executeUpdate();

                try (ResultSet rs = psOrder.getGeneratedKeys()) {

                    if (rs.next()) {
                        orderId = rs.getInt(1);
                    } else {
                        throw new SQLException("Không lấy được Order ID");
                    }
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
            System.out.println("CREATE ORDER SUCCESS");
            System.out.println("OrderCode: " + orderCode);
            System.out.println("Total: " + total);
            System.out.println("ShippingFee: " + shippingFee);
            System.out.println("Discount: " + discountAmount);
        } catch (Exception e) {
            if (conn != null) {
                conn.rollback();
            }
            e.printStackTrace();
            throw new SQLException("Lỗi tạo đơn hàng: " + e.getMessage());

        } finally {
            if (conn != null) {
                conn.close();
            }
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
                Order order = new Order();
                order.setId(rs.getInt("Id"));
                order.setUserId(rs.getInt("UserId"));
                order.setOrderCode(rs.getString("OrderCode"));
                order.setTotalPrice(rs.getDouble("TotalPrice"));
                order.setStatus(rs.getString("Status"));
                order.setPaymentMethod(rs.getString("PaymentMethod"));

                order.setReceiverName(rs.getString("ReceiverName"));
                order.setReceiverPhone(rs.getString("ReceiverPhone"));
                order.setAddress(rs.getString("Address"));
                order.setNote(rs.getString("Note"));

                order.setDistrictId(rs.getInt("district_id"));
                order.setWardCode(rs.getString("ward_code"));

                order.setShippingFee(rs.getDouble("shipping_fee"));
                order.setDiscountAmount(rs.getDouble("DiscountAmount"));


                order.setCreatedAt(rs.getTimestamp("CreatedAt"));
                order.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
                order.setConfirmedAt(rs.getTimestamp("ConfirmedAt"));
                order.setShippingAt(rs.getTimestamp("ShippingAt"));
                order.setCompletedAt(rs.getTimestamp("CompletedAt"));
                order.setCancelledAt(rs.getTimestamp("CancelledAt"));
                order.setCancelReason(rs.getString("CancelReason"));
                order.setUserFullName(rs.getString("userFullName"));
                orders.add(order);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

    public List<OrderItem> getOrderItems(String orderCode) throws SQLException {

        List<OrderItem> items = new ArrayList<>();

        String sql = "SELECT p.id AS productId, p.name AS productName, p.price, od.Quantity " +
                "FROM orderdetails od " +
                "JOIN orders o ON od.OrderId = o.Id " +
                "JOIN products p ON od.ProductId = p.id " +
                "WHERE o.OrderCode = ?";

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
        String sql = "UPDATE orders SET Status = 'CANCELLED', CancelReason = ?, CancelledAt = NOW(), " +
                "UpdatedAt = NOW() WHERE OrderCode = ? AND UserId = ? AND Status IN ('PENDING', 'CONFIRMED')";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, cancelReason);
            ps.setString(2, orderCode);
            ps.setInt(3, userId);
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


    public boolean updateStatusByGhnCode(String ghnCode, String status)
            throws SQLException {

        String timeColumn = "";

        switch (status) {

            case "PROCESSING":
                timeColumn = ", ConfirmedAt = NOW()";
                break;

            case "SHIPPING":
                timeColumn = ", ShippingAt = NOW()";
                break;

            case "DELIVERED":
                timeColumn = ", CompletedAt = NOW()";
                break;

            case "CANCELLED":
                timeColumn = ", CancelledAt = NOW()";
                break;
        }

        String sql =
                "UPDATE orders " +
                        "SET Status = ?, UpdatedAt = NOW() "
                        + timeColumn +
                        " WHERE ghn_code = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);

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
                    Order order = new Order();
                    order.setId(rs.getInt("Id"));
                    order.setUserId(rs.getInt("UserId"));
                    order.setOrderCode(rs.getString("OrderCode"));
                    order.setTotalPrice(rs.getDouble("TotalPrice"));
                    order.setStatus(rs.getString("Status"));
                    order.setPaymentMethod(rs.getString("PaymentMethod"));


                    order.setReceiverName(rs.getString("ReceiverName"));
                    order.setReceiverPhone(rs.getString("ReceiverPhone"));
                    order.setAddress(rs.getString("Address"));
                    order.setNote(rs.getString("Note"));


                    order.setDistrictId(rs.getInt("district_id"));
                    order.setWardCode(rs.getString("ward_code"));


                    order.setShippingFee(rs.getDouble("shipping_fee"));
                    order.setDiscountAmount(rs.getDouble("DiscountAmount"));


                    order.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    order.setUpdatedAt(rs.getTimestamp("UpdatedAt")); // Đã bổ sung trường này tránh khuyết dữ liệu
                    order.setConfirmedAt(rs.getTimestamp("ConfirmedAt"));
                    order.setShippingAt(rs.getTimestamp("ShippingAt"));
                    order.setCompletedAt(rs.getTimestamp("CompletedAt"));
                    order.setCancelledAt(rs.getTimestamp("CancelledAt"));
                    order.setCancelReason(rs.getString("CancelReason"));


                    order.setUserFullName(rs.getString("userFullName"));

                    orders.add(order);
                }
            }
        } catch (Exception e) {
            System.err.println(" Lỗi xảy ra tại hàm getOrdersByStatus: " + e.getMessage());
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
            ResultSet rs = ps.executeQuery();

            OrderDetailDAO detailDAO = new OrderDetailDAO();

            while (rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("Id"));
                o.setOrderCode(rs.getString("OrderCode"));
                o.setTotalPrice(rs.getDouble("TotalPrice"));
                o.setStatus(rs.getString("Status"));
                o.setCreatedAt(rs.getTimestamp("CreatedAt"));
                o.setAddress(rs.getString("Address"));
                o.setReceiverName(rs.getString("ReceiverName"));
                o.setReceiverPhone(rs.getString("ReceiverPhone"));
                o.setDistrictId(rs.getInt("district_id"));
                o.setWardCode(rs.getString("ward_code"));
                o.setNote(rs.getString("Note"));
                o.setPaymentMethod(rs.getString("PaymentMethod"));

                o.setShippingFee(rs.getDouble("shipping_fee"));
                o.setDiscountAmount(rs.getDouble("DiscountAmount"));

                List<OrderDetail> details = detailDAO.getOrderDetailsByOrderId(o.getId());
                o.setOrderDetails(details);

                orders.add(o);
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
            ResultSet rs = ps.executeQuery();

            OrderDetailDAO detailDAO = new OrderDetailDAO();

            while (rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("Id"));
                o.setOrderCode(rs.getString("OrderCode"));
                o.setTotalPrice(rs.getDouble("TotalPrice"));
                o.setStatus(rs.getString("Status"));
                o.setCreatedAt(rs.getTimestamp("CreatedAt"));
                o.setAddress(rs.getString("Address"));
                o.setReceiverName(rs.getString("ReceiverName"));
                o.setReceiverPhone(rs.getString("ReceiverPhone"));
                o.setDistrictId(rs.getInt("district_id"));
                o.setWardCode(rs.getString("ward_code"));
                o.setNote(rs.getString("Note"));
                o.setPaymentMethod(rs.getString("PaymentMethod"));

                o.setShippingFee(rs.getDouble("shipping_fee"));
                o.setDiscountAmount(rs.getDouble("DiscountAmount"));

                List<OrderDetail> details = detailDAO.getOrderDetailsByOrderId(o.getId());
                o.setOrderDetails(details);

                orders.add(o);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return orders;
    }
    public Order getOrderById(int id) {

        String sql = "SELECT * FROM orders WHERE Id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
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

                o.setDistrictId(rs.getInt("district_id"));
                o.setWardCode(rs.getString("ward_code"));


                o.setShippingFee(rs.getDouble("shipping_fee"));
                o.setDiscountAmount(rs.getDouble("DiscountAmount"));

                o.setCreatedAt(rs.getTimestamp("CreatedAt"));
                o.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
                o.setConfirmedAt(rs.getTimestamp("ConfirmedAt"));
                o.setShippingAt(rs.getTimestamp("ShippingAt"));
                o.setCompletedAt(rs.getTimestamp("CompletedAt"));
                o.setCancelledAt(rs.getTimestamp("CancelledAt"));
                o.setCancelReason(rs.getString("CancelReason"));

                OrderDetailDAO detailDAO = new OrderDetailDAO();
                List<OrderDetail> details = detailDAO.getOrderDetailsByOrderId(id);
                o.setOrderDetails(details);

                return o;
            }
        } catch (Exception e) {
            System.out.println("Lỗi tại getOrderById: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public boolean confirmOrder(int id) {
        String sql = "UPDATE orders SET Status = 'CONFIRMED', ConfirmedAt = NOW(), UpdatedAt = NOW() WHERE Id = ?";
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
        String sql = "UPDATE orders SET Status = 'SHIPPING', ShippingAt = NOW(), UpdatedAt = NOW() WHERE Id = ?";
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
        String sql = "UPDATE orders SET Status = 'DELIVERED', CompletedAt = NOW(), UpdatedAt = NOW() WHERE Id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
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
            ResultSet rs = ps.executeQuery();
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


            int idSearch = 0;
            try {
                idSearch = Integer.parseInt(cleanKeyword);
            } catch (NumberFormatException e) {
                idSearch = -1;
            }
            ps.setInt(3, idSearch);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {

                    Order o = new Order();

                    o.setId(rs.getInt("Id"));
                    o.setUserId(rs.getInt("UserId"));

                    o.setOrderCode(rs.getString("OrderCode"));

                    o.setTotalPrice(rs.getDouble("TotalPrice"));

                    o.setPaymentMethod(rs.getString("PaymentMethod"));

                    o.setStatus(rs.getString("Status"));

                    o.setNote(rs.getString("Note"));

                    o.setVoucherId(
                            rs.getObject("VoucherId") != null
                                    ? rs.getInt("VoucherId")
                                    : null
                    );

                    o.setDiscountAmount(rs.getDouble("DiscountAmount"));

                    o.setReceiverName(rs.getString("ReceiverName"));

                    o.setReceiverPhone(rs.getString("ReceiverPhone"));

                    o.setAddress(rs.getString("Address"));


                    o.setDistrictId(rs.getInt("district_id"));

                    o.setWardCode(rs.getString("ward_code"));

                    o.setGhnCode(rs.getString("ghn_code"));

                    o.setShippingFee(rs.getDouble("shipping_fee"));

                    o.setCreatedAt(rs.getTimestamp("CreatedAt"));

                    o.setUpdatedAt(rs.getTimestamp("UpdatedAt"));

                    o.setConfirmedAt(rs.getTimestamp("ConfirmedAt"));

                    o.setShippingAt(rs.getTimestamp("ShippingAt"));

                    o.setCompletedAt(rs.getTimestamp("CompletedAt"));

                    o.setCancelledAt(rs.getTimestamp("CancelledAt"));

                    o.setCancelReason(rs.getString("CancelReason"));

                    return o;
                }

            }
        } catch (Exception e) {
            System.err.println(" Lỗi tại findOrderByCodeOrPhone: " + e.getMessage());
            e.printStackTrace();
        }
        return null;

    }
    public Order getOrderByCode(String orderCode) {

        String sql = "SELECT * FROM orders WHERE OrderCode = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, orderCode);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

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
                o.setDistrictId(rs.getInt("district_id"));
                o.setWardCode(rs.getString("ward_code"));
                o.setDiscountAmount(rs.getDouble("DiscountAmount"));

                o.setShippingFee(rs.getDouble("shipping_fee"));

                o.setCreatedAt(rs.getTimestamp("CreatedAt"));

                return o;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean cancelOrderByAdmin(int id) {

        String sql =
                "UPDATE orders " +
                        "SET Status = 'CANCELLED', " +
                        "CancelledAt = NOW() " +
                        "WHERE Id = ?";

        try (
                Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

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
}