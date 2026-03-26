<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

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

        /* CARD */
        .detail-card {
            border-radius: 14px;
            background: white;
            padding: 30px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        }

        /* IMAGE */
        .product-image {
            width: 100%;
            max-height: 420px;
            object-fit: contain;
            transition: 0.3s;
        }

        .product-image:hover {
            transform: scale(1.05);
        }

        /* TITLE */
        .product-title {
            font-weight: 700;
            font-size: 28px;
        }

        /* PRICE */
        .product-price {
            color: #d81f19;
            font-size: 30px;
            font-weight: bold;
            margin: 12px 0;
        }

        .product-info {
            font-size: 15px;
            margin-bottom: 6px;
        }

        .stock {
            color: #666;
            font-size: 14px;
        }

        .btn-cart {
            background: #d81f19;
            border: none;
            font-weight: 600;
            color: white;
            padding: 12px;
            border-radius: 8px;
            transition: 0.3s;
        }

        .btn-cart:hover {
            background: #b71c17;
            transform: translateY(-2px);
        }

        /* BUTTON BACK */
        .btn-back {
            background: white;
            border: 2px solid #d81f19;
            color: #d81f19;
            padding: 8px 16px;
            border-radius: 8px;
            font-weight: 600;
            margin-bottom: 15px;
            transition: 0.3s;
        }

        .btn-back:hover {
            background: #d81f19;
            color: white;
        }

        /* INPUT QUANTITY */
        input[type="number"] {
            border-radius: 8px;
            text-align: center;
        }
    </style>

</head>

<body>

<!-- HEADER -->
<jsp:include page="WEB-INF/layout/index.jsp"/>

<div class="container mt-5">

    <div class="detail-card">

        <div class="row">
            <a href="${root}/products" class="btn-back">
                ← Quay lại
            </a>
            <!-- IMAGE -->
            <div class="col-md-5 text-center">
                <img src="${root}/resources/${product.imageUrl}"
                     class="product-image">
            </div>

            <!-- INFO -->
            <div class="col-md-7">

                <div class="product-title">${product.name}</div>

                <div class="product-price">
                    <fmt:formatNumber value="${product.price}"/>
                    VNĐ
                </div>

                <div class="product-info"><b>Brand:</b> ${product.brand}</div>
                <div class="product-info"><b>Size:</b> ${product.size}</div>
                <div class="product-info"><b>Color:</b> ${product.color}</div>

                <div class="product-info stock">
                    Stock: ${product.stockQuantity}
                </div>

                <hr>

                <div class="product-info">
                    ${product.description}
                </div>

                <hr>

                <!-- ADD CART -->
                <c:choose>

                    <c:when test="${product.stockQuantity > 0}">

                        <form action="${root}/cart" method="post">

                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="productId" value="${product.id}">

                            <div class="row">

                                <div class="col-md-4">
                                    <input type="number"
                                           name="quantity"
                                           value="1"
                                           min="1"
                                           max="${product.stockQuantity}"
                                           class="form-control text-center">
                                </div>

                                <button class="btn-cart w-100">
                                    🛒 Thêm vào giỏ hàng
                                </button>
                            </div>

                            <div class="stock">
                                <c:choose>
                                    <c:when test="${product.stockQuantity > 0}">
                                        ✔ Còn hàng (${product.stockQuantity})
                                    </c:when>
                                    <c:otherwise>
                                        ❌ Hết hàng
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </form>

                        <c:if test="${param.added == 'true'}">
                            <div class="alert alert-success mt-3">
                                Đã thêm sản phẩm vào giỏ hàng
                            </div>
                        </c:if>

                    </c:when>

                    <c:otherwise>
                        <div class="alert alert-danger">
                            Hết hàng
                        </div>
                    </c:otherwise>

                </c:choose>

            </div>

        </div>

    </div>

</div>

</body>
</html>