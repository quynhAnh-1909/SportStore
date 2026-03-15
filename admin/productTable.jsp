<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:forEach var="p" items="${products}">

	<tr class="${p.stockQuantity <= 0 ? 'table-danger' : ''}">

		<td><c:choose>

				<c:when test="${not empty p.imageUrl}">
					<img src="${p.imageUrl}" class="rounded shadow-sm"
						style="width: 60px; height: 60px; object-fit: cover;">
				</c:when>

				<c:otherwise>
					<img src="${pageContext.request.contextPath}/images/no-image.png"
						class="rounded"
						style="width: 60px; height: 60px; object-fit: cover;">
				</c:otherwise>

			</c:choose></td>

		<td class="fw-bold">${p.name}</td>

		<td class="text-danger fw-bold">${p.price} VNĐ</td>

		<td><c:choose>

				<c:when test="${p.stockQuantity <= 0}">
					<span class="badge bg-dark">❌ Hết hàng</span>
				</c:when>

				<c:when test="${p.stockQuantity < 10}">
					<span class="badge bg-danger"> ⚠ Chỉ còn ${p.stockQuantity}
					</span>
				</c:when>

				<c:otherwise>
					<span class="badge bg-success"> ${p.stockQuantity} </span>
				</c:otherwise>

			</c:choose></td>

		<td>${p.unit}</td>

		<td><span class="badge bg-secondary"> ${p.categoryName} </span></td>

		<td class="text-center">

			<div class="btn-group">

				<a class="btn btn-sm btn-outline-primary"
					href="${pageContext.request.contextPath}/admin/products?action=edit&id=${p.id}">
					Sửa </a> <a class="btn btn-sm btn-outline-info"
					href="${pageContext.request.contextPath}/admin/products?action=detail&id=${p.id}">
					Xem </a> <a class="btn btn-sm btn-outline-danger"
					href="${pageContext.request.contextPath}/admin/products?action=delete&id=${p.id}">
					Xóa </a>

			</div>

		</td>

	</tr>

</c:forEach>