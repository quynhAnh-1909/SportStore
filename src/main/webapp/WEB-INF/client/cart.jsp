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


        .cart-count {
            position: absolute;
            top: -5px;          /* Đẩy lên phía trên */
            right: -8px;        /* Đẩy sang phải */
            background-color: #ff0000;
            color: white;
            border-radius: 50%; /* Làm cho badge hình tròn */
            padding: 2px 6px;
            font-size: 12px;
            font-weight: bold;
            line-height: 1;
            border: 2px solid white; /* Tạo viền trắng để nổi bật trên nền đỏ */
            min-width: 18px;
            text-align: center;
        }

        /* ITEM */
        .cart-item {
            display: flex;
            align-items: center;
        }

        /* IMAGE */
        .product-img {
            width: 80px;
            height: 80px;
            object-fit: contain;
            margin-right: 10px;

        }

        .product-name {
            font-size: 14px;
            line-height: 1.4;
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
            border: 1px solid #ccc;
            border-radius: 6px;
        }

        .qty-control {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border: 1px solid #ddd;
            border-radius: 8px;
            overflow: hidden;
        }

        .qty-btn {
            width: 35px;
            height: 35px;
            border: none;
            background: #f5f5f5;
            font-size: 18px;
        }

        .qty-btn:hover {
            background: #e0e0e0;
        }

        .qty-input {
            width: 50px;
            height: 35px;
            text-align: center;
            border: none;
            outline: none;
            background: #fff;
            font-weight: bold;
        }

        .cart-item:hover {
            background: #fff5f5;
            transition: 0.2s;
        }

        /* BUTTON QTY */
        .btn-qty {
            width: 30px;
            height: 30px;
            padding: 0;
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

        .item-check {
            width: 16px;
            height: 16px;
            cursor: pointer;
        }
        .cart-container {
            border-radius: 12px;

        }



    </style>

</head>

<body>

<jsp:include page="/WEB-INF/layout/index.jsp"/>

<div class="container mt-4">

    <a href="${root}/products" class="btn btn-secondary mb-3">
        ← Tiếp tục mua hàng
    </a>

    <c:if test="${empty sessionScope.cart}">
        <div class="text-center p-5 bg-white rounded shadow-sm">
            <h4>🛒 Giỏ hàng trống</h4>
        </div>
    </c:if>

    <c:if test="${not empty sessionScope.cart}">

        <div class="row">

            <!-- LEFT -->
            <div class="col-md-8">

                <div class="card p-3">

                    <div class="row fw-bold text-white bg-danger p-2 rounded text-center align-items-center">
                        <div class="col-md-1"></div>
                        <div class="col-md-4 text-start">Sản phẩm</div>
                        <div class="col-md-2">Đơn giá</div>
                        <div class="col-md-2">Số lượng</div>
                        <div class="col-md-2">Thành tiền</div>
                        <div class="col-md-1">Xóa</div>
                    </div>

                    <c:forEach var="item" items="${sessionScope.cart}">

                        <div class="row align-items-center mt-3 cart-item text-center g-0"
                             data-id="${item.product.id}">

                            <div class="col-md-1">
                                <input type="checkbox" class="item-check"
                                       data-price="${item.product.price}" checked>
                            </div>

                            <div class="col-md-4 d-flex align-items-center">
                                <img src="${root}/resources/${item.product.imageUrl}" width="70">
                                <div class="ms-2">${item.product.name}</div>
                            </div>

                            <div class="col-md-2 text-danger fw-bold">
                                <fmt:formatNumber value="${item.product.price}" /> VNĐ
                            </div>

                            <div class="col-md-2 text-center">
                                <div class="qty-control">
                                    <button type="button" class="qty-btn minus">-</button>
                                    <input type="text" value="${item.quantity}" class="qty-input" readonly>
                                    <button type="button" class="qty-btn plus">+</button>
                                </div>
                            </div>

                            <div class="col-md-2 text-danger fw-bold item-total">
                                <fmt:formatNumber value="${item.product.price * item.quantity}" />
                            </div>

                            <div class="col-md-1">
                                <button onclick="confirmDelete(${item.product.id})"
                                        class="btn btn-danger">X</button>
                            </div>

                        </div>

                    </c:forEach>

                </div>

            </div>

            <!-- RIGHT -->
            <div class="col-md-4">

                <div class="card p-3">

                    <h5>Tóm tắt</h5>
                    <hr>

                    <div class="d-flex justify-content-between">
                        <span>Tạm tính</span>
                        <span id="totalPrice">0 VNĐ</span>
                    </div>

                    <div class="d-flex justify-content-between mt-2">
                        <span>Phí ship</span>
                        <span>30,000 VNĐ</span>
                    </div>

                    <hr>

                    <div class="d-flex justify-content-between">
                        <span>Tổng</span>
                        <span id="finalTotal" class="text-danger fw-bold"></span>
                    </div>

                    <form id="checkoutForm" action="${root}/checkout" method="get">
                        <input type="hidden" name="selectedIds" id="selectedIds">
                        <button class="btn btn-danger w-100 mt-3">
                            Thanh toán
                        </button>
                    </form>

                </div>

            </div>

        </div>

    </c:if>

</div>

<script>
    const root = "${pageContext.request.contextPath}";

    function confirmDelete(productId) {
        if (confirm("Bạn có chắc chắn muốn xóa sản phẩm này không?")) {
            fetch(root + "/cart", {
                method: "POST",
                headers: {"Content-Type": "application/x-www-form-urlencoded"},
                body: "action=remove&productId=" + productId
            }).then(() => location.reload());
        }
    }

    // ===== TOTAL =====
    function updateTotal() {
        let total = 0;

        document.querySelectorAll('.cart-item').forEach(item => {
            let checkbox = item.querySelector('.item-check');

            if (checkbox.checked) {
                let price = Number(checkbox.dataset.price);
                let qty = parseInt(item.querySelector('.qty-input').value);
                total += price * qty;
            }
        });

        document.getElementById("totalPrice").innerText =
            total.toLocaleString('vi-VN') + " VNĐ";

        document.getElementById("finalTotal").innerText =
            (total + 30000).toLocaleString('vi-VN') + " VNĐ";
    }

    // ===== UPDATE QTY =====
    function updateQuantity(productId, quantity) {

        fetch(root + "/cart", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: "action=update&productId=" + productId + "&quantity=" + quantity
        })
            .then(res => res.text())
            .then(() => {
                updateCartCount();
            });
    }

    document.querySelectorAll('.cart-item').forEach(item => {

        let plus = item.querySelector('.plus');
        let minus = item.querySelector('.minus');
        let qtyBox = item.querySelector('.qty-input');
        let id = item.dataset.id;
        let price = Number(item.querySelector('.item-check').dataset.price);

        plus.onclick = () => {
            let qty = parseInt(qtyBox.value) + 1;

            updateQuantity(id, qty);
            qtyBox.value = qty;

            item.querySelector('.item-total').innerText =
                (qty * price).toLocaleString('vi-VN');

            updateTotal();
        }

        minus.onclick = () => {
            let qty = Math.max(1, parseInt(qtyBox.value) - 1);

            updateQuantity(id, qty);
            qtyBox.value = qty;

            item.querySelector('.item-total').innerText =
                (qty * price).toLocaleString('vi-VN');

            updateTotal();
        }

    });

    function updateCartCount() {
        fetch(root + "/cart", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: "action=count"
        })
            .then(res => res.text())
            .then(count => {
                document.getElementById("cart-count").innerText = count;
            });
    }

    document.getElementById("checkoutForm").onsubmit = function () {

        let selected = [];

        document.querySelectorAll('.cart-item').forEach(item => {
            let checkbox = item.querySelector('.item-check');

            if (checkbox.checked) {
                selected.push(item.dataset.id);
            }
        });

        document.getElementById("selectedIds").value = selected.join(",");

        return true;
    }


    document.querySelectorAll('.item-check').forEach(cb => {
        cb.addEventListener('change', updateTotal);
    });

    window.onload = updateTotal;

</script>

</body>
</html>