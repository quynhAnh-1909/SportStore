<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="root" value="${pageContext.request.contextPath}"/>

<div class="container pt-4">

  <div class="card shadow p-4 border-start border-4 border-success">

    <h4 class="mb-4 text-success fw-bold">
      ➕ Thêm Voucher
    </h4>

    <!-- ERROR -->
    <c:if test="${not empty error}">
      <div class="alert alert-danger">
          ${error}
      </div>
    </c:if>

    <form method="post" action="${root}/admin/vouchers" id="formVoucher">

      <input type="hidden" name="action" value="create"/>

      <div class="row">

        <!-- CODE -->
        <div class="col-md-6 mb-3">
          <label class="fw-bold text-primary">🔑 Mã Voucher *</label>
          <input type="text" class="form-control border-primary"
                 name="code" placeholder="VD: SALE10" required>
        </div>

        <!-- TYPE -->
        <div class="col-md-6 mb-3">
          <label class="fw-bold text-success">🎯 Loại</label>
          <select class="form-control border-success" name="type" id="type">
            <option value="PERCENT">%</option>
            <option value="FIXED">VNĐ</option>
          </select>
        </div>

        <!-- VALUE -->
        <div class="col-md-6 mb-3">
          <label class="fw-bold text-danger">💸 Giá trị *</label>
          <input type="number" class="form-control border-danger"
                 name="value" id="value"
                 placeholder="VD: 10 hoặc 50000" required>
        </div>

        <!-- MIN ORDER -->
        <div class="col-md-6 mb-3">
          <label class="fw-bold">🛒 Đơn tối thiểu</label>
          <input type="number" class="form-control"
                 name="minOrder" placeholder="VD: 200000">
        </div>

        <!-- MAX DISCOUNT -->
        <div class="col-md-6 mb-3">
          <label class="fw-bold text-warning">⚠ Giảm tối đa</label>
          <input type="number" class="form-control border-warning"
                 name="maxDiscount" placeholder="VD: 100000">
        </div>

        <!-- QUANTITY -->
        <div class="col-md-6 mb-3">
          <label class="fw-bold text-info">📦 Số lượng *</label>
          <input type="number" class="form-control border-info"
                 name="quantity" placeholder="VD: 50" required>
        </div>

        <!-- PAYMENT -->
        <div class="col-md-6 mb-3">
          <label class="fw-bold">💳 Thanh toán</label>
          <select class="form-control" name="paymentMethod">
            <option value="ALL">ALL</option>
            <option value="COD">COD</option>
            <option value="VNPAY">VNPAY</option>
          </select>
        </div>

        <!-- MIN PRODUCT -->
        <div class="col-md-6 mb-3">
          <label class="fw-bold">🏷 Giá SP tối thiểu</label>
          <input type="number" class="form-control"
                 name="minProductPrice" placeholder="VD: 100000">
        </div>

        <!-- CATEGORY -->
        <div class="col-md-6 mb-3">
          <label class="fw-bold">📂 Category ID</label>
          <input type="number" class="form-control"
                 name="categoryId" placeholder="0 = tất cả">
        </div>

        <!-- START DATE -->
        <div class="col-md-6 mb-3">
          <label class="fw-bold text-success">🟢 Ngày bắt đầu</label>
          <input type="date" class="form-control border-success"
                 name="startDate" required>
        </div>

        <!-- END DATE -->
        <div class="col-md-6 mb-3">
          <label class="fw-bold text-danger">🔴 Ngày kết thúc</label>
          <input type="date" class="form-control border-danger"
                 name="expiryDate" required>
        </div>

        <!-- STATUS -->
        <div class="col-md-6 mb-3">
          <label class="fw-bold">⚙ Trạng thái</label>
          <select class="form-control" name="status">
            <option value="true">Hoạt động</option>
            <option value="false">Tắt</option>
          </select>
        </div>

        <!-- BUTTON -->
        <div class="col-12 mt-3">
          <button class="btn btn-success px-4">
            💾 Lưu
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
    border-color: #198754;
    box-shadow: 0 0 5px rgba(25,135,84,0.4);
  }

  label {
    margin-bottom: 5px;
  }
</style>

<!-- JS VALIDATE -->
<script>
  document.getElementById("formVoucher").addEventListener("submit", function (e) {

    let code = document.querySelector("input[name='code']").value.trim();
    let value = document.getElementById("value").value;
    let type = document.getElementById("type").value;
    let start = document.querySelector("input[name='startDate']").value;
    let end = document.querySelector("input[name='expiryDate']").value;

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
      return;
    }

    if (start > end) {
      alert("Ngày kết thúc phải sau ngày bắt đầu");
      e.preventDefault();
    }
  });
</script>