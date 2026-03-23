<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="root" value="${pageContext.request.contextPath}" />

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">

<style>
    .top-bar {
        background:#d81f19;
        color:white;
        position:sticky;
        top:0;
        z-index:950;
    }

    .top-bar .container {
        display:flex;
        align-items:center;
        padding:0 25px;
        height:70px;
        gap:20px;
    }

    /* LOGO */
    .logo {
        display:flex;
        align-items:center;
        gap:10px;
        min-width:180px;
    }

    .logo img {
        height:60px;
    }

    .logo-text {
        font-size:22px;
        font-weight:bold;
        color:white;
    }

    /* SEARCH (đẩy giữa) */
    .search-bar {
        flex:1; /* 🔥 ăn hết khoảng giữa */
        max-width:500px;
        position:relative;
    }

    .search-bar input {
        width:100%;
        padding:8px 40px 8px 15px;
        border-radius:25px;
        border:none;
        font-size:14px;
    }

    .search-bar button {
        position:absolute;
        right:5px;
        top:50%;
        transform:translateY(-50%);
        border:none;
        background:#b71c1c;
        color:white;
        padding:6px 10px;
        border-radius:50%;
    }

    /* MENU */
    .nav-links {
        display:flex;
        gap:10px;
    }

    .nav-links a {
        color:white;
        text-decoration:none;
        font-weight:600;
        padding:7px 14px;
        border-radius:5px;
        transition:0.2s;
        white-space:nowrap;
    }

    .nav-links a:hover {
        background:white;
        color:#d81f19;
    }

    /* USER */
    .user-actions {
        display:flex;
        gap:18px;
        align-items:center;
        margin-left:auto; /* 🔥 đẩy về phải */
    }

    .cart {
        font-size:24px;
    }

    .account {
        background:white;
        color:#d81f19;
        padding:7px 14px;
        border-radius:20px;
        font-weight:600;
    }

    .user-actions a {
        color:white;
        text-decoration:none;
    }
    /* dropdown account */

    /* dropdown account */
    .dropdown {
        position: relative;
    }

    .dropdown:hover .dropdown-menu {
        display: block;
    }

    .dropdown-menu {
        display: none;
        position: absolute;
        background: white;
        min-width: 180px;
        box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        border-radius: 6px;
        z-index: 999;
    }

    .dropdown-menu a {
        display: block;
        padding: 10px 15px;
        color: black;   /* chữ hiện rõ luôn */
        text-decoration: none;
        opacity: 1;     /* không mờ */
    }

    .dropdown-menu a:hover {
        background: #f0f0f0;
    }
</style>

<!-- AUTH -->
<jsp:include page="auth.jsp"/>

<div class="top-bar">
    <div class="container">

        <!-- LOGO -->
        <div class="logo">
            <a href="${root}/products">
                <img src="${root}/resources/sport_store.jpg">
            </a>
            <span class="logo-text">SportStore</span>
        </div>

        <!-- 🔥 SEARCH (đưa lên trước) -->
        <form class="search-bar" action="${root}/products" method="get">
            <input type="text" name="keyword" placeholder="🔍 Tìm sản phẩm...">
        </form>

        <!-- 🔥 MENU (đưa xuống sau search) -->
        <div class="nav-links">
            <a href="${root}/products">Sản phẩm</a>
        </div>

        <!-- USER -->
        <div class="user-actions">

            <a href="${root}/cart" class="cart">
                🛒 ${sessionScope.cart!=null?sessionScope.cart.size():0}
            </a>

            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <div class="dropdown">
                        <button class="account dropdown-toggle" type="button" id="accountMenu" data-bs-toggle="dropdown" aria-expanded="false">
                            👤 ${sessionScope.user.fullName}
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="accountMenu">
                            <li><a class="dropdown-item" href="${root}/account">Thông tin cá nhân</a></li>
                            <c:if test="${sessionScope.user.role == 'ADMIN'}">
                                <li><a class="dropdown-item" href="${root}/admin/dashboard">⚙️ Trang quản trị</a></li>
                            </c:if>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="${root}/logout">🚪 Đăng xuất</a></li>
                        </ul>
                    </div>
                </c:when>

                <c:otherwise>
                    <a href="#" onclick="openAuth('login')">Đăng nhập</a>
                    <span>/</span>
                    <a href="#" onclick="openAuth('register')">Đăng ký</a>
                </c:otherwise>
            </c:choose>

        </div>
    </div>
</div>