<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<style>
    .voucher-wallet-card {
        border: 1px dashed #dc3545;
        border-radius: 8px;
        overflow: hidden;
        background: #fff;
        transition: transform 0.2s, box-shadow 0.2s;
        display: flex;
        margin-bottom: 20px;
    }
    .voucher-wallet-card:hover {
        transform: translateY(-3px);
        box-shadow: 0 8px 20px rgba(0,0,0,0.12) !important;
    }
    .wallet-left {
        width: 120px;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        text-align: center;
        padding: 10px;
        position: relative;
    }
    .wallet-left::after {
        content: "";
        position: absolute;
        right: -5px;
        top: 0;
        width: 10px;
        height: 100%;
        background-image: radial-gradient(circle, #f5f6fa 4px, transparent 5px);
        background-size: 10px 15px;
    }
    .tier-wallet-all {
        background: linear-gradient(135deg, #dc3545, #921d28);
        color: #fff;
    }
    .wallet-code-badge {
        font-family: 'Courier New', Courier, monospace;
        font-size: 0.9rem;
        letter-spacing: 1px;
    }
</style>

<div class="row">
    <c:choose>
        <c:when test="${not empty userVouchers}">
            <c:forEach var="v" items="${userVouchers}">
                <div class="col-xl-6">
                    <div class="voucher-wallet-card shadow-sm h-100">
                        <div class="wallet-left tier-wallet-all">
                            <i class="bi ${v.discountType == 'PERCENT' ? 'bi-percent' : 'bi-cash-coin'} fs-2 mb-1"></i>
                            <small class="fw-bold text-uppercase" style="font-size: 0.65rem; letter-spacing: 0.5px;">SportStore</small>
                        </div>

                        <div class="p-3 flex-grow-1 d-flex flex-column justify-content-between bg-white">
                            <div>
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <h5 class="fw-bold text-dark m-0">
                                        <c:choose>
                                            <c:when test="${v.discountType == 'PERCENT'}">
                                                Giảm ${v.discountValue}%
                                            </c:when>
                                            <c:otherwise>
                                                Giảm <fmt:formatNumber value="${v.discountValue}" type="number"/>đ
                                            </c:otherwise>
                                        </c:choose>
                                    </h5>
                                    <span class="badge bg-success-subtle text-success border border-success-subtle fw-bold wallet-code-badge px-2 py-1 text-uppercase">
                                            ${v.code}
                                    </span>
                                </div>

                                <div class="text-secondary small">
                                    <div class="mb-1">
                                        <i class="bi bi-check2-circle text-success me-1"></i>
                                        Đơn tối thiểu: <strong class="text-dark"><fmt:formatNumber value="${v.minOrderValue}" type="number"/> đ</strong>
                                    </div>
                                    <c:if test="${v.maxDiscount != null && v.maxDiscount > 0}">
                                        <div class="mb-1">
                                            <i class="bi bi-arrow-down-right-circle text-primary me-1"></i>
                                            Mức giảm tối đa: <strong class="text-dark"><fmt:formatNumber value="${v.maxDiscount}" type="number"/> đ</strong>
                                        </div>
                                    </c:if>
                                </div>
                            </div>

                            <div class="d-flex justify-content-between align-items-center mt-3 pt-2 border-top border-light-subtle text-muted" style="font-size: 0.75rem;">
                                <span>
                                    <i class="bi bi-calendar-event me-1"></i>
                                    HSD: <strong class="text-dark"><fmt:formatDate value="${v.expiryDate}" pattern="dd/MM/yyyy HH:mm"/></strong>
                                </span>
                                <span class="badge bg-success rounded-pill px-2 py-1" style="font-size: 10px; color: white;">Sẵn sàng dùng</span>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <div class="col-12 text-center py-5">
                <i class="bi bi-ticket-perforated text-muted" style="font-size: 4rem;"></i>
                <p class="text-muted mt-2">Kho Voucher của bạn hiện đang trống.</p>
                <a href="${pageContext.request.contextPath}/promotions" class="btn btn-sm btn-danger px-3 py-2 fw-bold mt-2" style="border-radius: 8px;">
                    <i class="bi bi-arrow-right-circle me-1"></i> Đến trang săn Voucher ngay
                </a>
            </div>
        </c:otherwise>
    </c:choose>
</div>