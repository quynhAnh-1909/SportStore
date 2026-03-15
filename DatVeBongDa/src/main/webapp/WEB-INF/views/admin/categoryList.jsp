<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="root" value="${pageContext.request.contextPath}" />

<div class="container-fluid pt-4 px-4">

	<div class="bg-light text-center rounded p-4 shadow-sm">

		<div class="d-flex align-items-center justify-content-between mb-4">

			<h4 class="mb-0 text-success fw-bold">Danh mục sản phẩm</h4>

			<a href="${root}/admin/categories?action=create"
				class="btn btn-success rounded-pill px-4 shadow-sm"> <i
				class="fas fa-plus-circle me-1"></i> Thêm danh mục mới

			</a>

		</div>



		<div class="table-responsive">

			<table
				class="table text-start align-middle table-bordered table-hover mb-0">

				<thead class="table-dark">

					<tr>

						<th class="text-center" style="width: 50px;">#</th>
						<th>Tên danh mục</th>
						<th>Mô tả</th>
						<th class="text-center" style="width: 250px;">Thao tác</th>

					</tr>

				</thead>

				<tbody>

					<c:set var="stt" value="1" />

					<c:forEach var="c" items="${categories}">

						<tr>

							<td class="text-center fw-bold">${stt}</td>

							<td class="fw-bold text-dark">${c.name}</td>

							<td class="text-muted"><c:choose>

									<c:when test="${empty c.description}">
Không có mô tả
</c:when>

									<c:otherwise>
${c.description}
</c:otherwise>

								</c:choose></td>

							<td class="text-center">

								<div class="btn-group">

									<a href="${root}/admin/categories?action=edit&id=${c.id}"
										class="btn btn-sm btn-outline-primary px-3"> <i
										class="fas fa-edit"></i> Sửa

									</a> <a href="${root}/admin/categories?action=detail&id=${c.id}"
										class="btn btn-sm btn-outline-info px-3"> <i
										class="fas fa-eye"></i> Xem

									</a> <a href="${root}/admin/categories?action=delete&id=${c.id}"
										class="btn btn-sm btn-outline-danger px-3"> <i
										class="fas fa-trash"></i> Xóa

									</a>

								</div>

							</td>

						</tr>

						<c:set var="stt" value="${stt + 1}" />

					</c:forEach>

				</tbody>

			</table>

		</div>



		<c:if test="${empty categories}">

			<div class="text-center mt-4 p-5 border rounded">

				<i class="fas fa-folder-open fa-3x text-muted mb-3"></i>

				<p class="text-muted">Chưa có danh mục nào được tạo.</p>

			</div>

		</c:if>

	</div>

</div>