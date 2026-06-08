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

        /* CSS cho hệ thống Tab mượt mà */
        .nav-tabs .nav-link { color: #495057; font-weight: 500; border: none; cursor: pointer; }
        .nav-tabs .nav-link.active {
            color: #d81f19 !important;
            border-bottom: 3px solid #d81f19 !important;
            background: none;
        }

        /* CSS Custom cho phân trang */
        .pagination .page-item.active .page-link {
            background-color: #d81f19 !important;
            border-color: #d81f19 !important;
            color: #ffffff !important;
        }
        .pagination .page-link {
            color: #495057;
        }
        .pagination .page-link:hover {
            color: #d81f19;
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

    <%-- Thông báo hệ thống --%>
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

    <%-- Thanh chia Tab --%>
    <ul class="nav nav-tabs mb-4 bg-white rounded shadow-sm p-2" id="orderTabs" role="tablist">
        <li class="nav-item">
            <button class="nav-link active" data-filter="all">Tất cả</button>
        </li>
        <li class="nav-item">
            <button class="nav-link" data-filter="pending">Chờ xử lý</button>
        </li>
        <li class="nav-item">
            <button class="nav-link" data-filter="shipping">Đang giao</button>
        </li>
        <li class="nav-item">
            <button class="nav-link" data-filter="completed">Hoàn tất</button>
        </li>
        <li class="nav-item">
            <button class="nav-link" data-filter="cancelled">Đã hủy</button>
        </li>
        <li class="nav-item">
            <button class="nav-link" data-filter="refund">Trả hàng/Hoàn tiền</button>
        </li>
    </ul>

    <%-- Xử lý hiển thị vùng dữ liệu bảng --%>
    <c:choose>
        <c:when test="${empty orders}">
            <div class="alert alert-info shadow-sm border-0 py-4">
                <i class="fas fa-info-circle me-2 fs-5"></i> Bạn chưa có đơn hàng nào.
                <a href="${pageContext.request.contextPath}/" class="fw-bold text-info text-decoration-none ms-1">Mua sắm ngay tại đây!</a>
            </div>
        </c:when>
        <c:otherwise>
            <%-- Khung thông báo rỗng khi bộ lọc JS không tìm thấy hàng nào tương thích --%>
            <div id="emptyFilterAlert" class="alert alert-info shadow-sm border-0 py-4 d-none">
                <i class="fas fa-info-circle me-2 fs-5"></i> Không có đơn hàng nào thuộc trạng thái này.
            </div>

            <div id="orderArea" class="table-responsive shadow-sm rounded mb-4">
                <table class="table table-hover align-middle bg-white mb-0" id="orderTable">
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

            <%-- Thanh điều hướng phân trang --%>
            <nav aria-label="Order pagination" id="paginationWrapper">
                <ul class="pagination justify-content-center" id="paginationNav">
                </ul>
            </nav>
        </c:otherwise>
    </c:choose>
</div>

<%-- Các Modal giữ nguyên không thay đổi --%>
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
    document.addEventListener("DOMContentLoaded", function () {
        const tabButtons = document.querySelectorAll("#orderTabs .nav-link");
        const orderRows = document.querySelectorAll(".order-row");
        const orderArea = document.getElementById("orderArea");
        const emptyAlert = document.getElementById("emptyFilterAlert");
        const paginationNav = document.getElementById("paginationNav");
        const paginationWrapper = document.getElementById("paginationWrapper");

        const rowsPerPage = 10;
        let currentPage = 1;
        let filteredRows = [];

        function displayPage(page) {
            currentPage = page;
            const startIndex = (currentPage - 1) * rowsPerPage;
            const endIndex = startIndex + rowsPerPage;

            orderRows.forEach(row => row.style.display = "none");

            filteredRows.forEach((row, index) => {
                if (index >= startIndex && index < endIndex) {
                    row.style.display = "";
                }
            });

            const pageItems = paginationNav.querySelectorAll(".page-number");
            pageItems.forEach(item => {
                if (parseInt(item.getAttribute("data-page")) === currentPage) {
                    item.classList.add("active");
                } else {
                    item.classList.remove("active");
                }
            });

            // Lấy tổng số trang thực tế hoặc tối thiểu là 3 trang giả lập mẫu
            const totalPages = Math.max(3, Math.ceil(filteredRows.length / rowsPerPage));
            const prevBtn = document.getElementById("prevPageItem");
            const nextBtn = document.getElementById("nextPageItem");

            if (prevBtn) {
                if (currentPage === 1) prevBtn.classList.add("disabled");
                else prevBtn.classList.remove("disabled");
            }
            if (nextBtn) {
                if (currentPage === totalPages) nextBtn.classList.add("disabled");
                else nextBtn.classList.remove("disabled");
            }
        }

        // --- HÀM ĐÃ ĐƯỢC FIX ĐỂ LUÔN HIỆN NÚT 1, 2, 3 ---
        function setupPagination() {
            paginationNav.innerHTML = "";

            // Tính số trang dựa trên dữ liệu, nhưng ép buộc tối thiểu là 3 trang để luôn hiện nút 1, 2, 3
            const totalPages = Math.max(3, Math.ceil(filteredRows.length / rowsPerPage));

            if(paginationWrapper) paginationWrapper.classList.remove("d-none");

            // Nút "Trước"
            const prevLi = document.createElement("li");
            prevLi.className = "page-item";
            prevLi.id = "prevPageItem";
            prevLi.innerHTML = `<a class="page-link" href="javascript:void(0)"><i class="fas fa-chevron-left"></i></a>`;
            prevLi.addEventListener("click", function() {
                if (currentPage > 1) displayPage(currentPage - 1);
            });
            paginationNav.appendChild(prevLi);

            // Luôn lặp để tạo ít nhất 3 nút (1, 2, 3)
            for (let i = 1; i <= totalPages; i++) {
                const li = document.createElement("li");
                li.className = "page-item page-number";
                li.setAttribute("data-page", i);
                li.innerHTML = `<a class="page-link" href="javascript:void(0)">${i}</a>`;
                li.addEventListener("click", function () {
                    displayPage(i);
                });
                paginationNav.appendChild(li);
            }

            // Nút "Sau"
            const nextLi = document.createElement("li");
            nextLi.className = "page-item";
            nextLi.id = "nextPageItem";
            nextLi.innerHTML = `<a class="page-link" href="javascript:void(0)"><i class="fas fa-chevron-right"></i></a>`;
            nextLi.addEventListener("click", function() {
                if (currentPage < totalPages) displayPage(currentPage + 1);
            });
            paginationNav.appendChild(nextLi);
        }

        function filterOrders(filterValue) {
            filteredRows = [];

            orderRows.forEach(row => {
                const status = row.getAttribute("data-status");
                const refund = row.getAttribute("data-refund");
                let isMatch = false;

                if (filterValue === "all") {
                    isMatch = true;
                } else if (filterValue === "pending") {
                    isMatch = (status === "pending" || status === "chờ xác nhận" || status === "confirmed" || status === "0");
                } else if (filterValue === "shipping") {
                    isMatch = (status === "shipping" || status === "đang giao");
                } else if (filterValue === "completed") {
                    isMatch = (status === "completed" || status === "hoàn tất" || status === "delivered" || status === "đã giao");
                } else if (filterValue === "cancelled") {
                    isMatch = (status === "cancelled" || status === "đã hủy");
                } else if (filterValue === "refund") {
                    isMatch = (refund === "has-refund");
                }

                if (isMatch) {
                    filteredRows.push(row);
                } else {
                    row.style.display = "none";
                }
            });

            // Khi ép phân trang mẫu, bảng vẫn hiển thị và thanh điều hướng luôn mở ra
            if (filteredRows.length === 0) {
                if(orderArea) orderArea.classList.add("d-none");
                if(emptyAlert) emptyAlert.classList.remove("d-none");
                // Giữ lại thanh điều hướng mẫu cho đẹp giao diện
                setupPagination();
                const pageItems = paginationNav.querySelectorAll(".page-number");
                pageItems.forEach(item => {
                    if (parseInt(item.getAttribute("data-page")) === 1) item.classList.add("active");
                });
            } else {
                if(orderArea) orderArea.classList.remove("d-none");
                if(emptyAlert) emptyAlert.classList.add("d-none");
                setupPagination();
                displayPage(1);
            }
        }

        tabButtons.forEach(button => {
            button.addEventListener("click", function () {
                tabButtons.forEach(btn => btn.classList.remove("active"));
                this.classList.add("active");

                const filterValue = this.getAttribute("data-filter");
                filterOrders(filterValue);
            });
        });

        filterOrders("all");
    });

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