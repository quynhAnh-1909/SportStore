<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<c:set var="root" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">
<title>${product.name}</title>

<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">

<style>
body {
	background: #f5f6fa;
	font-family: Segoe UI;
}

/* CARD */
.detail-card {
	background: white;
	border-radius: 12px;
	padding: 30px;
	box-shadow: 0 5px 25px rgba(0, 0, 0, 0.08);
}

/* IMAGE */
.product-image {
	width: 100%;
	max-height: 400px;
	object-fit: contain;
}

/* TITLE */
.product-title {
	font-weight: 700;
	font-size: 28px;
}

/* PRICE */
.product-price {
	color: #e41e31;
	font-size: 26px;
	font-weight: bold;
	margin: 10px 0;
}

/* INFO */
.product-info {
	font-size: 15px;
	margin-bottom: 6px;
}

/* BUTTON */
.btn-cart {
	background: #d81f19;
	border: none;
	padding: 10px 20px;
	font-weight: 600;
}

.btn-cart:hover {
	background: #006b39;
}

.stock {
	color: #666;
	font-size: 14px;
}
</style>

</head>

<body>

	<jsp:include page="header.jsp" />

	<div class="container mt-5">

		<div class="detail-card">

			<div class="row">

				<!-- IMAGE -->

				<div class="col-md-5 text-center">

					<img src="${root}/resources/${product.imageUrl}"
						class="product-image">

				</div>

				<!-- INFO -->

				<div class="col-md-7">

					<div class="product-title">${product.name}</div>

					<div class="product-price">

						<fmt:formatNumber value="${product.price}" type="number" />
						VNĐ

					</div>

					<div class="product-info">
						<b>Brand:</b> ${product.brand}
					</div>

					<div class="product-info">
						<b>Size:</b> ${product.size}
					</div>

					<div class="product-info">
						<b>Color:</b> ${product.color}
					</div>

					<div class="product-info stock">Stock:
						${product.stockQuantity}</div>

					<hr>

					<div class="product-info">${product.description}</div>

					<hr>

					<!-- ADD CART -->

					<c:choose>

						<c:when test="${product.stockQuantity > 0}">

							<form action="${root}/cart" method="post">

								<input type="hidden" name="productId" value="${product.id}">

								<div class="row">

									<div class="col-md-4">

										<input type="number" name="quantity" value="1" min="1"
											max="${product.stockQuantity}" class="form-control">

									</div>

									<div class="col-md-8">

										<form action="${root}/cart" method="post">

											<input type="hidden" name="action" value="add"> <input
												type="hidden" name="productId" value="${product.id}">

											<button class="btn btn-success w-100">🛒 Thêm giỏ
												hàng</button>

										</form>
										<c:if test="${param.added == 'true'}">

											<div class="alert alert-success">Đã thêm sản phẩm vào
												giỏ hàng</div>

										</c:if>

									</div>
								</div>

							</form>

						</c:when>

						<c:otherwise>

							<div class="alert alert-danger">Hết hàng</div>

						</c:otherwise>

					</c:choose>

				</div>

			</div>

		</div>

	</div>

	<jsp:include page="footer.jsp" />

</body>

</html>