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

<link
	href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700;900&display=swap"
	rel="stylesheet">

<style>
:root {
	--red: #d81f19;
	--green: #008f4c;
	--yellow: #ffeb3b;
	--dark-red: #b71c1c;
	--light-bg: #fff5f5;
}

body {
	background: var(--light-bg);
	font-family: 'Montserrat', sans-serif;
	font-size: 0.95rem;
	margin: 0;
}

#wrapper {
	display: flex;
	min-height: 100vh;
}

/* ===== SIDEBAR ===== */
#sidebar-wrapper {
	width: 260px;
	background: var(--red);
	color: white;
	min-height: 100vh;
	box-shadow: 3px 0 10px rgba(0,0,0,0.1);
}

.sidebar-heading {
	padding: 25px;
	text-align: center;
	background: var(--dark-red);
	font-size: 1.2rem;
	font-weight: bold;
}

.list-group-item {
	background: transparent;
	color: white;
	border: none;
	padding: 14px 22px;
	font-weight: 600;
	transition: 0.3s;
}

.list-group-item:hover {
	background: var(--yellow);
	color: var(--green);
	padding-left: 28px;
}

.list-group-item i {
	width: 22px;
}

/* ===== CONTENT ===== */
#page-content-wrapper {
	flex: 1;
}

/* ===== NAVBAR ===== */
.admin-navbar {
	background: white;
	padding: 15px 30px;
	border-bottom: 3px solid var(--red);
	box-shadow: 0 2px 8px rgba(0,0,0,0.08);
}

/* ===== DASHBOARD TITLE ===== */
.dashboard-title {
	font-weight: 800;
	color: var(--red);
	margin-bottom: 25px;
}

/* ===== CARD ===== */
.dashboard-card {
	border: none;
	border-radius: 18px;
	box-shadow: 0 8px 20px rgba(0,0,0,0.08);
	transition: 0.3s;
	overflow: hidden;
}

.dashboard-card:hover {
	transform: translateY(-5px);
}

.card-header-custom {
	height: 6px;
	background: var(--red);
}

.dashboard-card .card-body {
	padding: 25px;
	text-align: center;
}

.dashboard-card h5 {
	color: var(--red);
	font-weight: 700;
}

.dashboard-card h2 {
	color: var(--green);
	font-weight: 900;
	font-size: 2rem;
}


/* ===== BUTTON ===== */
.btn-logout {
	border: 2px solid var(--red);
	color: var(--red);
	font-weight: 700;
	border-radius: 30px;
	padding: 6px 18px;
}

.btn-logout:hover {
	background: var(--red);
	color: white;
}
</style>
</head>

<body>

<div id="wrapper">

	<!-- SIDEBAR -->
	<div id="sidebar-wrapper">

		<div class="sidebar-heading">
			<i class="fas fa-store"></i> SPORT SHOP ADMIN
		</div>

		<div class="list-group list-group-flush pt-3">

			<a href="${root}/admin/dashboard" class="list-group-item">
				<i class="fas fa-chart-line"></i> Tổng quan
			</a>

			<a href="${root}/admin/orders" class="list-group-item">
				<i class="fas fa-shopping-cart"></i> Quản lý đơn hàng
			</a>

			<a href="${root}/admin/products" class="list-group-item">
				<i class="fas fa-box"></i> Quản lý sản phẩm
			</a>

			<a href="${root}/admin/categories" class="list-group-item">
				<i class="fas fa-layer-group"></i> Quản lý danh mục
			</a>

			<a href="${root}/productList" class="list-group-item">
				<i class="fas fa-globe"></i> Xem trang khách
			</a>

		</div>

	</div>

	<!-- CONTENT -->
	<div id="page-content-wrapper">

		<nav class="admin-navbar d-flex justify-content-between align-items-center">

			<div>
				<strong>Xin chào ${sessionScope.user.fullName}</strong>
			</div>

			<a href="${root}/logout" class="btn btn-logout">
				Đăng xuất
			</a>

		</nav>

		<div class="container-fluid p-4">

			<c:choose>

				<c:when test="${not empty contentPage}">
					<jsp:include page="${contentPage}" />
				</c:when>

				<c:otherwise>

	<h3 class="dashboard-title">Dashboard</h3>

	<!-- STATS -->
	<div class="row g-4">

		<div class="col-md-4">
			<div class="dashboard-card">
				<div class="card-header-custom"></div>
				<div class="card-body">
					<h5>Tổng sản phẩm</h5>
					<h2>${productCount}</h2>
				</div>
			</div>
		</div>

		<div class="col-md-4">
			<div class="dashboard-card">
				<div class="card-header-custom"></div>
				<div class="card-body">
					<h5>Tổng đơn hàng</h5>
					<h2>${orderCount}</h2>
				</div>
			</div>
		</div>

		<div class="col-md-4">
			<div class="dashboard-card">
				<div class="card-header-custom"></div>
				<div class="card-body">
					<h5>Doanh thu</h5>
					<h2>${revenue}₫</h2>
				</div>
			</div>
		</div>

	</div>

	<!-- TOP + THÔNG BÁO -->
	<div class="row mt-4">

		<div class="col-md-8">
			<div class="card">
				<div class="card-body">
					<h5 class="fw-bold text-danger">
						<i class="fas fa-fire"></i> Top sản phẩm bán chạy
					</h5>

					<table class="table table-hover mt-3">
						<thead>
							<tr>
								<th>Sản phẩm</th>
								<th>Đã bán</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>Yonex Astrox 88D</td>
								</tr>
							<tr>
								<td>Adidas Predator Ball</td>
							</tr>
							<tr>
								<td>Nike Air Zoom</td>
								</tr>
						</tbody>
					</table>

				</div>
			</div>
		</div>

		<div class="col-md-4">

			<div class="card">
				<div class="card-body">
					<h5 class="fw-bold text-success">
						<i class="fas fa-bell"></i> Thông báo
					</h5>

					<p>🔔 Có <span id="newOrderBadge">${newOrderCount}</span> đơn mới</p>
					<p>📦 ${productCount} Sản phẩm đang hoạt động</p>
				</div>
			</div>

		</div>

	</div>

	<!-- CHART -->
	<div class="card mt-4">
		<div class="card-body">
			<h5 class="fw-bold text-success">
				<i class="fas fa-chart-line"></i> Doanh thu theo tháng
			</h5>

			<canvas id="revenueChart"></canvas>
		</div>
	</div>

</c:otherwise>

			</c:choose>

		</div>

	</div>

</div>

</body>
</html>
