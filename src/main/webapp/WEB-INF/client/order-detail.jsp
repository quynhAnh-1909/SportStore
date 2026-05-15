<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<h3>Chi tiết đơn hàng #${order.orderCode}</h3>

<div class="row">
    <div class="col-md-6">
        <h5>Thông tin nhận hàng</h5>
        <p><strong>Người nhận:</strong> ${order.receiverName}</p>
        <p><strong>Số điện thoại:</strong> ${order.receiverPhone}</p>
        <p><strong>Địa chỉ:</strong> ${order.address}</p>
    </div>
    <div class="col-md-6 text-end">
        <h5>Chi tiết đơn hàng</h5>
        <p><strong>Mã đơn:</strong> ${order.orderCode}</p>
        <p><strong>Ngày đặt:</strong>
            <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm" />
        </p>
        <p><strong>Trạng thái:</strong>
            <span class="badge bg-info">${order.status}</span>
        </p>
    </div>
</div>
<div class="status-box">
    <p><strong>Phương thức:</strong> ${order.paymentMethod}</p>
    <p><strong>Tình trạng:</strong>
        <span class="badge bg-warning">${order.status}</span>
    </p>
</div>
<table class="table">
    <thead>
    <tr>
        <th>Sản phẩm</th>
        <th>Đơn giá</th>
        <th>Số lượng</th>
        <th>Thành tiền</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="detail" items="${order.orderDetails}">
        <tr>
            <td>
                <img src="resources/${detail.product.imageUrl}" width="50">
                    ${detail.product.name}
            </td>
            <td><fmt:formatNumber value="${detail.price}" type="number"/> ₫</td>
            <td>${detail.quantity}</td>
            <td><fmt:formatNumber value="${detail.price * detail.quantity}" type="number"/> ₫</td>
        </tr>
    </c:forEach>
    </tbody>
</table>

<div class="total-box">
    <p>Tiền hàng: <fmt:formatNumber value="${order.totalPrice}" pattern="#,###"/> đ</p>
    <p>Phí vận chuyển: 0 đ</p>
    <hr>
    <h5>TỔNG CỘNG: <fmt:formatNumber value="${order.totalPrice}" pattern="#,###"/> đ</h5>
</div>