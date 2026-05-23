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

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
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

        .share {
            width: 38px;
            height: 38px;
            border-radius: 50%;
            background: #f1f1f1;
            display: flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
            transition: all 0.3s ease;
            font-size: 18px;
            color: #333;
        }

        .share:hover {
            transform: translateY(-3px);
        }

        /* FACEBOOK */
        .share .bi-facebook {
            color: #1877f2;
        }

        /* INSTAGRAM */
        .share .bi-instagram {
            color: #e1306c;
        }

        /* MESSENGER */
        .share .bi-messenger {
            color: #0099ff;
        }

        .share:hover {
            background: #eee;
        }

        .btn-show-more{
            display:inline-flex;
            align-items:center;
            gap:8px;

            padding:12px 28px;

            background:#ee4d2d;
            color:white;

            text-decoration:none;

            border-radius:999px;

            font-weight:600;
            font-size:15px;

            transition:0.3s ease;

            box-shadow:0 4px 12px rgba(238,77,45,0.25);
        }

        .btn-show-more:hover{
            background:#d93f21;
            transform:translateY(-2px);
            color:white;

            box-shadow:0 6px 18px rgba(238,77,45,0.35);
        }

        /* FIX INPUT QUANTITY OVERLAY MODAL */
        .quantity-box,
        .quantity-box input,
        .qty-btn {
            position: relative;
            z-index: 1;
        }

        /* LOGIN MODAL */
        .modal,
        .modal-dialog,
        .modal-content,
        .auth-modal,
        .login-modal {
            z-index: 99999 !important;
        }

        /* OVERLAY */
        .modal-backdrop,
        .overlay {
            z-index: 99998 !important;
        }

        .quantity-box input[type=number]::-webkit-outer-spin-button,
        .quantity-box input[type=number]::-webkit-inner-spin-button {
            -webkit-appearance: none;
            margin: 0;
        }


        .review-actions{
            display:flex;
            align-items:center;
            gap:8px;
        }

        .review-btn{
            width:32px;
            height:32px;

            border:none;
            border-radius:50%;

            display:flex;
            align-items:center;
            justify-content:center;

            background:#f5f5f5;

            transition:0.2s ease;
            cursor:pointer;

            font-size:14px;
        }

        /* EDIT */
        .edit-btn{
            color:#0d6efd;
        }

        .edit-btn:hover{
            background:#e7f1ff;
            transform:scale(1.08);
        }

        /* DELETE */
        .delete-btn{
            color:#dc3545;
        }

        .delete-btn:hover{
            background:#ffe5e8;
            transform:scale(1.08);
        }

        #reviewList > div{

            transition:0.3s ease;
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

                    <a href="javascript:void(0)"
                       class="share"
                       onclick="shareFacebook()">
                        <i class="bi bi-facebook"></i>
                    </a>

                    <a href="javascript:void(0)"
                       class="share instagram"
                       onclick="shareInstagram()">
                        <i class="bi bi-instagram"></i>
                    </a>

                    <a href="javascript:void(0)"
                       class="share messenger"
                       onclick="shareMessenger()">
                        <i class="bi bi-messenger"></i>
                    </a>

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

                        <c:if test="${empty product.vouchers}">
                            <span class="text-muted">Không có</span>
                        </c:if>

                        <c:forEach var="v" items="${product.vouchers}">
            <span class="voucher">
                ${v.code} -
                <fmt:formatNumber value="${v.discountValue}"/>₫
            </span>
                        </c:forEach>

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

    <!-- REVIEW -->
    <div class="detail-card mt-4">

        <div class="section-title">
            ĐÁNH GIÁ SẢN PHẨM
        </div>

        <!-- FORM -->
        <form id="reviewForm" class="mt-3">

            <input type="hidden"
                   name="productId"
                   value="${product.id}">

            <input type="hidden"
                   name="currentUrl"
                   value="${pageContext.request.requestURI}?id=${product.id}">

            <div class="mb-3">

                <label class="form-label">
                    Số sao
                </label>

                <select name="rating"
                        id="rating"
                        class="form-select"
                        required>

                    <option value="">Chọn đánh giá</option>
                    <option value="5">★★★★★ - 5 Sao</option>
                    <option value="4">★★★★☆ - 4 Sao</option>
                    <option value="3">★★★☆☆ - 3 Sao</option>
                    <option value="2">★★☆☆☆ - 2 Sao</option>
                    <option value="1">★☆☆☆☆ - 1 Sao</option>

                </select>

            </div>

            <div class="mb-3">

                <label class="form-label">
                    Bình luận
                </label>

                <textarea name="comment"
                          id="comment"
                          class="form-control"
                          rows="4"
                          placeholder="Nhập đánh giá của bạn..."
                          required></textarea>

            </div>

            <button type="submit"
                    class="btn btn-danger">
                Gửi đánh giá
            </button>

        </form>

        <!-- REVIEW LIST -->
        <div class="mt-4" id="reviewList">

            <c:forEach var="r"
                       items="${reviews}">

                <div class="border-top pt-3 pb-3"
                     id="review-${r.id}">

                    <div class="d-flex justify-content-between">

                        <div>

                            <div class="fw-bold">
                                    ${r.fullName}
                            </div>

                            <div class="text-warning">
                                    ${r.rating} ★
                            </div>

                        </div>

                        <!-- OWNER ACTION -->
                        <c:if test="${sessionScope.user != null
                            && sessionScope.user.userId == r.userId}">

                            <div class="review-actions">

                                <button type="button"
                                        class="review-btn edit-btn"
                                        onclick='editReview(
                                                "${r.id}",
                                                "${r.rating}",
                                                `${r.comment}`
                                                )'>

                                    <i class="bi bi-pencil"></i>

                                </button>

                                <button type="button"
                                        class="review-btn delete-btn"
                                        onclick="deleteReview('${r.id}')">

                                    <i class="bi bi-trash"></i>

                                </button>

                            </div>

                        </c:if>

                    </div>

                    <!-- CONTENT -->
                    <div class="mt-2 review-comment">
                        <c:out value="${r.comment}"/>
                    </div>

                    <small class="text-muted">
                            ${r.createdAt}
                    </small>

                </div>

            </c:forEach>

        </div>

        <c:if test="${totalPages > 1}">

            <div class="d-flex justify-content-center mt-4 gap-2"
                 id="reviewPagination">

                <!-- PREV -->
                <c:if test="${currentPage > 1}">
                    <button type="button"
                            class="btn btn-light"
                            onclick="loadReviewPage(${currentPage - 1})">
                        ←
                    </button>
                </c:if>

                <!-- PAGE -->
                <c:forEach begin="1"
                           end="${totalPages}"
                           var="i">

                    <button
                        type="button"
                        onclick="loadReviewPage(${i})"
                        class="btn ${i == currentPage ? 'btn-danger' : 'btn-light'}">

                            ${i}

                    </button>

                </c:forEach>

                <!-- NEXT -->
                <c:if test="${currentPage < totalPages}">
                    <button type="button"
                            class="btn btn-light"
                            onclick="loadReviewPage(${currentPage + 1})">
                        →
                    </button>
                </c:if>

            </div>

        </c:if>

    </div>

    <!-- GỢI Ý SẢN PHẨM -->
    <div class="mt-4">

        <div class="suggest-title mb-3">
            GỢI Ý CHO BẠN
        </div>

        <!-- 4 sản phẩm đầu -->
        <div id="preview-products" class="row">

            <c:forEach var="p"
                       items="${relatedProducts}"
                       varStatus="status">

                <c:if test="${status.index < 4}">

                    <div class="col-md-3 mb-4">

                        <a href="${root}/productDetail?id=${p.id}"
                           class="suggest-card">

                            <img src="${root}/resources/${p.imageUrl}"
                                 class="suggest-img">

                            <div class="suggest-name">
                                    ${p.name}
                            </div>

                            <div class="suggest-price">
                                <fmt:formatNumber value="${p.price}"/> VNĐ
                            </div>

                        </a>

                    </div>

                </c:if>

            </c:forEach>

        </div>

        <!-- TẤT CẢ SẢN PHẨM -->
        <div id="all-products"
             class="row d-none">

            <c:forEach var="p"
                       items="${relatedProducts}">

                <div class="col-md-3 mb-4">

                    <a href="${root}/productDetail?id=${p.id}"
                       class="suggest-card">

                        <img src="${root}/resources/${p.imageUrl}"
                             class="suggest-img">

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

        <div class="text-center mt-4">

            <button id="toggleBtn"
                    class="btn-show-more">

                <i class="bi bi-grid"></i>
                Xem thêm sản phẩm

            </button>

        </div>

    </div>



