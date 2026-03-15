<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="root" value="${pageContext.request.contextPath}" />
<c:set var="isEn" value="${sessionScope.lang == 'en'}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<link
	href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700;900&display=swap"
	rel="stylesheet">

<style>
body {
	margin: 0;
	font-family: 'Montserrat', sans-serif;
}

/* ===== HEADER ===== */
.nav-bar {
	background: #d81f19;
	height: 70px;
	padding: 0 40px;
	display: flex;
	align-items: center;
	justify-content: space-between;
	position: sticky;
	top: 0;
	z-index: 1000;
}

/* LOGO */
.logo img {
	height: 50px;
}

/* MENU */
.nav-menu {
	display: flex;
	gap: 10px;
}

.nav-menu a {
	color: white;
	text-decoration: none;
	font-weight: 700;
	padding: 10px 18px;
	border-radius: 4px;
	text-transform: uppercase;
	font-size: 0.9rem;
}

.nav-menu a:hover {
	background: white;
	color: #008f4c;
}

/* SEARCH */
.header-search {
	width: 280px;
	position: relative;
}

.header-search input {
	width: 100%;
	padding: 8px 40px 8px 15px;
	border-radius: 30px;
	border: none;
}

.header-search button {
	position: absolute;
	right: 5px;
	top: 50%;
	transform: translateY(-50%);
	border: none;
	background: #008f4c;
	color: white;
	padding: 6px 10px;
	border-radius: 20px;
}

/* LANGUAGE */
.lang-dropdown {
	position: relative;
	cursor: pointer;
	color: white;
	font-weight: 700;
	font-size: 0.8rem;
}

.lang-current {
	display: flex;
	align-items: center;
	gap: 6px;
}

.lang-flag {
	width: 22px;
	height: 22px;
	border-radius: 50%;
	border: 2px solid #ffd600;
	display: flex;
	align-items: center;
	justify-content: center;
}

.lang-menu {
	display: none;
	position: absolute;
	right: 0;
	top: 120%;
	background: white;
	border-radius: 6px;
	box-shadow: 0 5px 20px rgba(0, 0, 0, 0.25);
}

.lang-menu a {
	display: block;
	padding: 10px 15px;
	text-decoration: none;
	color: #008f4c;
	font-weight: 700;
}

.lang-menu a:hover {
	background: #f1f1f1;
}

.lang-dropdown.open .lang-menu {
	display: block;
}

/* USER */
.user-actions {
	display: flex;
	align-items: center;
	gap: 15px;
}

.btn-user {
	background: white;
	color: #008f4c;
	padding: 8px 16px;
	border-radius: 30px;
	font-weight: 700;
	text-decoration: none;
}

/* CART */
.cart-badge {
	background: red;
	color: white;
	border-radius: 50%;
	padding: 2px 6px;
	font-size: 12px;
	margin-left: 5px;
}
</style>

</head>

<body>

	<header>

		<div class="nav-bar">

			<!-- LOGO -->

			<div class="logo">

				<a href="${root}/productList"> <img
					src="${root}/resources/sport_store.jpg">

				</a>

			</div>


			<!-- MENU -->

			<nav class="nav-menu">

				<a href="${root}/productList"> ${isEn ? 'PRODUCTS' : 'Sản phẩm'}

				</a>

				<c:choose>

					<c:when test="${not empty sessionScope.user}">

						<c:if test="${sessionScope.user.role == 'ADMIN'}">

							<a href="${root}/admin/dashboard" style="color: #ffeb3b;">

								${isEn ? 'ADMIN' : 'Quản trị'} </a>

						</c:if>

						<a href="${root}/logout"> ${isEn ? 'LOGOUT' : 'Đăng xuất'} </a>

					</c:when>

					<c:otherwise>

						<a href="${root}/login"> ${isEn ? 'LOGIN' : 'Đăng nhập'} </a>

						<a href="${root}/register"> ${isEn ? 'REGISTER' : 'Đăng ký'} </a>

					</c:otherwise>

				</c:choose>

			</nav>


			<!-- SEARCH -->

			<form class="header-search" action="${root}/productList" method="get">

				<input type="text" name="keyword" value="${param.keyword}"
					placeholder="${isEn ? 'Search product...' : 'Tìm sản phẩm...'}">

				<button type="submit">🔍</button>

			</form>


			<!-- LANGUAGE -->

			<div class="lang-dropdown">

				<div class="lang-current">

					<div class="lang-flag">${isEn ? '🇬🇧' : '🇻🇳'}</div>

					<span> ${isEn ? 'English' : 'Tiếng Việt'} </span>

				</div>

				<div class="lang-menu">

					<a href="?lang=vi">🇻🇳 Tiếng Việt</a> <a href="?lang=en">🇬🇧
						English</a>

				</div>

			</div>


			<!-- USER + CART -->

			<div class="user-actions">

				<a href="${root}/cart"> 🛒 <span class="cart-badge">

						${sessionScope.cart != null ? sessionScope.cart.size() : 0} </span>

				</a>

				<c:if test="${not empty sessionScope.user}">

					<a href="${root}/account" class="btn-user"> 👤
						${sessionScope.user.fullName} </a>

				</c:if>

			</div>

		</div>

	</header>

	<script>
		document.addEventListener("DOMContentLoaded", function() {

			const dropdown = document.querySelector(".lang-dropdown");

			dropdown.addEventListener("click", function(e) {

				e.stopPropagation();

				dropdown.classList.toggle("open");

			});

			document.addEventListener("click", function() {

				dropdown.classList.remove("open");

			});

		});
	</script>

</body>
</html>