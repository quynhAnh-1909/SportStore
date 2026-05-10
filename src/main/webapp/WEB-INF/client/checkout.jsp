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
            background: #f2f2f7;
            font-family: 'Segoe UI', sans-serif;
        }

        /* CARD CHUNG */
        .card {
            border-radius: 12px;
            border: none;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            background: #ffffff;
        }

        /* TITLE */
        .checkout-title {
            color: #d81f19;
            font-weight: 700;
            font-size: 1.8rem;
        }

        /* FORM INPUT & SELECT */
        .form-control, .form-select {
            border-radius: 8px;
            border: 1px solid #ddd;
            transition: all 0.3s;
        }
        .form-control:focus, .form-select:focus {
            border-color: #d81f19;
            box-shadow: 0 0 0 3px rgba(216,31,25,0.2);
        }

        /* PAYMENT BOX */
        .payment-box input[type="radio"] {
            display: none;
        }
        .payment-box .card {
            transition: 0.3s;
            border: 2px solid #eee;
            cursor: pointer;
            background: #fff;
        }
        .payment-box:hover .card {
            transform: translateY(-3px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.15);
        }
        .payment-box input[type="radio"]:checked + .card {
            border-color: #d81f19;
            background: linear-gradient(145deg, #ffe5e5, #fff0f0);
        }

        /* BACK BUTTON */
        .btn-back {
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 8px;
            color: #333;
            font-weight: 500;
            text-decoration: none;
            display: inline-block;
            padding: 6px 12px;
        }
        .btn-back:hover {
            background: #f8f8f8;
            color: #000;
        }

        /* ORDER SUMMARY */
        .order-summary .card-body {
            background: #fff;
        }
        .total-price {
            color: #d81f19;
            font-size: 1.3rem;
            font-weight: bold;
        }

        /* NÚT THANH TOÁN */
        .btn-order {
            background: linear-gradient(135deg, #ff4d4d, #d81f19);
            color: white;
            font-weight: 700;
            border: none;
            border-radius: 8px;
            padding: 12px 0;
            font-size: 1.1rem;
            transition: all 0.3s ease;
        }
        .btn-order:hover {
            background: linear-gradient(135deg, #d81f19, #b71c1c);
            box-shadow: 0 6px 15px rgba(0,0,0,0.2);
        }

        /* HÌNH ẢNH SẢN PHẨM */
        .d-flex img {
            border-radius: 6px;
            border: 1px solid #eee;
        }

        /* TỔNG HỢP GIỎ HÀNG */
        .d-flex justify-content-between span {
            font-size: 1rem;
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
                    <h2 class="checkout-title mb-3">Thông tin thanh toán</h2>

                    <form action="${root}/checkout" method="post">
                        <input type="hidden" name="selectedIds" value="${param.selectedIds}">

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
                            <label class="form-label fw-bold">Địa chỉ nhận hàng (Số nhà, tên đường...)</label>
                            <input type="text" name="specificAddress" class="form-control"
                                   value="${sessionScope.user.address}" placeholder="VD: 123 Đường Lê Lợi, Tòa nhà ABC..." required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Ghi chú (Tùy chọn)</label>
                            <textarea name="note" class="form-control" rows="2" placeholder="Ghi chú thêm về thời gian giao hàng..."></textarea>
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
                                <b>${item.product.name}</b> <br> SL: ${item.quantity}
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
                        <span><fmt:formatNumber value="${total}" type="number" /> ₫</span>
                    </div>
                    <div class="d-flex justify-content-between mt-2">
                        <span>Phí giao hàng</span>
                        <span>30,000 ₫</span>
                    </div>
                    <hr>
                    <div class="d-flex justify-content-between fw-bold mt-3">
                        <span>TỔNG CỘNG</span>
                        <span class="total-price">
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
    document.addEventListener('DOMContentLoaded', function() {
        const provinceSelect = document.getElementById('province');
        const districtSelect = document.getElementById('district');
        const wardSelect = document.getElementById('ward');

        // Lấy dữ liệu API cấp 3 (Tỉnh > Huyện > Xã)
        fetch('https://provinces.open-api.vn/api/?depth=3')
                .then(response => response.json())
                .then(data => {
                    let provinces = data;

                    // Đổ dữ liệu Tỉnh/Thành
                    provinces.forEach(p => {
                        // value và text đều là tên tỉnh (để submit về backend lưu dạng chữ)
                        let option = new Option(p.name, p.name);
                        option.dataset.code = p.code; // Lưu mã code để truy xuất tuyến dưới
                        provinceSelect.options.add(option);
                    });

                    // Xử lý sự kiện khi đổi Tỉnh/Thành
                    provinceSelect.addEventListener('change', function() {
                        districtSelect.length = 1; // Xóa danh sách quận cũ
                        wardSelect.length = 1;     // Xóa danh sách phường cũ

                        const selectedOption = this.options[this.selectedIndex];
                        if(!selectedOption.dataset.code) return;

                        const provinceCode = selectedOption.dataset.code;
                        const selectedProvince = provinces.find(p => p.code == provinceCode);

                        if (selectedProvince && selectedProvince.districts) {
                            selectedProvince.districts.forEach(d => {
                                let option = new Option(d.name, d.name);
                                option.dataset.code = d.code;
                                districtSelect.options.add(option);
                            });
                        }
                    });

                    // Xử lý sự kiện khi đổi Quận/Huyện
                    districtSelect.addEventListener('change', function() {
                        wardSelect.length = 1; // Xóa danh sách phường cũ

                        const selectedProvOption = provinceSelect.options[provinceSelect.selectedIndex];
                        const selectedDistOption = this.options[this.selectedIndex];

                        if(!selectedProvOption.dataset.code || !selectedDistOption.dataset.code) return;

                        const provinceCode = selectedProvOption.dataset.code;
                        const districtCode = selectedDistOption.dataset.code;

                        const selectedProvince = provinces.find(p => p.code == provinceCode);
                        const selectedDistrict = selectedProvince.districts.find(d => d.code == districtCode);

                        if (selectedDistrict && selectedDistrict.wards) {
                            selectedDistrict.wards.forEach(w => {
                                let option = new Option(w.name, w.name);
                                wardSelect.options.add(option);
                            });
                        }
                    });
                })
                .catch(error => console.error("Lỗi khi tải dữ liệu tỉnh thành:", error));
    });
</script>

</body>
</html>