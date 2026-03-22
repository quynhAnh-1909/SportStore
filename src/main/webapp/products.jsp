<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="root" value="${pageContext.request.contextPath}" />

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
        /* ===== HERO SLIDER FIXED ===== */
        .hero-container {
            width: 100%;
            height: 420px;
        }

        .carousel-item {
            height: 420px;
            background-color: #000; /* nền đen cho đẹp */
        }

        /* ẢNH KHÔNG ZOOM - NẰM GIỮA */
        .hero-bg {
            width: 100%;
            height: 100%;

            background-size: contain;      /* giữ nguyên ảnh */
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
            box-shadow: 0 4px 20px rgba(0,0,0,0.05);
        }

        .product-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 30px rgba(0,0,0,0.15);
        }

        .product-img-area {
            height: 200px;
            display:flex;
            align-items:center;
            justify-content:center;
        }

        .product-img {
            max-height:180px;
        }

        .price {
            color:#e41e31;
            font-weight:bold;
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
<jsp:include page="WEB-INF/layout/index.jsp"/>
<jsp:include page="WEB-INF/layout/auth.jsp"/>
<jsp:include page="banner.jsp"/>

<!-- CONTENT -->
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
                                    <fmt:formatNumber value="${p.price}" type="number" groupingUsed="true" /> VNĐ
                                </div>                                <!-- ADD TO CART -->
                                <form action="${root}/cart" method="post">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" name="productId" value="${p.id}">
                                    <input type="hidden" name="quantity" value="1">

                                    <button class="btn btn-success btn-sm mt-2 w-100">
                                        🛒 Thêm vào giỏ hàng
                                    </button>
                                </form>

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
<jsp:include page="footer.jsp" />
</body>
</html>