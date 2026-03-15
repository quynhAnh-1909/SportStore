<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<c:set var="root" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title>Giỏ hàng</title>

<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">

<style>
body {
	background: #f5f5f5;
	font-family: Segoe UI;
}

.cart-container {
	background: white;
	padding: 20px;
	border-radius: 8px;
}

.cart-header {
	font-weight: bold;
	color: #888;
	border-bottom: 1px solid #eee;
	padding-bottom: 10px;
	margin-bottom: 15px;
}

.cart-item {
	padding: 15px 0;
	border-bottom: 1px solid #eee;
	align-items: center;
}

.product-img {
	width: 80px;
	height: 80px;
	object-fit: contain;
}

.product-name {
	font-weight: 600;
}

.price {
	color: #e41e31;
	font-weight: bold;
}

.qty-box{
    width:40px;
    height:35px;
    padding:0;
}

.remove-btn {
	color: red;
	cursor: pointer;
}

.cart-summary {
	background: white;
	padding: 20px;
	border-radius: 8px;
}

.checkout-btn {
	background: #ee4d2d;
	color: white;
	font-weight: bold;
}
</style>

</head>

<body>

	<jsp:include page="header.jsp" />

	<div class="container mt-4">

		<div class="row">

			<!-- CART LIST -->

			<div class="col-md-8">

				<div class="cart-container">

					<div class="row cart-header">

						<div class="col-md-5">Sản phẩm</div>
						<div class="col-md-2 text-center">Đơn giá</div>
						<div class="col-md-2 text-center">Số lượng</div>
						<div class="col-md-2 text-center">Thành tiền</div>
						<div class="col-md-1 text-center">Xóa</div>

					</div>

					<c:set var="total" value="0" />

					<c:forEach var="item" items="${sessionScope.cart}">

						<div class="row cart-item">

							<div class="col-md-5 d-flex align-items-center">

								<img src="${root}/resources/${item.product.imageUrl}"
									class="product-img">

								<div class="ms-3 product-name">${item.product.name}</div>

							</div>

							<div class="col-md-2 text-center price">

								<fmt:formatNumber value="${item.product.price}" type="number" />

							</div>

							<div class="col-md-2 text-center">

								<form action="${root}/cart" method="post">

									<input type="hidden" name="action" value="update"> <input
										type="hidden" name="productId" value="${item.product.id}">

									<div class="d-flex justify-content-center align-items-center">

										<form action="${root}/cart" method="post" class="d-flex">

											<input type="hidden" name="action" value="update"> <input
												type="hidden" name="productId" value="${item.product.id}">

											<button type="submit" name="quantity"
												value="${item.quantity - 1}"
												class="btn btn-outline-secondary btn-sm">-</button>

											<input type="text" value="${item.quantity}"
												class="form-control text-center mx-1 qty-box" readonly>

											<button type="submit" name="quantity"
												value="${item.quantity + 1}"
												class="btn btn-outline-secondary btn-sm">+</button>

										</form>

									</div>

								</form>

							</div>

							<div class="col-md-2 text-center price">

								<fmt:formatNumber value="${item.product.price * item.quantity}"
									type="number" />

							</div>

							<div class="col-md-1 text-center">

								<a href="${root}/cart?action=remove&id=${item.product.id}"
									class="remove-btn"> ❌ </a>

							</div>

						</div>

						<c:set var="total"
							value="${total + (item.product.price * item.quantity)}" />

					</c:forEach>

				</div>

			</div>

			<!-- SUMMARY -->

			<div class="col-md-4">

				<div class="cart-summary">

					<h5>Tóm tắt đơn hàng</h5>

					<hr>

					<div class="d-flex justify-content-between">

						<span>Tổng tiền</span> <b class="price"> <fmt:formatNumber
								value="${total}" type="number" /> VNĐ

						</b>

					</div>

					<a href="${root}/checkout" class="btn checkout-btn w-100 mt-3">
						Thanh toán </a>

				</div>

			</div>

		</div>

	</div>

</body>
</html>