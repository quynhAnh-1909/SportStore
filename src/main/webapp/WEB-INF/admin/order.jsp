<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="container-fluid pt-4 px-4">
    <div class="bg-light text-center rounded p-4 shadow-sm">

        <div class="d-flex align-items-center justify-content-between mb-4">
            <h4 class="mb-0 text-success fw-bold">
                <i class="fas fa-box me-2"></i> Quản lý đơn hàng
            </h4>
        </div>

        <c:if test="${empty orders}">
            <div class="text-center mt-4 p-5 border rounded">
                <i class="fas fa-box-open fa-3x text-muted mb-3"></i>
                <p class="text-muted">Chưa có đơn hàng nào.</p>
            </div>
        </c:if>

        <c:if test="${not empty orders}">
            <div class="table-responsive">
                <table class="table compact-table table-bordered table-hover align-middle text-center mb-0">
                    <thead class="table-dark">
                    <tr>
                        <th style="width: 50px;">#</th>
                        <th style="width: 120px;">Mã đơn</th>
                        <th style="width: 150px;">Khách hàng</th>
                        <th style="width: 140px;">Ngày tạo</th>
                        <th style="width: 120px;">Tổng tiền</th>
                        <th style="width: 110px;">Thanh toán</th>
                        <th style="width: 120px;">Trạng thái</th>
                        <th style="width: 150px;">Ghi chú</th>
                        <th style="width: 170px;">Hành động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:set var="stt" value="1"/>
                    <c:forEach var="order" items="${orders}">
                        <tr class="<c:choose>
                                            <c:when test='${order.status eq "PENDING"}'>table-warning</c:when>
                                            <c:when test='${order.status eq "DELIVERED"}'>table-success</c:when>
                                            <c:when test='${order.status eq "CANCELED"}'>table-danger</c:when>
                                       </c:choose>">
                            <td>${stt}</td>
                            <c:set var="stt" value="${stt + 1}"/>

                            <td>${order.orderCode}</td>
                            <td class="fw-semibold text-success">${order.userFullName}</td>
                            <td><fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                            <td class="text-danger fw-bold">
                                <fmt:formatNumber value="${order.totalPrice}" type="currency" currencySymbol="₫"/>
                            </td>
                            <td>${order.paymentMethod}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${order.status eq 'PENDING'}">
                                        <span class="badge bg-warning text-dark">Chờ xử lý</span>
                                    </c:when>
                                    <c:when test="${order.status eq 'DELIVERED'}">
                                        <span class="badge bg-success text-white">Hoàn tất</span>
                                    </c:when>
                                    <c:when test="${order.status eq 'CANCELED'}">
                                        <span class="badge bg-danger text-white">Đã hủy</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary text-white">Không xác định</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-truncate" style="max-width:150px;">
                                    ${order.note}
                            </td>
                            <td>

                                <div class="d-flex flex-column gap-1">

                                    <!-- HÀNG NÚT TRẠNG THÁI -->
                                    <div class="d-flex justify-content-center gap-2 flex-wrap">

                                        <!-- PENDING -->
                                        <c:if test="${order.status eq 'PENDING'}">

                                            <!-- XÁC NHẬN -->
                                            <form action="${root}/admin/orders"
                                                  method="post"
                                                  class="d-inline">

                                                <input type="hidden"
                                                       name="action"
                                                       value="confirm">

                                                <input type="hidden"
                                                       name="id"
                                                       value="${order.id}">

                                                <button class="btn btn-sm btn-success">
                                                    Xác nhận
                                                </button>

                                            </form>

                                            <!-- HỦY -->
                                            <form action="${root}/admin/orders"
                                                  method="post"
                                                  class="d-inline">

                                                <input type="hidden"
                                                       name="action"
                                                       value="cancel">

                                                <input type="hidden"
                                                       name="id"
                                                       value="${order.id}">

                                                <button class="btn btn-sm btn-danger">
                                                    Hủy
                                                </button>

                                            </form>

                                        </c:if>

                                        <!-- CONFIRMED -->
                                        <c:if test="${order.status eq 'CONFIRMED'}">

                                            <form action="${root}/admin/orders"
                                                  method="post"
                                                  class="d-inline">

                                                <input type="hidden"
                                                       name="action"
                                                       value="shipping">

                                                <input type="hidden"
                                                       name="id"
                                                       value="${order.id}">

                                                <button class="btn btn-sm btn-primary">
                                                    Giao ĐVVC
                                                </button>

                                            </form>

                                        </c:if>

                                        <!-- SHIPPING -->
                                        <c:if test="${order.status eq 'SHIPPING'}">

                                            <form action="${root}/admin/orders"
                                                  method="post"
                                                  class="d-inline">

                                                <input type="hidden"
                                                       name="action"
                                                       value="complete">

                                                <input type="hidden"
                                                       name="id"
                                                       value="${order.id}">

                                                <button class="btn btn-sm btn-success">
                                                    Hoàn thành
                                                </button>

                                            </form>

                                        </c:if>

                                    </div>

                                    <!-- XEM CHI TIẾT -->
                                    <div>
                                        <a href="${root}/admin/orders/details?orderCode=${order.orderCode}"
                                           class="btn btn-sm btn-outline-info w-100">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                    </div>

                                </div>

                            </td>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>
    </div>
</div>

<style>
    .table-hover tbody tr:hover {
        background-color: rgba(0,0,0,0.05);
        transition: background 0.3s;
    }
    .compact-table{
        table-layout: fixed;
        font-size: 13px;
    }

    .compact-table th,
    .compact-table td{
        padding: 8px !important;
        vertical-align: middle;
        word-wrap: break-word;
    }

    .compact-table .btn{
        font-size: 12px;
        padding: 4px 8px;
    }

    .compact-table .badge{
        font-size: 11px;
    }
</style>