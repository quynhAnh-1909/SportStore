<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="root" value="${pageContext.request.contextPath}"/>

<div class="container-fluid pt-4 px-4">

    <div class="voucher-wrapper">

        <!-- HEADER -->
        <div class="voucher-header">
            <div>
                <h3 class="title">🎫 Quản lý Voucher</h3>
                <p class="subtitle">Quản lý mã giảm giá dễ dàng hơn</p>
            </div>

            <a href="${root}/admin/vouchers?action=create"
               class="btn btn-add">
                ➕ Thêm voucher
            </a>
        </div>

        <!-- SEARCH -->
        <div class="search-box">
            <input type="text"
                   id="searchInput"
                   class="form-control search-input"
                   placeholder="🔍 Tìm mã voucher...">
        </div>

        <!-- TABLE -->
        <div class="table-responsive">

            <table class="table voucher-table align-middle">

                <thead>
                <tr>
                    <th>Mã</th>
                    <th>Giảm giá</th>
                    <th>Điều kiện</th>
                    <th>Sử dụng</th>
                    <th>Thời gian</th>
                    <th>Trạng thái</th>
                    <th>Thao tác</th>
                </tr>
                </thead>

                <tbody>

                <c:forEach var="v" items="${vouchers}">

                    <tr class="
                        ${v.quantity == v.usedCount ? 'voucher-full' : ''}
                        ${!v.status ? 'voucher-disabled' : ''}
                    ">

                        <!-- CODE -->
                        <td>
                            <div class="voucher-code">
                                    ${v.code}
                            </div>
                        </td>

                        <!-- DISCOUNT -->
                        <td>

                            <c:if test="${v.discountType == 'PERCENT'}">
                                <span class="badge bg-success badge-custom">
                                    ${v.discountValue} %
                                </span>
                            </c:if>

                            <c:if test="${v.discountType == 'FIXED'}">
                                <span class="badge bg-primary badge-custom">
                                    <fmt:formatNumber value="${v.discountValue}"/> ₫
                                </span>
                            </c:if>

                            <div class="mt-2 text-muted small">
                                Max:
                                <fmt:formatNumber value="${v.maxDiscount}"/> ₫
                            </div>

                        </td>

                        <!-- CONDITION -->
                        <td class="condition-cell">

                            <div>
                                🛒 Đơn từ:
                                <strong>
                                    <fmt:formatNumber value="${v.minOrderValue}"/> ₫
                                </strong>
                            </div>

                            <div>
                                🏷 Giá SP:
                                <strong>
                                    <fmt:formatNumber value="${v.minProductPrice}"/> ₫
                                </strong>
                            </div>

                            <div>
                                📂 Danh mục:
                                <strong>
                                    <c:choose>
                                        <c:when test="${v.categoryId == 0}">
                                            Tất cả
                                        </c:when>
                                        <c:otherwise>
                                            ${v.categoryId}
                                        </c:otherwise>
                                    </c:choose>
                                </strong>
                            </div>

                            <div>
                                💳 ${v.paymentMethod}
                            </div>

                        </td>

                        <!-- USAGE -->
                        <td>

                            <div class="usage-box">
                                <span class="used">
                                        ${v.usedCount}
                                </span>

                                <span class="slash">/</span>

                                <span class="quantity">
                                        ${v.quantity}
                                </span>
                            </div>

                        </td>

                        <!-- DATE -->
                        <td>

                            <div class="date-box">

                                <div class="date-item">
                                    <span>🟢 Bắt đầu</span>

                                    <fmt:formatDate value="${v.startDate}"
                                                    pattern="yyyy-MM-dd"
                                                    var="start"/>

                                    <input type="date"
                                           value="${start}"
                                           disabled>
                                </div>

                                <div class="date-item mt-2">
                                    <span>🔴 Kết thúc</span>

                                    <fmt:formatDate value="${v.expiryDate}"
                                                    pattern="yyyy-MM-dd"
                                                    var="end"/>

                                    <input type="date"
                                           value="${end}"
                                           disabled>
                                </div>

                            </div>

                        </td>

                        <!-- STATUS -->
                        <td>

                            <c:if test="${v.status}">
                                <span class="status active">
                                    Hoạt động
                                </span>
                            </c:if>

                            <c:if test="${!v.status}">
                                <span class="status inactive">
                                    Đã tắt
                                </span>
                            </c:if>

                        </td>

                        <!-- ACTION -->
                        <td>

                            <div class="action-buttons">

                                <a href="${root}/admin/vouchers?action=edit&id=${v.id}"
                                   class="btn-action btn-edit">
                                    ✏️
                                </a>

                                <a href="${root}/admin/vouchers?action=delete&id=${v.id}"
                                   class="btn-action btn-delete"
                                   onclick="return confirmDelete(event, this.href, '${v.code}')">
                                    🗑
                                </a>

                            </div>

                        </td>

                    </tr>

                </c:forEach>

                </tbody>

            </table>

        </div>

        <!-- EMPTY -->
        <c:if test="${empty vouchers}">
            <div class="empty-box">
                <h5>📭 Chưa có voucher</h5>
            </div>
        </c:if>

    </div>

