<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<div class="bg-light text-center rounded p-4 shadow-sm">

	<div class="d-flex align-items-center justify-content-between mb-4">

		<h4 class="mb-0 text-success fw-bold">Quản lý kho hàng</h4>

		<a
			href="${pageContext.request.contextPath}/admin/products?action=create"
			class="btn btn-success rounded-pill px-4"> <i
			class="fas fa-plus me-1"></i> Thêm sản phẩm

		</a>

	</div>


	<div class="row mb-3 gx-2">

		<div class="col-md-4">

			<input type="text" id="searchInput" class="form-control"
				placeholder="🔍 Tìm tên sản phẩm">

		</div>


		<div class="col-md-3">

			<select id="categoryFilter" class="form-control">

				<option value="">-- Tất cả danh mục --</option>

				<c:forEach var="c" items="${categories}">
					<option value="${c.id}">${c.name}</option>
				</c:forEach>

			</select>

		</div>


		<div class="col-md-3">

			<select id="stockFilter" class="form-control">

				<option value="">-- Tất cả trạng thái --</option>
				<option value="in">✅ Còn hàng</option>
				<option value="out">❌ Hết hàng</option>

			</select>

		</div>

	</div>



	<div class="table-responsive">

		<table class="table table-bordered table-hover">

			<thead class="table-dark">

				<tr>

					<th>Hình ảnh</th>
					<th>Tên</th>
					<th>Giá</th>
					<th>Tồn kho</th>
					<th>Đơn vị</th>
					<th>Danh mục</th>
					<th class="text-center">Thao tác</th>

				</tr>

			</thead>

			<tbody id="productTableBody">

				<jsp:include page="productTable.jsp" />

			</tbody>

		</table>

	</div>

</div>