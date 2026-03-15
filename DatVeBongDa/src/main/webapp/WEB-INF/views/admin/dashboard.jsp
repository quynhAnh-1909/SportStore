<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="root" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>

<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Admin Dashboard</title>

<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

<style>
:root {
	--admin-sidebar-bg: #212529;
	--admin-main-success: #198754;
}

body {
	background: #f4f6f9;
	font-size: 0.9rem;
}

#wrapper {
	display: flex;
}

#sidebar-wrapper {
	width: 250px;
	min-height: 100vh;
	background: var(--admin-sidebar-bg);
}

.sidebar-heading {
	padding: 1.5rem;
	color: white;
	text-align: center;
	background: #1a1d20;
}

.list-group-item {
	background: transparent;
	color: #c2c7d0;
	border: none;
}

.list-group-item:hover {
	background: rgba(255, 255, 255, 0.1);
	color: white;
}

.list-group-item.active {
	background: var(--admin-main-success);
	color: white;
}

#page-content-wrapper {
	flex: 1;
}

.admin-navbar {
	background: white;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}
</style>

</head>

<body>

	<div id="wrapper">

		<!-- SIDEBAR -->

		<div id="sidebar-wrapper">

			<div class="sidebar-heading">
				<h5 class="fw-bold">
					<i class="fas fa-store text-success"></i> SPORT SHOP ADMIN
				</h5>
			</div>

			<div class="list-group list-group-flush pt-3">

				<a href="${root}/admin/dashboard"
					class="list-group-item list-group-item-action"> <i
					class="fas fa-chart-line me-2"></i> Tổng quan
				</a> <a href="${root}/admin/orders"
					class="list-group-item list-group-item-action"> <i
					class="fas fa-shopping-cart me-2"></i> Quản lý đơn hàng
				</a> <a href="${root}/admin/products"
					class="list-group-item list-group-item-action"> <i
					class="fas fa-box me-2"></i> Quản lý sản phẩm
				</a> <a href="${root}/admin/categories"
					class="list-group-item list-group-item-action"> <i
					class="fas fa-layer-group me-2"></i> Quản lý danh mục
				</a>

				<div class="border-top my-3"></div>

				<a href="${root}/productList"
					class="list-group-item list-group-item-action text-info"> <i
					class="fas fa-external-link-alt me-2"></i> Xem trang khách
				</a>

			</div>

		</div>

		<!-- PAGE CONTENT -->

		<div id="page-content-wrapper">

			<nav class="navbar admin-navbar px-4 py-2">

				<button class="btn btn-outline-secondary btn-sm" id="menu-toggle">
					<i class="fas fa-bars"></i>
				</button>

				<div class="ms-auto">

					<span class="me-3"> Xin chào <strong>${sessionScope.user.fullName}</strong>
					</span> <a href="${root}/logout" class="btn btn-sm btn-outline-danger">
						Đăng xuất </a>

				</div>

			</nav>

			<div class="container-fluid p-4">

				<c:choose>

					<c:when test="${not empty contentPage}">
						<jsp:include page="${contentPage}" />
					</c:when>

					<c:otherwise>

						<h3 class="mb-4">Dashboard</h3>

						<div class="row g-4">

							<div class="col-md-4">
								<div class="card shadow border-0">
									<div class="card-body text-center">
										<h5>Tổng sản phẩm</h5>
										<h2>${productCount}</h2>
									</div>
								</div>
							</div>

							<div class="col-md-4">
								<div class="card shadow border-0">
									<div class="card-body text-center">
										<h5>Tổng đơn hàng</h5>
										<h2>${orderCount}</h2>
									</div>
								</div>
							</div>

							<div class="col-md-4">
								<div class="card shadow border-0">
									<div class="card-body text-center">
										<h5>Doanh thu</h5>
										<h2>${revenue}₫</h2>
									</div>
								</div>
							</div>

						</div>

					</c:otherwise>

				</c:choose>

			</div>

			<script
				src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

			<script>
				document.getElementById("menu-toggle").addEventListener(
						"click",
						function() {
							document.getElementById("wrapper").classList
									.toggle("toggled");
						});
			</script>
</body>
</html>
