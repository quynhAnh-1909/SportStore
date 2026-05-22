<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="root" value="${pageContext.request.contextPath}"/>

<div class="container-fluid pt-4 px-4">

    <div class="bg-white rounded p-4 shadow">

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h4 class="text-primary fw-bold">
                👥 Quản lý Khách hàng
            </h4>

            <a href="${root}/admin/customers?action=create"
               class="btn btn-primary">
                ➕ Thêm khách hàng
            </a>
        </div>

        <div class="mb-3">
            <input type="text" id="searchInput"
                   class="form-control"
                   placeholder="🔍 Tìm kiếm tên, email, số điện thoại...">
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ⚠️ ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <div class="table-responsive">
            <table class="table table-bordered table-hover text-center align-middle">

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
</style>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
    document.addEventListener("DOMContentLoaded", function() {

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
