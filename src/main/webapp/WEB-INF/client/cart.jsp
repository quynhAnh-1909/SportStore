<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="root" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Giỏ hàng</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">

    <style>
        body {
            background: #f5f5f5;
            font-family: 'Segoe UI', sans-serif;
        }
        .cart-header {
            background: rgba(255, 0, 0, 0.85);
            color: white;
            font-weight: bold;
            padding: 10px 0;
            border-radius: 5px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.2);
            backdrop-filter: brightness(1.1) contrast(1.2);
        }
        .cart-count {
            position: absolute;
            top: -5px;
            right: -8px;
            background-color: #ff0000;
            color: white;
            border-radius: 50%;
            padding: 2px 6px;
            font-size: 12px;
            font-weight: bold;
            line-height: 1;
            border: 2px solid white;
            min-width: 18px;
            text-align: center;
        }
        .product-name {
            font-size: 14px;
            line-height: 1.4;
        }
        .price {
            color: #d81f19;
            font-weight: bold;
        }
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
        .remove-btn {
            color: #999;
            font-size: 18px;
        }
        .remove-btn:hover {
            color: #d81f19;
        }
        .cart-summary {
            background: #fff;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }
        .total-price {
            color: #d81f19;
            font-size: 20px;
            font-weight: bold;
        }
        .checkout-btn {
            background-color: #d81f19 !important;
            color: white !important;
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
            background-color: #b71c1c!important;
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }
        .btn-back {
            border-radius: 8px;
            border: 1px solid #ddd;
        }
        .btn-back:hover {
            background: #eee;
        }
        .item-check, #checkAll {
            width: 18px;
            height: 18px;
            cursor: pointer;
            accent-color: #a855f7;
        }
        .cart-container {
            border-radius: 12px;
        }
        .product-image {
            width: 70px;
            height: 70px;
            object-fit: contain;
        }
        .delete-btn {
            width: 40px;
            height: 40px;
            padding: 0;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .cart-item {
            flex-wrap: nowrap !important;
            width: 100%;
            min-height: 110px;
            padding: 0 10px;
        }
        .cart-col {
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100%;
        }
        .product-col {
            display: flex;
            align-items: center;
            justify-content: flex-start !important;
        }
        .delete-col {
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .cart-check {
            width: 6%;
            display: flex;
            justify-content: center;
        }
        .cart-product {
            width: 34%;
            display: flex;
            align-items: center;
        }
        .cart-price {
            width: 18%;
            display: flex;
            justify-content: center;
            font-weight: bold;
            color: #dc3545;
        }
        .cart-qty {
            width: 18%;
            display: flex;
            justify-content: center;
        }
        .cart-total {
            width: 16%;
            display: flex;
            justify-content: center;
            font-weight: bold;
            color: #dc3545;
        }
        .cart-delete {
            width: 8%;
            display: flex;
            justify-content: center;
        }
        .delete-btn {
            width: 42px;
            height: 42px;
        }
        .product-image {
            width:70px;
            height:70px;
            object-fit:contain;
            transition:0.3s;
            cursor:pointer;
        }
        .product-image:hover {
            transform:scale(1.08);
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
            <div class="col-md-9">
                <div class="card p-3">
                    <div class="row fw-bold text-white bg-danger p-2 rounded text-center align-items-center">
                        <div class="col-md-1 text-center">
                            <input type="checkbox" id="checkAll">
                        </div>
                        <div class="col-md-4 text-start">Sản phẩm</div>
                        <div class="col-md-2">Đơn giá</div>
                        <div class="col-md-2">Số lượng</div>
                        <div class="col-md-2">Thành tiền</div>
                        <div class="col-md-1">Xóa</div>
                    </div>

                    <c:forEach var="item" items="${sessionScope.cart}">
                        <div class="d-flex mt-3 text-center cart-item align-items-center border-bottom"
                             data-id="${item.product.id}"
                             data-stock="${item.product.stockQuantity}">

                            <div class="cart-check cart-col">
                                <input type="checkbox" class="item-check" data-price="${item.product.price}" checked>
                            </div>

                            <div class="cart-product product-col">
                                <a href="${root}/productDetail?id=${item.product.id}">
                                    <img src="${root}/resources/${item.product.imageUrl}" class="product-image">
                                </a>
                                <div class="ms-3 product-name text-start">
                                    <a href="${root}/productDetail?id=${item.product.id}" class="text-decoration-none text-dark fw-semibold">
                                            ${item.product.name}
                                    </a>
                                    <div class="text-muted small mt-1">Kho còn: ${item.product.stockQuantity}</div>
                                </div>
                            </div>

                            <div class="cart-price cart-col text-danger fw-bold">
                                <fmt:formatNumber value="${item.product.price}" /> ₫
                            </div>

                            <div class="cart-qty cart-col">
                                <div class="qty-control">
                                    <button type="button" class="qty-btn minus">-</button>
                                    <input type="text" value="${item.quantity}" class="qty-input" readonly>
                                    <button type="button" class="qty-btn plus">+</button>
                                </div>
                            </div>

                            <div class="cart-total cart-col text-danger fw-bold item-total">
                                <fmt:formatNumber value="${item.product.price * item.quantity}" /> ₫
                            </div>

                            <div class="cart-delete delete-col">
                                <button onclick="confirmDelete(${item.product.id})" class="btn btn-danger delete-btn">
                                    X
                                </button>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <div class="col-md-3">
                <div class="card p-3">
                    <h5>Tóm tắt</h5>
                    <hr>
                    <div class="d-flex justify-content-between">
                        <span>Tạm tính</span>
                        <span id="totalPrice">0 ₫</span>
                    </div>
                    <div class="d-flex justify-content-between mt-2">
                        <span>Phí ship Tạm Tính</span>
                        <span>30,000 ₫</span>
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
                    <c:if test="${sessionScope.userRole == 'ADMIN'}">
                        <div class="alert alert-warning mt-3 text-center">
                            Tài khoản Admin không được phép mua hàng.
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </c:if>
</div>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
    const root = "${pageContext.request.contextPath}";

    // 1. Hộp thoại nổi xác nhận xóa mặt hàng (Popup đổ ra giữa màn hình)
    function confirmDelete(productId) {
        Swal.fire({
            title: 'Xác nhận xóa?',
            text: "Bạn có chắc chắn muốn bỏ sản phẩm này ra khỏi giỏ hàng?",
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: '#dc3545', // màu đỏ bootstrap tương ứng giao diện
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Đồng ý xóa',
            cancelButtonText: 'Hủy bỏ',
            customClass: {
                popup: 'rounded-4'
            }
        }).then((result) => {
            if (result.isConfirmed) {
                fetch(root + "/cart", {
                    method: "POST",
                    headers: {"Content-Type": "application/x-www-form-urlencoded"},
                    body: "action=remove&productId=" + productId
                }).then(() => location.reload());
            }
        });
    }

    function updateTotal() {
        let total = 0;
        let checkedCount = 0;

        document.querySelectorAll('.cart-item').forEach(item => {
            let checkbox = item.querySelector('.item-check');
            if (checkbox.checked) {
                let itemTotalText = item.querySelector('.item-total').innerText;
                let itemTotal = Number(itemTotalText.replace(/[^\d]/g, ""));
                total += itemTotal;
                checkedCount++;
            }
        });

        let shipping = checkedCount > 0 ? 30000 : 0;
        document.getElementById("totalPrice").innerText = total.toLocaleString('vi-VN') + " ₫";
        document.getElementById("finalTotal").innerText = (total + shipping).toLocaleString('vi-VN') + " ₫";
    }

    function updateQuantity(productId, quantity) {
        fetch(root + "/cart", {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded" },
            body: "action=update&productId=" + productId + "&quantity=" + quantity
        })
                .then(res => res.text())
                .then(() => {
                    updateCartCount();
                    updateTotal();
                });
    }

    document.querySelectorAll('.cart-item').forEach(item => {
        let plus = item.querySelector('.plus');
        let minus = item.querySelector('.minus');
        let qtyBox = item.querySelector('.qty-input');
        let id = item.dataset.id;
        let maxStock = parseInt(item.dataset.stock) || 0;
        let price = Number(item.querySelector('.item-check').dataset.price);

        let currentQty = parseInt(qtyBox.value);
        if (currentQty > maxStock) {
            currentQty = maxStock;
            qtyBox.value = currentQty;
            let itemTotal = currentQty * price;
            item.querySelector('.item-total').innerText = itemTotal.toLocaleString('vi-VN') + " ₫";
            updateQuantity(id, currentQty);
        }
        plus.onclick = () => {
            let qty = parseInt(qtyBox.value) + 1;

            if (qty > maxStock) {
                Swal.fire({
                    title: 'Số lượng không hợp lệ',
                    text: 'Xin lỗi, sản phẩm này hiện tại chỉ còn tối đa ' + maxStock + ' mặt hàng trong kho!',
                    icon: 'warning',
                    confirmButtonColor: '#dc3545',
                    confirmButtonText: 'Đã hiểu'
                });
                return;
            }

            updateQuantity(id, qty);
            qtyBox.value = qty;
            let itemTotal = qty * price;
            item.querySelector('.item-total').innerText = itemTotal.toLocaleString('vi-VN') + " ₫";
            updateTotal();
        }

        minus.onclick = () => {
            let qty = Math.max(1, parseInt(qtyBox.value) - 1);
            updateQuantity(id, qty);
            qtyBox.value = qty;
            let itemTotal = qty * price;
            item.querySelector('.item-total').innerText = itemTotal.toLocaleString('vi-VN') + " ₫";
            updateTotal();
        }
    });

    function updateCartCount() {
        fetch(root + "/cart", {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded" },
            body: "action=count"
        })
                .then(res => res.text())
                .then(count => {
                    document.getElementById("cart-count").innerText = count;
                });
    }

    document.getElementById("checkoutForm").onsubmit = function (e) {
        let selected = [];
        document.querySelectorAll('.cart-item').forEach(item => {
            let checkbox = item.querySelector('.item-check');
            if (checkbox.checked) {
                selected.push(item.dataset.id);
            }
        });

        if (selected.length === 0) {
            e.preventDefault();
            Swal.fire({
                title: 'Chưa chọn sản phẩm',
                text: 'Vui lòng tích chọn ít nhất một sản phẩm trước khi tiến hành thanh toán!',
                icon: 'info',
                confirmButtonColor: '#dc3545',
                confirmButtonText: 'Quay lại chọn'
            });
            return false;
        }

        document.getElementById("selectedIds").value = selected.join(",");
        return true;
    }

    document.querySelectorAll('.item-check').forEach(cb => {
        cb.addEventListener('change', updateTotal);
    });

    const checkAll = document.getElementById("checkAll");
    const itemChecks = document.querySelectorAll(".item-check");

    checkAll.addEventListener("change", function () {
        itemChecks.forEach(cb => {
            cb.checked = this.checked;
        });
        updateTotal();
    });

    itemChecks.forEach(cb => {
        cb.addEventListener("change", function () {
            checkAll.checked = [...itemChecks].every(item => item.checked);
            updateTotal();
        });
    });

    window.onload = () => {
        updateTotal();
        if (checkAll) checkAll.checked = true;
    };
</script>
</body>
</html>