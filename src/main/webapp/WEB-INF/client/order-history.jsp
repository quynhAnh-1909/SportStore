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
<div class="container my-5 py-4">
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

    <c:if test="${not empty sessionScope.successMsg}">
        <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
            <i class="fas fa-check-circle me-2"></i> <strong>Thành công!</strong> ${sessionScope.successMsg}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="successMsg" scope="session" />
    </c:if>

    <c:if test="${not empty sessionScope.errorMsg}">
        <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
            <i class="fas fa-exclamation-triangle me-2"></i> <strong>Lỗi:</strong> ${sessionScope.errorMsg}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="errorMsg" scope="session" />
    </c:if>

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
                    <th>Hành động</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="item" items="${orders}">
                    <c:set var="statusLower" value="${not empty item.status ? fn:toLowerCase(item.status) : 'pending'}" />
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
                            <fmt:formatNumber value="${item.totalPrice}" type="number" /> đ
                        </td>
                        <td class="text-center">
                            <c:choose>
                                <c:when test="${item.paid}">
                                    <span class="badge rounded-pill bg-danger-subtle-custom text-danger-custom border border-danger-custom px-2">
                                        <i class="fas fa-check-circle me-1"></i>Đã thanh toán
                                    </span>
                                </c:when>
                                <c:when test="${item.paymentMethod eq 'VNPAY'}">
                                    <span class="badge rounded-pill bg-warning-subtle text-dark border border-warning px-2">
                                        <i class="fas fa-clock me-1"></i>Chờ tiền
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge rounded-pill bg-light text-muted border px-2">Chưa thanh toán</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${statusLower eq 'pending' or statusLower eq 'chờ xác nhận'}">
                                    <span class="badge bg-primary-subtle text-primary px-2 py-1">
                                        <i class="fas fa-sync-alt fa-spin me-1"></i>Chờ xác nhận
                                    </span>
                                </c:when>
                                <c:when test="${statusLower eq 'shipping' or statusLower eq 'đang giao'}">
                                    <span class="badge bg-info-subtle text-info px-2 py-1">
                                        <i class="fas fa-truck me-1"></i>Đang giao
                                    </span>
                                </c:when>
                                <c:when test="${statusLower eq 'delivered' or statusLower eq 'completed' or statusLower eq 'hoàn tất' or statusLower eq 'đã giao'}">
                                    <span class="badge bg-success text-white px-2 py-1">
                                        <i class="fas fa-check me-1"></i>Hoàn tất
                                    </span>
                                </c:when>
                                <c:when test="${statusLower eq 'cancelled' or statusLower eq 'đã hủy'}">
                                    <span class="badge bg-light text-secondary border px-2 py-1 text-decoration-line-through">
                                        <i class="fas fa-ban me-1"></i>Đã hủy
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary px-2 py-1"><c:out value="${item.status}" /></span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/order-detail?id=${item.id}" class="btn btn-sm btn-info text-white shadow-sm" title="Xem chi tiết">
                                <i class="fas fa-eye"></i>
                            </a>
                            <c:if test="${not empty item.ghnCode}">
                                <a href="https://tracking.ghn.dev/?order_code=${item.ghnCode}"
                                   target="_blank"
                                   class="btn btn-sm btn-warning text-dark shadow-sm ms-1" title="Tra cứu hành trình đơn hàng trên GHN">
                                    <i class="fas fa-truck"></i>
                                </a>
                            </c:if>
                        </td>
                        <td>
                            <jsp:useBean id="now" class="java.util.Date"/>
                            <c:set var="timeDiff" value="${now.time - item.createdAt.time}" />
                            <c:set var="isUnder30Mins" value="${timeDiff < (30 * 60 * 1000)}" />
                            <c:choose>
                                <c:when test="${(statusLower eq 'pending' or statusLower eq 'chờ xác nhận') && isUnder30Mins}">
                                    <button type="button" class="btn btn-sm btn-danger w-100" onclick="openCancelModal('${item.orderCode}')">
                                        <i class="fas fa-times me-1"></i>Hủy đơn
                                    </button>
                                </c:when>
                                <c:when test="${statusLower eq 'shipping' or statusLower eq 'đang giao'}">
                                    <form action="${pageContext.request.contextPath}/confirm-received" method="POST" class="d-inline" onsubmit="return confirm('Xác nhận bạn đã nhận được gói hàng này?')">
                                        <input type="hidden" name="orderId" value="${item.id}">
                                        <button type="submit" class="btn btn-sm btn-success w-100">
                                            <i class="fas fa-box-open me-1"></i>Đã nhận hàng
                                        </button>
                                    </form>
                                </c:when>
                                <c:when test="${statusLower eq 'delivered' or statusLower eq 'completed' or statusLower eq 'hoàn tất' or statusLower eq 'đã giao'}">
                                    <a href="${pageContext.request.contextPath}/productDetail?id=${item.id}#reviewForm" class="btn btn-sm btn-outline-danger w-100">
                                        <i class="fas fa-star me-1"></i>Đánh giá
                                    </a>
                                </c:when>
                                <c:when test="${(statusLower eq 'cancelled' or statusLower eq 'đã hủy') && item.paymentMethod eq 'VNPAY' && item.paid}">
                                    <c:choose>
                                        <c:when test="${empty item.refundStatus}">
                                            <button type="button" class="btn btn-sm btn-warning w-100" onclick="openRefundModal('${item.id}')">
                                                <i class="fas fa-rotate-left me-1"></i>Hoàn tiền
                                            </button>
                                        </c:when>
                                        <c:when test="${item.refundStatus eq 'PENDING_REFUND'}">
                                            <span class="badge bg-warning text-dark d-block py-2"><i class="fas fa-clock me-1"></i>Chờ duyệt</span>
                                        </c:when>
                                        <c:when test="${item.refundStatus eq 'REFUNDED'}">
                                            <span class="badge bg-success d-block py-2"><i class="fas fa-check me-1"></i>Đã hoàn tiền</span>
                                        </c:when>
                                        <c:when test="${item.refundStatus eq 'REJECTED'}">
                                            <span class="badge bg-danger d-block py-2"><i class="fas fa-times me-1"></i>Từ chối</span>
                                        </c:when>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <button type="button" class="btn btn-sm btn-light border text-muted w-100" disabled>
                                        <i class="fas fa-lock me-1"></i>Khóa
                                    </button>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </c:if>
