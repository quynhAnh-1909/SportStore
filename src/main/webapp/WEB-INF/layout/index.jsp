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
        flex:1;
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
        margin-left:auto;
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
        color: black;
        text-decoration: none;
        opacity: 1;
    }

    .dropdown-menu a:hover {
        background: #f0f0f0;
    }

    .nav-links {
        display:flex;
        align-items:center;
        gap:15px;
    }

    .nav-links a {
        color:white;
        text-decoration:none;
        font-weight:600;
        padding:8px 14px;
        border-radius:20px;
        transition:0.3s;
    }

    .nav-links a:hover {
        background:white;
        color:#d81f19;
    }

    .top-bar {
        background:#d81f19;
        color:white;
        position:sticky;
        top:0;
        z-index:950;
        box-shadow:0 2px 10px rgba(0,0,0,0.2);
    }
    .search-bar input {
        width:100%;
        padding:10px 45px 10px 20px;
        border-radius:30px;
        border:none;
        font-size:14px;
    }

    .badge {
        background:yellow;
        color:black;
        border-radius:50%;
        padding:3px 7px;
        font-size:12px;
    }

    .cart-wrapper {
        position: relative;
        font-size: 24px;
        color: white;
        text-decoration: none;
    }

    /* badge số */
    .cart-badge {
        position: absolute;
        top: -5px;
        right: -8px;
        background: yellow;
        color: black;
        font-size: 11px;
        font-weight: bold;
        padding: 2px 6px;
        border-radius: 50%;
        min-width: 18px;
        text-align: center;
    }

    .cart-badge {
        border: 2px solid #d81f19;
    }

    .cart-badge {
        animation: pop 0.3s ease;
    }

    @keyframes pop {
        0% { transform: scale(0.5); }
        100% { transform: scale(1); }
    }

    img {
        position: static !important;
    }

    .cart-wrapper {
        position: relative;
        cursor: pointer;
    }

    /* dropdown */
    .cart-dropdown {
        position: absolute;
        top: 120%;
        right: 0;
        width: 300px;
        background: white;
        border-radius: 10px;
        box-shadow: 0 8px 25px rgba(0,0,0,0.2);
        display: none;
        padding: 10px;
        z-index: 999;
    }

    /* hover */
    .cart-wrapper:hover .cart-dropdown {
        display: block;
    }

    /* item */
    .cart-item {
        display: flex;
        gap: 10px;
        margin-bottom: 10px;
    }

    .cart-item img {
        width: 50px;
        height: 50px;
        object-fit: cover;
    }

    .cart-item-name {
        font-size: 13px;
    }

    .cart-item-price {
        color: red;
        font-weight: bold;
        font-size: 13px;
    }

    .cart-footer {
        border-top: 1px solid #eee;
        padding-top: 10px;
    }

    .cart-dropdown {
        position: absolute;
        top: 100%;
        right: 0;
        display: none;
        z-index: 9999;
    }

    .cart-wrapper:hover .cart-dropdown {
        display: block;
    }

</style>

<!-- AUTH -->
<jsp:include page="/WEB-INF/layout/auth.jsp"/>

<div class="top-bar">
    <div class="container">

        <!-- LOGO -->
        <div class="logo">
            <a href="${root}/products">
                <img src="${root}/resources/sport_store.jpg">
            </a>

                <span class="logo-text">SportStore</span>

        </div>

        <!--SEARCH  -->
        <form class="search-bar" action="${root}/products" method="get">
            <input type="text" name="keyword" placeholder=" Tìm kiếm sản phẩm..." />
        </form>

        <div class="nav-links">
            <a href="${root}/products">Trang chủ</a>

            <div class="dropdown">
                <a href="#">Khuyến mãi</a>
                <div class="dropdown-menu">
                    <a href="#"> Giảm giá hôm nay</a>
                    <a href="#"> Mã giảm giá</a>
                </div>
            </div>

            <div class="dropdown">
                <a href="#">Thành viên</a>
                <div class="dropdown-menu">
                    <a href="#"> Hồ sơ</a>
                    <a href="#"> Đơn hàng</a>
                </div>
            </div>
        </div>

        <!-- USER -->
        <div class="user-actions">

            <c:set var="cartCount" value="0"/>

            <c:if test="${not empty sessionScope.cart}">
                <c:forEach var="item" items="${sessionScope.cart}">
                    <c:set var="cartCount" value="${cartCount + item.quantity}"/>
                </c:forEach>
            </c:if>

            <div class="cart-wrapper">

                <a href="${root}/cart" class="cart-icon">🛒</a>

                <span class="cart-badge" style="${cartCount == 0 ? 'display:none' : ''}">
                    ${cartCount}
                </span>

                <div class="cart-dropdown">
                    <div id="cart-items"></div>

                    <div class="cart-footer">
                        <a href="${root}/cart" class="btn btn-danger w-100">
                            Xem giỏ hàng
                        </a>
                    </div>
                </div>

            </div>

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

<script>

    function loadCartDropdown() {

        fetch("${root}/cart?action=get")
            .then(res => res.json())
            .then(data => {

                const container = document.getElementById("cart-items");

                if (!container) return;

                if (data.length === 0) {
                    container.innerHTML = "<div>Giỏ hàng trống</div>";
                    return;
                }

                let html = "";

                data.forEach(item => {
                    html += `
                    <div class="cart-item">
                        <img src="${root}/resources/${item.image}">
                        <div>
                            <div class="cart-item-name">${item.name}</div>
                            <div class="cart-item-price">
                                ${item.price} x ${item.quantity}
                            </div>
                        </div>
                    </div>
                `;
                });

                container.innerHTML = html;
            });
    }

    document.addEventListener("DOMContentLoaded", function () {
        const cart = document.querySelector(".cart-wrapper");

        if (cart) {
            cart.addEventListener("mouseenter", loadCartDropdown);
        }
    });

</script>