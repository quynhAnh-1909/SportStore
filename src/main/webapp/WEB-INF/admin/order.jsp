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
                <table class="table table-bordered table-hover align-middle text-center mb-0">
                    <thead class="table-dark">
                    <tr>
                        <th>#</th>
                        <th>Mã đơn</th>
                        <th>Khách hàng</th>
                        <th>Ngày tạo</th>
                        <th>Tổng tiền</th>
                        <th>Thanh toán</th>
                        <th>Trạng thái</th>
                        <th>Ghi chú</th>
                        <th>Hành động</th>
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
                            <td>${order.note}</td>
                            <td>
                                <a href="${root}/admin/orders/details?orderCode=${order.orderCode}" class="btn btn-sm btn-outline-info">
                                    <i class="fas fa-eye"></i> Xem
                                </a>
                            </td>
                        </tr>
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
</style>