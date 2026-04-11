<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="root" value="${pageContext.request.contextPath}"/>

<div class="container-fluid pt-4 px-4">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold text-gray-800 mb-0">Hồ sơ Khách hàng</h3>
        <a href="${root}/admin/customers" class="btn btn-outline-secondary">
            <i class="bi bi-arrow-left-short"></i> Quay lại danh sách
        </a>
    </div>

    <div class="row g-4">

        <div class="col-sm-12 col-xl-4">
            <div class="row g-4 h-100">

                <div class="col-12">
                    <div class="bg-white rounded-lg p-4 shadow-sm h-100 text-center border-top-primary">
                        <img class="rounded-circle mb-3 shadow"
                             src="https://ui-avatars.com/api/?name=${customer.fullName}&background=random&color=fff&size=128"
                             style="width: 100px; height: 100px; border: 3px solid #fff; box-shadow: 0 0 10px rgba(0,0,0,0.1);">
                        <h5 class="fw-bold mb-1">${customer.fullName}</h5>
                        <p class="text-muted small mb-3">ID: #${customer.userId}</p>

                        <div class="mb-3">
                            <c:choose>
                                <c:when test="${customerRank == 'Khách VIP 👑'}">
                                    <span class="badge bg-warning text-dark px-3 py-2 rounded-pill fw-bold">👑 VIP</span>
                                </c:when>
                                <c:when test="${customerRank == 'Khách Thân Thiết 🌟'}">
                                    <span class="badge bg-success px-3 py-2 rounded-pill fw-bold">🌟 THÂN THIẾT</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-info text-dark px-3 py-2 rounded-pill fw-bold">🆕 MỚI</span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <c:if test="${customer.status}">
                            <span class="badge bg-light text-success border border-success px-2 py-1"><i class="bi bi-check-circle-fill"></i> Hoạt động</span>
                        </c:if>
                        <c:if test="${!customer.status}">
                            <span class="badge bg-light text-danger border border-danger px-2 py-1"><i class="bi bi-x-circle-fill"></i> Đã khóa</span>
                        </c:if>
                    </div>
                </div>

                <div class="col-12">
                    <div class="bg-white rounded-lg p-4 shadow-sm border-left-primary h-100">
                        <h6 class="fw-bold text-gray-800 mb-4 pb-2 border-bottom">Thông tin Liên hệ</h6>

                        <div class="d-flex align-items-center mb-3">
                            <div class="icon-shape rounded-circle bg-light text-primary me-3">
                                <i class="bi bi-envelope"></i>
                            </div>
                            <div>
                                <small class="text-muted d-block mb-0">Email</small>
                                <span class="fw-bold">${customer.email}</span>
                            </div>
                        </div>

                        <div class="d-flex align-items-center mb-3">
                            <div class="icon-shape rounded-circle bg-light text-primary me-3">
                                <i class="bi bi-telephone"></i>
                            </div>
                            <div>
                                <small class="text-muted d-block mb-0">Số điện thoại</small>
                                <span class="fw-bold">${customer.phoneNumber}</span>
                            </div>
                        </div>

                        <div class="d-flex align-items-start mb-0">
                            <div class="icon-shape rounded-circle bg-light text-primary me-3">
                                <i class="bi bi-geo-alt"></i>
                            </div>
                            <div>
                                <small class="text-muted d-block mb-0">Địa chỉ</small>
                                <span class="fw-bold">${not empty customer.address ? customer.address : '<span class="text-muted">Chưa cập nhật</span>'}</span>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <div class="col-sm-12 col-xl-8">
            <div class="row g-4">

                <div class="col-md-6 col-lg-4">
                    <div class="card card-stat bg-white shadow-sm border-0 h-100 p-3">
                        <div class="card-body d-flex align-items-center justify-content-between p-0">
                            <div>
                                <h2 class="fw-bold text-primary mb-1">${totalOrders}</h2>
                                <p class="text-muted mb-0 small uppercase fw-bold">Tổng đơn hoàn thành</p>
                            </div>
                            <div class="icon-stat rounded bg-primary-light text-primary">
                                <i class="bi bi-cart-check"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-6 col-lg-4">
                    <div class="card card-stat bg-white shadow-sm border-0 h-100 p-3">
                        <div class="card-body d-flex align-items-center justify-content-between p-0">
                            <div>
                                <h2 class="fw-bold text-success mb-1">
                                    <fmt:formatNumber value="${totalSpent}"/>
                                    <small class="fs-6 fw-normal">₫</small>
                                </h2>
                                <p class="text-muted mb-0 small uppercase fw-bold">Tổng chi tiêu</p>
                            </div>
                            <div class="icon-stat rounded bg-success-light text-success">
                                <i class="bi bi-cash-stack"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-12 col-lg-4">
                    <div class="card card-stat bg-white shadow-sm border-0 h-100 p-3">
                        <div class="card-body d-flex align-items-center justify-content-between p-0">
                            <div>
                                <h5 class="fw-bold text-info mb-1">
                                    <c:choose>
                                        <c:when test="${not empty orderHistory}">
                                            <fmt:formatDate value="${orderHistory[0].createdAt}" pattern="dd/MM/yyyy"/>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted fw-normal fs-6">Chưa có đơn</span>
                                        </c:otherwise>
                                    </c:choose>
                                </h5>
                                <p class="text-muted mb-0 small uppercase fw-bold">Đơn gần nhất</p>
                            </div>
                            <div class="icon-stat rounded bg-info-light text-info">
                                <i class="bi bi-clock-history"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-12">
                    <div class="bg-white rounded-lg p-4 shadow-sm border-top-success h-100">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h6 class="fw-bold text-gray-800 mb-0">🕒 Lịch sử mua hàng gần đây (10 đơn mới nhất)</h6>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-hover table-striped table-bordered text-center align-middle mb-0">
                                <thead class="table-dark">
                                <tr>
                                    <th class="small uppercase">Mã Đơn</th>
                                    <th class="small uppercase">Ngày đặt</th>
                                    <th class="small uppercase">Tổng tiền</th>
                                    <th class="small uppercase">Thanh toán</th>
                                    <th class="small uppercase">Trạng thái</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="order" items="${orderHistory}">
                                    <tr>
                                        <td class="fw-bold text-primary">${order.orderCode}</td>
                                        <td><fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                                        <td class="fw-bold"><fmt:formatNumber value="${order.totalPrice}"/> ₫</td>
                                        <td>
                                            <span class="badge bg-light text-dark border">${order.paymentMethod}</span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${order.status == 'COMPLETED'}">
                                                    <span class="badge bg-success px-2 py-1"><i class="bi bi-check2-circle"></i> Hoàn thành</span>
                                                </c:when>
                                                <c:when test="${order.status == 'PENDING'}">
                                                    <span class="badge bg-warning text-dark px-2 py-1"><i class="bi bi-hourglass-split"></i> Chờ xử lý</span>
                                                </c:when>
                                                <c:when test="${order.status == 'CANCELLED'}">
                                                    <span class="badge bg-danger px-2 py-1"><i class="bi bi-x-circle"></i> Đã hủy</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary px-2 py-1">${order.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>

                                <c:if test="${empty orderHistory}">
                                    <tr>
                                        <td colspan="5" class="text-center py-5 text-muted">
                                            <i class="bi bi-basket3 fs-1 d-block mb-3"></i>
                                            Khách hàng này chưa thực hiện đơn hàng nào trên hệ thống.
                                        </td>
                                    </tr>
                                </c:if>
                                </tbody>
                            </table>
                        </div>

                    </div>
                </div>

            </div>
        </div>

    </div>
