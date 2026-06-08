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
        .nav-tabs .nav-link { color: #495057; font-weight: 500; }
        .nav-tabs .nav-link.active {
            color: #d81f19 !important;
            border-bottom: 3px solid #d81f19 !important;
            background: none;
        }
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

    <ul class="nav nav-tabs mb-4 bg-white rounded shadow-sm p-2" id="orderTabs" role="tablist">
        <li class="nav-item" role="presentation">
            <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#tab-all" type="button">Tất cả</button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-pending" type="button">Chờ xử lý</button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-shipping" type="button">Đang giao</button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-completed" type="button">Hoàn tất</button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-cancelled" type="button">Đã hủy</button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-refund" type="button">Trả hàng/Hoàn tiền</button>
        </li>
    </ul>

    <c:choose>
        <c:when test="${empty orders}">
            <div class="alert alert-info shadow-sm border-0">
                <i class="fas fa-info-circle me-2"></i> Bạn chưa có đơn hàng nào.
                <a href="${pageContext.request.contextPath}/" class="fw-bold text-info text-decoration-none">Mua sắm ngay tại đây!</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="tab-content" id="orderTabsContent">
                <div class="tab-pane fade show active" id="tab-all" role="tabpanel">
                    <c:set var="filterStatus" value="ALL" scope="request"/>
                    <jsp:include page="_orderTableTemplate.jsp"/>
                </div>

                <div class="tab-pane fade" id="tab-pending" role="tabpanel">
                    <c:set var="filterStatus" value="PENDING" scope="request"/>
                    <jsp:include page="_orderTableTemplate.jsp"/>
                </div>

                <div class="tab-pane fade" id="tab-shipping" role="tabpanel">
                    <c:set var="filterStatus" value="SHIPPING" scope="request"/>
                    <jsp:include page="_orderTableTemplate.jsp"/>
                </div>

                <div class="tab-pane fade" id="tab-completed" role="tabpanel">
                    <c:set var="filterStatus" value="COMPLETED" scope="request"/>
                    <jsp:include page="_orderTableTemplate.jsp"/>
                </div>

                <div class="tab-pane fade" id="tab-cancelled" role="tabpanel">
                    <c:set var="filterStatus" value="CANCELLED" scope="request"/>
                    <jsp:include page="_orderTableTemplate.jsp"/>
                </div>

                <div class="tab-pane fade" id="tab-refund" role="tabpanel">
                    <c:set var="filterStatus" value="REFUND" scope="request"/>
                    <jsp:include page="_orderTableTemplate.jsp"/>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
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