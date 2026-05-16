<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Lịch sử đơn hàng</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        body { background-color: #f8f9fa; }

        .text-danger-custom { color: #d81f19 !important; }
        .btn-danger-custom {
            background-color: #d81f19 !important;
            border-color: #d81f19 !important;
            color: #ffffff !important;
        }
        .btn-danger-custom:hover {
            background-color: #b31410 !important;
            border-color: #b31410 !important;
        }
        .table-danger-custom {
            background-color: #fce8e6 !important;
            color: #a81c18 !important;
        }
        .bg-danger-subtle-custom { background-color: #fce8e6 !important; }
        .border-danger-custom { border-color: #f5c2c0 !important; }

        .bg-warning-subtle { background-color: #fff3cd !important; }
        .bg-primary-subtle { background-color: #cfe2ff !important; }
        .bg-info-subtle { background-color: #cff4fc !important; }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/layout/index.jsp" />

<div class="container my-5 py-4">

    <nav aria-label="breadcrumb" class="mb-2">
        <ol class="breadcrumb">
            <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/" class="text-danger-custom text-decoration-none">
                    <i class="fas fa-home"></i> Trang chủ
                </a>
            </li>
            <li class="breadcrumb-item active" aria-current="page">
                <a href="${pageContext.request.contextPath}/order-history" class="text-secondary text-decoration-none fw-semibold">Lịch sử đơn hàng</a>
            </li>
        </ol>
    </nav>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold mb-0 text-danger-custom">
            <a href="${pageContext.request.contextPath}/order-history" class="text-danger-custom text-decoration-none">
                <i class="fas fa-history me-2"></i>Lịch sử đơn hàng
            </a>
        </h2>
        <a href="${pageContext.request.contextPath}/" class="btn btn-danger-custom fw-bold shadow-sm">
            <i class="fas fa-cart-plus me-2"></i>Mua sắm thêm
        </a>
    </div>

    <c:if test="${empty orders}">
        <div class="alert alert-info shadow-sm border-0">
            <i class="fas fa-info-circle me-2"></i> Bạn chưa có đơn hàng nào.
            <a href="${pageContext.request.contextPath}/" class="fw-bold text-info text-decoration-none">Mua sắm ngay tại đây!</a>
        </div>
    </c:if>

    <c:if test="${not empty orders}">
        <div id="orderArea" class="table-responsive shadow-sm rounded">
            <table class="table table-hover align-middle bg-white mb-0">
                <thead class="table-danger-custom">
                <tr>
                    <th>Mã đơn</th>
                    <th>Ngày đặt</th>
                    <th>Phương thức</th>
                    <th>Tổng tiền</th>
                    <th class="text-center">Thanh toán</th>
                    <th>Trạng thái</th>
                    <th>Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="item" items="${orders}">
                    <tr>
                        <td class="fw-bold">#<c:out value="${item.orderCode}" default="0000" /></td>
                        <td class="small text-muted">
                            <c:catch var="errDate">
                                <fmt:formatDate value="${item.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                            </c:catch>
                            <c:if test="${not empty errDate}">--/--/----</c:if>
                        </td>
                        <td>
                            <span class="badge border text-dark bg-light px-2 py-1">
                                <i class="fas ${item.paymentMethod eq 'VNPAY' ? 'fa-credit-card text-primary' : 'fa-money-bill-wave text-danger-custom'} me-1"></i>
                                <c:out value="${item.paymentMethod}" default="COD" />
                            </span>
                        </td>
                        <td class="fw-bold text-danger-custom">
                            <c:catch var="errPrice">
                                <fmt:formatNumber value="${item.totalPrice}" type="number" /> đ
                            </c:catch>
                            <c:if test="${not empty errPrice}">${item.totalPrice} đ</c:if>
                        </td>

                        <td class="text-center">
                            <c:catch var="errPaid">
                                <c:choose>
                                    <c:when test="${item.paid}">
                                        <span class="badge rounded-pill bg-danger-subtle-custom text-danger-custom border border-danger-custom px-2">
                                            <i class="fas fa-check-circle me-1"></i>Đã xong
                                        </span>
                                    </c:when>
                                    <c:when test="${item.paymentMethod eq 'VNPAY'}">
                                        <span class="badge rounded-pill bg-warning-subtle text-dark border border-warning px-2">
                                            <i class="fas fa-clock me-1"></i>Chờ tiền
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted small">--</span>
                                    </c:otherwise>
                                </c:choose>
                            </c:catch>
                            <c:if test="${not empty errPaid}">
                                <span class="text-muted small">--</span>
                            </c:if>
                        </td>

                        <td>
                            <c:catch var="errStatus">
                                <c:set var="statusLower" value="${not empty item.status ? fn:toLowerCase(item.status) : 'pending'}" />
                                <c:choose>
                                    <c:when test="${statusLower eq 'pending' or statusLower eq '0'}">
                                        <span class="badge bg-primary-subtle text-primary px-2 py-1">
                                            <i class="fas fa-sync-alt fa-spin me-1"></i>Đang xử lý
                                        </span>
                                    </c:when>
                                    <c:when test="${statusLower eq 'shipping' or statusLower eq '1'}">
                                        <span class="badge bg-info-subtle text-info px-2 py-1">
                                            <i class="fas fa-truck me-1"></i>Đang giao
                                        </span>
                                    </c:when>
                                    <c:when test="${statusLower eq 'delivered' or statusLower eq '2'}">
                                        <span class="badge bg-danger text-white px-2 py-1">
                                            <i class="fas fa-check me-1"></i>Hoàn tất
                                        </span>
                                    </c:when>
                                    <c:when test="${statusLower eq 'cancelled' or statusLower eq '3'}">
                                        <span class="badge bg-light text-secondary border px-2 py-1 text-decoration-line-through">
                                            <i class="fas fa-ban me-1"></i>Đã hủy
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary px-2 py-1"><c:out value="${item.status}" /></span>
                                    </c:otherwise>
                                </c:choose>
                            </c:catch>
                            <c:if test="${not empty errStatus}">
                                <span class="badge bg-secondary px-2 py-1">Đang xử lý</span>
                            </c:if>
                        </td>

                        <td>
                            <a href="${pageContext.request.contextPath}/order-detail?id=${item.id}"
                               class="btn btn-sm btn-info text-white shadow-sm" title="Xem chi tiết">
                                👁️
                            </a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </c:if>
</div>

<jsp:include page="/footer.jsp" />

</body>
</html>