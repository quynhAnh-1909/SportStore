<%@ page contentType="text/html;charset=UTF-8" %>
<%--<%@ taglib prefix="c" uri="jakarta.tags.core" %>--%>
<%--<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="root" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>${product.name}</title>

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">

    <style>
        body {
            background: #f4f6f9;
            font-family: Segoe UI;
        }

        .detail-card {
            border-radius: 14px;
            background: white;
            padding: 20px 25px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        }

        .product-image {
            width: 100%;
            max-height: 350px;
            object-fit: contain;
        }

        .product-title {
            font-weight: 700;
            font-size: 28px;
        }

        .product-price {
            color: #ee4d2d;
            font-size: 30px;
            font-weight: bold;
            margin: 12px 0;
        }

        /* BACK LINK */
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            color: #ee4d2d;
            font-size: 15px;
            text-decoration: none;
            margin-bottom: 15px;
        }

        .back-link:hover {
            color: #d73211;
        }

        /* LABEL */
        .label {
            width: 100px;
            flex-shrink: 0;
            color: #757575;
            font-size: 14px;
        }

        /* QUANTITY */
        .quantity-box {
            display: flex;
            align-items: center;

            width: fit-content;
        }

        .quantity-box input {
            width: 40px;
            height: 32px;
            text-align: center;
            border: none;
            outline: none;
        }

        .quantity-box input {
            border-left: 1px solid #ccc;
            border-right: 1px solid #ccc;
        }

        .qty-btn {
            width: 32px;
            height: 32px;
            border: none;
            background: transparent;
            cursor: pointer;
        }

        .label {
            min-width: 90px;
        }

        .qty-btn:hover {
            background: #f5f5f5;
        }

        /* BUTTON */
        .btn-cart {
            background: #ee4d2d;
            color: white;
            padding: 8px 16px;
            border-radius: 6px;
            border: none;
            margin: 0;
            line-height: 1;
        }

        .btn-buy {
            background: #ff9800;
            color: white;
            padding: 8px 16px;
            border-radius: 6px;
            border: none;
            margin: 0;
            line-height: 1;
        }

        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 15px;
        }

        .btn-cart, .btn-buy {
            height: 40px;
            padding: 0 20px;
            border-radius: 6px;
        }

        /* VOUCHER */
        .voucher-box {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .voucher {
            background: #fff0ec;
            color: #ee4d2d;
            padding: 4px 10px;
            border: 1px dashed #ee4d2d;
            font-size: 13px;
        }

        /* SHIPPING */
        .shipping-box {
            display: flex;
            gap: 15px;
        }

        /* SHARE */
        .share-box {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-top: 10px;
        }

        .share {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: #f5f5f5;
            display: flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
        }

        .share:hover {
            background: #ddd;
        }

        .stock {
            font-size: 14px;
            color: #666;
        }
        .product-extra {
            background: white;
            padding: 25px;
            border-radius: 10px;
        }

        .extra-section {
            border-top: 1px solid #eee;
            padding-top: 15px;
        }

        .extra-card {
            background: white;
            padding: 25px;
            border-radius: 14px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
        }

        .section-title {
            font-weight: 600;
            font-size: 18px;
            background: #f5f5f5;
            padding: 10px;
            border-radius: 6px;
        }

        /* TITLE */
        .suggest-title {
            font-weight: 600;
            font-size: 18px;
        }

        /* CARD */
        .suggest-card {
            display: block;
            background: white;
            padding: 10px;
            border-radius: 10px;
            text-decoration: none;
            color: black;
            transition: 0.2s;
        }

        .suggest-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        /* IMAGE */
        .suggest-img {
            width: 100%;
            height: 200px;
            object-fit: contain;
            background: #f5f5f5;
            padding: 10px;
        }

        /* NAME */
        .suggest-name {
            font-size: 14px;
            margin: 10px 0;
            color: #333;
            min-height: 40px;
        }

        /* PRICE */
        .suggest-price {
            color: #ee4d2d;
            font-weight: bold;
        }

        .suggest-card {
            display: block;
            background: #fff;
            border-radius: 8px;
            padding: 10px;
            text-align: center;
            transition: 0.2s;
            text-decoration: none;
        }

        .suggest-card:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            transform: translateY(-3px);
        }

        .zoom-container {
            position: relative;
            overflow: hidden;
            cursor: zoom-in;
        }

        .zoom-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.2s ease;
        }

        .zoom-container:hover .zoom-img {
            transform: scale(2);
        }

        .hidden-product {
            display: none;
        }

    </style>