</div>

<!-- STYLE -->
<style>

    body {
        background: #f5f7fb;
    }

    .voucher-wrapper {
        background: white;
        border-radius: 18px;
        padding: 24px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        border: 1px solid #dee2e6;
    }

    /* HEADER */

    .voucher-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 24px;
    }

    .title {
        font-weight: 700;
        color: #dc3545;
        margin-bottom: 4px;
    }

    .subtitle {
        color: #777;
        margin: 0;
        font-size: 14px;
    }

    .btn-add {
        background: #dc3545;
        color: white;
        padding: 10px 18px;
        border-radius: 10px;
        text-decoration: none;
        font-weight: 600;
        transition: 0.2s;
        border: 1px solid #dc3545;
    }

    .btn-add:hover {
        background: #bb2d3b;
        color: white;
    }

    /* SEARCH */

    .search-box {
        margin-bottom: 20px;
    }

    .search-input {
        border-radius: 10px;
        padding: 12px;
        border: 1px solid #ced4da;
    }

    /* TABLE */

    .voucher-table {
        width: 100%;
        border-collapse: collapse;
        overflow: hidden;
        border-radius: 14px;
        border: 2px solid #dee2e6;
        background: white;
    }

    /* HEADER TABLE */

    .voucher-table thead th {
        background: #212529;
        color: white;
        padding: 14px 12px;
        font-size: 14px;
        text-align: center;
        border: 1px solid #495057;
        white-space: nowrap;
    }

    /* BODY */

    .voucher-table tbody td {
        padding: 16px 12px;
        border: 1px solid #dee2e6;
        vertical-align: middle;
        background: white;
    }

    .voucher-table tbody tr {
        transition: 0.2s;
    }

    .voucher-table tbody tr:hover td {
        background: #f8f9fa;
    }
    /* MÃ */
    .voucher-table th:nth-child(1),
    .voucher-table td:nth-child(1) {
        width: 10%;
        min-width: 120px;
        text-align: center;
    }

    /* GIẢM GIÁ */
    .voucher-table th:nth-child(2),
    .voucher-table td:nth-child(2) {
        width: 13%;
        min-width: 150px;
        text-align: center;
    }

    /* ĐIỀU KIỆN  */
    .voucher-table th:nth-child(3),
    .voucher-table td:nth-child(3) {
        width: 30%;
        min-width: 320px;
    }

    /* SỬ DỤNG */
    .voucher-table th:nth-child(4),
    .voucher-table td:nth-child(4) {
        width: 10%;
        min-width: 120px;
        text-align: center;
    }

    /* THỜI GIAN */
    .voucher-table th:nth-child(5),
    .voucher-table td:nth-child(5) {
        width: 18%;
        min-width: 220px;
    }

    /* STATUS */
    .voucher-table th:nth-child(6),
    .voucher-table td:nth-child(6) {
        width: 9%;
        min-width: 120px;
        text-align: center;
    }

    /* ACTION */
    .voucher-table th:nth-child(7),
    .voucher-table td:nth-child(7) {
        width: 10%;
        min-width: 120px;
        text-align: center;
    }

    /* CODE */

    .voucher-code {
        font-weight: 700;
        color: #0d6efd;
        font-size: 15px;
        word-break: break-word;
    }

    /* BADGE */

    .badge-custom {
        padding: 8px 12px;
        border-radius: 8px;
        font-size: 13px;
    }

    /* CONDITION */

    .condition-cell {
        line-height: 1.8;
        font-size: 14px;
    }

    .condition-cell div {
        margin-bottom: 4px;
    }

    /* USAGE */

    .usage-box {
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 8px;
        font-weight: 700;
    }

    .used {
        background: #ffc107;
        padding: 6px 10px;
        border-radius: 8px;
        border: 1px solid #e0a800;
    }

    .quantity {
        background: #0d6efd;
        color: white;
        padding: 6px 10px;
        border-radius: 8px;
        border: 1px solid #0a58ca;
    }

    /* DATE */

    .date-box {
        min-width: 180px;
    }

    .date-item span {
        display: block;
        font-size: 13px;
        margin-bottom: 5px;
        font-weight: 600;
    }

    .date-item input {
        width: 100%;
        border: 1px solid #ced4da;
        border-radius: 8px;
        padding: 6px 8px;
        background: #f8f9fa;
        font-size: 13px;
    }

    /* STATUS */

    .status {
        padding: 7px 14px;
        border-radius: 20px;
        font-size: 13px;
        font-weight: 600;
        display: inline-block;
        border: 1px solid transparent;
    }

    .status.active {
        background: #d1e7dd;
        color: #0f5132;
        border-color: #badbcc;
    }

    .status.inactive {
        background: #e2e3e5;
        color: #41464b;
        border-color: #c6c7c8;
    }

    /* ACTION */

    .action-buttons {
        display: flex;
        justify-content: center;
        gap: 8px;
    }

    .btn-action {
        width: 38px;
        height: 38px;
        border-radius: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        text-decoration: none;
        transition: 0.2s;
        font-size: 16px;
        border: 1px solid transparent;
    }

    .btn-edit {
        background: #0d6efd;
        color: white;
        border-color: #0a58ca;
    }

    .btn-delete {
        background: #dc3545;
        color: white;
        border-color: #b02a37;
    }

    .btn-action:hover {
        transform: scale(1.05);
        color: white;
    }

    /* ROW STATE */

    .voucher-full td {
        border-left: 4px solid #dc3545 !important;
    }

    .voucher-disabled td {
        background: #f1f3f5;
        opacity: 0.85;
    }

    /* EMPTY */

    .empty-box {
        text-align: center;
        padding: 40px;
        color: #777;
    }

