<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="root" value="${pageContext.request.contextPath}"/>

<link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">

<div class="container-fluid pt-4 px-4">
    <div class="bg-white rounded p-4 shadow">

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h4 class="text-primary fw-bold mb-0">
                👥 Quản lý Khách hàng
            </h4>

            <a href="${root}/admin/customers?action=create"
               class="btn btn-primary">
                ➕ Thêm khách hàng
            </a>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ⚠️ ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <div class="table-responsive">
            <table id="customerTable" class="table table-bordered table-hover text-center align-middle mb-0">
                <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Khách hàng</th>
                    <th>Liên hệ</th>
                    <th>Địa chỉ</th>
                    <th>Trạng thái</th>
                    <th>Thao tác</th>
                </tr>
                </thead>

                <tbody>
                <c:forEach var="c" items="${customers}">
                    <tr class="${!c.status ? 'table-secondary' : ''}">
                        <td class="fw-bold text-primary">
                            #${c.userId}
                        </td>

                        <td style="text-align:left">
                            👤 <strong>${c.fullName}</strong>
                        </td>

                        <td style="text-align:left">
                            📧 ${c.email} <br>
                            📞 ${c.phoneNumber}
                        </td>

                        <td>
                            📍 ${not empty c.address ? c.address : '<span class="text-muted">Chưa cập nhật</span>'}
                        </td>

                        <td>
                            <c:if test="${c.status}">
                                <span class="badge bg-success">Hoạt động</span>
                            </c:if>
                            <c:if test="${!c.status}">
                                <span class="badge bg-danger">Đã khóa</span>
                            </c:if>
                        </td>

                        <td>
                            <a href="${root}/admin/customers?action=view&id=${c.userId}"
                               class="btn btn-sm btn-info text-white" title="Xem chi tiết">
                                👁️
                            </a>

                            <a href="${root}/admin/customers?action=edit&id=${c.userId}"
                               class="btn btn-sm btn-primary" title="Sửa">
                                ✏️
                            </a>

                            <c:if test="${c.status}">
                                <a href="${root}/admin/customers?action=delete&id=${c.userId}"
                                   class="btn btn-sm btn-danger btn-delete-customer" title="Khóa">
                                    🔒
                                </a>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

        <c:if test="${empty customers}">
            <div class="text-center mt-4">
                <h5 class="text-muted">Chưa có dữ liệu khách hàng</h5>
            </div>
        </c:if>

    </div>
</div>

<style>
    table tr:hover {
        background-color: #f5f5f5;
    }
    .table-secondary {
        background-color: #e2e3e5 !important;
    }
    .dataTables_wrapper .dataTables_filter {
        float: left !important;
        text-align: left !important;
        margin-bottom: 15px;
    }
    .dataTables_wrapper .dataTables_filter input {
        width: 300px !important;
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
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        $('#customerTable').DataTable({
            "pageLength": 10,
            "lengthChange": false,
            "ordering": false,
            "info": true,
            "dom": '<"d-flex justify-content-between align-items-center mb-3"f>t<"d-flex justify-content-between align-items-center mt-3"ip>',
            "language": {
                "search": "",
                "searchPlaceholder": "🔍 Tìm kiếm tên, email, số điện thoại...",
                "info": "Hiển thị dòng _START_ đến _END_ trên tổng số _TOTAL_ khách hàng",
                "paginate": {
                    "next": '<i class="fas fa-chevron-right"></i>',
                    "previous": '<i class="fas fa-chevron-left"></i>'
                },
                "zeroRecords": "Không tìm thấy dữ liệu khớp"
            }
        });

        const deleteButtons = document.querySelectorAll('.btn-delete-customer');
        deleteButtons.forEach(button => {
            button.addEventListener('click', function(e) {
                e.preventDefault();
                const deleteUrl = this.getAttribute('href');

                Swal.fire({
                    title: 'Khóa tài khoản?',
                    text: "Khách hàng sẽ không thể đăng nhập sau khi bị khóa!",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#dc3545',
                    cancelButtonColor: '#6c757d',
                    confirmButtonText: 'Đồng ý khóa',
                    cancelButtonText: 'Hủy bỏ'
                }).then((result) => {
                    if (result.isConfirmed) {
                        window.location.href = deleteUrl;
                    }
                });
            });
        });
    });
</script>