</div>

<script>

    const ROOT = "${pageContext.request.contextPath}";

    let currentReviewPage = 1;

    function editReview(id, rating, comment) {

        const newComment =
                prompt("Sửa bình luận", comment);

        if (newComment == null) return;

        const newRating =
                prompt("Số sao (1-5)", rating);

        if(
                !newRating ||
                newRating < 1 ||
                newRating > 5
        ){
            alert("Số sao không hợp lệ");
            return;
        }

        fetch("${root}/updateReview", {

            method: "POST",

            headers: {
                "Content-Type":
                        "application/x-www-form-urlencoded"
            },

            body:
                    "reviewId=" + id
                    + "&rating=" + newRating
                    + "&comment="
                    + encodeURIComponent(newComment)
        })

                .then(res => res.text())

                .then(data => {

                    loadReviewPage(currentReviewPage);

                });
    }


    function deleteReview(reviewId) {

        if (!confirm("Xóa đánh giá này?")) {
            return;
        }

        fetch("${root}/deleteReview", {

            method: "POST",

            headers: {
                "Content-Type":
                        "application/x-www-form-urlencoded"
            },

            body: "reviewId=" + reviewId
        })

                .then(res => {

                    if (res.ok) {

                        const review =
                                document.getElementById(
                                        "review-" + reviewId
                                );

                        review.style.opacity = "0";

                        review.style.transform =
                                "translateX(30px)";

                        review.style.pointerEvents = "none";

                        setTimeout(() => {

                            const totalReview =
                                    document.querySelectorAll(
                                            "#reviewList > div[id^='review-']"
                                    ).length;

                            if(totalReview <= 1 && currentReviewPage > 1){

                                currentReviewPage--;
                            }

                            loadReviewPage(currentReviewPage);

                        }, 300);
                    }
                });
    }

    const toggleBtn =
            document.getElementById("toggleBtn");

    const previewProducts =
            document.getElementById("preview-products");

    const allProducts =
            document.getElementById("all-products");

    let expanded = false;

    toggleBtn.addEventListener("click", function () {

        expanded = !expanded;

        if (expanded) {

            previewProducts.classList.add("d-none");

            allProducts.classList.remove("d-none");

            toggleBtn.innerHTML =
                    '<i class="bi bi-chevron-up"></i> Thu gọn';

        } else {

            allProducts.classList.add("d-none");

            previewProducts.classList.remove("d-none");

            toggleBtn.innerHTML =
                    '<i class="bi bi-grid"></i> Xem thêm sản phẩm';

            window.scrollTo({
                top: previewProducts.offsetTop - 100,
                behavior: "smooth"
            });
        }

    });

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

    document.getElementById("reviewForm")
            .addEventListener("submit", function (e) {

                e.preventDefault();

                const rating =
                        document.getElementById("rating").value;

                const comment =
                        document.getElementById("comment").value;

                const productId =
                        document.querySelector(
                                'input[name="productId"]'
                        ).value;

                fetch("${root}/review", {

                    method: "POST",

                    headers: {
                        "Content-Type":
                                "application/x-www-form-urlencoded"
                    },

                    body:
                            "productId=" + productId
                            + "&rating=" + rating
                            + "&comment=" + encodeURIComponent(comment)
                })

                        .then(res => {

                            if (res.status === 401) {

                                // lưu url
                                sessionStorage.setItem(
                                        "redirectUrl",
                                        window.location.href
                                );

                                // lưu scroll
                                sessionStorage.setItem(
                                        "redirectScroll",
                                        window.scrollY
                                );

                                // lưu rating
                                sessionStorage.setItem(
                                        "reviewRating",
                                        document.getElementById("rating").value
                                );

                                // lưu comment
                                sessionStorage.setItem(
                                        "reviewComment",
                                        document.getElementById("comment").value
                                );

                                sessionStorage.setItem(
                                        "restoreReview",
                                        "true"
                                );

                                window.location.href =
                                        "${root}/login";

                                return null;
                            }

                            return res.text();
                        })

                        .then(data => {

                            if (!data) return;

                            document.getElementById("comment").value = "";

                            document.getElementById("rating").value = "";

                            sessionStorage.removeItem("reviewRating");

                            sessionStorage.removeItem("reviewComment");

                            sessionStorage.removeItem("restoreReview");

                            currentReviewPage = 1;

                            setTimeout(() => {

                                loadReviewPage(1);

                            }, 100);

                        });

            });

    function shareFacebook() {

        const url = encodeURIComponent(window.location.href);

        window.open(
                `https://www.facebook.com/sharer/sharer.php?u=${url}`,
                "_blank"
        );
    }

    async function shareInstagram() {

        await navigator.clipboard.writeText(window.location.href);

        alert("Đã copy link sản phẩm!");
    }

    async function shareMessenger() {

        await navigator.clipboard.writeText(window.location.href);

        alert("Đã copy link để gửi Messenger!");
    }

    window.addEventListener("load", () => {

        const shouldRestore =
                sessionStorage.getItem(
                        "restoreReview"
                );

        // CHỈ restore khi login xong quay lại
        if(shouldRestore === "true"){

            // restore rating
            const savedRating =
                    sessionStorage.getItem(
                            "reviewRating"
                    );

            if(savedRating){

                document.getElementById(
                        "rating"
                ).value = savedRating;
            }

            // restore comment
            const savedComment =
                    sessionStorage.getItem(
                            "reviewComment"
                    );

            if(savedComment){

                document.getElementById(
                        "comment"
                ).value = savedComment;
            }

            // restore scroll
            const scrollPos =
                    sessionStorage.getItem(
                            "redirectScroll"
                    );

            if(scrollPos){

                setTimeout(() => {

                    window.scrollTo({
                        top: parseInt(scrollPos),
                        behavior: "smooth"
                    });

                }, 200);
            }

            // restore xong thì xóa
            sessionStorage.removeItem(
                    "restoreReview"
            );
            sessionStorage.removeItem(
                    "redirectScroll"
            );

            sessionStorage.removeItem(
                    "reviewRating"
            );

            sessionStorage.removeItem(
                    "reviewComment"
            );
        }
    });

    function loadReviewPage(page){

        currentReviewPage = page;

        const productId =
                ${product.id};

        fetch(
                `${ROOT}/productDetail?id=${
                    productId
            }&page=${
                    page
            }`
        )

                .then(res => res.text())

                .then(html => {

                    // parse html mới
                    const parser =
                            new DOMParser();

                    const doc =
                            parser.parseFromString(
                                    html,
                                    "text/html"
                            );

                    // lấy review mới
                    const newReviewList =
                            doc.getElementById(
                                    "reviewList"
                            );

                    // lấy pagination mới
                    const newPagination =
                            doc.getElementById(
                                    "reviewPagination"
                            );

                    // replace
                    document.getElementById(
                            "reviewList"
                    ).innerHTML =
                            newReviewList.innerHTML;

                    const paginationContainer =
                            document.getElementById(
                                    "reviewPagination"
                            );

                    if(paginationContainer){

                        if(newPagination){

                            paginationContainer.innerHTML =
                                    newPagination.innerHTML;

                        }else{

                            paginationContainer.remove();
                        }

                    }else if(newPagination){

                        document
                                .getElementById("reviewList")
                                .insertAdjacentHTML(
                                        "afterend",
                                        newPagination.outerHTML
                                );
                    }
                    bindReviewEvents();

                    // scroll nhẹ tới review
                    window.scrollTo({
                        top:
                                document.getElementById(
                                        "reviewList"
                                ).offsetTop - 120,

                        behavior:"instant"
                    });

                });
    }

    function bindReviewEvents(){

        document
                .querySelectorAll(".edit-btn")
                .forEach(btn => {

                    btn.type = "button";
                });

        document
                .querySelectorAll(".delete-btn")
                .forEach(btn => {

                    btn.type = "button";
                });
    }

    bindReviewEvents();

</script>

<jsp:include page="footer.jsp"/>
</body>
</html>