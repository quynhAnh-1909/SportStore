<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="root" value="${pageContext.request.contextPath}"/>

<link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">

<div class="container-fluid pt-4 px-4">
    <div class="bg-light rounded p-4 shadow-sm">

        <div class="d-flex align-items-center justify-content-between mb-4">
            <h4 class="mb-0 text-success fw-bold">
                <i class="fas fa-box me-2"></i> Quản lý kho hàng
            </h4>
            <a href="${root}/admin/products?action=create" class="btn btn-success rounded-pill px-4 shadow-sm">
                <i class="fas fa-plus me-1"></i> Thêm sản phẩm
            </a>
        </div>

        <div class="row mb-3 gx-2 align-items-center">
            <div class="col-md-4" id="searchContainer"></div>
            <div class="col-md-4">
                <select id="categoryFilter" class="form-select">
                    <option value="">-- Tất cả danh mục --</option>
                    <c:forEach var="c" items="${categories}">
                        <option value="${c.name.replaceAll('[|\\-+ ]', '').trim()}">${c.name}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-4">
                <select id="stockFilter" class="form-select">
                    <option value="">-- Trạng thái kho --</option>
                    <option value="Còn hàng">✅ Còn hàng</option>
                    <option value="Hết hàng">❌ Hết hàng</option>
                </select>
            </div>
        </div>

        <div class="table-responsive">
            <table id="productTable" class="table table-bordered table-hover align-middle text-center mb-0">
                <thead class="table-dark">
                <tr>
                    <th style="width: 80px;">Ảnh</th>
                    <th class="text-start">Tên sản phẩm</th>
                    <th>Giá</th>
                    <th>Tồn kho</th>
                    <th>Mã Giảm</th>
                    <th>Danh mục</th>
                    <th style="width: 140px;">Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="item" items="${products}">
                    <tr class="${item.stockQuantity <= 0 ? 'table-danger' : ''}">
                        <td>
                            <c:choose>
                                <c:when test="${not empty item.imageUrl}">
                                    <img src="${root}/resources/${item.imageUrl}" class="rounded shadow-sm" style="width:60px;height:60px;object-fit:cover;">
                                </c:when>
                                <c:otherwise>
                                    <img src="${root}/resources/no-image.png" class="rounded" style="width:60px;height:60px;object-fit:cover;">
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="text-start fw-bold ps-3">${item.name}</td>
                        <td class="text-danger fw-bold">
                            <fmt:formatNumber value="${item.price}" groupingUsed="true"/> ₫
                        </td>
                        <td data-search="${item.stockQuantity <= 0 ? 'Hết hàng' : 'Còn hàng'}">
                            <c:choose>
                                <c:when test="${item.stockQuantity <= 0}">
                                    <span class="badge bg-dark">Hết hàng</span>
                                </c:when>
                                <c:when test="${item.stockQuantity < 10}">
                                    <span class="badge bg-warning text-dark">${item.stockQuantity}</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-success">${item.stockQuantity}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty item.vouchers}">
                                    <c:forEach var="v" items="${item.vouchers}">
                                        <span class="badge bg-warning text-dark me-1">${v.code}</span>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-muted">Không có</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td data-search="${item.categoryName.trim()}">
                            <span class="badge bg-info text-dark px-3">${item.categoryName}</span>
                        </td>
                        <td>
                            <div class="btn-group">
                                <a href="${root}/admin/products?action=edit&id=${item.id}" class="btn btn-sm btn-outline-primary">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <a href="${root}/admin/products?action=detail&id=${item.id}" class="btn btn-sm btn-outline-info">
                                    <i class="fas fa-eye"></i>
                                </a>
                                <a href="${root}/admin/products?action=delete&id=${item.id}" class="btn btn-sm btn-outline-danger" onclick="return confirmDelete(event, this.href)">
                                    <i class="fas fa-trash"></i>
                                </a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

        <c:if test="${empty products}">
            <div class="text-center mt-4 p-5 border rounded">
                <i class="fas fa-box-open fa-3x text-muted mb-3"></i>
                <p class="text-muted">Chưa có sản phẩm nào trong hệ thống</p>
            </div>
        </c:if>
    </div>
</div>

<style>
    table tbody tr:hover { background-color: rgba(0, 123, 255, 0.05); }
    td, th { vertical-align: middle !important; }
    td img { border: 1px solid #dee2e6; }
    .table-danger { background-color: #f8d7da !important; }
    .dataTables_wrapper .dataTables_filter { float: left !important; text-align: left !important; width: 100%; }
    .dataTables_wrapper .dataTables_filter label { width: 100%; display: flex; align-items: center; gap: 10px; }
    .dataTables_wrapper .dataTables_filter input {
        width: 100% !important; margin-left: 0 !important; display: inline-block;
        height: 38px; border-radius: 6px; border: 1px solid #ced4da; padding: 0.375rem 0.75rem;
    }
    .dataTables_wrapper .dataTables_paginate .paginate_button { padding: 0px !important; margin: 2px !important; }
</style>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const table = $('#productTable').DataTable({
            "pageLength": 10,
            "lengthChange": false,
            "ordering": false,
            "info": true,
            "dom": '<"row"<"col-12"f>>t<"d-flex justify-content-between align-items-center mt-3"ip>',
            "language": {
                "search": "",
                "searchPlaceholder": "🔍 Tìm tên sản phẩm...",
                "info": "Hiển thị dòng _START_ đến _END_ trên tổng số _TOTAL_ sản phẩm",
                "paginate": {
                    "next": '<i class="fas fa-chevron-right"></i>',
                    "previous": '<i class="fas fa-chevron-left"></i>'
                },
                "zeroRecords": "Không tìm thấy dữ liệu khớp"
            }
        });

        const filterInput = $('.dataTables_filter input').detach();
        filterInput.appendTo('#searchContainer');
        $('.dataTables_filter').remove();

        $('#categoryFilter').on('change', function() {
            const val = $.fn.dataTable.util.escapeRegex($(this).val());
            table.column(5).search(val ? '^' + val + '$' : '', true, false).draw();
        });

        $('#stockFilter').on('change', function() {
            const val = $(this).val();
            table.column(3).search(val).draw();
        });

        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('msg') === 'success') {
            Swal.fire({
                icon: 'success',
                title: 'Thành công!',
                text: 'Dữ liệu sản phẩm đã được cập nhật ổn định.',
                timer: 2000,
                showConfirmButton: false
            });
            window.history.replaceState({}, document.title, window.location.pathname);
        }
    });

    function confirmDelete(event, url) {
        event.preventDefault();
        Swal.fire({
            title: 'Bạn chắc chắn chứ?',
            text: 'Sản phẩm này sẽ bị xóa vĩnh viễn khỏi hệ thống kho!',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#dc3545',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Đồng ý xóa',
            cancelButtonText: 'Hủy bỏ'
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = url;
            }
        });
        return false;
    }
</script>