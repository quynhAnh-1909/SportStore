<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="root" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Checkout</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            background: linear-gradient(to bottom, #f6f7fb, #eef1f7);
            font-family: 'Segoe UI', sans-serif;
            color: #333;
        }

        .card {
            border-radius: 18px;
            border: none;
            box-shadow: 0 8px 24px rgba(0,0,0,0.08);
            background: #ffffff;
            overflow: hidden;
        }

        .checkout-title {
            color: #d81f19;
            font-weight: 800;
            font-size: 2rem;
            letter-spacing: 0.5px;
        }

        .form-label {
            font-size: 0.95rem;
            margin-bottom: 8px;
            color: #222;
        }

        .form-control,
        .form-select {
            height: 50px;
            border-radius: 12px;
            border: 1.5px solid #dcdfe6;
            background: #fff;
            transition: all 0.25s ease;
            font-size: 15px;
            padding-left: 14px;
        }

        textarea.form-control {
            height: auto;
            min-height: 100px;
            padding-top: 12px;
        }

        .form-control:focus,
        .form-select:focus {
            border-color: #d81f19;
            box-shadow: 0 0 0 4px rgba(216,31,25,0.12);
            background: #fff;
        }

        .form-control:not(:placeholder-shown),
        .form-select:valid {
            border-color: #20b26b;
            background: #f3fff8;
        }

        textarea.form-control:not(:placeholder-shown) {
            border-color: #20b26b;
            background: #f3fff8;
        }

        .btn-back {
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 10px;
            color: #444;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
            padding: 8px 14px;
            transition: all 0.25s ease;
        }

        .btn-back:hover {
            background: #f9f9f9;
            color: #d81f19;
            border-color: #d81f19;
        }

        .payment-box input[type="radio"] {
            display: none;
        }

        .payment-box .card {
            transition: all 0.25s ease;
            border: 2px solid #ececec;
            cursor: pointer;
            background: #fff;
            border-radius: 16px;
        }

        .payment-box:hover .card {
            transform: translateY(-4px);
            box-shadow: 0 10px 24px rgba(0,0,0,0.08);
        }

        .payment-box input[type="radio"]:checked + .card {
            border-color: #d81f19;
            background: linear-gradient(145deg, #fff1f1, #fff9f9);
            box-shadow: 0 8px 20px rgba(216,31,25,0.12);
        }

        .btn-order {
            background: linear-gradient(135deg, #ff4d4d, #d81f19);
            color: white;
            font-weight: 800;
            border: none;
            border-radius: 14px;
            padding: 14px 0;
            font-size: 1.05rem;
            transition: all 0.3s ease;
            letter-spacing: 0.5px;
        }

        .btn-order:hover {
            transform: translateY(-2px);
            background: linear-gradient(135deg, #d81f19, #b71c1c);
            box-shadow: 0 10px 24px rgba(216,31,25,0.25);
        }

        .order-summary .card-body {
            background: linear-gradient(to bottom, #ffffff, #fcfcfc);
        }

        .order-summary h5 {
            color: #222;
            font-weight: 800;
        }

        .order-summary .d-flex {
            font-size: 15px;
        }

        .total-price {
            color: #d81f19;
            font-size: 1.6rem;
            font-weight: 800;
        }

        .d-flex img {
            border-radius: 12px;
            border: 1px solid #eee;
            object-fit: cover;
        }

        #voucherSelect {
            font-weight: 600;
        }

        .default-address-box {
            margin-top: 14px;
            display: flex;
            align-items: center;
            gap: 12px;
            background: linear-gradient(145deg, #fff5f5, #fffafa);
            border: 1px solid #ffd7d7;
            padding: 14px 16px;
            border-radius: 16px;
            transition: all 0.25s ease;
        }

        .default-address-box:hover {
            border-color: #ffb5b5;
            transform: translateY(-1px);
        }

        .default-address-box input[type="checkbox"] {
            appearance: none;
            width: 24px;
            height: 24px;
            border-radius: 50%;
            border: 2px solid #d81f19;
            cursor: pointer;
            position: relative;
            background: white;
            transition: all 0.25s ease;
        }

        .default-address-box input[type="checkbox"]:checked {
            background: #d81f19;
            border-color: #d81f19;
            box-shadow: 0 0 0 4px rgba(216,31,25,0.15);
        }

        .default-address-box input[type="checkbox"]:checked::after {
            content: "✓";
            position: absolute;
            color: white;
            font-size: 13px;
            font-weight: bold;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
        }

        .default-address-label {
            margin: 0;
            font-weight: 700;
            color: #b71c1c;
            cursor: pointer;
            font-size: 15px;
        }

        hr { opacity: 0.1; }

        @media (max-width: 768px) {
            .checkout-title { font-size: 1.6rem; }
            .card-body { padding: 20px !important; }
        }
    </style>
</head>

<body>

<jsp:include page="/WEB-INF/layout/index.jsp" />

<div class="container my-5">
    <div class="row">
        <div class="col-lg-7">
            <div class="card shadow-sm border-0">
                <div class="card-body p-4">
                    <a href="${root}/cart" class="btn-back mb-3">
                        ← Quay lại giỏ hàng
                    </a>
                    <h2 class="checkout-title mb-3">
                        Thông tin thanh toán
                    </h2>

                    <form action="${root}/checkout"
                          method="post"
                          id="checkoutForm">

                        <input type="hidden"
                               name="selectedIds"
                               value="${param.selectedIds}">

                        <input type="hidden"
                               name="type"
                               value="${param.type}">

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Họ và tên người nhận</label>
                                <input type="text" name="receiverName" class="form-control"
                                       value="${sessionScope.user.fullName}" placeholder="Nhập họ và tên" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Số điện thoại</label>
                                <input type="tel" name="receiverPhone" class="form-control"
                                       value="${sessionScope.user.phoneNumber}" placeholder="Nhập số điện thoại" required>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Khu vực giao hàng</label>
                            <div class="row g-2">
                                <div class="col-md-4">
                                    <select name="province" id="province" class="form-select" required>
                                        <option value="" selected disabled>Tỉnh/Thành phố</option>
                                    </select>
                                </div>
                                <div class="col-md-4">
                                    <select name="district" id="district" class="form-select" required>
                                        <option value="" selected disabled>Quận/Huyện</option>
                                    </select>
                                </div>
                                <div class="col-md-4">
                                    <select name="ward" id="ward" class="form-select" required>
                                        <option value="" selected disabled>Phường/Xã</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Địa chỉ nhận hàng</label>
                            <input type="text"
                                   name="shippingAddress"
                                   value="${not empty user.address ? user.address : ''}"
                                   class="form-control"
                                   required
                                   placeholder="Nhập số nhà, tên đường, phường/xã...">
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Ghi chú</label>
                            <textarea name="note" class="form-control" rows="2"></textarea>
                        </div>

                        <div class="mb-3 mt-4">
                            <label class="form-label fw-bold">🎫 Chọn voucher</label>
                            <select name="voucherId" class="form-select" id="voucherSelect">
                                <option value="">-- Không sử dụng voucher --</option>
                                <c:forEach var="v" items="${vouchers}">
                                    <option value="${v.id}">${v.code}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <h5 class="fw-bold mt-4">Phương thức thanh toán</h5>
                        <div class="row g-3 mt-2">
                            <div class="col-6">
                                <label class="payment-box w-100">
                                    <input type="radio" name="paymentMethod" value="COD" checked>
                                    <div class="card p-3 text-center">
                                        💵
                                        <div class="fw-bold mt-2">Thanh toán khi nhận hàng</div>
                                    </div>
                                </label>
                            </div>
                            <div class="col-6">
                                <label class="payment-box w-100">
                                    <input type="radio" name="paymentMethod" value="VNPAY">
                                    <div class="card p-3 text-center">
                                        💳
                                        <div class="fw-bold mt-2">Thanh toán VNPay</div>
                                    </div>
                                </label>
                            </div>
                        </div>

                        <input type="hidden" name="shippingFee" id="shippingFeeInput" value="30000">

                        <button type="submit" class="btn btn-order w-100 mt-4">
                            🛒 XÁC NHẬN ĐẶT HÀNG
                        </button>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-lg-5">
            <div class="card shadow-sm order-summary">
                <div class="card-body p-4">
                    <h5 class="fw-bold border-bottom pb-2">Đơn hàng của bạn</h5>
                    <c:set var="total" value="0" />

                    <c:forEach var="item" items="${selectedItems}">
                        <div class="d-flex align-items-center mb-3">
                            <img src="${root}/resources/${item.product.imageUrl}" width="50" height="50" style="object-fit: cover">
                            <div class="ms-3 flex-grow-1">
                                <b>${item.product.name}</b><br>
                                SL: ${item.quantity}
                            </div>
                            <div>
                                <fmt:formatNumber value="${item.product.price * item.quantity}" type="number" /> ₫
                            </div>
                        </div>
                        <c:set var="total" value="${total + (item.product.price * item.quantity)}" />
                    </c:forEach>

                    <hr>

                    <div class="d-flex justify-content-between">
                        <span>Tạm tính</span>
                        <span id="subtotalPrice">
                            <fmt:formatNumber value="${total}" type="number" /> ₫
                        </span>
                    </div>

                    <div class="d-flex justify-content-between mt-2">
                        <span>Giảm giá</span>
                        <span class="text-danger" id="discountPrice">- 0 ₫</span>
                    </div>

                    <div class="d-flex justify-content-between mt-2">
                        <span>Phí giao hàng</span>
                        <span id="shippingFeeDisplay">30,000 ₫</span>
                    </div>

                    <hr>

                    <div class="d-flex justify-content-between fw-bold mt-3">
                        <span>TỔNG CỘNG</span>
                        <span class="total-price" id="finalPrice">
                            <fmt:formatNumber value="${total + 30000}" type="number" /> ₫
                        </span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/footer.jsp" />

<script>
    let subtotal = parseFloat("${total}");
    let shippingFee = 30000;
    let discount = 0;
    const GHN_TOKEN = "2eb2d430-50e9-11f1-a973-aee5264794df";

    const voucherSelect = document.getElementById("voucherSelect");
    const discountPrice = document.getElementById("discountPrice");
    const shippingFeeDisplay = document.getElementById("shippingFeeDisplay");
    const finalPrice = document.getElementById("finalPrice");
    const shippingFeeInput = document.getElementById("shippingFeeInput");
    const provinceSelect = document.getElementById('province');
    const districtSelect = document.getElementById('district');
    const wardSelect = document.getElementById('ward');
    let selectedDistrictId = null;
    let selectedWardCode = null;
    let shipTimeout = null;

    const form = document.getElementById("checkoutForm");

    const districtInput = document.createElement("input");
    districtInput.type = "hidden";
    districtInput.name = "districtId";
    form.appendChild(districtInput);

    const wardInput = document.createElement("input");
    wardInput.type = "hidden";
    wardInput.name = "wardCode";
    form.appendChild(wardInput);


    function resetSelect(select, text) {
        select.innerHTML = "";
        const opt = new Option("-- " + text + " --", "");
        opt.disabled = true;
        opt.selected = true;
        select.add(opt);
    }


    fetch("https://dev-online-gateway.ghn.vn/shiip/public-api/master-data/province", {
        headers: { "Token": GHN_TOKEN }
    })
            .then(r => r.json())
            .then(res => {
                const provinces = res.data || [];
                provinces.forEach(p => {
                    const opt = new Option(p.ProvinceName, p.ProvinceName);
                    opt.dataset.id = p.ProvinceID;
                    provinceSelect.add(opt);
                });
            })
            .catch(err => console.error("Lỗi tải Tỉnh thành:", err));

    provinceSelect.addEventListener("change", function () {
        resetSelect(districtSelect, "Quận/Huyện");
        resetSelect(wardSelect, "Phường/Xã");

        const provinceId = this.selectedOptions[0].dataset.id;
        if (!provinceId) return;

        fetch("https://dev-online-gateway.ghn.vn/shiip/public-api/master-data/district?province_id=" + provinceId, {
            headers: { "Token": GHN_TOKEN }
        })
                .then(r => r.json())
                .then(res => {
                    const districts = res.data || [];
                    districts.forEach(d => {
                        const opt = new Option(d.DistrictName, d.DistrictName);
                        opt.dataset.id = d.DistrictID;
                        districtSelect.add(opt);
                    });
                });
    });

    districtSelect.addEventListener("change", function () {
        resetSelect(wardSelect, "Phường/Xã");

        const districtId = this.selectedOptions[0].dataset.id;
        if (!districtId) return;

        selectedDistrictId = districtId;
        districtInput.value = districtId;

        fetch("https://dev-online-gateway.ghn.vn/shiip/public-api/master-data/ward?district_id=" + districtId, {
            headers: { "Token": GHN_TOKEN }
        })
                .then(r => r.json())
                .then(res => {
                    const wards = res.data || [];
                    wards.forEach(w => {
                        const opt = new Option(w.WardName, w.WardCode);
                        opt.dataset.code = w.WardCode;
                        wardSelect.add(opt);
                    });
                });
    });

    wardSelect.addEventListener("change", function () {
        selectedWardCode = this.value;
        wardInput.value = selectedWardCode;
        triggerShipping();
    });

    // . SHIPPING API
    function triggerShipping() {
        if (!selectedDistrictId || !selectedWardCode) return;

        clearTimeout(shipTimeout);

        shipTimeout = setTimeout(() => {
            fetch("${root}/api/get-shipping-fee?"
                    + "districtId=" + selectedDistrictId
                    + "&wardCode=" + selectedWardCode
                    + "&subtotal=" + subtotal
            )
                    .then(r => r.json())
                    .then(res => {
                        if (res && (res.data || res.total)) {
                            shippingFee = res.data ? (res.data.total ?? res.data) : res.total;
                        } else {
                            shippingFee = res || 30000;
                        }
                        updateTotal();
                    })
                    .catch(() => {
                        shippingFee = 30000;
                        updateTotal();
                    });
        }, 400);
    }

    //  UPDATE TOTAL
    function updateTotal() {
        discount = 0;
        const voucherId = voucherSelect.value;

        <c:forEach var="v" items="${vouchers}">
        if (voucherId === "${v.id}") {
            const type = "${v.discountType}";
            const value = ${v.discountValue};
            const max = ${v.maxDiscount};
            const min = ${v.minOrderValue};

            if (subtotal >= min) {
                if (type === "PERCENT") {
                    discount = (subtotal * value) / 100;
                    if (discount > max) discount = max;
                } else {
                    discount = value;
                }
            }
        }
        </c:forEach>

        const total = Math.max(0, subtotal - discount + shippingFee);

        discountPrice.innerText = "- " + discount.toLocaleString("vi-VN") + " ₫";
        shippingFeeDisplay.innerText = shippingFee.toLocaleString("vi-VN") + " ₫";
        finalPrice.innerText = total.toLocaleString("vi-VN") + " ₫";

        shippingFeeInput.value = shippingFee;
    }


    voucherSelect.addEventListener("change", updateTotal);


    form.addEventListener("submit", function (e) {
        shippingFeeInput.value = shippingFee;
    });

</script>
</body>
</html>