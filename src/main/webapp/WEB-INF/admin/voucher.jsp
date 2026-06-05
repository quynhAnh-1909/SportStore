<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="root" value="${pageContext.request.contextPath}"/>

<link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">

<div class="container-fluid pt-4 px-4">

    <div class="voucher-wrapper">

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

        <div class="table-responsive">

            <table id="voucherTable" class="table voucher-table align-middle">

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

                        <td>
                            <div class="voucher-code">
                                    ${v.code}
                            </div>
                        </td>

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

        <c:if test="${empty vouchers}">
            <div class="empty-box">
                <h5>📭 Chưa có voucher</h5>
            </div>
        </c:if>

    </div>

</div>

<style>

    body{
        background:#f4f6f9;
    }

    .voucher-wrapper{
        background:#fff;
        border-radius:18px;
        padding:22px;
        border:1px solid #e5e7eb;
        box-shadow:0 3px 15px rgba(0,0,0,0.05);
    }

    .voucher-header{
        display:flex;
        justify-content:space-between;
        align-items:center;
        gap:15px;
        flex-wrap:wrap;
        margin-bottom:20px;
    }

    .title{
        font-size:28px;
        font-weight:800;
        color:#dc3545;
        margin:0;
    }

    .subtitle{
        margin-top:4px;
        font-size:14px;
        color:#6b7280;
    }

    .btn-add{
        background:#dc3545;
        color:white;
        text-decoration:none;
        padding:10px 18px;
        border-radius:12px;
        font-weight:600;
        transition:0.25s;
        white-space:nowrap;
    }

    .btn-add:hover{
        background:#bb2d3b;
        color:white;
        transform:translateY(-2px);
    }

    .table-responsive{
        width:100%;
        overflow-x:auto;
        border-radius:16px;
    }

    .voucher-table{
        width:100%;
        min-width:1000px;
        border-collapse:separate;
        border-spacing:0;
        overflow:hidden;
        border-radius:16px;
        margin-bottom:0;
        border:1px solid #e5e7eb;
        background:white;
    }

    .voucher-table thead th{
        background:#111827;
        color:white;
        padding:14px 10px;
        font-size:13px;
        font-weight:700;
        text-align:center;
        white-space:nowrap;
        border:none;
    }

    .voucher-table tbody td{
        padding:14px 10px;
        border-top:1px solid #ececec;
        vertical-align:middle;
        font-size:13px;
        color:#111827;
        background:white;
    }

    .voucher-table tbody tr:hover td{
        background:#f9fafb;
    }

    .voucher-table th:nth-child(1),
    .voucher-table td:nth-child(1){
        width:12%;
        text-align:center;
    }

    .voucher-table th:nth-child(2),
    .voucher-table td:nth-child(2){
        width:14%;
        text-align:center;
    }

    .voucher-table th:nth-child(3),
    .voucher-table td:nth-child(3){
        width:28%;
    }

    .voucher-table th:nth-child(4),
    .voucher-table td:nth-child(4){
        width:10%;
        text-align:center;
    }

    .voucher-table th:nth-child(5),
    .voucher-table td:nth-child(5){
        width:20%;
    }

    .voucher-table th:nth-child(6),
    .voucher-table td:nth-child(6){
        width:8%;
        text-align:center;
    }

    .voucher-table th:nth-child(7),
    .voucher-table td:nth-child(7){
        width:8%;
        text-align:center;
    }

    .voucher-code{
        font-size:14px;
        font-weight:700;
        color:#0d6efd;
        word-break:break-word;
    }

    .badge-custom{
        padding:6px 10px;
        border-radius:8px;
        font-size:12px;
        font-weight:600;
    }

    .condition-cell{
        line-height:1.6;
        font-size:13px;
    }

    .condition-cell div{
        margin-bottom:4px;
    }

    .usage-box{
        display:flex;
        align-items:center;
        justify-content:center;
        gap:6px;
        font-weight:700;
    }

    .used{
        background:#fff3cd;
        border:1px solid #ffe69c;
        padding:5px 8px;
        border-radius:8px;
    }

    .quantity{
        background:#0d6efd;
        color:white;
        padding:5px 8px;
        border-radius:8px;
    }

    .date-box{
        display:flex;
        flex-direction:column;
        gap:8px;
    }

    .date-item span{
        display:block;
        margin-bottom:4px;
        font-size:12px;
        font-weight:600;
    }

    .date-item input{
        width:100%;
        height:34px;
        border-radius:8px;
        border:1px solid #d1d5db;
        background:#f9fafb;
        padding:0 10px;
        font-size:12px;
    }

    .status{
        display:inline-block;
        padding:6px 12px;
        border-radius:20px;
        font-size:12px;
        font-weight:700;
    }

    .status.active{
        background:#d1e7dd;
        color:#0f5132;
    }

    .status.inactive{
        background:#e5e7eb;
        color:#374151;
    }

    .action-buttons{
        display:flex;
        justify-content:center;
        gap:6px;
    }

    .btn-action{
        width:34px;
        height:34px;
        border-radius:10px;
        display:flex;
        align-items:center;
        justify-content:center;
        text-decoration:none;
        color:white;
        font-size:14px;
        transition:0.2s;
    }

    .btn-edit{
        background:#0d6efd;
    }

    .btn-delete{
        background:#dc3545;
    }

    .btn-action:hover{
        transform:scale(1.08);
        color:white;
    }

    .voucher-full td{
        border-left:3px solid #dc3545 !important;
    }

    .voucher-disabled td{
        background:#f3f4f6 !important;
        opacity:0.85;
    }

    .empty-box{
        text-align:center;
        padding:40px;
        color:#6b7280;
    }

    .table-responsive::-webkit-scrollbar{
        height:8px;
    }

    .table-responsive::-webkit-scrollbar-thumb{
        background:#c7c7c7;
        border-radius:20px;
    }

    /* Style DataTables tinh chỉnh đồng bộ */
    .dataTables_wrapper .dataTables_filter input {
        height: 40px;
        border-radius: 10px;
        border: 1px solid #d1d5db;
        padding: 0 14px;
        font-size: 14px;
    }
    .dataTables_wrapper .dataTables_filter input:focus {
        border-color: #dc3545;
        outline: none;
    }
    .dataTables_wrapper .dataTables_paginate .paginate_button {
        padding: 0px !important;
        margin: 2px !important;
    }
    .dataTables_wrapper .dataTables_info {
        font-size: 13px;
        color: #6b7280;
    }
</style>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        // Tích hợp DataTables phân trang 10 mục, ép thanh tìm kiếm sang bên trái
        $('#voucherTable').DataTable({
            "pageLength": 10,
            "lengthChange": false,
            "ordering": false,
            "info": true,
            "dom": '<"d-flex justify-content-between align-items-center mb-3"f>t<"d-flex justify-content-between align-items-center mt-3"ip>',
            "language": {
                "search": "🔍 Tìm kiếm nhanh:",
                "searchPlaceholder": "Nhập mã voucher...",
                "info": "Hiển thị dòng _START_ đến _END_ trên tổng số _TOTAL_ voucher",
                "paginate": {
                    "next": '<i class="fas fa-chevron-right"></i>',
                    "previous": '<i class="fas fa-chevron-left"></i>'
                },
                "zeroRecords": "Không tìm thấy dữ liệu khớp"
            }
        });
    });

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