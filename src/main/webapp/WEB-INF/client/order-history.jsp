<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<style>
    .text-danger-custom { color: #d81f19 !important; }

    .btn-danger-custom{
        background-color:#d81f19 !important;
        border-color:#d81f19 !important;
        color:#fff !important;
    }

    .btn-danger-custom:hover{
        background-color:#b31410 !important;
        border-color:#b31410 !important;
    }

    .table-danger-custom{
        background-color:#fce8e6 !important;
        color:#a81c18 !important;
    }

    .bg-danger-subtle-custom{
        background-color:#fce8e6 !important;
    }

    .border-danger-custom{
        border-color:#f5c2c0 !important;
    }

    .bg-warning-subtle{
        background-color:#fff3cd !important;
    }

    .bg-primary-subtle{
        background-color:#cfe2ff !important;
    }

    .bg-info-subtle{
        background-color:#cff4fc !important;
    }

    #orderTabs .nav-link{
        color:#495057;
        font-weight:500;
        border:none;
        background:none;
        transition:all .2s;
        cursor:pointer;
    }

    #orderTabs .nav-link.active{
        color:#d81f19 !important;
        border-bottom:3px solid #d81f19 !important;
        font-weight:600;
    }

    .order-row{
        transition:opacity .2s;
    }
</style>
<div class="container my-5 py-4">

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
            <button class="nav-link active" data-filter="all" type="button">Tất cả</button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" data-filter="pending" type="button">Chờ xử lý</button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" data-filter="shipping" type="button">Đang giao</button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" data-filter="completed" type="button">Hoàn tất</button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" data-filter="cancelled" type="button">Đã hủy</button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" data-filter="refund" type="button">Trả hàng/Hoàn tiền</button>
        </li>
    </ul>

    <c:choose>
        <c:when test="${empty orders}">
            <div class="alert alert-info shadow-sm border-0 py-4">
                <i class="fas fa-info-circle me-2 fs-5"></i> Bạn chưa có đơn hàng nào.
                <a href="${pageContext.request.contextPath}/" class="fw-bold text-info text-decoration-none ms-1">Mua sắm ngay tại đây!</a>
            </div>
        </c:when>
        <c:otherwise>
            <div id="emptyFilterAlert" class="alert alert-info shadow-sm border-0 py-4 d-none animate__animated animate__fadeIn">
                <i class="fas fa-info-circle me-2 fs-5"></i> Không có đơn hàng nào thuộc trạng thái này.
            </div>

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
                        <c:set var="statusLower" value="${not empty item.status ? fn:trim(fn:toLowerCase(item.status)) : 'pending'}" />
                        <tr class="order-row"
                            data-status="${statusLower}"
                            data-refund="${not empty item.refundStatus ? 'has-refund' : 'none'}">

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
                                    <c:when test="${statusLower eq 'pending' or statusLower eq 'confirmed' or statusLower eq 'paid' or statusLower eq 'chờ xác nhận'}">
                                        <span class="badge bg-primary-subtle text-primary px-2 py-1">
                                            <i class="fas fa-sync-alt fa-spin me-1"></i>Chờ xử lý
                                        </span>
                                    </c:when>
                                    <c:when test="${statusLower eq 'shipping' or statusLower eq 'đang giao'}">
                                        <span class="badge bg-info-subtle text-info px-2 py-1">
                                            <i class="fas fa-truck me-1"></i>Đang giao
                                        </span>
                                    </c:when>
                                    <c:when test="${statusLower eq 'completed' or statusLower eq 'delivered' or statusLower eq 'hoàn tất' or statusLower eq 'đã giao'}">
                                        <span class="badge bg-success text-white px-2 py-1">
                                            <i class="fas fa-check me-1"></i>Hoàn tất
                                        </span>
                                    </c:when>
                                    <c:when test="${statusLower eq 'cancelled' or statusLower eq 'failed' or statusLower eq 'đã hủy'}">
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
                                       rel="noopener noreferrer"
                                       class="btn btn-sm btn-warning text-dark shadow-sm ms-1" title="Tra cứu hành trình đơn hàng trên GHN">
                                        <i class="fas fa-truck"></i>
                                    </a>
                                </c:if>
                            </td>
                            <td>
                                <jsp:useBean id="now" class="java.util.Date"/>
                                <c:set var="isUnder30Mins" value="false"/>

                                <c:if test="${not empty item.createdAt}">
                                    <c:set var="timeDiff" value="${now.time - item.createdAt.time}" />
                                    <c:set var="isUnder30Mins" value="${timeDiff lt 1800000}" />
                                </c:if>
                                <c:choose>
                                    <c:when test="${(statusLower eq 'pending' or statusLower eq 'confirmed' or statusLower eq 'chờ xác nhận') && isUnder30Mins}">
                                        <button type="button" class="btn btn-sm btn-danger w-100" data-order-code="${item.orderCode}"
                                                onclick="openCancelModal(this.dataset.orderCode)">
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
                                    <c:when test="${statusLower eq 'completed' or statusLower eq 'delivered' or statusLower eq 'hoàn tất' or statusLower eq 'đã giao'}">
                                        <a href="${pageContext.request.contextPath}/productDetail?id=${item.id}#reviewForm" class="btn btn-sm btn-outline-danger w-100">
                                            <i class="fas fa-star me-1"></i>Đánh giá
                                        </a>
                                    </c:when>
                                    <c:when test="${(statusLower eq 'cancelled' or statusLower eq 'failed' or statusLower eq 'đã hủy') && item.paymentMethod eq 'VNPAY' && item.paid}">
                                        <c:choose>
                                            <c:when test="${empty item.refundStatus}">
                                                <button type="button" class="btn btn-sm btn-warning w-100" onclick="openRefundModal('${item.id}')">
                                                    <i class="fas fa-rotate-left me-1"></i>Hoàn tiền
                                                </button>
                                            </c:when>
                                            <c:when test="${item.refundStatus eq 'PENDING_REFUND'}">
                                                <span class="badge bg-warning text-dark d-block py-2 text-center"><i class="fas fa-clock me-1"></i>Chờ duyệt</span>
                                            </c:when>
                                            <c:when test="${item.refundStatus eq 'REFUNDED'}">
                                                <span class="badge bg-success d-block py-2 text-center"><i class="fas fa-check me-1"></i>Đã hoàn tiền</span>
                                            </c:when>
                                            <c:when test="${item.refundStatus eq 'REJECTED'}">
                                                <span class="badge bg-danger d-block py-2 text-center"><i class="fas fa-times me-1"></i>Từ chối</span>
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
<script>
    document.addEventListener("DOMContentLoaded", function () {
        console.log("Order History Loaded - Fixed Tab Click Logic");
        const orderTabsContainer = document.getElementById("orderTabs");

        if (orderTabsContainer) {
            orderTabsContainer.addEventListener("click", function (e) {
                const tabBtn = e.target.closest(".nav-link");

                if (tabBtn) {
                    e.preventDefault();
                    const allTabs = orderTabsContainer.querySelectorAll(".nav-link");
                    allTabs.forEach(btn => btn.classList.remove("active"));
                    tabBtn.classList.add("active");
                    if (typeof filterTableRows === "function") {
                        filterTableRows(tabBtn.dataset.filter);
                    }
                }
            });
        }
        const cancelModalEl = document.getElementById("cancelOrderModal");
        if (cancelModalEl) {
            cancelModalEl.addEventListener("hidden.bs.modal", function () {
                const reasonSelect = document.getElementById("cancelReason");
                const otherWrapper = document.getElementById("otherReasonFieldWrapper");
                const otherInput = document.getElementById("otherReason");

                if (reasonSelect) reasonSelect.selectedIndex = 0;
                if (otherWrapper) otherWrapper.classList.add("d-none");
                if (otherInput) {
                    otherInput.value = "";
                    otherInput.required = false;
                }
            });
        }

        const refundModalEl = document.getElementById("refundModal");
        if (refundModalEl) {
            refundModalEl.addEventListener("hidden.bs.modal", function () {
                const textarea = this.querySelector("textarea");
                if (textarea) textarea.value = "";
            });
        }
    });
    function filterTableRows(filterValue) {
        const rows = document.querySelectorAll(".order-row");
        const alertEmpty = document.getElementById("emptyFilterAlert");
        const orderArea = document.getElementById("orderArea");

        let hasVisibleRow = false;

        rows.forEach(row => {
            const status = (row.dataset.status || "").trim().toLowerCase();
            const refund = (row.dataset.refund || "").trim();
            let isMatch = false;

            switch (filterValue) {
                case "all":
                    isMatch = true;
                    break;
                case "pending":
                    isMatch = ["pending", "confirmed", "paid", "chờ xác nhận", "chờ xử lý"].includes(status);
                    break;
                case "shipping":
                    isMatch = ["shipping", "đang giao", "đang giao hàng"].includes(status);
                    break;
                case "completed":
                    isMatch = ["completed", "delivered", "hoàn tất", "đã giao", "thành công"].includes(status);
                    break;
                case "cancelled":
                    isMatch = ["cancelled", "failed", "đã hủy", "hủy"].includes(status);
                    break;
                case "refund":
                    isMatch = (refund === "has-refund");
                    break;
            }

            if (isMatch) {
                row.classList.remove("d-none");
                hasVisibleRow = true;
            } else {
                row.classList.add("d-none");
            }
        });

        // Xử lý bật/tắt thông báo trống
        if (alertEmpty && orderArea) {
            if (hasVisibleRow) {
                alertEmpty.classList.add("d-none");
                orderArea.classList.remove("d-none");
            } else {
                alertEmpty.classList.remove("d-none");
                orderArea.classList.add("d-none");
            }
        }
    }
    function openCancelModal(orderCode) {
        const cancelInput = document.getElementById("cancelOrderCode");
        const displayCode = document.getElementById("displayOrderCode");

        if (cancelInput) cancelInput.value = orderCode;
        if (displayCode) displayCode.innerText = orderCode;

        const modalEl = document.getElementById("cancelOrderModal");
        if (modalEl) {
            const modal = new bootstrap.Modal(modalEl);
            modal.show();
        }
    }

    function openRefundModal(orderId) {
        const refundInput = document.getElementById("refundOrderId");
        if (refundInput) refundInput.value = orderId;

        const modalEl = document.getElementById("refundModal");
        if (modalEl) {
            const modal = new bootstrap.Modal(modalEl);
            modal.show();
        }
    }

    function toggleOtherReasonField() {
        const reason = document.getElementById("cancelReason");
        const wrapper = document.getElementById("otherReasonFieldWrapper");
        const other = document.getElementById("otherReason");

        if (reason && wrapper && other) {
            if (reason.value === "Khác") {
                wrapper.classList.remove("d-none");
                other.required = true;
            } else {
                wrapper.classList.add("d-none");
                other.required = false;
                other.value = "";
            }
        }
    }
</script>