<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="root" value="${pageContext.request.contextPath}" />

<jsp:include page="/WEB-INF/layout/index.jsp" />

<div class="container my-5">
    <div class="card order-success-card p-5 mx-auto">

        <!-- Icon check -->
        <div class="icon-check">
            <div class="circle-check"> ✔</div>
        </div>

        <!-- Title -->
        <h2 class="order-title mb-3">ĐẶT HÀNG THÀNH CÔNG!</h2>
        <p class="fs-6 text-muted mb-4">Cảm ơn bạn đã mua sắm tại <strong>SportStore</strong>.</p>

        <!-- Order Info Box -->
        <div class="order-info-box mb-4">
            <p class="mb-2"><strong>Mã đơn hàng:</strong> <span class="fw-bold">${sessionScope.lastOrderCode}</span></p>
            <h4>Chi tiết sản phẩm</h4>
            <table class="table table-bordered">
                <thead>
                <tr>
                    <th>Tên sản phẩm</th>
                    <th>Giá</th>
                    <th>Số lượng</th>
                    <th>Thành tiền</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="item" items="${items}">
                    <tr>
                        <td>${item.productName}</td>
                        <td>${item.price} VND</td>
                        <td>${item.quantity}</td>
                        <td>${item.subtotal} VND</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
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
    /* CARD TRUNG TÂM */
    .order-success-card {
        max-width: 500px;
        width: 90%;
        background-color: #ffffff;
        border-radius: 25px;
        box-shadow: 0 12px 32px rgba(0,0,0,0.15);
        text-align: center;
        margin: auto;
        padding: 50px 30px;
        position: relative;
        z-index: 1;
    }


    .icon-check {
        position: relative;
        margin-bottom: 30px;
    }
    .icon-check i {
        font-size: 100px;
        color: #4BB543;
        background: linear-gradient(45deg, #4BB543, #66d26b);
        border-radius: 50%;
        padding: 25px;
        box-shadow: 0 8px 20px rgba(0,0,0,0.2);
    }
    .circle-check {
        width: 120px;
        height: 120px;
        background: linear-gradient(45deg, #4BB543, #66d26b);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 60px;
        font-weight: 800;
        color: white;
        box-shadow: 0 8px 20px rgba(0,0,0,0.25);
        margin: auto;
    }

    .order-title {
        font-size: 36px;
        font-weight: 800;
        color: #111111;
        text-shadow: 2px 2px 4px rgba(0,0,0,0.08);
    }


    .order-info-box {
        background-color: #fefefe;
        border: 1px solid #e0e0e0;
        border-radius: 20px;
        padding: 30px;
        text-align: left;
        box-shadow: inset 0 0 15px rgba(0,0,0,0.03);
    }


    .order-info-box .text-danger {
        font-size: 22px;
        font-weight: 700;
        color: #E53935 !important;
    }

    .btn-primary {
        background-color: #FF5722;
        border-color: #FF5722;
        font-weight: 700;
        padding: 12px 25px;
        font-size: 1.1rem;
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
        font-weight: 700;
    }
    .btn-outline-primary:hover {
        background-color: #FF5722;
        color: #fff;
    }

    /* RESPONSIVE */
    @media (max-width: 576px) {
        .order-success-card {
            padding: 35px 20px;
            width: 95%;
        }
        .icon-check i {
            font-size: 80px;
            padding: 20px;
        }
        .order-title {
            font-size: 28px;
        }
        .order-info-box {
            padding: 20px;
        }
        .btn-lg {
            width: 100%;
        }
    }
</style>