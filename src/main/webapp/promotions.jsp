<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mã Giảm Giá & Ưu Đãi - SportStore</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

    <style>

        .voucher-card {
            border: 1px dashed #dc3545;
            border-radius: 8px;
            overflow: hidden;
            background: #fff;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .voucher-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.12) !important;
        }
        .voucher-left {
            width: 120px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            padding: 10px;
            position: relative;
        }

        .voucher-left::after {
            content: "";
            position: absolute;
            right: -5px;
            top: 0;
            width: 10px;
            height: 100%;
            background-image: radial-gradient(circle, #f8f9fa 4px, transparent 5px);
            background-size: 10px 15px;
        }

        .tier-dong { background: linear-gradient(135deg, #cd7f32, #a0522d); color: #fff; }
        .tier-bac { background: linear-gradient(135deg, #c0c0c0, #708090); color: #fff; }
        .tier-vang { background: linear-gradient(135deg, #ffd700, #ff8c00); color: #333; }
        .tier-kimcuong { background: linear-gradient(135deg, #212529, #343a40); color: #fff; }
        .tier-all { background: linear-gradient(135deg, #dc3545, #921d28); color: #fff; }

        .code-badge {
            font-family: 'Courier New', Courier, monospace;
            font-size: 0.9rem;
            letter-spacing: 1px;
        }
    </style>
</head>
<body class="bg-light">

<jsp:include page="/WEB-INF/layout/index.jsp"/>

<div class="p-5 mb-4 text-white rounded-0 position-relative shadow-sm"
     style="background: linear-gradient(135deg, #dc3545 0%, #921d28 100%);">
    <div class="container py-4 text-center text-lg-start">
        <div class="row align-items-center">
            <div class="col-lg-8">
                <span class="badge bg-warning text-dark mb-2 px-3 py-2 fw-bold text-uppercase">Đặc Quyền Thành Viên</span>
                <h1 class="display-4 fw-bold">KHO BÁU VOUCHER</h1>
                <p class="lead mb-0">Hệ thống tự động áp dụng mức chiết khấu tốt nhất dựa trên thứ hạng tài khoản của bạn khi thanh toán.</p>
            </div>
            <div class="col-lg-4 text-center d-none d-lg-block">
                <i class="bi bi-ticket-perforated" style="font-size: 7rem; opacity: 0.3;"></i>
            </div>
        </div>
    </div>
</div>

<div class="container my-5">

    <div class="card border-0 shadow-sm p-4 mb-5 bg-white rounded-3 d-flex flex-md-row justify-content-between align-items-center">
        <div class="d-flex align-items-center mb-3 mb-md-0">
            <div class="p-3 bg-danger-subtle text-danger rounded-circle me-3">
                <i class="bi bi-person-crown fs-3"></i>
            </div>
            <div>
                <h5 class="fw-bold mb-1 text-dark">
                    Xin chào,
                    <c:choose>

                        <c:when test="${not empty sessionScope.user}">
                            ${sessionScope.user.fullName}
                        </c:when>


                        <c:when test="${not empty sessionScope.currentUser}">
                            ${sessionScope.currentUser.fullName}
                        </c:when>


                        <c:otherwise>
                            Khách vãng lai
                        </c:otherwise>
                    </c:choose>
                </h5>
                <p class="text-muted mb-0 small">Tài khoản của bạn hiện có cấp độ hệ thống là:</p>
            </div>
        </div>
        <div>
            <c:set var="userTier" value="${sessionScope.user.tierName != null ? sessionScope.user.tierName : (sessionScope.currentUser.tierName != null ? sessionScope.currentUser.tierName : 'Đồng')}" />
            <span class="badge fs-5 px-4 py-2 text-uppercase shadow-sm
            <c:choose>
                <c:when test="${userTier == 'Kim Cương'}">tier-kimcuong</c:when>
                <c:when test="${userTier == 'Vàng'}">tier-vang</c:when>
                <c:when test="${userTier == 'Bạc'}">tier-bac</c:when>
                <c:otherwise>tier-dong</c:otherwise>
            </c:choose>">
            Hạng ${userTier}
        </span>
        </div>
    </div>

    <div class="border-start border-danger border-4 ps-3 mb-4">
        <h2 class="fw-bold text-uppercase m-0 text-dark">Mã Giảm Giá Dành Cho Bạn</h2>
        <small class="text-muted">Áp dụng trực tiếp mã voucher hợp lệ tại phần thanh toán đơn hàng</small>
    </div>

    <div class="row">
        <c:forEach var="p" items="${promotions}">
            <div class="col-xl-6 mb-4">
                <div class="d-flex voucher-card shadow-sm h-100">

                    <c:set var="vtier" value="${p.applicableTier}" />
                    <div class="voucher-left
                        <c:choose>
                            <c:when test="${vtier == 'Kim Cương'}">tier-kimcuong</c:when>
                            <c:when test="${vtier == 'Vàng'}">tier-vang</c:when>
                            <c:when test="${vtier == 'Bạc'}">tier-bac</c:when>
                            <c:when test="${vtier == 'Đồng'}">tier-dong</c:when>
                            <c:otherwise>tier-all</c:otherwise>
                        </c:choose>">
                        <i class="bi ${p.discountType == 'PERCENT' ? 'bi-percent' : 'bi-cash-coin'} fs-2 mb-1"></i>
                        <small class="fw-bold text-uppercase" style="font-size: 0.65rem; letter-spacing: 0.5px;">
                            Hạng ${p.applicableTier != null ? p.applicableTier : 'TẤT CẢ'}
                        </small>
                    </div>

                    <div class="p-3 flex-grow-1 d-flex flex-column justify-content-between bg-white">
                        <div>
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <h5 class="fw-bold text-dark m-0">
                                    <c:choose>
                                        <c:when test="${p.discountType == 'PERCENT'}">
                                            Giảm ${p.discountValue}%
                                        </c:when>
                                        <c:otherwise>
                                            Giảm <fmt:formatNumber value="${p.discountValue}" type="number"/>đ
                                        </c:otherwise>
                                    </c:choose>
                                </h5>
                                <span class="badge bg-danger-subtle text-danger border border-danger-subtle fw-bold code-badge px-2 py-1 text-uppercase">
                                        ${p.code}
                                </span>
                            </div>

                            <div class="text-secondary small">
                                <div class="mb-1">
                                    <i class="bi bi-check2-circle text-success me-1"></i>
                                    Đơn hàng tối thiểu: <strong class="text-dark"><fmt:formatNumber value="${p.minOrderValue}" type="number"/> đ</strong>
                                </div>
                                <c:if test="${p.maxDiscount != null && p.maxDiscount > 0}">
                                    <div class="mb-1">
                                        <i class="bi bi-arrow-down-right-circle text-primary me-1"></i>
                                        Mức giảm tối đa: <strong class="text-dark"><fmt:formatNumber value="${p.maxDiscount}" type="number"/> đ</strong>
                                    </div>
                                </c:if>
                                <c:if test="${p.minProductPrice > 0}">
                                    <div class="mb-1">
                                        <i class="bi bi-box-seam text-warning me-1"></i>
                                        Yêu cầu giá SP từ: <strong class="text-dark"><fmt:formatNumber value="${p.minProductPrice}" type="number"/> đ</strong>
                                    </div>
                                </c:if>
                                <div class="mb-1">
                                    <i class="bi bi-credit-card text-info me-1"></i>
                                    Hình thức: Thanh toán <span class="badge bg-light text-secondary border text-uppercase">${p.paymentMethod}</span>
                                </div>
                            </div>
                        </div>

                        <div class="d-flex justify-content-between align-items-center mt-3 pt-2 border-top border-light-subtle text-muted" style="font-size: 0.75rem;">
                            <span>
                                <i class="bi bi-calendar-event me-1"></i>
                                HSD: <strong class="text-dark"><fmt:formatDate value="${p.expiryDate}" pattern="dd/MM/yyyy HH:mm"/></strong>
                            </span>
                            <span>
                                Giới hạn/Khách: <strong class="text-danger">${p.usageLimitPerUser} lần</strong>
                            </span>
                        </div>

                        <div class="mt-3 pt-2 border-top border-light-subtle">
                            <button class="btn btn-sm btn-danger w-100 btn-save-voucher fw-bold py-2"
                                    data-voucher-id="${p.id}"
                                ${empty sessionScope.user and empty sessionScope.currentUser ? 'disabled' : ''}
                                    style="border-radius: 8px;">
                                <i class="bi bi-bookmark-plus-fill me-1"></i>
                                    ${empty sessionScope.user and empty sessionScope.currentUser ? 'Đăng nhập để lưu' : 'Lưu mã ưu đãi'}
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

    <c:if test="${empty promotions}">
        <div class="text-center py-5">
            <i class="bi bi-box-open text-muted" style="font-size: 4rem;"></i>
            <p class="text-muted mt-2">Hiện tại chưa có chương trình khuyến mãi nào diễn ra.</p>
        </div>
    </c:if>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
    $(document).ready(function() {

        $('.btn-save-voucher').click(function() {
            var btn = $(this);
            var voucherId = btn.data('voucher-id');

            $.ajax({
                url: '${pageContext.request.contextPath}/save-voucher',
                type: 'POST',
                data: { voucherId: voucherId },
                dataType: 'json',
                success: function(response) {
                    if(response.status === "success") {

                        btn.removeClass('btn-danger')
                                .addClass('btn-secondary')
                                .html('<i class="bi bi-bookmark-check-fill me-1"></i> Đã lưu vào kho')
                                .prop('disabled', true);

                        alert('Lưu mã giảm giá thành công! Bạn có thể chọn mã này trong danh sách tại trang thanh toán.');
                    } else {
                        alert(response.message);
                    }
                },
                error: function() {
                    alert('Có lỗi xảy ra, vui lòng thử lại sau!');
                }
            });
        });
    });
</script>

<jsp:include page="footer.jsp"/>
</body>
</html>