</head>

<body>

<jsp:include page="/WEB-INF/layout/index.jsp"/>

<div class="container mt-5">

    <div class="detail-card">

        <!-- BACK -->
        <a href="${root}/products" class="back-link">
            ← Quay lại
        </a>

        <div class="row align-items-center">

            <!-- IMAGE -->
            <div class="col-md-5 text-center">
                <div class="zoom-container">
                    <img src="${root}/resources/${product.imageUrl}" class="zoom-img">
                </div>
                <!-- SHARE -->
                <div class="share-box mt-3">
                    <span>Chia sẻ:</span>
                    <a href="#" class="share">f</a>
                    <a href="#" class="share">💬</a>
                    <a href="#" class="share">P</a>
                </div>
            </div>

            <!-- INFO -->
            <div class="col-md-7">

                <div class="product-title">${product.name}</div>

                <div class="product-price">
                    <fmt:formatNumber value="${product.price}"/> VNĐ
                </div>

                <!-- VOUCHER -->
                <div class="voucher-box mt-3">
                    <div class="label">Mã giảm giá</div>
                    <div>
                        <span class="voucher">Giảm 10k</span>
                        <span class="voucher">Giảm 20k</span>
                    </div>
                </div>

                <!-- SHIPPING -->
                <div class="shipping-box mt-2">
                    <div class="label">Vận chuyển</div>
                    <div>
                        🚚 2-4 ngày<br>
                        <span class="text-muted">Miễn phí vận chuyển</span>
                    </div>
                </div>

                <c:choose>

                    <c:when test="${product.stockQuantity > 0}">

                        <!-- SỐ LƯỢNG -->
                        <div class="d-flex align-items-center mt-3" style="gap:20px;">
                            <div class="label">Số lượng</div>

                            <div class="quantity-box">
                                <button type="button" class="qty-btn" onclick="decrease()">-</button>
                                <input type="text" id="quantity" value="1">
                                <button type="button" class="qty-btn"
                                        onclick="increase(${product.stockQuantity})">+</button>
                            </div>
                        </div>

                        <!-- BUTTON -->
                        <div class="action-buttons mt-3">

                            <button type="button" class="btn-cart"
                                    onclick="addToCart(${product.id})">
                                🛒 Thêm vào giỏ hàng
                            </button>

                            <button type="button" class="btn-buy"
                                    onclick="buyNow(${product.id})">
                                ⚡ Mua ngay
                            </button>

                        </div>

                    </c:when>

                    <c:otherwise>
                        <div class="alert alert-danger">Hết hàng</div>
                    </c:otherwise>

                </c:choose>

            </div>

        </div>

    </div>

    <!-- CARD CHI TIẾT + MÔ TẢ -->
    <div class="detail-card mt-4">

        <!-- CHI TIẾT -->
        <div class="section-title">CHI TIẾT SẢN PHẨM</div>

        <div class="row mt-3">
            <div class="col-md-3 text-muted">Danh mục</div>
            <div class="col-md-9">Thời trang / Áo hoodie</div>
        </div>

        <div class="row mt-2">
            <div class="col-md-3 text-muted">Thương hiệu</div>
            <div class="col-md-9">Nike</div>
        </div>

        <div class="row mt-2">
            <div class="col-md-3 text-muted">Xuất xứ</div>
            <div class="col-md-9">Việt Nam</div>
        </div>

        <hr>

        <!-- MÔ TẢ -->
        <div class="section-title">MÔ TẢ SẢN PHẨM</div>

        <div class="mt-3">
            ${product.description}
        </div>

    </div>

    <!-- GỢI Ý SẢN PHẨM -->
    <div class="mt-4">

        <div class="suggest-title mb-3">
            GỢI Ý CHO BẠN
        </div>

        <div class="row">

                    <c:forEach var="p" items="${relatedProducts}" varStatus="status">

                        <div class="col-md-3 mb-4 ${status.index >= 4 ? 'hidden-product' : ''}">

                            <!-- Tạo URL đúng -->
                            <c:url var="link" value="/productDetail">
                                <c:param name="id" value="${p.id}" />
                                <c:if test="${showAll != null}">
                                    <c:param name="showAll" value="true" />
                                </c:if>
                            </c:url>

                            <!-- Dùng link -->
                            <a href="${link}" class="suggest-card">

                                <img src="${root}/resources/${p.imageUrl}" class="suggest-img">

                                <div class="suggest-name">
                                        ${p.name}
                                </div>

                                <div class="suggest-price">
                                    <fmt:formatNumber value="${p.price}"/> VNĐ
                                </div>

                            </a>

                        </div>

                    </c:forEach>

        </div>

