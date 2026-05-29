<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="root" value="${pageContext.request.contextPath}"/>

<link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">

<div class="container-fluid pt-4 px-4">
    <div class="bg-light text-center rounded p-4 shadow-sm">

        <div class="d-flex align-items-center justify-content-between mb-4">
            <h4 class="mb-0 text-success fw-bold">Danh mục sản phẩm</h4>
            <a href="${root}/admin/categories?action=create" class="btn btn-success rounded-pill px-4 shadow-sm">
                <i class="fas fa-plus-circle me-1"></i> Thêm danh mục mới
            </a>
        </div>

        <div class="table-responsive">
            <table id="categoryTable" class="table text-start align-middle table-bordered table-hover mb-0">
                <thead class="table-dark">
                <tr>
                    <th class="text-center" style="width: 50px;">#</th>
                    <th>Tên danh mục</th>
                    <th>Mô tả</th>
                    <th class="text-center" style="width: 250px;">Thao tác</th>
                </tr>
                </thead>

                <tbody>
                <c:set var="stt" value="1"/>
                <c:forEach var="parent" items="${categories}">
                    <tr class="table-secondary">
                        <td class="text-center fw-bold">${stt}</td>
                        <td class="fw-bold text-primary">📁 ${parent.name}</td>
                        <td class="text-muted">Danh mục cha</td>
                        <td class="text-center">
                            <div class="btn-group">
                                <a href="${root}/admin/categories?action=edit&id=${parent.id}" class="btn btn-sm btn-outline-primary">Sửa</a>
                                <a href="${root}/admin/categories?action=delete&id=${parent.id}" class="btn btn-sm btn-outline-danger">Xóa</a>
                            </div>
                        </td>
                    </tr>

                    <c:forEach var="child" items="${parent.children}">
                        <tr>
                            <td class="text-center">${stt}</td>
                            <td class="ps-4">├ ${child.name}</td>
                            <td class="text-muted">Danh mục con</td>
                            <td class="text-center">
                                <div class="btn-group">
                                    <a href="${root}/admin/categories?action=edit&id=${child.id}" class="btn btn-sm btn-outline-primary">Sửa</a>
                                    <a href="${root}/admin/categories?action=delete&id=${child.id}" class="btn btn-sm btn-outline-danger">Xóa</a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:set var="stt" value="${stt + 1}"/>
                </c:forEach>
                </tbody>
            </table>
        </div>

        <c:if test="${empty categories}">
            <div class="text-center mt-4 p-5 border rounded">
                <i class="fas fa-folder-open fa-3x text-muted mb-3"></i>
                <p class="text-muted">Chưa có danh mục nào được tạo.</p>
            </div>
        </c:if>
    </div>
</div>

<style>
    .dataTables_wrapper .dataTables_filter {
        float: left !important;
        text-align: left !important;
        margin-bottom: 15px;
    }
    .dataTables_wrapper .dataTables_filter input {
        width: 250px !important;
        height: 38px;
        border-radius: 6px;
        border: 1px solid #ced4da;
        padding: 0.375rem 0.75rem;
    }
    .dataTables_wrapper .dataTables_paginate .paginate_button {
        padding: 0px !important;
        margin: 2px !important;
    }
    .dataTables_wrapper .dataTables_info {
        font-size: 14px;
        color: #6c757d;
    }
</style>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        $('#categoryTable').DataTable({
            "pageLength": 10,
            "lengthChange": false,
            "ordering": false,
            "info": true,
            "dom": '<"d-flex justify-content-between align-items-center mb-3"f>t<"d-flex justify-content-between align-items-center mt-3"ip>',
            "language": {
                "search": "",
                "searchPlaceholder": "🔍 Tìm nhanh danh mục...",
                "info": "Hiển thị dòng _START_ đến _END_ trên tổng số _TOTAL_ dòng dữ liệu",
                "paginate": {
                    "next": '<i class="fas fa-chevron-right"></i>',
                    "previous": '<i class="fas fa-chevron-left"></i>'
                },
                "zeroRecords": "Không tìm thấy dữ liệu khớp"
            }
        });
    });
</script>