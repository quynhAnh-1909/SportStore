<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="root" value="${pageContext.request.contextPath}"/>

<div class="container-fluid pt-4 px-4">

  <div class="bg-white rounded p-4 shadow">

    <!-- HEADER -->
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h4 class="text-danger fw-bold">
        🎫 Quản lý Voucher
      </h4>

      <a href="${root}/admin/vouchers?action=create"
         class="btn btn-danger">
        ➕ Thêm voucher
      </a>
    </div>

    <!-- SEARCH -->
    <div class="mb-3">
      <input type="text" id="searchInput"
             class="form-control"
             placeholder="🔍 Tìm mã voucher...">
    </div>

    <!-- TABLE -->
    <div class="table-responsive">
      <table class="table table-bordered table-hover text-center align-middle">

        <thead class="table-dark">
        <tr>
          <th>Mã</th>
          <th>Giảm giá</th>
          <th>Điều kiện</th>
          <th>Sử dụng</th>
          <th>Thời gian</th>
          <th>Trạng thái</th>
          <th>Thao tác</th>
        </tr>
        </thead>

        <tbody>
        <c:forEach var="v" items="${vouchers}">

          <tr class="
          ${v.quantity == v.usedCount ? 'bg-danger text-white' : ''}
          ${!v.status ? 'table-secondary' : ''}
      ">

            <!-- CODE -->
            <td class="fw-bold text-primary">
                ${v.code}
            </td>

            <!-- GIẢM GIÁ -->
            <td>
              <c:if test="${v.discountType == 'PERCENT'}">
            <span class="badge bg-success">
              ${v.discountValue} %
            </span>
              </c:if>

              <c:if test="${v.discountType == 'FIXED'}">
            <span class="badge bg-info">
              <fmt:formatNumber value="${v.discountValue}"/> ₫
            </span>
              </c:if>

              <br>
              <small class="text-muted">
                Max: <fmt:formatNumber value="${v.maxDiscount}"/> ₫
              </small>
            </td>

            <!-- ĐIỀU KIỆN -->
            <td style="text-align:left">
              🛒 Đơn hàng từ :
              <fmt:formatNumber value="${v.minOrderValue}"/> ₫ <br>

              🏷 Giá từ :
              <fmt:formatNumber value="${v.minProductPrice}"/> ₫ <br>

              📂 Sản phẩm:
              <c:choose>
                <c:when test="${v.categoryId == 0}">Tất cả</c:when>
                <c:otherwise>${v.categoryId}</c:otherwise>
              </c:choose> <br>

              💳 ${v.paymentMethod}
            </td>

            <!-- SỬ DỤNG -->
            <td>
          <span class="badge bg-warning text-dark">
              ${v.usedCount}
          </span>
              /
              <span class="badge bg-primary">
                  ${v.quantity}
              </span>
            </td>

            <!-- THỜI GIAN -->
            <td>
              <small>
                🟢 <fmt:formatDate value="${v.startDate}" pattern="dd-MM-yyyy"/> <br>
                🔴 <fmt:formatDate value="${v.expiryDate}" pattern="dd-MM-yyyy"/>
              </small>
            </td>

            <!-- STATUS -->
            <td>
              <c:if test="${v.status}">
                <span class="badge bg-success">Hoạt động</span>
              </c:if>
              <c:if test="${!v.status}">
                <span class="badge bg-secondary">Tắt</span>
              </c:if>
            </td>

            <!-- ACTION -->
            <td>
              <a href="${root}/admin/vouchers?action=edit&id=${v.id}"
                 class="btn btn-sm btn-primary">
                ✏️
              </a>

              <a href="${root}/admin/vouchers?action=delete&id=${v.id}"
                 class="btn btn-sm btn-danger"
                 onclick="return confirm('Xóa voucher này?')">
                🗑
              </a>
            </td>

          </tr>

        </c:forEach>
        </tbody>

      </table>
    </div>

    <!-- EMPTY -->
    <c:if test="${empty vouchers}">
      <div class="text-center mt-4">
        <h5 class="text-muted">Chưa có voucher</h5>
      </div>
    </c:if>

  </div>
</div>

<!-- STYLE -->
<style>
  table tr:hover {
    background-color: #f5f5f5;
  }

  .bg-danger {
    background-color: #ff4d4f !important;
  }

  .table-secondary {
    background-color: #e2e3e5 !important;
  }
</style>

<!-- SEARCH -->
<script>
  document.getElementById("searchInput").addEventListener("keyup", function () {
    let keyword = this.value.toLowerCase();
    let rows = document.querySelectorAll("tbody tr");

    rows.forEach(row => {
      let code = row.children[0].innerText.toLowerCase();
      row.style.display = code.includes(keyword) ? "" : "none";
    });
  });
</script>