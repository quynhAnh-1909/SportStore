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

            <!-- GIẢM -->
            <td>
              <c:choose>
                <c:when test="${v.discountType == 'PERCENT'}">
                  <span class="badge bg-success">${v.discountValue}%</span>
                </c:when>
                <c:otherwise>
                <span class="badge bg-info">
                    <fmt:formatNumber value="${v.discountValue}"/> ₫
                </span>
                </c:otherwise>
              </c:choose>

              <br>
              <small class="text-muted">
                Max: <fmt:formatNumber value="${v.maxDiscount}"/> ₫
              </small>
            </td>

            <!-- ĐIỀU KIỆN -->
            <td class="text-start small">
              <div>🛒 Tối thiểu: <b><fmt:formatNumber value="${v.minOrderValue}"/> ₫</b></div>
              <div>🏷 Giá SP: <b><fmt:formatNumber value="${v.minProductPrice}"/> ₫</b></div>
              <div>📂 Danh mục:
                <b>
                  <c:choose>
                    <c:when test="${v.categoryId == 0}">Tất cả</c:when>
                    <c:otherwise>${v.categoryId}</c:otherwise>
                  </c:choose>
                </b>
              </div>
              <div>💳 ${v.paymentMethod}</div>
            </td>

            <!-- SỬ DỤNG -->
            <td>
              <div class="progress" style="height: 8px;">
                <div class="progress-bar bg-warning"
                     style="width: ${v.usedCount * 100 / v.quantity}%">
                </div>
              </div>
              <small>${v.usedCount} / ${v.quantity}</small>
            </td>

            <!-- THỜI GIAN -->
            <td class="small">
              🟢 <fmt:formatDate value="${v.startDate}" pattern="dd/MM/yyyy"/><br>
              🔴 <fmt:formatDate value="${v.expiryDate}" pattern="dd/MM/yyyy"/>
            </td>

            <!-- STATUS -->
            <td>
              <c:choose>
                <c:when test="${v.status}">
                  <span class="badge bg-success">Hoạt động</span>
                </c:when>
                <c:otherwise>
                  <span class="badge bg-secondary">Tắt</span>
                </c:otherwise>
              </c:choose>
            </td>

            <!-- ACTION -->
            <td>
              <a href="${root}/admin/vouchers?action=edit&id=${v.id}"
                 class="btn btn-sm btn-primary">✏️</a>

              <a href="${root}/admin/vouchers?action=delete&id=${v.id}"
                 class="btn btn-sm btn-danger"
                 onclick="return confirm('Xóa voucher này?')">🗑</a>
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
  td {
    vertical-align: middle !important;
  }

  .progress {
    background: #eee;
    border-radius: 10px;
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