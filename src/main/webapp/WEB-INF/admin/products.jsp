<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="root" value="${pageContext.request.contextPath}"/>

<div class="container-fluid pt-4 px-4">

    <div class="bg-light rounded p-4 shadow-sm">

        <!-- HEADER -->
        <div class="d-flex align-items-center justify-content-between mb-4">
            <h4 class="mb-0 text-success fw-bold">
                <i class="fas fa-box me-2"></i> Quản lý kho hàng
            </h4>

            <a href="${root}/admin/products?action=create"
               class="btn btn-success rounded-pill px-4 shadow-sm">
                <i class="fas fa-plus me-1"></i> Thêm sản phẩm
            </a>
        </div>

        <!-- FILTER -->
        <div class="row mb-3 gx-2">

            <div class="col-md-4">
                <input type="text" id="searchInput"
                       class="form-control"
                       placeholder="🔍 Tìm tên sản phẩm...">
            </div>

            <div class="col-md-4">
                <select id="categoryFilter" class="form-control">
                    <option value="">-- Tất cả danh mục --</option>
                    <c:forEach var="c" items="${categories}">
                        <option value="${c.id}">${c.name}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="col-md-4">
                <select id="stockFilter" class="form-control">
                    <option value="">-- Trạng thái --</option>
                    <option value="in">✅ Còn hàng</option>
                    <option value="out">❌ Hết hàng</option>
                </select>
            </div>

        </div>

        <!-- TABLE -->
        <div class="table-responsive">
            <table class="table table-bordered table-hover align-middle text-center">

                <thead class="table-dark">
                <tr>
                    <th style="width: 80px;">Ảnh</th>
                    <th class="text-start">Tên sản phẩm</th>
                    <th>Giá</th>
                    <th>Tồn</th>
                    <th>Đơn vị</th>
                    <th>Danh mục</th>
                    <th style="width: 220px;">Thao tác</th>
                </tr>
                </thead>

                <tbody>
                <c:forEach var="item" items="${products}">

                    <tr class="${item.stockQuantity <= 0 ? 'table-danger' : ''}">

                        <!-- IMAGE -->
                        <td>
                            <c:choose>
                                <c:when test="${not empty item.imageUrl}">
                                    <img src="${root}/resources/${item.imageUrl}"
                                         class="rounded shadow-sm"
                                         style="width:60px;height:60px;object-fit:cover;">
                                </c:when>
                                <c:otherwise>
                                    <img src="${root}/resources/no-image.png"
                                         class="rounded"
                                         style="width:60px;height:60px;object-fit:cover;">
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <!-- NAME -->
                        <td class="text-start fw-bold ps-3">
                                ${item.name}
                        </td>

                        <!-- PRICE -->
                        <td class="text-danger fw-bold">
                            <fmt:formatNumber value="${item.price}" groupingUsed="true"/> ₫
                        </td>

                        <!-- STOCK -->
                        <td>
                            <c:choose>
                                <c:when test="${item.stockQuantity <= 0}">
                                    <span class="badge bg-dark">Hết hàng</span>
                                </c:when>
                                <c:when test="${item.stockQuantity < 10}">
                                    <span class="badge bg-warning text-dark">
                                            ${item.stockQuantity}
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-success">
                                            ${item.stockQuantity}
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <!-- UNIT -->
                        <td>${item.unit}</td>

                        <!-- CATEGORY -->
                        <td>
                            <span class="badge bg-info text-dark px-3">
                                    ${item.categoryName}
                            </span>
                        </td>

                        <!-- ACTION -->
                        <td>
                            <div class="btn-group">

                                <a href="${root}/admin/products?action=edit&id=${item.id}"
                                   class="btn btn-sm btn-outline-primary">
                                    <i class="fas fa-edit"></i>
                                </a>

                                <a href="${root}/admin/products?action=detail&id=${item.id}"
                                   class="btn btn-sm btn-outline-info">
                                    <i class="fas fa-eye"></i>
                                </a>

                                <a href="${root}/admin/products?action=delete&id=${item.id}"
                                   class="btn btn-sm btn-outline-danger"
                                   onclick="return confirm('Xóa sản phẩm này?')">
                                    <i class="fas fa-trash"></i>
                                </a>

                            </div>
                        </td>

                    </tr>

                </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- EMPTY -->
        <c:if test="${empty products}">
            <div class="text-center mt-4 p-5 border rounded">
                <i class="fas fa-box-open fa-3x text-muted mb-3"></i>
                <p class="text-muted">Chưa có sản phẩm</p>
            </div>
        </c:if>

    </div>
</div>

<!-- STYLE -->
<style>
    table tbody tr:hover {
        background-color: rgba(0, 123, 255, 0.05);
    }

    td, th {
        vertical-align: middle !important;
    }

    td img {
        border: 1px solid #dee2e6;
    }

    .table-danger {
        background-color: #f8d7da !important;
    }
</style>

<!-- SIMPLE FILTER JS -->
<script>
    const searchInput = document.getElementById("searchInput");
    const categoryFilter = document.getElementById("categoryFilter");

    searchInput.addEventListener("keyup", filterTable);
    categoryFilter.addEventListener("change", filterTable);

    function filterTable() {
        let keyword = searchInput.value.toLowerCase();
        let category = categoryFilter.value;

        let rows = document.querySelectorAll("tbody tr");

        rows.forEach(row => {
            let name = row.children[1].innerText.toLowerCase();
            let catText = row.children[5].innerText;

            let matchName = name.includes(keyword);
            let matchCategory = !category || catText.includes(category);

            row.style.display = (matchName && matchCategory) ? "" : "none";
        });
    }
</script>