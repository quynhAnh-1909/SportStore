<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="root" value="${pageContext.request.contextPath}" />

<jsp:include page="/WEB-INF/layout/index.jsp" />

<div class="container my-5">
    <div class="card order-success-card p-5 mx-auto">

        <!-- Icon check -->
        <div class="icon-check mb-4">
            <i class="fas fa-check-circle"></i>
        </div>

        <!-- Title -->
        <h2 class="order-title mb-3">ĐẶT HÀNG THÀNH CÔNG!</h2>
        <p class="fs-6 text-muted mb-4">Cảm ơn bạn đã mua sắm tại <strong>SportStore</strong>.</p>

        <!-- Order Info Box -->
        <div class="order-info-box mb-4">
            <p class="mb-2"><strong>Mã đơn hàng:</strong> <span class="fw-bold">${sessionScope.lastOrderCode}</span></p>
            <p class="mb-2"><strong>Tổng thanh toán:</strong>
                <span class="fw-bold text-danger">
                    <fmt:formatNumber value="${sessionScope.lastTotal}" type="number"/> ₫
                </span>
            </p>
            <p class="mb-0 text-muted small">Chi tiết đơn hàng đã được lưu trong lịch sử mua hàng của bạn.</p>
        </div>

        <!-- Buttons -->
        <div class="d-flex gap-3 justify-content-center mt-3 flex-wrap">
            <a href="${root}/" class="btn btn-outline-primary btn-lg rounded-pill fw-bold">Tiếp tục mua sắm</a>
            <a href="${root}/orderHistory" class="btn btn-primary btn-lg rounded-pill fw-bold">Xem lịch sử đơn hàng</a>
        </div>
    </div>
</div>

<jsp:include page="/footer.jsp" />

<style>
    /* Card trung tâm */
    .order-success-card {
        max-width: 500px; /* giảm từ 600px xuống 500px */
        width: 90%;       /* responsive tự động */
        background-color: #ffffff;
        border-radius: 20px;
        box-shadow: 0 8px 24px rgba(0,0,0,0.1);
        text-align: center;
        margin: auto; /* canh giữa */
        padding: 40px 30px;
    }

    .order-info-box {
        background-color: #fefefe;
        border: 1px solid #e0e0e0;
        border-radius: 15px;
        padding: 20px;
        text-align: left;
        max-height: 300px; /* nếu danh sách quá dài */
        overflow-y: auto;  /* scroll nội dung dài */
        box-shadow: inset 0 0 10px rgba(0,0,0,0.02);
    }

    .btn-lg {
        min-width: 150px;  /* tránh quá dài */
    }

    @media (max-width: 576px) {
        .order-success-card {
            padding: 30px 20px;
            width: 95%;
        }
    }

    /* Icon check */
    .icon-check i {
        font-size: 90px;
        color: #4BB543; /* xanh lá Shopee */
        background: linear-gradient(45deg, #4BB543, #66d26b);
        border-radius: 50%;
        padding: 20px;
    }

    /* Tiêu đề */
    .order-title {
        font-size: 32px;
        font-weight: 800;
        color: #111111;
        text-shadow: 1px 1px 2px rgba(0,0,0,0.05);
    }

    /* Khung thông tin */
    .order-info-box {
        background-color: #fefefe;
        border: 1px solid #e0e0e0;
        border-radius: 15px;
        padding: 25px;
        text-align: left;
        box-shadow: inset 0 0 10px rgba(0,0,0,0.02);
    }

    /* Số tiền */
    .order-info-box .text-danger {
        font-size: 20px;
        font-weight: 700;
        color: #E53935 !important; /* đỏ nổi bật */
    }

    /* Buttons */
    .btn-primary {
        background-color: #FF5722;
        border-color: #FF5722;
        transition: all 0.3s ease;
    }

    .btn-primary:hover {
        background-color: #E64A19;
        border-color: #E64A19;
        color: #fff;
    }

    .btn-outline-primary {
        color: #FF5722;
        border-color: #FF5722;
        transition: all 0.3s ease;
    }

    .btn-outline-primary:hover {
        background-color: #FF5722;
        color: #fff;
    }

    /* Responsive */
    @media (max-width: 576px) {
        .order-success-card {
            padding: 30px 20px;
        }

        .icon-check i {
            font-size: 70px;
            padding: 15px;
        }

        .order-title {
            font-size: 26px;
        }

        .order-info-box {
            padding: 20px;
        }

        .btn-lg {
            width: 100%;
        }
    }
</style>