</style>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<!-- SEARCH -->
<script>

    // SEARCH
    document.getElementById("searchInput")
            .addEventListener("keyup", function () {

                let keyword = this.value.toLowerCase();

                let rows = document.querySelectorAll("tbody tr");

                rows.forEach(row => {

                    let code = row.children[0]
                            .innerText
                            .toLowerCase();

                    row.style.display =
                            code.includes(keyword)
                                    ? ""
                                    : "none";

                });

            });


    // DELETE CONFIRM
    function confirmDelete(event, url, code) {

        event.preventDefault();

        Swal.fire({
            title: 'Bạn chắc chắn?',
            html: `
                Bạn muốn xóa voucher:
                <br><br>

                <b style="color:#dc3545;font-size:18px">
                    ${code}
                </b>

                <br><br>

                Hành động này không thể hoàn tác!
            `,
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#dc3545',
            cancelButtonColor: '#6c757d',
            confirmButtonText: '🗑 Xóa',
            cancelButtonText: 'Hủy'
        }).then((result) => {

            if (result.isConfirmed) {

                Swal.fire({
                    title: 'Đã xóa!',
                    text: 'Voucher đã được xóa thành công.',
                    icon: 'success',
                    timer: 1200,
                    showConfirmButton: false
                });

                setTimeout(() => {
                    window.location.href = url;
                }, 1200);

            }

        });

        return false;
    }

</script>