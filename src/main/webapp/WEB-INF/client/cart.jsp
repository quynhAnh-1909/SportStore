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

        /* Container giỏ hàng */
        .cart-container {
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }

        /* Header bảng */
        .cart-header {
            font-weight: 600;
            color: #555;
            border-bottom: 2px solid #eee;
            padding-bottom: 10px;
            margin-bottom: 15px;
            background-color: #fafafa;
        }

        /* Item giỏ hàng */
        .cart-item {
            padding: 15px 10px;
            border-bottom: 1px solid #eee;
            align-items: center;
            transition: background 0.2s;
            border-radius: 5px;
            margin-bottom: 10px;
        }

        .cart-item:hover {
            background: #f9f9f9;
        }

        /* Ảnh sản phẩm */
        .product-img {
            width: 80px;
            height: 80px;
            object-fit: contain;
        }

        .product-name {
            font-weight: 500;
            margin-left: 15px;
        }

        /* Giá sản phẩm */
        .price {
            color: #f57224; /* màu Lazada cam */
            font-weight: bold;
        }

        /* Số lượng */
        .qty-box{
            width: 40px;
            height: 35px;
            padding: 0;
            text-align: center;
        }

        /* Button tăng giảm số lượng */
        .btn-qty {
            border-color: #f57224;
            color: #f57224;
            font-weight: bold;
        }

        .btn-qty:hover {
            background-color: #f57224;
            color: white;
        }

        /* Nút xóa */
        .remove-btn {
            color: red;
            cursor: pointer;
            font-size: 1.2rem;
        }

        /* Summary */
        .cart-summary {
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }

        .cart-summary h5 {
            font-weight: 600;
            color: #333;
        }

        .checkout-btn {
            background-color: #f57224;
            color: white;
            font-weight: bold;
        }

        .checkout-btn:hover {
            background-color: #e85b1e;
            color: white;
        }

        /* Responsive */
        @media(max-width: 768px){
            .cart-header .col-md-5,
            .cart-item .col-md-5 {
                flex-basis: 100%;
            }
            .cart-item .col-md-2, .cart-item .col-md-1 {
                flex-basis: 50%;
                text-align: left;
                margin-top: 5px;
            }
        }

    </style>

</head>

<body>

<jsp:include page="/WEB-INF/layout/index.jsp"/>

<div class="container mt-4">

    <div class="row">

        <!-- CART LIST -->

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

                        <div class="col-md-5 d-flex align-items-center">

                            <img src="${root}/resources/${item.product.imageUrl}"
                                 class="product-img">

                            <div class="ms-3 product-name">${item.product.name}</div>

                        </div>

                        <div class="col-md-2 text-center price">

                            <fmt:formatNumber value="${item.product.price}" type="number" />

                        </div>

                        <div class="col-md-2 text-center">

                            <form action="${root}/cart" method="post">

                                <input type="hidden" name="action" value="update"> <input
                                    type="hidden" name="productId" value="${item.product.id}">

                                <div class="d-flex justify-content-center align-items-center">

                                    <form action="${root}/cart" method="post" class="d-flex">

                                        <input type="hidden" name="action" value="update"> <input
                                            type="hidden" name="productId" value="${item.product.id}">

                                        <button type="submit" name="quantity" value="${item.quantity - 1}" class="btn btn-outline-secondary btn-sm btn-qty">-</button>
                                        <input type="text" value="${item.quantity}" class="form-control text-center mx-1 qty-box" readonly>
                                        <button type="submit" name="quantity" value="${item.quantity + 1}" class="btn btn-outline-secondary btn-sm btn-qty">+</button>
                                    </form>

                                </div>

                            </form>

                        </div>

                        <div class="col-md-2 text-center price">

                            <fmt:formatNumber value="${item.product.price * item.quantity}"
                                              type="number" />

                        </div>

                        <div class="col-md-1 text-center">

                            <a href="${root}/cart?action=remove&id=${item.product.id}"
                               class="remove-btn"> ❌ </a>

                        </div>

                    </div>

                    <c:set var="total"
                           value="${total + (item.product.price * item.quantity)}" />

                </c:forEach>

            </div>

        </div>

        <!-- SUMMARY -->

        <div class="col-md-4">

            <div class="cart-summary">

                <h5>Tóm tắt đơn hàng</h5>

                <hr>

                <div class="d-flex justify-content-between">

                    <span>Tổng tiền</span> <b class="price"> <fmt:formatNumber
                        value="${total}" type="number" /> VNĐ

                </b>

                </div>

                <a href="${root}/checkout" class="btn checkout-btn w-100 mt-3">
                    Thanh toán </a>

            </div>

        </div>

    </div>

</div>

</body>
</html>