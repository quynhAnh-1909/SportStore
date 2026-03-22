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
        gap:20px; /* 🔥 quan trọng để đều */
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
                    <a href="${root}/account" class="account">
                        👤 ${sessionScope.user.fullName}
                    </a>

                    <c:if test="${sessionScope.user.role == 'ADMIN'}">
                        <a href="${root}/admin/dashboard">⚙️ Trang quản trị</a>
                    </c:if>
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