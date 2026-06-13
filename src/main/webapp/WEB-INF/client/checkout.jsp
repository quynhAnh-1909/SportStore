<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="root" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Checkout - Thanh toán đơn hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: linear-gradient(to bottom, #f6f7fb, #eef1f7); font-family: 'Segoe UI', sans-serif; color: #333; }
        .card { border-radius: 18px; border: none; box-shadow: 0 8px 24px rgba(0,0,0,0.08); background: #ffffff; overflow: hidden; }
        .checkout-title { color: #d81f19; font-weight: 800; font-size: 2rem; letter-spacing: 0.5px; }
        .form-label { font-size: 0.95rem; margin-bottom: 8px; color: #222; }
        .form-control, .form-select { height: 50px; border-radius: 12px; border: 1.5px solid #dcdfe6; background: #fff; font-size: 15px; padding-left: 14px; }
        .form-control:focus, .form-select:focus { border-color: #d81f19; box-shadow: 0 0 0 4px rgba(216,31,25,0.12); }
        .btn-back { background: #fff; border: 1px solid #ddd; border-radius: 10px; color: #444; font-weight: 600; text-decoration: none; display: inline-block; padding: 8px 14px; }
        .btn-back:hover { color: #d81f19; border-color: #d81f19; }
        .payment-box input[type="radio"] { display: none; }
        .payment-box .card { transition: all 0.25s ease; border: 2px solid #ececec; cursor: pointer; border-radius: 16px; }
        .payment-box input[type="radio"]:checked + .card { border-color: #d81f19; background: linear-gradient(145deg, #fff1f1, #fff9f9); box-shadow: 0 8px 20px rgba(216,31,25,0.12); }
        .btn-order { background: linear-gradient(135deg, #ff4d4d, #d81f19); color: white; font-weight: 800; border: none; border-radius: 14px; padding: 14px 0; font-size: 1.05rem; }
        .total-price { color: #d81f19; font-size: 1.6rem; font-weight: 800; }
        .d-flex img { border-radius: 12px; border: 1px solid #eee; object-fit: cover; }
        hr { opacity: 0.1; }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/layout/index.jsp" />

<div class="container my-5">
    <div class="row">
        <div class="col-lg-7">
            <div class="card shadow-sm border-0">
                <div class="card-body p-4">
                    <a href="${root}/cart" class="btn-back mb-3">← Quay lại giỏ hàng</a>
                    <h2 class="checkout-title mb-3">Thông tin thanh toán</h2>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger fw-bold mb-3" style="border-radius:12px;"> ${error}</div>
                    </c:if>

                    <form action="${root}/checkout?selectedIds=${param.selectedIds}&type=${param.type}" method="post" id="checkoutForm">
                        <input type="hidden" name="selectedIds" value="${param.selectedIds}">
                        <input type="hidden" name="type" value="${param.type}">

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Họ và tên người nhận</label>
                                <input type="text" name="receiverName" class="form-control" value="${sessionScope.user.fullName}" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Số điện thoại</label>
                                <input type="tel" name="receiverPhone" class="form-control" value="${sessionScope.user.phoneNumber}" required>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Khu vực giao hàng</label>
                            <div class="row g-2">
                                <div class="col-md-4"><select name="province" id="province" class="form-select" required><option value="" selected disabled>Tỉnh/Thành phố</option></select></div>
                                <div class="col-md-4"><select name="district" id="district" class="form-select" required><option value="" selected disabled>Quận/Huyện</option></select></div>
                                <div class="col-md-4"><select name="ward" id="ward" class="form-select" required><option value="" selected disabled>Phường/Xã</option></select></div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Địa chỉ nhận hàng cụ thể</label>
                            <input type="text" name="shippingAddress" value="${not empty sessionScope.user.address ? sessionScope.user.address : ''}" class="form-control" required placeholder="Số nhà, tên đường...">
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Ghi chú đơn hàng</label>
                            <textarea name="note" class="form-control" rows="2"></textarea>
                        </div>

                        <div class="mb-3 mt-4 p-3 bg-light rounded-3 border">
                            <label class="form-label fw-bold mb-1 d-block"> Chương trình Khách hàng thân thiết</label>
                            <div class="d-flex align-items-center justify-content-between fw-bold">
                                <span>Cấp độ tài khoản hiện tại:
                                    <span class="badge bg-danger">
                                        <c:out value="${not empty sessionScope.user.tierName ? sessionScope.user.tierName : 'Đồng'}" />
                                    </span>
                                    <c:if test="${not empty appliedVoucher}">
                                        | Đang áp dụng: <span class="badge bg-success">${appliedVoucher.code}</span>
                                    </c:if>
                                </span>
                                <small class="text-muted">Ưu đãi tự động kích hoạt</small>
                            </div>
                        </div>

                        <input type="hidden" name="rankVoucherId" id="rankVoucherId" value="${not empty appliedVoucher ? appliedVoucher.id : ''}">
                        <input type="hidden" id="rankDiscountValue" value="${not empty voucherDiscount ? voucherDiscount : 0}">

                        <div class="mb-3 mt-3 p-3 bg-white rounded-3 border">
                            <label class="form-label fw-bold mb-2 d-block">
                                <i class="bi bi-ticket-perforated-fill text-danger me-1"></i> Chọn mã giảm giá thêm (Nếu có)
                            </label>
                            <select name="voucherId" id="productVoucherSelect" class="form-select">
                                <option value="" data-discount-type="NONE" data-discount-value="0" data-max-discount="0">-- Bấm để chọn 1 trong các mã giảm giá khả dụng --</option>

                                <optgroup label=" Ưu đãi hệ thống dành cho bạn">
                                    <c:forEach var="v" items="${vouchers}">
                                        <option value="${v.id}"
                                                data-discount-type="${v.discountType}"
                                                data-discount-value="${v.discountValue}"
                                                data-max-discount="${v.maxDiscount}">
                                                ${v.code} - Giảm ${v.discountValue}${v.discountType == 'PERCENT' ? '%' : 'đ'}
                                            <c:if test="${v.discountType == 'PERCENT'}">(Tối đa <fmt:formatNumber value="${v.maxDiscount}" type="number"/>đ)</c:if>
                                        </option>
                                    </c:forEach>
                                </optgroup>

                                <c:if test="${not empty savedVouchers}">
                                    <optgroup label=" Mã giảm giá bạn đã lưu từ trang Promotion">
                                        <c:forEach var="sv" items="${savedVouchers}">
                                            <option value="${sv.id}"
                                                    data-discount-type="${sv.discountType}"
                                                    data-discount-value="${sv.discountValue}"
                                                    data-max-discount="${sv.maxDiscount}">
                                                    ${sv.code} - Giảm ${sv.discountValue}${sv.discountType == 'PERCENT' ? '%' : 'đ'}
                                                <c:if test="${sv.discountType == 'PERCENT'}">(Tối đa <fmt:formatNumber value="${sv.maxDiscount}" type="number"/>đ)</c:if>
                                            </option>
                                        </c:forEach>
                                    </optgroup>
                                </c:if>

                                <c:if test="${empty savedVouchers}">
                                    <optgroup label=" Mã giảm giá bạn đã lưu" disabled>
                                        <option value="">(Bạn chưa lưu thêm mã nào từ trang Khuyến mãi)</option>
                                    </optgroup>
                                </c:if>
                            </select>
                        </div>
                        <h5 class="fw-bold mt-4">Phương thức thanh toán</h5>
                        <div class="row g-3 mt-2">
                            <div class="col-6">
                                <label class="payment-box w-100">
                                    <input type="radio" name="paymentMethod" value="COD" checked>
                                    <div class="card p-3 text-center">💵<div class="fw-bold mt-2">Nhận hàng thanh toán</div></div>
                                </label>
                            </div>
                            <div class="col-6">
                                <label class="payment-box w-100">
                                    <input type="radio" name="paymentMethod" value="VNPAY">
                                    <div class="card p-3 text-center">💳<div class="fw-bold mt-2">Thanh toán VNPay</div></div>
                                </label>
                            </div>
                        </div>

                        <input type="hidden" name="shippingFee" id="shippingFeeInput" value="30000">
                        <button type="submit" class="btn btn-order w-100 mt-4">🛒 XÁC NHẬN ĐẶT HÀNG</button>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-lg-5">
            <div class="card shadow-sm order-summary">
                <div class="card-body p-4">
                    <h5 class="fw-bold border-bottom pb-2">Đơn hàng của bạn</h5>
                    <c:set var="totalPriceSum" value="0" />
                    <c:forEach var="item" items="${selectedItems}">
                        <div class="d-flex align-items-center mb-3">
                            <img src="${root}/resources/${item.product.imageUrl}" width="50" height="50" onerror="this.src='https://placehold.co/50'">
                            <div class="ms-3 flex-grow-1"><b>${item.product.name}</b><br><small class="text-muted">SL: ${item.quantity}</small></div>
                            <div class="fw-semibold"><fmt:formatNumber value="${item.product.price * item.quantity}" type="number" /> ₫</div>
                        </div>
                        <c:set var="totalPriceSum" value="${totalPriceSum + (item.product.price * item.quantity)}" />
                    </c:forEach>
                    <hr>
                    <div class="d-flex justify-content-between"><span>Tạm tính</span><span id="subtotalPrice" class="fw-semibold"><fmt:formatNumber value="${totalPriceSum}" type="number" /> ₫</span></div>

                    <div class="d-flex justify-content-between mt-2"><span>Giảm giá Rank:</span><span class="text-danger fw-bold" id="rankDiscountPrice">- 0 ₫</span></div>
                    <div class="d-flex justify-content-between mt-2"><span>Giảm giá thêm (Voucher):</span><span class="text-danger fw-bold" id="productDiscountPrice">- 0 ₫</span></div>

                    <div class="d-flex justify-content-between mt-2"><span>Phí giao hàng</span><span id="shippingFeeDisplay" class="fw-semibold">30,000 ₫</span></div>
                    <hr>
                    <div class="d-flex justify-content-between fw-bold mt-3"><span>TỔNG CỘNG</span><span class="total-price" id="finalPrice">0 ₫</span></div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/footer.jsp" />

<script>
    const orderSubtotalPrice = parseInt("${totalPriceSum}") || 0;

    let rankDiscount = parseFloat(document.getElementById("rankDiscountValue").value) || 0;
    let productDiscount = 0;
    let shippingFee = 30000;

    const GHN_TOKEN = "2eb2d430-50e9-11f1-a973-aee5264794df";

    const shippingFeeDisplay = document.getElementById("shippingFeeDisplay");
    const rankDiscountPrice = document.getElementById("rankDiscountPrice");
    const productDiscountPrice = document.getElementById("productDiscountPrice");
    const finalPrice = document.getElementById("finalPrice");
    const shippingFeeInput = document.getElementById("shippingFeeInput");
    const productVoucherSelect = document.getElementById("productVoucherSelect");

    const provinceSelect = document.getElementById('province');
    const districtSelect = document.getElementById('district');
    const wardSelect = document.getElementById('ward');

    let selectedDistrictId = null;
    let selectedWardCode = null;
    let shipTimeout = null;

    const checkoutFormEl = document.getElementById("checkoutForm");
    const districtInput = document.createElement("input"); districtInput.type = "hidden"; districtInput.name = "districtId"; checkoutFormEl.appendChild(districtInput);
    const wardInput = document.createElement("input"); wardInput.type = "hidden"; wardInput.name = "wardCode"; checkoutFormEl.appendChild(wardInput);

    function resetSelect(select, text) { select.innerHTML = ""; const opt = new Option("-- " + text + " --", ""); opt.disabled = true; opt.selected = true; select.add(opt); }

    function displayAutomaticRankDiscount() {
        rankDiscountPrice.innerText = "- " + rankDiscount.toLocaleString("vi-VN") + " ₫";
    }

    function calculateProductVoucherDiscount() {
        const selectedOpt = productVoucherSelect.selectedOptions[0];
        if (!selectedOpt) return;

        const type = selectedOpt.dataset.discountType;
        const value = parseFloat(selectedOpt.dataset.discountValue) || 0;
        const maxDiscount = parseFloat(selectedOpt.dataset.maxDiscount) || 0;

        if (type === "PERCENT") {
            productDiscount = orderSubtotalPrice * value / 100.0;
            if (maxDiscount > 0 && productDiscount > maxDiscount) {
                productDiscount = maxDiscount;
            }
        } else if (type === "FIXED" || type === "AMOUNT") {
            productDiscount = value;
        } else {
            productDiscount = 0;
        }

        productDiscountPrice.innerText = "- " + productDiscount.toLocaleString("vi-VN") + " ₫";
    }

    productVoucherSelect.addEventListener("change", function() {
        calculateProductVoucherDiscount();
        updateTotal();
    });

    fetch("https://dev-online-gateway.ghn.vn/shiip/public-api/master-data/province", {
        headers: { "Token": GHN_TOKEN }
    })
            .then(r => r.json())
            .then(res => {
                (res.data || []).forEach(p => {
                    const opt = new Option(p.ProvinceName, p.ProvinceName);
                    opt.dataset.id = p.ProvinceID;
                    provinceSelect.add(opt);
                });
            })
            .catch(err => console.error(err));

    provinceSelect.addEventListener("change", function () {
        resetSelect(districtSelect, "Quận/Huyện"); resetSelect(wardSelect, "Phường/Xã");
        districtInput.value = ""; wardInput.value = "";
        selectedDistrictId = null; selectedWardCode = null;

        const provinceId = this.selectedOptions[0].dataset.id; if (!provinceId) return;
        fetch("https://dev-online-gateway.ghn.vn/shiip/public-api/master-data/district?province_id=" + provinceId, { headers: { "Token": GHN_TOKEN } })
                .then(r => r.json()).then(res => {
            (res.data || []).forEach(d => { const opt = new Option(d.DistrictName, d.DistrictName); opt.dataset.id = d.DistrictID; districtSelect.add(opt); });
        });
    });

    districtSelect.addEventListener("change", function () {
        resetSelect(wardSelect, "Phường/Xã");
        wardInput.value = ""; selectedWardCode = null;

        const districtId = this.selectedOptions[0].dataset.id; if (!districtId) return;
        selectedDistrictId = districtId; districtInput.value = districtId;
        fetch("https://dev-online-gateway.ghn.vn/shiip/public-api/master-data/ward?district_id=" + districtId, { headers: { "Token": GHN_TOKEN } })
                .then(r => r.json()).then(res => {
            (res.data || []).forEach(w => { const opt = new Option(w.WardName, w.WardCode); wardSelect.add(opt); });
        });
    });

    wardSelect.addEventListener("change", function () { selectedWardCode = this.value; wardInput.value = selectedWardCode; triggerShipping(); });

    function triggerShipping() {
        if (!selectedDistrictId || !selectedWardCode) return;
        clearTimeout(shipTimeout);
        shipTimeout = setTimeout(() => {
            fetch("${root}/api/get-shipping-fee?districtId=" + selectedDistrictId + "&wardCode=" + selectedWardCode + "&subtotal=" + orderSubtotalPrice)
                    .then(r => r.json()).then(res => {
                let feeVal = 30000;
                if (res) {
                    if (res.data) {
                        feeVal = res.data.total ?? res.data.service_fee ?? res.data.fee ?? res.data;
                    } else {
                        feeVal = res.total ?? res.service_fee ?? res.fee ?? res;
                    }
                }

                if (typeof feeVal === 'object' && feeVal !== null) {
                    shippingFee = Number(feeVal.total || feeVal.service_fee || feeVal.fee || 30000);
                } else {
                    shippingFee = Number(feeVal) || 30000;
                }

                updateTotal();
            }).catch(() => { shippingFee = 30000; updateTotal(); });
        }, 400);
    }

    function updateTotal() {
        const cleanShippingFee = Number(shippingFee) || 0;
        const cleanRankDiscount = Number(rankDiscount) || 0;
        const cleanProductDiscount = Number(productDiscount) || 0;

        const totalFinalCalculated = Math.max(0, orderSubtotalPrice - cleanRankDiscount - cleanProductDiscount + cleanShippingFee);

        shippingFeeDisplay.innerText = cleanShippingFee.toLocaleString("vi-VN") + " ₫";
        finalPrice.innerText = totalFinalCalculated.toLocaleString("vi-VN") + " ₫";
        shippingFeeInput.value = cleanShippingFee;
    }

    document.addEventListener("DOMContentLoaded", function() {
        displayAutomaticRankDiscount();
        calculateProductVoucherDiscount();
        updateTotal();
    });
</script>
</body>
</html>