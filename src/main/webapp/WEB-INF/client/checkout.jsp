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

        /* CARD */

        .card {
            border-radius: 18px;
            border: none;
            box-shadow: 0 8px 24px rgba(0,0,0,0.08);
            background: #ffffff;
            overflow: hidden;
        }

        /* TITLE */

        .checkout-title {
            color: #d81f19;
            font-weight: 800;
            font-size: 2rem;
            letter-spacing: 0.5px;
        }

        /* LABEL */

        .form-label {
            font-size: 0.95rem;
            margin-bottom: 8px;
            color: #222;
        }

        /* INPUT + SELECT */

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

        /* FOCUS */

        .form-control:focus,
        .form-select:focus {

            border-color: #d81f19;

            box-shadow: 0 0 0 4px rgba(216,31,25,0.12);

            background: #fff;
        }

        /* ĐÃ NHẬP */

        .form-control:not(:placeholder-shown),
        .form-select:valid {

            border-color: #20b26b;

            background: #f3fff8;
        }

        textarea.form-control:not(:placeholder-shown) {

            border-color: #20b26b;

            background: #f3fff8;
        }

        /* BUTTON BACK */

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

        /* PAYMENT */

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

            background: linear-gradient(
                    145deg,
                    #fff1f1,
                    #fff9f9
            );

            box-shadow: 0 8px 20px rgba(216,31,25,0.12);
        }

        /* BUTTON ORDER */

        .btn-order {

            background: linear-gradient(
                    135deg,
                    #ff4d4d,
                    #d81f19
            );

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

            background: linear-gradient(
                    135deg,
                    #d81f19,
                    #b71c1c
            );

            box-shadow: 0 10px 24px rgba(216,31,25,0.25);
        }

        /* SUMMARY */

        .order-summary .card-body {

            background: linear-gradient(
                    to bottom,
                    #ffffff,
                    #fcfcfc
            );
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

        /* PRODUCT */

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

            background: linear-gradient(
                    145deg,
                    #fff5f5,
                    #fffafa
            );

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

        /* HR */

        hr {

            opacity: 0.1;
        }

        /* RESPONSIVE */

        @media (max-width: 768px) {

            .checkout-title {
                font-size: 1.6rem;
            }

            .card-body {
                padding: 20px !important;
            }
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

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">
                                    Họ và tên người nhận
                                </label>

                                <input type="text"
                                       name="receiverName"
                                       class="form-control"
                                       value="${sessionScope.user.fullName}"
                                       placeholder="Nhập họ và tên"
                                       required>
                            </div>

                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">
                                    Số điện thoại
                                </label>

                                <input type="tel"
                                       name="receiverPhone"
                                       class="form-control"
                                       value="${sessionScope.user.phoneNumber}"
                                       placeholder="Nhập số điện thoại"
                                       required>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">
                                Khu vực giao hàng
                            </label>

                            <div class="row g-2">

                                <div class="col-md-4">
                                    <select name="province"
                                            id="province"
                                            class="form-select"
                                            required>

                                        <option value=""
                                                selected
                                                disabled>
                                            Tỉnh/Thành phố
                                        </option>

                                    </select>
                                </div>

                                <div class="col-md-4">
                                    <select name="district"
                                            id="district"
                                            class="form-select"
                                            required>

                                        <option value=""
                                                selected
                                                disabled>
                                            Quận/Huyện
                                        </option>

                                    </select>
                                </div>

                                <div class="col-md-4">
                                    <select name="ward"
                                            id="ward"
                                            class="form-select"
                                            required>

                                        <option value=""
                                                selected
                                                disabled>
                                            Phường/Xã
                                        </option>

                                    </select>
                                </div>

                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">
                                Địa chỉ nhận hàng
                            </label>

                            <input type="text"
                                   name="specificAddress"
                                   class="form-control"
                                   value="${sessionScope.user.address}"
                                   placeholder="VD: 123 Lê Lợi..."
                                   required>
                            <div class="default-address-box">

                                <input type="checkbox"
                                       name="saveDefaultAddress"
                                       id="saveDefaultAddress">

                                <label for="saveDefaultAddress"
                                       class="default-address-label">

                                    Đặt làm địa chỉ mặc định

                                </label>

                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">
                                Ghi chú
                            </label>

                            <textarea name="note"
                                      class="form-control"
                                      rows="2"></textarea>
                        </div>
                        <!-- VOUCHER -->
                        <div class="mb-3 mt-4">

                            <label class="form-label fw-bold">
                                🎫 Chọn voucher
                            </label>

                            <select name="voucherId"
                                    class="form-select"
                                    id="voucherSelect">

                                <option value="">
                                    -- Không sử dụng voucher --
                                </option>

                                <c:forEach var="v" items="${vouchers}">
                                    <option value="${v.id}">
                                            ${v.code}
                                    </option>
                                </c:forEach>

                            </select>
                        </div>
                        <h5 class="fw-bold mt-4">
                            Phương thức thanh toán
                        </h5>

                        <div class="row g-3 mt-2">

                            <div class="col-6">
                                <label class="payment-box w-100">

                                    <input type="radio"
                                           name="paymentMethod"
                                           value="COD"
                                           checked>

                                    <div class="card p-3 text-center">
                                        💵
                                        <div class="fw-bold mt-2">
                                            Thanh toán khi nhận hàng
                                        </div>
                                    </div>

                                </label>
                            </div>

                            <div class="col-6">
                                <label class="payment-box w-100">

                                    <input type="radio"
                                           name="paymentMethod"
                                           value="VNPAY">

                                    <div class="card p-3 text-center">
                                        💳
                                        <div class="fw-bold mt-2">
                                            Thanh toán VNPay
                                        </div>
                                    </div>

                                </label>
                            </div>

                        </div>

                        <button type="submit"
                                class="btn btn-order w-100 mt-4">

                            🛒 XÁC NHẬN ĐẶT HÀNG

                        </button>

                    </form>

                </div>
            </div>
        </div>

        <div class="col-lg-5">

            <div class="card shadow-sm order-summary">

                <div class="card-body p-4">

                    <h5 class="fw-bold border-bottom pb-2">
                        Đơn hàng của bạn
                    </h5>

                    <c:set var="total" value="0" />

                    <c:forEach var="item" items="${selectedItems}">

                        <div class="d-flex align-items-center mb-3">

                            <img src="${root}/resources/${item.product.imageUrl}"
                                 width="50"
                                 height="50"
                                 style="object-fit: cover">

                            <div class="ms-3 flex-grow-1">
                                <b>${item.product.name}</b>
                                <br>
                                SL: ${item.quantity}
                            </div>

                            <div>
                                <fmt:formatNumber
                                        value="${item.product.price * item.quantity}"
                                        type="number" /> ₫
                            </div>

                        </div>

                        <c:set var="total"
                               value="${total + (item.product.price * item.quantity)}" />

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

                        <span class="text-danger"
                              id="discountPrice">
                            - 0 ₫
                        </span>
                    </div>

                    <div class="d-flex justify-content-between mt-2">
                        <span>Phí giao hàng</span>

                        <span>
                            30,000 ₫
                        </span>
                    </div>

                    <hr>

                    <div class="d-flex justify-content-between fw-bold mt-3">

                        <span>TỔNG CỘNG</span>

                        <span class="total-price"
                              id="finalPrice">

                            <fmt:formatNumber
                                    value="${total + 30000}"
                                    type="number" /> ₫

                        </span>

                    </div>

                </div>
            </div>
        </div>

    </div>
</div>

<jsp:include page="/footer.jsp" />

<script>

    const subtotal = ${total};
    const shippingFee = 30000;

    const voucherSelect =
            document.getElementById("voucherSelect");

    const discountPrice =
            document.getElementById("discountPrice");

    const finalPrice =
            document.getElementById("finalPrice");

    const vouchers = {

        <c:forEach var="v" items="${vouchers}">
        "${v.id}": {
            type: "${v.discountType}",
            value: ${v.discountValue},
            maxDiscount: ${v.maxDiscount},
            minOrder: ${v.minOrderValue}
        },
        </c:forEach>

    };

    function formatMoney(number) {

        return number.toLocaleString('vi-VN') + ' ₫';
    }

    function updateTotal() {

        let discount = 0;

        const voucherId =
                voucherSelect.value;

        if (voucherId && vouchers[voucherId]) {

            const v =
                    vouchers[voucherId];

            if (subtotal >= v.minOrder) {

                if (v.type === "PERCENT") {

                    discount =
                            subtotal * v.value / 100;

                    if (discount > v.maxDiscount) {

                        discount =
                                v.maxDiscount;
                    }

                } else if (v.type === "FIXED") {

                    discount =
                            v.value;
                }
            }
        }

        let finalTotal =
                subtotal
                - discount
                + shippingFee;

        if (finalTotal < 0) {

            finalTotal = 0;
        }

        discountPrice.innerText =
                "- " + formatMoney(discount);

        finalPrice.innerText =
                formatMoney(finalTotal);
    }

    voucherSelect.addEventListener(
            "change",
            updateTotal
    );

</script>

<script>
    document.addEventListener('DOMContentLoaded', function() {

        const provinceSelect =
                document.getElementById('province');

        const districtSelect =
                document.getElementById('district');

        const wardSelect =
                document.getElementById('ward');

        fetch('https://provinces.open-api.vn/api/?depth=3')

                .then(response => response.json())

                .then(data => {

                    let provinces = data;

                    provinces.forEach(p => {

                        let option =
                                new Option(p.name, p.name);

                        option.dataset.code =
                                p.code;

                        provinceSelect.options.add(option);
                    });

                    provinceSelect.addEventListener(
                            'change',
                            function() {

                                districtSelect.length = 1;
                                wardSelect.length = 1;

                                const selectedOption =
                                        this.options[this.selectedIndex];

                                if(!selectedOption.dataset.code)
                                    return;

                                const provinceCode =
                                        selectedOption.dataset.code;

                                const selectedProvince =
                                        provinces.find(
                                                p => p.code == provinceCode
                                        );

                                if (selectedProvince
                                        && selectedProvince.districts) {

                                    selectedProvince.districts.forEach(d => {

                                        let option =
                                                new Option(d.name, d.name);

                                        option.dataset.code =
                                                d.code;

                                        districtSelect.options.add(option);
                                    });
                                }
                            });

                    districtSelect.addEventListener(
                            'change',
                            function() {

                                wardSelect.length = 1;

                                const selectedProvOption =
                                        provinceSelect.options[
                                                provinceSelect.selectedIndex
                                                ];

                                const selectedDistOption =
                                        this.options[this.selectedIndex];

                                if(!selectedProvOption.dataset.code
                                        || !selectedDistOption.dataset.code)
                                    return;

                                const provinceCode =
                                        selectedProvOption.dataset.code;

                                const districtCode =
                                        selectedDistOption.dataset.code;

                                const selectedProvince =
                                        provinces.find(
                                                p => p.code == provinceCode
                                        );

                                const selectedDistrict =
                                        selectedProvince.districts.find(
                                                d => d.code == districtCode
                                        );

                                if (selectedDistrict
                                        && selectedDistrict.wards) {

                                    selectedDistrict.wards.forEach(w => {

                                        let option =
                                                new Option(w.name, w.name);

                                        wardSelect.options.add(option);
                                    });
                                }
                            });
                })

                .catch(error =>
                        console.error(
                                "Lỗi khi tải dữ liệu tỉnh thành:",
                                error
                        )
                );
    });
</script>

</body>
</html>