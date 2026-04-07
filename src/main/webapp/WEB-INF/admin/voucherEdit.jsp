<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="root" value="${pageContext.request.contextPath}"/>

<div class="container pt-4">

    <div class="card shadow p-4 border-start border-4 border-primary">

        <h4 class="mb-4 text-primary fw-bold">
            🎫 Sửa Voucher
        </h4>

        <!-- ERROR -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                    ${error}
            </div>
        </c:if>

        <form method="post" action="${root}/admin/vouchers" id="formVoucher">

            <input type="hidden" name="action" value="update"/>
            <input type="hidden" name="id" value="${voucher.id}"/>

            <div class="row">

                <!-- CODE -->
                <div class="col-md-6 mb-3">
                    <label class="fw-bold text-primary">🔑 Mã Voucher *</label>
                    <input type="text" class="form-control border-primary"
                           name="code" value="${voucher.code}" required>
                </div>

                <!-- TYPE -->
                <div class="col-md-6 mb-3">
                    <label class="fw-bold text-success">🎯 Loại</label>
                    <select class="form-control border-success" name="type" id="type">
                        <option value="PERCENT"
                                <c:if test="${voucher.discountType == 'PERCENT'}">selected</c:if>>
                            %
                        </option>
                        <option value="FIXED"
                                <c:if test="${voucher.discountType == 'FIXED'}">selected</c:if>>
                            VNĐ
                        </option>
                    </select>
                </div>

                <!-- VALUE -->
                <div class="col-md-6 mb-3">
                    <label class="fw-bold text-danger">💸 Giá trị *</label>
                    <input type="number" class="form-control border-danger"
                           name="value" id="value"
                           value="${voucher.discountValue}" required>
                </div>

                <!-- MIN ORDER -->
                <div class="col-md-6 mb-3">
                    <label class="fw-bold">🛒 Đơn tối thiểu</label>
                    <input type="number" class="form-control"
                           name="minOrder"
                           value="${voucher.minOrderValue}">
                </div>

                <!-- MAX DISCOUNT -->
                <div class="col-md-6 mb-3">
                    <label class="fw-bold text-warning">⚠ Giảm tối đa</label>
                    <input type="number" class="form-control border-warning"
                           name="maxDiscount"
                           value="${voucher.maxDiscount}">
                </div>

                <!-- QUANTITY -->
                <div class="col-md-6 mb-3">
                    <label class="fw-bold text-info">📦 Số lượng *</label>
                    <input type="number" class="form-control border-info"
                           name="quantity"
                           value="${voucher.quantity}" required>
                </div>

                <!-- PAYMENT -->
                <div class="col-md-6 mb-3">
                    <label class="fw-bold">💳 Thanh toán</label>
                    <select class="form-control" name="paymentMethod">
                        <option value="ALL"
                                <c:if test="${voucher.paymentMethod == 'Tất Cả'}">selected</c:if>>ALL</option>
                        <option value="COD"
                                <c:if test="${voucher.paymentMethod == 'COD'}">selected</c:if>>COD</option>
                        <option value="VNPAY"
                                <c:if test="${voucher.paymentMethod == 'VNPAY'}">selected</c:if>>VNPAY</option>
                    </select>
                </div>

                <!-- MIN PRODUCT -->
                <div class="col-md-6 mb-3">
                    <label class="fw-bold">🏷 Giá SP tối thiểu</label>
                    <input type="number" class="form-control"
                           name="minProductPrice"
                           value="${voucher.minProductPrice}">
                </div>

                <!-- CATEGORY -->
                <div class="col-md-6 mb-3">
                    <label class="fw-bold">📂 Loại sản phẩm</label>
                    <input type="number" class="form-control"
                           name="categoryId"
                           value="${voucher.categoryId}">
                </div>

                <!-- START DATE -->
                <div class="col-md-6 mb-3">
                    <label class="fw-bold text-success">🟢 Ngày bắt đầu</label>
                    <input type="date" class="form-control border-success"
                           name="startDate"
                           value="<fmt:formatDate value='${voucher.startDate}' pattern='yyyy-MM-dd'/>">
                </div>

                <!-- END DATE -->
                <div class="col-md-6 mb-3">
                    <label class="fw-bold text-danger">🔴 Ngày kết thúc</label>
                    <input type="date" class="form-control border-danger"
                           name="expiryDate"
                           value="<fmt:formatDate value='${voucher.expiryDate}' pattern='yyyy-MM-dd'/>">
                </div>

                <!-- STATUS -->
                <div class="col-md-6 mb-3">
                    <label class="fw-bold">⚙ Trạng thái</label>
                    <select class="form-control" name="status">
                        <option value="true"
                                <c:if test="${voucher.status}">selected</c:if>>
                            Hoạt động
                        </option>
                        <option value="false"
                                <c:if test="${!voucher.status}">selected</c:if>>
                            Tắt
                        </option>
                    </select>
                </div>

                <!-- BUTTON -->
                <div class="col-12 mt-3">
                    <button class="btn btn-success px-4">
                        💾 Cập nhật
                    </button>

                    <a href="${root}/admin/vouchers" class="btn btn-secondary">
                        ← Quay lại
                    </a>
                </div>

            </div>

        </form>

    </div>
</div>

<!-- STYLE -->
<style>
    .card { border-radius: 10px; }
    input:focus, select:focus {
        border-color: #0d6efd;
        box-shadow: 0 0 5px rgba(0,123,255,0.4);
    }
</style>

<!-- JS -->
<script>
    document.getElementById("formVoucher").addEventListener("submit", function (e) {

        let code = document.querySelector("input[name='code']").value.trim();
        let value = document.querySelector("input[name='value']").value;
        let type = document.getElementById("type").value;

        if (code === "") {
            alert("Nhập mã voucher");
            e.preventDefault();
            return;
        }

        if (value <= 0) {
            alert("Giá trị phải > 0");
            e.preventDefault();
            return;
        }

        if (type === "PERCENT" && value > 100) {
            alert("Không được > 100%");
            e.preventDefault();
        }
    });
</script>