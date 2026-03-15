<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<c:set var="root" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title>Checkout</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">

<style>
.payment-box input[type="radio"] {
	display: none;
}

.payment-box .card {
	cursor: pointer;
	transition: 0.2s;
	border: 2px solid #f1f1f1;
}

.payment-box input[type="radio"]:checked+.card {
	border-color: #198754;
	background: #f0fff4;
}
</style>

</head>

<body>

	<jsp:include page="header.jsp" />

	<div class="container my-5">

		<div class="row">

			<!-- LEFT -->

			<div class="col-lg-7">

				<div class="card shadow-sm border-0">

					<div class="card-body p-4">

						<h2 class="fw-bold text-success mb-3">Thông tin thanh toán</h2>

						<form action="${root}/checkout" method="post">
							<!-- NAME -->

							<div class="mb-3">

								<label class="form-label fw-bold">Họ tên người nhận</label> <input
									type="text" name="receiverName" class="form-control">

							</div>

							<!-- PHONE -->

							<div class="mb-3">

								<label class="form-label fw-bold">Số điện thoại</label> <input
									type="text" name="receiverPhone" class="form-control">

							</div>

							<!-- ADDRESS -->

							<div class="mb-3">

								<label class="form-label fw-bold">Địa chỉ giao hàng</label>

								<textarea name="address" class="form-control"></textarea>

							</div>

							<!-- NOTE -->

							<div class="mb-3">

								<label class="form-label fw-bold">Ghi chú</label>

								<textarea name="note" class="form-control"></textarea>

							</div>

							<hr>

							<h5 class="fw-bold">Phương thức thanh toán</h5>

							<div class="row g-3 mt-2">

								<!-- COD -->

								<div class="col-6">
									<label class="payment-box w-100"> <input type="radio"
										name="paymentMethod" value="COD" checked>

										<div class="card p-3 text-center">
											💵
											<div class="fw-bold mt-2">Thanh toán khi nhận hàng</div>
										</div>

									</label>
								</div>

								<!-- VNPAY -->

								<div class="col-6">
									<label class="payment-box w-100"> <input type="radio"
										name="paymentMethod" value="VNPAY">

										<div class="card p-3 text-center">
											💳
											<div class="fw-bold mt-2">Thanh toán VNPay</div>
										</div>

									</label>
								</div>

							</div>
							<button type="submit" class="btn btn-success btn-lg w-100 mt-4">
								XÁC NHẬN ĐẶT HÀNG</button>
						</form>

					</div>
				</div>
			</div>


			<!-- RIGHT ORDER SUMMARY -->

			<div class="col-lg-5">

				<div class="card shadow-sm">

					<div class="card-body">

						<h5 class="fw-bold border-bottom pb-2">Đơn hàng của bạn</h5>

						<c:set var="total" value="0" />

						<c:forEach var="item" items="${sessionScope.cart}">

							<div class="d-flex align-items-center mb-3">

								<img src="${root}/resources/${item.product.imageUrl}" width="50"
									height="50" style="object-fit: cover">

								<div class="ms-3 flex-grow-1">

									<b>${item.product.name}</b> <br> SL: ${item.quantity}

								</div>

								<div>

									<fmt:formatNumber value="${item.product.price * item.quantity}"
										type="number" />

									₫

								</div>

							</div>

							<c:set var="total"
								value="${total + (item.product.price * item.quantity)}" />

						</c:forEach>

						<hr>

						<div class="d-flex justify-content-between">

							<span>Tạm tính</span> <span> <fmt:formatNumber
									value="${total}" type="number" /> ₫

							</span>

						</div>

						<div class="d-flex justify-content-between">

							<span>Phí giao hàng</span> <span>30,000 ₫</span>

						</div>

						<hr>

						<div class="d-flex justify-content-between fw-bold">

							<span>TỔNG CỘNG</span> <span class="text-danger"> <fmt:formatNumber
									value="${total + 30000}" type="number" /> ₫

							</span>

						</div>

					</div>
				</div>
			</div>

		</div>
	</div>

	<jsp:include page="footer.jsp" />

</body>
</html>