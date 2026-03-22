<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="root" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">
    <title>Giỏ hàng</title>

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">

    <style>
        body {
            background: #f5f5f5;
            font-family: 'Segoe UI', sans-serif;
        }

        /* CONTAINER */
        .cart-container {
            background: #fff;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }

        /* HEADER */
        .cart-header {
            background: rgba(255, 0, 0, 0.85); /* đỏ hơi trong suốt */
            color: white;
            font-weight: bold;
            padding: 10px 0;
            border-radius: 5px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.2);
            backdrop-filter: brightness(1.1) contrast(1.2);
        }

        /* ITEM */
        .cart-item {
            padding: 15px 10px;
            border-bottom: 1px solid #eee;
            transition: all 0.25s ease;
        }

        .cart-item:hover {
            background: #fff5f5;
            transform: scale(1.01);
        }

        /* IMAGE */
        .product-img {
            width: 90px;
            height: 90px;
            object-fit: contain;
        }

        .product-name {
            font-weight: 600;
        }

        /* PRICE */
        .price {
            color: #d81f19;
            font-weight: bold;
        }

        /* QTY */
        .qty-box {
            width: 45px;
            height: 35px;
            text-align: center;
            border-radius: 6px;
        }

        /* BUTTON QTY */
        .btn-qty {
            border: 1px solid #ddd;
            background: white;
            font-weight: bold;
        }

        .btn-qty:hover {
            background: #d81f19;
            color: white;
            border-color: #d81f19;
        }

        /* REMOVE */
        .remove-btn {
            color: #999;
            font-size: 18px;
        }

        .remove-btn:hover {
            color: #d81f19;
        }

        /* SUMMARY */
        .cart-summary {
            background: #fff;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }

        /* TOTAL */
        .total-price {
            color: #d81f19;
            font-size: 20px;
            font-weight: bold;
        }

        /* BTN */
        .checkout-btn {
            background-color: #d81f19 !important;
            color: white !important; /* chữ trắng */
            font-weight: bold;
            padding: 10px 15px;
            border: none;
            border-radius: 5px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
        }

        .checkout-btn:hover {
            background-color: #b71c1c!important; /* đỏ đậm khi hover */
            box-shadow: 0 4px 8px rgba(0,0,0,0.2); /* bóng nhẹ khi hover */
        }

        .btn-back {
            border-radius: 8px;
            border: 1px solid #ddd;
        }

        .btn-back:hover {
            background: #eee;
        }
    </style>

</head>

<body>

<jsp:include page="/WEB-INF/layout/index.jsp"/>

<div class="container mt-4">

    <!-- BACK -->
    <a href="${root}/products" class="btn btn-back mb-3">
        ← Tiếp tục mua hàng
    </a>

    <!-- EMPTY CART -->
    <c:if test="${empty sessionScope.cart}">
        <div class="text-center p-5 bg-white rounded shadow-sm">
            <h4>🛒 Giỏ hàng của bạn đang trống</h4>
            <a href="${root}/products" class="btn checkout-btn mt-3">
                Mua sắm ngay
            </a>
        </div>
    </c:if>

    <c:if test="${not empty sessionScope.cart}">

        <div class="row">

            <!-- LEFT -->
            <div class="col-md-8">

                <div class="cart-container">

                    <div class="row cart-header">
                        <div class="col-md-5">Sản phẩm</div>
                        <div class="col-md-2 text-center">Đơn giá</div>
                        <div class="col-md-2 text-center">Số lượng</div>
                        <div class="col-md-2 text-center">Thành tiền</div>
                        <div class="col-md-1 text-center">Xóa</div>
                    </div>

                    <c:set var="total" value="0" />

                    <c:forEach var="item" items="${sessionScope.cart}">

                        <div class="row cart-item">

                            <!-- PRODUCT -->
                            <div class="col-md-5 d-flex align-items-center">

                                <img src="${root}/resources/${item.product.imageUrl}"
                                     class="product-img">

                                <div class="ms-3">
                                    <div class="product-name">
                                            ${item.product.name}
                                    </div>

                                    <small class="text-muted">
                                        Size: ${item.product.size} |
                                        Màu: ${item.product.color}
                                    </small>
                                </div>

                            </div>

                            <!-- PRICE -->
                            <div class="col-md-2 text-center price">
                                <fmt:formatNumber value="${item.product.price}" />
                            </div>

                            <!-- QTY -->
                            <div class="col-md-2 text-center">

                                <form action="${root}/cart" method="post"
                                      class="d-flex justify-content-center">

                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="productId" value="${item.product.id}">

                                    <button type="submit"
                                            name="quantity"
                                            value="${item.quantity > 1 ? item.quantity - 1 : 1}"
                                            class="btn btn-qty btn-sm">-</button>

                                    <input type="text"
                                           value="${item.quantity}"
                                           class="form-control mx-1 qty-box"
                                           readonly>

                                    <button type="submit"
                                            name="quantity"
                                            value="${item.quantity + 1}"
                                            class="btn btn-qty btn-sm">+</button>

                                </form>

                            </div>

                            <!-- TOTAL -->
                            <div class="col-md-2 text-center price">
                                <fmt:formatNumber value="${item.product.price * item.quantity}" />
                            </div>

                            <!-- REMOVE -->
                            <div class="col-md-1 text-center">
                                <a href="${root}/cart?action=remove&id=${item.product.id}"
                                   class="remove-btn"
                                   onclick="return confirm('Bạn có chắc muốn xóa sản phẩm này?')">
                                    ❌
                                </a>
                            </div>

                        </div>

                        <c:set var="total"
                               value="${total + (item.product.price * item.quantity)}" />

                    </c:forEach>

                </div>

            </div>

            <!-- RIGHT -->
            <div class="col-md-4">

                <div class="cart-summary">

                    <h5>Tóm tắt đơn hàng</h5>
                    <hr>

                    <c:set var="shipping" value="30000" />

                    <div class="d-flex justify-content-between">
                        <span>Tạm tính</span>
                        <span>
                            <fmt:formatNumber value="${total}" /> VNĐ
                        </span>
                    </div>

                    <div class="d-flex justify-content-between mt-2">
                        <span>Phí vận chuyển</span>
                        <span>30,000 VNĐ</span>
                    </div>

                    <hr>

                    <div class="d-flex justify-content-between">
                        <span>Tổng cộng</span>
                        <span class="total-price">
                            <fmt:formatNumber value="${total + shipping}" /> VNĐ
                        </span>
                    </div>

                    <a href="${root}/checkout" class="btn checkout-btn w-100 mt-3">
                        🛒 Thanh toán ngay
                    </a>

                </div>

            </div>

        </div>

    </c:if>

</div>

</body>
</html>