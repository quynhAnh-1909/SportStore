<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="root" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sport Store</title>
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css">
    <style>
        body {
            background: #f4f6f9;
            font-family: Segoe UI;
        }


        .hero-container {
            width: 100%;
            height: 420px;
        }

        .carousel-item {
            height: 420px;
            background-color: #000;
        }


        .hero-bg {
            width: 100%;
            height: 100%;

            background-size: contain;
            background-repeat: no-repeat;
            background-position: center;

            background-color: #000;
        }

        /* TEXT */
        .hero-content {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            color: white;
            text-align: center;
        }

        .hero-content h1 {
            font-size: 48px;
            font-weight: bold;
        }

        .hero-content p {
            font-size: 18px;
        }

        /* PRODUCT CARD */
        .product-card {
            border-radius: 12px;
            background: white;
            transition: 0.3s;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
        }

        .product-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.15);
        }

        .product-img-area {
            height: 200px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .product-img {
            max-height: 180px;
        }

        .price {
            color: #e41e31;
            font-weight: bold;
        }

        a.product-link {
            text-decoration: none;
            color: black;
        }

        a.product-link:hover {
            color: #198754;
        }

        /* SECTION TITLE */
        .section-title{

            font-size:28px;

            font-weight:700;

            color:#198754;

            margin:0;

            letter-spacing:0.5px;
        }

        /* SECTION WRAPPER */
        .section-header{

            margin-top:40px;

            margin-bottom:20px;
        }

        /* PRODUCT NAME */
        .product-name{

            font-size:15px;

            font-weight:600;

            min-height:45px;

            display:flex;

            align-items:center;

            justify-content:center;

            text-align:center;
        }

        /* PRICE */
        .price{

            font-size:20px;

            color:#e41e31;

            font-weight:700;
        }

        /* BUTTON */
        .btn-cart{

            font-size:14px;

            border-radius:8px;

            padding:8px;
        }

        /* BUTTON */
        .bestSellerSwiper{
            padding:20px 80px;
        }

        .bestSellerSwiper .swiper-button-prev{
            left:10px;
        }

        .bestSellerSwiper .swiper-button-next{
            right:10px;
        }

        .bestSellerSwiper .swiper-button-prev,
        .bestSellerSwiper .swiper-button-next{

            width:50px;
            height:50px;

            border-radius:50%;

            background:#198754;
            color:white;
        }

        .bestSellerSwiper .swiper-button-prev:after,
        .bestSellerSwiper .swiper-button-next:after{
            font-size:20px;
            font-weight:bold;
        }

        .swiper-slide{
            height:auto;
        }

        .swiper-button-next,
        .swiper-button-prev{
            color:#198754;
        }

        .product-card{
            position:relative;
            z-index:1;
        }

        .product-card .card-body{
            display:flex;
            flex-direction:column;
        }

        .product-card .btn{
            margin-top:auto;
        }

    </style>

</head>

<body>
<jsp:include page="/WEB-INF/layout/index.jsp"/>
<jsp:include page="banner.jsp"/>


<div class="container-fluid px-5 mt-4">

    <c:if test="${empty param.categoryId}">

        <!-- BEST SELLER -->
        <div class="d-flex justify-content-between align-items-center section-header">

            <h2 class="section-title">
                Sản phẩm bán chạy
            </h2>

        </div>

        <div class="swiper bestSellerSwiper">

            <div class="swiper-wrapper">

                <c:forEach items="${bestSellerProducts}" var="p">

                    <div class="swiper-slide">

                        <div class="card product-card h-100">

                            <a href="${root}/productDetail?id=${p.id}">
                                <div class="product-img-area">
                                    <img src="${root}/resources/${p.imageUrl}"
                                         class="product-img">
                                </div>
                            </a>

                            <div class="card-body text-center">

                                <a href="${root}/productDetail?id=${p.id}"
                                   class="product-link">

                                    <div class="product-name">
                                            ${p.name}
                                    </div>

                                </a>

                                <div class="price">
                                    <fmt:formatNumber
                                            value="${p.price}"
                                            type="number"
                                            groupingUsed="true"/>
                                    VNĐ
                                </div>

                                <button type="button"
                                        onclick="addToCart(this, ${p.id})"
                                        class="btn btn-success btn-sm mt-2 w-100">
                                    🛒 Thêm vào giỏ hàng
                                </button>

                            </div>

                        </div>

                    </div>

                </c:forEach>

            </div>

            <div class="swiper-button-prev"></div>
            <div class="swiper-button-next"></div>

        </div>

        <c:forEach items="${categories}" var="c">

            <div class="d-flex justify-content-between align-items-center section-header">

                <h2 class="section-title">
                        ${c.name}
                </h2>

                <a href="${root}/products?categoryId=${c.id}"
                   class="btn btn-outline-success btn-sm">
                    Xem thêm
                </a>

            </div>

            <div class="row g-4">

                <c:forEach items="${categoryProducts[c.id]}" var="p">

                    <div class="col-md-3">

                        <div class="card product-card h-100">

                            <a href="${root}/productDetail?id=${p.id}">
                                <div class="product-img-area">
                                    <img src="${root}/resources/${p.imageUrl}"
                                         class="product-img">
                                </div>
                            </a>

                            <div class="card-body text-center">

                                <a href="${root}/productDetail?id=${p.id}"
                                   class="product-link">

                                    <div class="product-name">
                                            ${p.name}
                                    </div>

                                </a>

                                <div class="price">
                                    <fmt:formatNumber
                                            value="${p.price}"
                                            type="number"
                                            groupingUsed="true"/>
                                    VNĐ
                                </div>

                                <button type="button"
                                        onclick="addToCart(this, ${p.id})"
                                        class="btn btn-success btn-sm mt-2 w-100">

                                    🛒 Thêm vào giỏ hàng

                                </button>

                            </div>

                        </div>

                    </div>

                </c:forEach>

            </div>

        </c:forEach>

    </c:if>

    <c:if test="${not empty param.categoryId}">

        <h2 class="text-center text-success fw-bold mb-4 mt-5">
            DANH SÁCH SẢN PHẨM
        </h2>

        <c:choose>

            <c:when test="${empty products}">

                <div class="alert alert-warning text-center">
                    Không có sản phẩm
                </div>

            </c:when>

            <c:otherwise>

                <div class="row g-4">

                    <c:forEach var="p" items="${products}">

                        <div class="col-md-3">

                            <div class="card product-card h-100">

                                <a href="${root}/productDetail?id=${p.id}">

                                    <div class="product-img-area">

                                        <img src="${root}/resources/${p.imageUrl}"
                                             class="product-img">

                                    </div>

                                </a>

                                <div class="card-body text-center">

                                    <a href="${root}/productDetail?id=${p.id}"
                                       class="product-link">

                                        <div>${p.name}</div>

                                    </a>

                                    <div class="price">

                                        <fmt:formatNumber
                                                value="${p.price}"
                                                type="number"
                                                groupingUsed="true"/>

                                        VNĐ

                                    </div>

                                    <button type="button"
                                            onclick="addToCart(this, ${p.id})"
                                            class="btn btn-success btn-sm mt-2 w-100">

                                        🛒 Thêm vào giỏ hàng

                                    </button>

                                </div>

                            </div>

                        </div>

                    </c:forEach>

                </div>

            </c:otherwise>

        </c:choose>

    </c:if>

    <%--    <!-- TITLE -->--%>
    <%--    <h2 class="text-center text-success fw-bold mb-4">--%>
    <%--        SẢN PHẨM BÁN CHẠY--%>
    <%--    </h2>--%>

    <%--    <!-- LIST -->--%>
    <%--    <c:choose>--%>

    <%--        <c:when test="${empty products}">--%>
    <%--            <div class="alert alert-warning text-center">--%>
    <%--                Không có sản phẩm--%>
    <%--            </div>--%>
    <%--        </c:when>--%>

    <%--        <c:otherwise>--%>
    <%--            <div class="row g-4">--%>

    <%--                <c:forEach var="p" items="${products}">--%>
    <%--                    <div class="col-md-3">--%>

    <%--                        <div class="card product-card h-100">--%>

    <%--                            <!-- CLICK IMAGE -->--%>
    <%--                            <a href="${root}/productDetail?id=${p.id}">--%>
    <%--                                <div class="product-img-area">--%>
    <%--                                    <img src="${root}/resources/${p.imageUrl}"--%>
    <%--                                         class="product-img">--%>
    <%--                                </div>--%>
    <%--                            </a>--%>

    <%--                            <div class="card-body text-center">--%>

    <%--                                <!-- CLICK NAME -->--%>
    <%--                                <a href="${root}/productDetail?id=${p.id}"--%>
    <%--                                   class="product-link">--%>
    <%--                                    <div>${p.name}</div>--%>
    <%--                                </a>--%>


    <%--                                <div class="price">--%>
    <%--                                    <fmt:formatNumber value="${p.price}" type="number" groupingUsed="true"/> VNĐ--%>
    <%--                                </div>                                <!-- ADD TO CART -->--%>
    <%--                                <button type="button"--%>
    <%--                                        onclick="addToCart(this, ${p.id})"--%>
    <%--                                        class="btn btn-success btn-sm mt-2 w-100">--%>
    <%--                                    🛒 Thêm vào giỏ hàng--%>
    <%--                                </button>--%>

    <%--                            </div>--%>

    <%--                        </div>--%>

    <%--                    </div>--%>
    <%--                </c:forEach>--%>

    <%--            </div>--%>
    <%--        </c:otherwise>--%>

    <%--    </c:choose>--%>

    <%--    <!-- PAGINATION -->--%>
    <%--    <div class="text-center mt-4">--%>
    <%--        <c:forEach begin="1" end="${totalPage}" var="i">--%>
    <%--            <a class="btn btn-sm ${i==pageIndex?'btn-success':'btn-outline-success'}"--%>
    <%--               href="${root}/products?page=${i}&keyword=${param.keyword}&categoryId=${param.categoryId}">--%>
    <%--                    ${i}--%>
    <%--            </a>--%>
    <%--        </c:forEach>--%>
    <%--    </div>--%>

</div>

<!-- JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
<jsp:include page="footer.jsp"/>

<script>

    const ROOT = "${pageContext.request.contextPath}";

    const urlParams = new URLSearchParams(window.location.search);

    if (urlParams.get("showLogin") === "true") {
        openAuth('login');
    }

    function addToCart(btn, productId) {

        fetch("${ROOT}/cart", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: "action=add&productId=" + productId
        })
                .then(() => {
                    animateToCart(btn);
                    updateCartCount();
                });
    }

    /* ================= ANIMATION ================= */

    function animateToCart(button) {
        let card = button.closest(".product-card");
        let img = card.querySelector("img");

        let flyingImg = img.cloneNode(true);

        let rect = img.getBoundingClientRect();

        flyingImg.style.position = "fixed";
        flyingImg.style.left = rect.left + "px";
        flyingImg.style.top = rect.top + "px";
        flyingImg.style.width = rect.width + "px";
        flyingImg.style.height = rect.height + "px";
        flyingImg.style.transition = "all 0.8s ease";
        flyingImg.style.zIndex = 9999;
        flyingImg.style.borderRadius = "10px";

        document.body.appendChild(flyingImg);


        let cart = document.querySelector(".cart-wrapper");
        let cartRect = cart.getBoundingClientRect();

        setTimeout(() => {
            flyingImg.style.left = cartRect.left + "px";
            flyingImg.style.top = cartRect.top + "px";
            flyingImg.style.width = "20px";
            flyingImg.style.height = "20px";
            flyingImg.style.opacity = "0.5";
        }, 10);


        setTimeout(() => {
            flyingImg.remove();
        }, 800);
    }

    /* ================= UPDATE COUNT ================= */

    function updateCartCount() {
        fetch("${ROOT}/cart", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: "action=count"
        })
                .then(res => res.text())
                .then(count => {

                    const badge = document.querySelector(".cart-badge");

                    if (!badge) return; // tránh lỗi null

                    badge.innerText = count;

                    if (count > 0) {
                        badge.style.display = "block";
                    } else {
                        badge.style.display = "none";
                    }

                    // animation badge
                    badge.classList.remove("animate");
                    void badge.offsetWidth;
                    badge.classList.add("animate");
                });
    }

    new Swiper(".bestSellerSwiper", {

        slidesPerView: 4,

        spaceBetween: 24,

        navigation: {
            nextEl: ".swiper-button-next",
            prevEl: ".swiper-button-prev"
        },

        breakpoints: {

            0: {
                slidesPerView: 1
            },

            768: {
                slidesPerView: 2
            },

            992: {
                slidesPerView: 3
            },

            1200: {
                slidesPerView: 4
            }
        }
    });

</script>
</body>
</html>
