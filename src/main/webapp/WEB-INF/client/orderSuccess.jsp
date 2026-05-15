<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="root" value="${pageContext.request.contextPath}" />

<jsp:include page="/WEB-INF/layout/index.jsp" />

<div class="container py-5">
    <div class="success-wrapper">
        <div class="success-icon">✔</div>

        <h1 class="success-title">Đặt hàng thành công!</h1>
        <p class="success-subtitle">
            Cảm ơn bạn đã mua sắm tại <strong>SportStore</strong>
        </p>

        <div class="info-card">
            <div class="info-header">
                <div>
                    <span class="label">Mã đơn hàng</span>
                    <h3 class="order-code">${order.orderCode}</h3>
                </div>
                <div class="total-box">
                    <span class="label">Tổng thanh toán</span>
                    <h3 class="total-price">
                        <fmt:formatNumber value="${order.totalPrice}" type="number"/> ₫
                    </h3>
                </div>
            </div>

            <div class="order-details mt-4">
                <h4 class="fw-bold mb-3">Sản phẩm đã đặt</h4>
                <div class="table-responsive">
                    <table class="table custom-table">
                        <thead>
                        <tr>
                            <th>Sản phẩm</th>
                            <th>Số lượng</th>
                            <th class="text-end">Đơn giá</th>
                            <th class="text-end">Thành tiền</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="item" items="${items}">
                            <tr>
                                <td>
                                    <div class="product-box">
                                        <div class="product-name">${item.productName}</div>
                                    </div>
                                </td>
                                <td class="text-center">
                                    <span class="qty-badge">${item.quantity}</span>
                                </td>
                                <td class="text-end fw-semibold">
                                    <fmt:formatNumber value="${item.price}" type="number" /> ₫
                                </td>
                                <td class="text-end text-danger fw-bold">
                                    <fmt:formatNumber value="${item.subtotal}" type="number" /> ₫
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                        <tfoot class="border-top">
                        <tr>
                            <th colspan="3" class="text-end py-3">Tổng giá trị sản phẩm:</th>
                            <th class="text-end py-3 text-danger fs-5">
                                <fmt:formatNumber value="${order.totalPrice}" type="number" /> ₫
                            </th>
                        </tr>
                        </tfoot>
                    </table>
                </div>
            </div>

            <div class="order-note">
                Đơn hàng của bạn đã được ghi nhận.
                Bạn sẽ nhận được email xác nhận sớm nhất.
                Bạn có thể theo dõi trạng thái đơn hàng trong lịch sử mua hàng.
            </div>
        </div>

        <div class="button-group">
            <a href="${root}/" class="btn-shop">Tiếp tục mua sắm</a>
            <a href="${root}/order-history" class="btn-history">Xem lịch sử đơn hàng</a>
        </div>
    </div>
</div>

<jsp:include page="/footer.jsp" />

<style>

    .custom-table {
        width: 100%;
        border-collapse: separate;
        border-spacing: 0;
    }
