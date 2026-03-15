<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<c:set var="root" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Sport Store</title>
<style>
body {
	background: #f4f6f9;
	font-family: Segoe UI;
}

.container-products {
	max-width: 1200px;
	margin: auto;
	padding: 0 30px;
} /* CARD */
.product-card {
	border: none;
	border-radius: 12px;
	overflow: hidden;
	background: white;
	transition: 0.3s;
	box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
}

.product-card:hover {
	transform: translateY(-8px);
	box-shadow: 0 12px 30px rgba(0, 0, 0, 0.15);
} /* IMAGE */
.product-img-area {
	height: 220px;
	display: flex;
	align-items: center;
	justify-content: center;
	background: #fafafa;
	padding: 15px;
}

.product-img {
	max-width: 100%;
	max-height: 190px;
	object-fit: contain;
}

.card-accent {
	position: absolute;
	top: 0;
	left: 0;
	width: 100%;
	height: 4px;
	background: #004d31;
}

/* TEXT */
.product-name {
	font-weight: 700;
	font-size: 1rem;
	margin-bottom: 8px;
	min-height: 40px;
}

.price {
	color: #e41e31;
	font-weight: bold;
	font-size: 1.1rem;
} /* BUTTON */
.btn-cart {
	background: #008f4c;
	color: white;
	border: none;
	padding: 7px;
	border-radius: 6px;
	font-size: 14px;
}

.btn-cart:hover {
	background: #006b39;
}

@media ( min-width :1200px) {
	.col-xl-custom {
		flex: 0 0 20%;
		max-width: 20%;
	}
}
</style>
</head>
<body>
	<jsp:include page="header.jsp" />
	<div class="container-products mt-4">
		<div class="row align-items-center mb-4">

			<!-- CATEGORY LEFT -->
			<div class="col-md-3">

				<select class="form-select" onchange="location=this.value">

					<option value="${root}/productList"
						<c:if test="${empty param.categoryId}">selected</c:if>>
						Tất cả danh mục</option>

					<c:forEach var="cat" items="${categoryList}">

						<option value="${root}/productList?categoryId=${cat.id}"
							<c:if test="${param.categoryId == cat.id}">selected</c:if>>

							${cat.name}</option>

					</c:forEach>

				</select>

			</div>

			<!-- EMPTY RIGHT -->
			<div class="col-md-3"></div>

		</div>
		<!-- TITLE -->
		<h2 class="text-center mb-4 text-success fw-bold">SẢN PHẨM THỂ
			THAO</h2>
		<!-- PRODUCT LIST -->
		<c:choose>
			<c:when test="${empty productList}">
				<div class="alert alert-warning text-center">Không tìm thấy
					sản phẩm phù hợp</div>
			</c:when>
			<c:otherwise>
				<div class="row g-4">
					<c:forEach var="p" items="${productList}">
						<div class="col-12 col-sm-6 col-md-4 col-lg-3 col-xl-custom">
							<div class="card product-card h-100">
								<div class="product-img-area">
									<div class="card-accent"></div>
									<a href="${root}/productDetail?id=${p.id}"> <img
										src="${root}/resources/${p.imageUrl}" class="product-img"
										alt="${p.name}">

									</a>
								</div>
								<div class="card-body text-center">
									<div class="product-name">${p.name}</div>
									<div class="price">
										<fmt:formatNumber value="${p.price}" type="number"
											groupingUsed="true" />
										VNĐ
									</div>
									<div class="d-grid gap-2 mt-3">
										<c:choose>
											<%-- ADMIN --%>
											<c:when
												test="${not empty sessionScope.user && sessionScope.user.role.equalsIgnoreCase('ADMIN')}">
												<div class="d-flex gap-2">
													<a
														href="${root}/admin/productManager?action=edit&id=${p.id}"
														class="btn btn-dark btn-sm w-100">⚙ EDIT</a> <a
														href="${root}/admin/productManager?action=delete&id=${p.id}"
														class="btn btn-danger btn-sm w-100"
														onclick="return confirm('Xác nhận xóa?')">🗑 DELETE</a>
												</div>
												<a href="${root}/productDetail?id=${p.id}"
													class="btn btn-success btn-sm">VIEW DETAILS</a>
											</c:when>
											<%-- USER --%>
											<c:when
												test="${not empty sessionScope.user && sessionScope.user.role.equalsIgnoreCase('USER')}">
												<form action="${root}/cart" method="post">

													<input type="hidden" name="action" value="add"> <input
														type="hidden" name="productId" value="${p.id}">

													<button class="btn-cart w-100">🛒 Add to Cart</button>

												</form>
												<a href="${root}/productDetail?id=${p.id}"
													class="btn btn-outline-success btn-sm">Xem chi tiết</a>
											</c:when>
											<%-- NOT LOGIN --%>
											<c:otherwise>
												<a href="${root}/login" class="btn btn-secondary btn-sm">
													ĐĂNG NHẬP ĐỂ MUA </a>
											</c:otherwise>
										</c:choose>
									</div>
								</div>
							</div>
						</div>
					</c:forEach>
				</div>
			</c:otherwise>
		</c:choose>
		<!-- PAGINATION -->
		<div class="d-flex justify-content-center mt-4">
			<nav>
				<ul class="pagination">
					<c:forEach begin="1" end="${totalPage}" var="i">
						<div class="d-flex justify-content-center mt-4">

							<nav>

								<ul class="pagination">

									<c:forEach begin="1" end="${totalPage}" var="i">

										<li class="page-item ${i == pageIndex ? 'active' : ''}">

											<a class="page-link"
											href="${root}/productList?page=${i}&keyword=${param.keyword}&categoryId=${param.categoryId}">

												${i} </a>

										</li>

									</c:forEach>

								</ul>

							</nav>

						</div>
						<a class="page-link"
							href="${root}/productList?page=${i}&keyword=${param.keyword}&categoryId=${param.categoryId}">
							${i} </a>
						</li>
					</c:forEach>
				</ul>
			</nav>
		</div>
	</div>
	<jsp:include page="footer.jsp" />
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>