<%--        <c:if test="${showAll == null}">--%>
<%--            <div style="text-align: center; margin-top: 20px;">--%>
<%--                <a href="${root}/productDetail?id=${product.id}&showAll=true"--%>
<%--                   class="btn btn-outline-danger">--%>
<%--                    Xem thêm--%>
<%--                </a>--%>
<%--            </div>--%>
<%--        </c:if>--%>
        <div style="text-align: center; margin-top: 20px;">
            <button onclick="toggleProducts()" class="btn btn-outline-danger">
                Xem thêm
            </button>
        </div>

    </div>



</div>

<script>
    const container = document.querySelector('.zoom-container');
    const img = document.querySelector('.zoom-img');

    container.addEventListener('mousemove', function(e) {
        const rect = container.getBoundingClientRect();


        const x = e.clientX - rect.left;
        const y = e.clientY - rect.top;

        const xPercent = (x / rect.width) * 100;
        const yPercent = (y / rect.height) * 100;

        img.style.transformOrigin = xPercent + '% ' + yPercent + '%';
        img.style.transform = 'scale(2)';
    });

    container.addEventListener('mouseleave', function() {
        img.style.transform = 'scale(1)';
        img.style.transformOrigin = 'center';
    });

    function increase(max) {
        let input = document.getElementById("quantity");
        let value = parseInt(input.value) || 1;
        if (value < max) input.value = value + 1;
    }

    function decrease() {
        let input = document.getElementById("quantity");
        let value = parseInt(input.value) || 1;
        if (value > 1) input.value = value - 1;
    }

    function addToCart(productId) {

        let quantity = document.getElementById("quantity").value;

        fetch("${pageContext.request.contextPath}/cart", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: "action=add&productId=" + productId + "&quantity=" + quantity
        })
            .then(() => {
                updateCartCount();

                // hiệu ứng nhẹ
                const badge = document.querySelector(".cart-badge");
                if (badge) {
                    badge.classList.remove("animate");
                    void badge.offsetWidth;
                    badge.classList.add("animate");
                }
            });
    }

    function buyNow(productId) {

        let quantity = document.getElementById("quantity").value;

        fetch("${pageContext.request.contextPath}/checkout", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: "action=add&productId=" + productId + "&quantity=" + quantity
        })
            .then(() => {
                window.location.href = "${pageContext.request.contextPath}/checkout";
            });
    }

    function updateCartCount() {
        fetch("${pageContext.request.contextPath}/cart", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: "action=count"
        })
            .then(res => res.text())
            .then(count => {

                const badge = document.querySelector(".cart-badge");

                if (!badge) return;

                badge.innerText = count;

                if (count > 0) {
                    badge.style.display = "block";
                } else {
                    badge.style.display = "none";
                }

                // animation nhẹ
                badge.classList.remove("animate");
                void badge.offsetWidth;
                badge.classList.add("animate");
            });
    }

    let expanded = false;

    function toggleProducts() {
        const items = document.querySelectorAll('.hidden-product');
        const btn = event.target;

        if (!expanded) {
            items.forEach(i => i.style.display = 'block');
            btn.innerText = "Thu gọn";
        } else {
            items.forEach(i => i.style.display = 'none');
            btn.innerText = "Xem thêm";
        }

        expanded = !expanded;
    }
</script>

</body>
<jsp:include page="footer.jsp"/>
</html>