</style>
<style>

    body {

        background:
                linear-gradient(
                        135deg,
                        #f3f6ff,
                        #eef2ff,
                        #f8fbff
                );

        font-family: 'Segoe UI', sans-serif;

        color: #1f2937;
    }


    .success-wrapper {

        max-width: 1050px;

        margin: auto;

        background: rgba(255,255,255,0.96);

        backdrop-filter: blur(10px);

        border-radius: 34px;

        padding: 50px;

        box-shadow:
                0 20px 50px rgba(37,99,235,0.08),
                0 8px 25px rgba(0,0,0,0.06);

        border:
                1px solid rgba(255,255,255,0.7);

        position: relative;

        overflow: hidden;
    }

    .success-wrapper::before {

        content: "";

        position: absolute;

        width: 250px;
        height: 250px;

        background:
                radial-gradient(
                        circle,
                        rgba(37,99,235,0.10),
                        transparent 70%
                );

        top: -100px;
        right: -80px;

        border-radius: 50%;
    }

    .success-wrapper::after {

        content: "";

        position: absolute;

        width: 220px;
        height: 220px;

        background:
                radial-gradient(
                        circle,
                        rgba(34,197,94,0.10),
                        transparent 70%
                );

        bottom: -100px;
        left: -70px;

        border-radius: 50%;
    }


    .success-icon {

        width: 130px;

        height: 130px;

        margin: auto;

        border-radius: 50%;

        background:
                linear-gradient(
                        135deg,
                        #22c55e,
                        #4ade80
                );

        color: white;

        font-size: 64px;

        font-weight: 800;

        display: flex;

        align-items: center;

        justify-content: center;

        box-shadow:
                0 15px 35px rgba(34,197,94,0.35);

        position: relative;

        animation: popIn 0.5s ease;
    }

    .success-icon::after {

        content: "";

        position: absolute;

        inset: -10px;

        border-radius: 50%;

        border: 3px solid rgba(34,197,94,0.2);
    }

    @keyframes popIn {

        from {

            transform: scale(0.7);
            opacity: 0;
        }

        to {

            transform: scale(1);
            opacity: 1;
        }
    }



    .success-title {

        margin-top: 30px;

        text-align: center;

        font-weight: 900;

        font-size: 46px;

        color: #0f172a;

        letter-spacing: -1px;
    }

    .success-subtitle {

        text-align: center;

        color: #64748b;

        margin-top: 12px;

        margin-bottom: 40px;

        font-size: 17px;

        line-height: 1.7;
    }

    .success-subtitle strong {

        color: #2563eb;
    }


    .info-card {

        background: white;

        border-radius: 28px;

        padding: 34px;

        border:
                1px solid #e5e7eb;

        box-shadow:
                0 10px 30px rgba(0,0,0,0.04);
    }



    .info-header {

        display: flex;

        justify-content: space-between;

        align-items: center;

        gap: 24px;

        flex-wrap: wrap;

        padding-bottom: 26px;

        border-bottom:
                2px dashed #dbe4f0;
    }

    .label {

        color: #94a3b8;

        font-size: 14px;

        font-weight: 600;

        text-transform: uppercase;

        letter-spacing: 0.5px;
    }

    .order-code {

        margin-top: 8px;

        font-weight: 900;

        color: #2563eb;

        font-size: 28px;
    }

    .total-box {

        background:
                linear-gradient(
                        135deg,
                        #fff5f5,
                        #fff0f0
                );

        padding: 18px 24px;

        border-radius: 18px;

        border:
                1px solid #ffd6d6;

        min-width: 250px;
    }

    .total-price {

        margin-top: 8px;

        font-weight: 900;

        color: #dc2626;

        font-size: 30px;
    }



    .custom-table {

        background: white;

        border-radius: 20px;

        overflow: hidden;

        border:
                1px solid #e5e7eb;
    }

    .custom-table thead th {

        background:
                linear-gradient(
                        135deg,
                        #111827,
                        #1f2937
                );

        color: white;

        padding: 18px;

        text-align: center;

        font-size: 14px;

        border: none;

        font-weight: 700;

        letter-spacing: 0.4px;
    }

    .custom-table tbody td {

        vertical-align: middle;

        padding: 22px 16px;

        border-color: #f1f5f9;
    }

    .custom-table tbody tr {

        transition: 0.25s ease;
    }

    .custom-table tbody tr:hover {

        background: #f8fbff;

        transform: scale(1.005);
    }



    .product-box {

        display: flex;

        align-items: center;

        gap: 16px;
    }

    .product-img {

        width: 78px;

        height: 78px;

        object-fit: cover;

        border-radius: 18px;

        border:
                1px solid #e2e8f0;

        background: white;

        padding: 4px;

        box-shadow:
                0 4px 10px rgba(0,0,0,0.05);
    }

    .product-name {

        font-weight: 800;

        color: #111827;

        font-size: 15px;

        line-height: 1.5;
    }



    .fw-semibold {

        font-weight: 700 !important;

        color: #1e293b;
    }



    .qty-badge {

        background:
                linear-gradient(
                        135deg,
                        #2563eb,
                        #3b82f6
                );

        color: white;

        padding: 8px 15px;

        border-radius: 12px;

        font-weight: 800;

        display: inline-block;

        min-width: 50px;

        text-align: center;

        box-shadow:
                0 5px 15px rgba(37,99,235,0.25);
    }



    .order-note {

        margin-top: 28px;

        background:
                linear-gradient(
                        135deg,
                        #eef4ff,
                        #f6f9ff
                );

        border:
                1px solid #c7dcff;

        padding: 20px 22px;

        border-radius: 18px;

        color: #334155;

        line-height: 1.8;

        font-size: 15px;

        font-weight: 500;
    }



    .button-group {

        display: flex;

        justify-content: center;

        gap: 18px;

        margin-top: 42px;

        flex-wrap: wrap;
    }

    .btn-shop,
    .btn-history {

        text-decoration: none;

        padding: 15px 32px;

        border-radius: 16px;

        font-weight: 800;

        transition: all 0.3s ease;

        font-size: 15px;

        letter-spacing: 0.3px;
    }

    .btn-shop {

        border:
                2px solid #2563eb;

        color: #2563eb;

        background: white;

        box-shadow:
                0 4px 12px rgba(37,99,235,0.08);
    }

    .btn-shop:hover {

        background: #2563eb;

        color: white;

        transform: translateY(-2px);

        box-shadow:
                0 10px 25px rgba(37,99,235,0.25);
    }

    .btn-history {

        background:
                linear-gradient(
                        135deg,
                        #ff6b35,
                        #ff8c42
                );

        color: white;

        border:
                2px solid transparent;

        box-shadow:
                0 8px 20px rgba(255,107,53,0.25);
    }

    .btn-history:hover {

        transform: translateY(-3px);

        box-shadow:
                0 14px 28px rgba(255,107,53,0.35);

        color: white;
    }


    @media(max-width:768px) {

        .success-wrapper {

            padding: 28px;
        }

        .success-title {

            font-size: 34px;
        }

        .success-icon {

            width: 100px;
            height: 100px;

            font-size: 48px;
        }

        .product-box {

            flex-direction: column;

            align-items: flex-start;
        }

        .info-header {

            flex-direction: column;

            align-items: stretch;
        }

        .total-box {

            width: 100%;
        }

        .btn-shop,
        .btn-history {

            width: 100%;

            text-align: center;
        }
    }

</style>