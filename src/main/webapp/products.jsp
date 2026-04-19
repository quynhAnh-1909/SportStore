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
    </style>

</head>

<body>
<jsp:include page="/WEB-INF/layout/index.jsp"/>
<jsp:include page="banner.jsp"/>


<div class="container mt-4">

    <!-- TITLE -->
    <h2 class="text-center text-success fw-bold mb-4">
        SẢN PHẨM BÁN CHẠY
    </h2>

    <!-- LIST -->
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

                            <!-- CLICK IMAGE -->
                            <a href="${root}/productDetail?id=${p.id}">
                                <div class="product-img-area">
                                    <img src="${root}/resources/${p.imageUrl}"
                                         class="product-img">
                                </div>
                            </a>

                            <div class="card-body text-center">

                                <!-- CLICK NAME -->
                                <a href="${root}/productDetail?id=${p.id}"
                                   class="product-link">
                                    <div>${p.name}</div>
                                </a>

                                <div class="price">
                                    <fmt:formatNumber value="${p.price}" type="number" groupingUsed="true"/> VNĐ
                                </div>                                <!-- ADD TO CART -->
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

    <!-- PAGINATION -->
    <div class="text-center mt-4">
        <c:forEach begin="1" end="${totalPage}" var="i">
            <a class="btn btn-sm ${i==pageIndex?'btn-success':'btn-outline-success'}"
               href="${root}/products?page=${i}&keyword=${param.keyword}&categoryId=${param.categoryId}">
                    ${i}
            </a>
        </c:forEach>
    </div>

</div>

<!-- JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<jsp:include page="footer.jsp"/>
<script>

    const urlParams = new URLSearchParams(window.location.search);

    if (urlParams.get("showLogin") === "true") {
        openAuth('login');
    }

    function addToCart(btn, productId) {

        fetch("${root}/cart", {
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
        fetch("${root}/cart", {
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

    document.querySelector(".cart-wrapper")
        .addEventListener("mouseenter", loadCartDropdown);
</script>
</body>
</html>