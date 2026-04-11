<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="root" value="${pageContext.request.contextPath}"/>

<div class="container-fluid pt-4 px-4">

    <div class="row justify-content-center">
        <div class="col-xl-8 col-lg-10">

            <div class="bg-white rounded-lg p-4 shadow border-top-primary">

                <div class="d-flex justify-content-between align-items-center mb-4 pb-3 border-bottom">
                    <div class="d-flex align-items-center">
                        <img class="rounded-circle me-3 shadow-sm"
                             src="https://ui-avatars.com/api/?name=${customer.fullName}&background=random&color=fff&size=50"
                             style="width: 50px; height: 50px;">
                        <div>
                            <h4 class="fw-bold text-gray-800 mb-0">Cập nhật Khách hàng</h4>
                            <small class="text-muted">ID: #${customer.userId}</small>
                        </div>
                    </div>
                    <a href="${root}/admin/customers" class="btn btn-outline-secondary">
                        <i class="bi bi-x-lg"></i> Hủy
                    </a>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                        ⚠️ <strong>Lỗi!</strong> ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <form action="${root}/admin/customers" method="POST">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" value="${customer.userId}">

                    <div class="row g-4">

                        <div class="col-md-6">
                            <label for="fullName" class="form-label fw-bold text-gray-800">👤 Họ và tên <span class="text-danger">*</span></label>
                            <input type="text" class="form-control bg-light" id="fullName" name="fullName"
                                   value="${customer.fullName}" placeholder="Nhập họ và tên..." required>
                        </div>

                        <div class="col-md-6">
                            <label for="phone" class="form-label fw-bold text-gray-800">📞 Số điện thoại</label>
                            <input type="text" class="form-control bg-light" id="phone" name="phone"
                                   value="${customer.phoneNumber}" placeholder="VD: 0912345678">
                        </div>

                        <div class="col-md-12">
                            <label for="email" class="form-label fw-bold text-gray-800">📧 Địa chỉ Email <span class="text-danger">*</span></label>
                            <input type="email" class="form-control bg-light" id="email" name="email"
                                   value="${customer.email}" placeholder="example@gmail.com" required>
                            <div class="form-text text-muted small">Email này được dùng để khách hàng đăng nhập hệ thống.</div>
                        </div>

                        <div class="col-md-12">
                            <label for="address" class="form-label fw-bold text-gray-800">📍 Địa chỉ giao hàng</label>
                            <textarea class="form-control bg-light" id="address" name="address" rows="3"
                                      placeholder="Nhập địa chỉ chi tiết (Số nhà, đường, phường/xã, quận/huyện...)"
                            >${customer.address}</textarea>
                        </div>

                        <div class="col-md-6">
                            <label for="status" class="form-label fw-bold text-gray-800">Trạng thái tài khoản</label>
                            <select class="form-select ${customer.status ? 'border-success' : 'border-danger'} bg-light"
                                    id="status" name="status">
                                <option value="true" class="text-success" ${customer.status ? 'selected' : ''}>
                                    🟢 Đang hoạt động
                                </option>
                                <option value="false" class="text-danger" ${!customer.status ? 'selected' : ''}>
                                    🔴 Khóa tài khoản
                                </option>
                            </select>
                        </div>

                    </div> <hr class="my-4">

                    <div class="d-flex justify-content-end gap-2">
                        <button type="reset" class="btn btn-light border">Khôi phục gốc</button>
                        <button type="submit" class="btn btn-primary px-4 fw-bold">
                            💾 Lưu thay đổi
                        </button>
                    </div>

                </form>

            </div>
        </div>
    </div>
</div>

<style>

    .form-control, .form-select {
        border: 1px solid #d1d3e2;
        border-radius: 0.35rem;
        padding: 0.5rem 0.75rem;
        transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
    }
    .form-control:focus, .form-select:focus {
        background-color: #fff !important;
        border-color: #bac8f3;
        box-shadow: 0 0 0 0.25rem rgba(78, 115, 223, 0.25);
    }
    .bg-light {
        background-color: #f8f9fc !important;
    }
    .border-top-primary {
        border-top: 4px solid #4e73df !important;
    }
    .text-gray-800 {
        color: #5a5c69;
    }
</style>