</div>

<style>

    .text-gray-800 { color: #5a5c69; }
    .bg-white { background-color: #ffffff !important; }
    .shadow-sm { box-shadow: 0 .125rem .25rem 0 rgba(58,59,69,.05) !important; }
    .shadow { box-shadow: 0 .15rem 1.75rem 0 rgba(58,59,69,.1) !important; }
    .rounded-lg { border-radius: 0.35rem !important; }
    .small { font-size: 80%; }
    .uppercase { text-transform: uppercase; }


    .border-top-primary { border-top: 4px solid #4e73df !important; }
    .border-left-primary { border-left: 4px solid #4e73df !important; }
    .border-top-success { border-top: 4px solid #1cc88a !important; }

    /* Icon Liên hệ */
    .icon-shape {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        text-align: center;
        vertical-align: middle;
        width: 40px;
        height: 40px;
    }

    /* Card Thống kê & Icon */
    .card-stat {
        transition: transform 0.2s ease-in-out;
    }
    .card-stat:hover {
        transform: translateY(-3px);
    }
    .icon-stat {
        display: flex;
        align-items: center;
        justify-content: center;
        width: 50px;
        height: 50px;
        font-size: 1.5rem;
    }

    /* Màu nền nhẹ (Light) */
    .bg-primary-light { background-color: #e4eaff; }
    .bg-success-light { background-color: #ddf7ed; }
    .bg-info-light { background-color: #d9f2f9; }

    /* Cải thiện Table */
    .table-responsive {
        border-radius: 0.35rem;
        overflow: hidden;
    }
    .table > :not(caption) > * > * {
        padding: 0.75rem 1rem;
    }
    .table-hover tbody tr:hover {
        background-color: #f8f9fc !important;
    }
    .table-striped tbody tr:nth-of-type(odd) {
        background-color: #fbfbfb;
    }
</style>