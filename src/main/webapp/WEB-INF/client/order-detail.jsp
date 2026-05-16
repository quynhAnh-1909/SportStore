<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<html>
<head>
    <title>Chi tiết đơn hàng #${order.orderCode}</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .order-container {
            max-width: 900px;
            margin: 40px auto;
        }
        .card-custom {
            background: #ffffff;
            border: none;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            padding: 30px;
            margin-bottom: 25px;
        }
        .section-title {
            color: #d81f19;
            font-weight: 600;
            border-left: 4px solid #d81f19;
            padding-left: 10px;
            margin-bottom: 20px;
        }
        .product-img {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 8px;
            margin-right: 15px;
            border: 1px solid #dee2e6;
        }
        .table th {
            background-color: #f1f3f5;
            color: #495057;
            font-weight: 600;
        }
        .total-box {
            background: #fff5f5;
            border-radius: 8px;
            padding: 20px;
            border: 1px solid #ffe3e3;
        }
        .total-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }
        .total-final {
            font-size: 1.25rem;
            font-weight: 700;
            color: #d81f19;
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/layout/index.jsp" />

<div class="container order-container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold m-0 text-dark">📋 Chi tiết đơn hàng #${order.orderCode}</h3>
        <a href="${pageContext.request.contextPath}/account" class="btn btn-outline-secondary btn-sm">
            ← Quay lại lịch sử
        </a>
    </div>

    <div class="card-custom">
        <div class="row">
            <div class="col-md-6 border-end">
                <h5 class="section-title">📍 Thông tin nhận hàng</h5>
                <p class="mb-2"><strong>Người nhận:</strong> <c:out value="${order.receiverName}" default="Chưa cập nhật"/></p>
                <p class="mb-2"><strong>Số điện thoại:</strong> <c:out value="${order.receiverPhone}" default="Chưa cập nhật"/></p>
                <p class="mb-0"><strong>Địa chỉ:</strong> <c:out value="${order.address}" default="Chưa có địa chỉ"/></p>
            </div>
            <div class="col-md-6 ps-md-4 text-md-end mt-4 mt-md-0">
                <h5 class="section-title text-md-start invisible d-none d-md-block">Chi tiết</h5>
                <p class="mb-2"><strong>Ngày đặt:</strong>
                    <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                </p>
                <p class="mb-2"><strong>Phương thức:</strong> <span class="badge bg-secondary">${order.paymentMethod}</span></p>
                <p class="mb-0"><strong>Tình trạng:</strong>
                    <c:choose>
                        <c:when test="${order.status eq 'PENDING'}">
                            <span class="badge bg-warning text-dark">Chờ xác nhận</span>
                        </c:when>
                        <c:when test="${order.status eq 'DELIVERED'}">
                            <span class="badge bg-success">Thành công</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge bg-danger">Đã hủy</span>
                        </c:otherwise>
                    </c:choose>
                </p>
            </div>
        </div>
    </div>

    <div class="card-custom">
        <h5 class="section-title">🛒 Danh sách sản phẩm</h5>
        <div class="table-responsive">
            <table class="table table-borderless align-middle">
                <thead>
                <tr class="border-bottom text-secondary">
                    <th>Sản phẩm</th>
                    <th class="text-end" style="width: 150px;">Đơn giá</th>
                    <th class="text-center" style="width: 100px;">Số lượng</th>
                    <th class="text-end" style="width: 150px;">Thành tiền</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="detail" items="${order.orderDetails}">
                    <tr class="border-bottom">
                        <td>
                            <div class="d-flex align-items-center">
                                <img src="${pageContext.request.contextPath}/resources/${detail.product.imageUrl}"
                                     class="product-img" alt="Product Image">
                                <span class="fw-semibold text-dark"><c:out value="${detail.product.name}"/></span>
                            </div>
                        </td>
                        <td class="text-end"><fmt:formatNumber value="${detail.price}" type="number"/> ₫</td>
                        <td class="text-center fw-bold text-secondary">${detail.quantity}</td>
                        <td class="text-end fw-bold text-dark">
                            <fmt:formatNumber value="${detail.price * detail.quantity}" type="number"/> ₫
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

        <div class="row justify-content-end mt-4">
            <div class="col-md-5">

                <div class="total-box">
                    <div class="total-row">
                        <span class="text-muted">Tiền hàng:</span>
                        <span class="fw-semibold">
            <fmt:formatNumber value="${order.totalPrice - order.shippingFee}" type="number"/> ₫
        </span>
                    </div>
                    <div class="total-row">
                        <span class="text-muted">Phí vận chuyển:</span>
                        <span class="text-success fw-semibold">
            <c:choose>
                <c:when test="${order.shippingFee > 0}">
                    <fmt:formatNumber value="${order.shippingFee}" type="number"/> ₫
                </c:when>
                <c:otherwise>
                    Mễn phí
                </c:otherwise>
            </c:choose>
        </span>
                    </div>
                    <hr class="my-2">
                    <div class="total-row total-final">
                        <span>TỔNG CỘNG:</span>
                        <span><fmt:formatNumber value="${order.totalPrice}" type="number"/> ₫</span>
                    </div>
                </div>


            </div>
        </div>
    </div>
</div>

<jsp:include page="/footer.jsp" />
</body>
</html>