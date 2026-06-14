<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<style>
    .detail-card{
        border: 1px solid #e9ecef;
        border-radius: 12px;
        overflow: hidden;
        background: #fff;
        transition: .2s;
    }

    .detail-card:hover{
        box-shadow: 0 0.5rem 1rem rgba(0,0,0,.08);
    }

    .detail-header{
        background: #f8f9fa;
        border-bottom: 1px solid #e9ecef;
        padding: 15px 20px;
        font-weight: 600;
    }

    .info-item{
        margin-bottom: 15px;
    }

    .info-label{
        display: block;
        font-size: 13px;
        color: #6c757d;
        margin-bottom: 3px;
    }

    .info-value{
        font-weight: 600;
        color: #212529;
    }

    .summary-box{
        border-radius: 12px;
        padding: 20px;
        color: #fff;
        background: linear-gradient(135deg,#198754,#20c997);
    }

    .product-image{
        width: 70px;
        height: 70px;
        object-fit: cover;
        border-radius: 8px;
        border: 1px solid #dee2e6;
    }

    .status-badge{
        font-size: 13px;
        padding: 8px 14px;
    }

    .table td,
    .table th{
        vertical-align: middle;
    }
</style>

<div class="container-fluid pt-4 px-4">

    <div class="bg-white rounded shadow-sm border p-4">

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h4 class="fw-bold text-success mb-0">
                <i class="fas fa-file-invoice me-2"></i>
                Chi tiết đơn hàng
            </h4>
            <a href="${pageContext.request.contextPath}/admin/orders"
               class="btn btn-outline-secondary">
                <i class="fas fa-arrow-left me-1"></i>
                Quay lại
            </a>
        </div>

        <div class="row">

            <div class="col-lg-7 mb-3">
                <div class="detail-card h-100">
                    <div class="detail-header">
                        <i class="fas fa-user-circle text-success me-2"></i>
                        Thông tin người nhận
                    </div>
                    <div class="p-4">
                        <div class="info-item">
                            <span class="info-label">Mã đơn hàng</span>
                            <div class="info-value">${order.orderCode}</div>
                        </div>

                        <div class="info-item">
                            <span class="info-label">Người nhận</span>
                            <div class="info-value">${order.receiverName}</div>
                        </div>

                        <div class="info-item">
                            <span class="info-label">Số điện thoại</span>
                            <div class="info-value">${order.receiverPhone}</div>
                        </div>

                        <div class="info-item">
                            <span class="info-label">Địa chỉ giao hàng</span>
                            <div class="info-value">${order.address}</div>
                        </div>

                        <div class="info-item mb-0">
                            <span class="info-label">Ghi chú</span>
                            <div class="info-value">
                                ${empty order.note ? 'Không có ghi chú' : order.note}
                            </div>
                        </div>

                        <c:if test="${not empty order.refundReason or not empty order.cancelReason}">
                            <div class="info-item mt-3 p-3 border border-danger-subtle rounded bg-danger-subtle bg-opacity-10">
                                <span class="info-label text-danger fw-bold">
                                    <i class="fas fa-exclamation-circle me-1"></i> Lý do hủy / Hoàn tiền
                                </span>
                                <div class="info-value text-danger fs-6 mt-1">
                                        ${not empty order.refundReason ? order.refundReason : order.cancelReason}
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>

            <div class="col-lg-5 mb-3">
                <div class="summary-box">
                    <small>TỔNG GIÁ TRỊ ĐƠN HÀNG</small>
                    <h3 class="fw-bold mt-2 mb-0">
                        <fmt:formatNumber value="${order.totalPrice}" type="currency" currencySymbol="₫"/>
                    </h3>
                </div>

                <div class="detail-card mt-3">
                    <div class="detail-header">
                        <i class="fas fa-truck text-primary me-2"></i>
                        Trạng thái đơn hàng
                    </div>
                    <div class="p-4">
                        <c:choose>
                            <c:when test="${order.status eq 'PENDING'}">
                                <span class="badge bg-warning text-dark status-badge">Chờ xử lý</span>
                            </c:when>
                            <c:when test="${order.status eq 'CONFIRMED'}">
                                <span class="badge bg-info status-badge">Chờ lấy hàng</span>
                            </c:when>
                            <c:when test="${order.status eq 'SHIPPING'}">
                                <span class="badge bg-primary status-badge">Đang giao hàng</span>
                            </c:when>
                            <c:when test="${order.status eq 'COMPLETED'}">
                                <span class="badge bg-success status-badge">Hoàn tất</span>
                            </c:when>
                            <c:when test="${order.status eq 'CANCELLED'}">
                                <span class="badge bg-danger status-badge">Đã hủy</span>
                            </c:when>
                            <c:when test="${order.status eq 'PENDING_REFUND'}">
                                <span class="badge bg-warning text-dark status-badge">Chờ hoàn tiền</span>
                            </c:when>
                            <c:when test="${order.status eq 'REFUNDED'}">
                                <span class="badge bg-success status-badge">Đã hoàn tiền</span>
                            </c:when>
                            <c:when test="${order.status eq 'REFUND_REJECTED'}">
                                <span class="badge bg-danger status-badge">Từ chối hoàn</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-secondary status-badge">${order.status}</span>
                            </c:otherwise>
                        </c:choose>

                        <hr>
                        <p>
                            <strong>Phương thức thanh toán:</strong><br>
                            ${order.paymentMethod}
                        </p>

                        <c:if test="${not empty order.ghnCode}">
                            <p class="mb-0">
                                <strong>Mã vận đơn GHN:</strong><br>
                                <span class="text-primary fw-bold">${order.ghnCode}</span>
                            </p>
                        </c:if>
                    </div>
                </div>
            </div>

        </div>

        <div class="detail-card mt-3">
            <div class="detail-header">
                <i class="fas fa-shopping-bag text-danger me-2"></i>
                Danh sách sản phẩm
            </div>
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                    <tr>
                        <th width="100">Ảnh</th>
                        <th>Sản phẩm</th>
                        <th width="120">Số lượng</th>
                        <th width="180">Đơn giá</th>
                        <th width="200">Thành tiền</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${order.orderDetails}" var="item">
                        <tr>
                            <td>
                                <img src="${pageContext.request.contextPath}/resources/${item.product.imageUrl}"
                                     class="img-thumbnail"
                                     style="width:80px;height:80px;object-fit:cover;">
                            </td>
                            <td class="fw-semibold">${item.product.name}</td>
                            <td>${item.quantity}</td>
                            <td>
                                <fmt:formatNumber value="${item.price}" type="currency" currencySymbol="₫"/>
                            </td>
                            <td class="text-danger fw-bold">
                                <fmt:formatNumber value="${item.price * item.quantity}" type="currency" currencySymbol="₫"/>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

    </div>
</div>