</div>

<div class="modal fade" id="refundModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/request-refund" method="post">
                <div class="modal-header bg-warning">
                    <h5 class="modal-title fw-bold">Yêu cầu hoàn tiền qua cổng VNPAY</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="refundOrderId" name="orderId">
                    <label class="form-label fw-bold">Lý do hoàn tiền</label>
                    <textarea class="form-control" name="reason" rows="4" placeholder="Vui lòng nhập số tài khoản hoặc lý do hoàn trả cụ thể..." required></textarea>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <button type="submit" class="btn btn-warning fw-bold">Gửi yêu cầu</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="cancelOrderModal" tabindex="-1" aria-labelledby="cancelModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow">
            <form action="${pageContext.request.contextPath}/cancel-order" method="POST">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title" id="cancelModalLabel">
                        <i class="fas fa-exclamation-triangle me-2"></i>Xác nhận hủy đơn hàng
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body py-4">
                    <p class="fs-6 text-secondary mb-3">
                        Bạn đang thực hiện hủy đơn hàng: <span id="displayOrderCode" class="text-danger fw-bold"></span>
                    </p>
                    <input type="hidden" name="orderCode" id="cancelOrderCode">
                    <div class="mb-3">
                        <label for="cancelReason" class="form-label fw-bold text-dark">Lý do hủy đơn hàng của bạn:</label>
                        <select class="form-select" name="cancelReason" id="cancelReason" required onchange="toggleOtherReasonField()">
                            <option value="" selected disabled>-- Vui lòng chọn lý do --</option>
                            <option value="Thay đổi ý định mua sắm">Thay đổi ý định mua sắm</option>
                            <option value="Tìm thấy cửa hàng khác giá tốt hơn">Tìm thấy cửa hàng khác giá tốt hơn</option>
                            <option value="Đặt sai kích cỡ, màu sắc hoặc sản phẩm">Đặt sai kích cỡ, màu sắc hoặc sản phẩm</option>
                            <option value="Thời gian chờ đợi giao hàng quá lâu">Thời gian chờ đợi giao hàng quá lâu</option>
                            <option value="Khác">Lý do khác...</option>
                        </select>
                    </div>
                    <div class="mb-1 d-none" id="otherReasonFieldWrapper">
                        <label for="otherReason" class="form-label small text-muted">Chi tiết lý do khác:</label>
                        <textarea class="form-control" name="otherReason" id="otherReason" rows="2" placeholder="Vui lòng nhập lý do cụ thể..."></textarea>
                    </div>
                </div>
                <div class="modal-footer bg-light border-0">
                    <button type="button" class="btn btn-secondary fw-semibold" data-bs-dismiss="modal">Đóng</button>
                    <button type="submit" class="btn btn-danger fw-bold px-3">Xác nhận hủy</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function openCancelModal(orderCode) {
        document.getElementById('cancelOrderCode').value = orderCode;
        document.getElementById('displayOrderCode').innerText = '#' + orderCode;
        document.getElementById('cancelReason').value = "";
        document.getElementById('otherReason').value = "";
        document.getElementById('otherReasonFieldWrapper').classList.add('d-none');
        document.getElementById('otherReason').removeAttribute('required');
        new bootstrap.Modal(document.getElementById('cancelOrderModal')).show();
    }

    function toggleOtherReasonField() {
        var selectElement = document.getElementById('cancelReason');
        var wrapper = document.getElementById('otherReasonFieldWrapper');
        var textarea = document.getElementById('otherReason');
        if (selectElement.value === "Khác") {
            wrapper.classList.remove('d-none');
            textarea.setAttribute('required', 'required');
            textarea.focus();
        } else {
            wrapper.classList.add('d-none');
            textarea.removeAttribute('required');
        }
    }

    function openRefundModal(orderId) {
        document.getElementById('refundOrderId').value = orderId;
        new bootstrap.Modal(document.getElementById('refundModal')).show();
    }
</script>
</body>
</html>