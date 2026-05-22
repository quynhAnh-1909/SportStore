<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tin Khuyến Mãi - SportStore</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        /* Tối ưu một chút hiệu ứng cho thẻ card khuyến mãi */
        .card-promotion {
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .card-promotion:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.15) !important;
        }
    </style>
</head>
<body class="bg-light">
<jsp:include page="/WEB-INF/layout/index.jsp"/>

<div class="p-5 mb-4 bg-danger text-white rounded-0 position-relative shadow-sm"
     style="background: linear-gradient(135deg, #dc3545 0%, #921d28 100%);">
    <div class="container py-4 text-center text-lg-start">
        <div class="row align-items-center">
            <div class="col-lg-8">
                <span class="badge bg-warning text-dark mb-2 px-3 py-2 fw-bold text-uppercase">Siêu Ưu Đãi Mùa Hè</span>
                <h1 class="display-4 fw-bold">SĂN SALE THẢ GA - KHÔNG LO VỀ GIÁ</h1>
                <p class="lead mb-0">Tổng hợp các chương trình khuyến mãi, voucher giảm giá cực sốc dành riêng cho tín đồ thể thao.</p>
            </div>
            <div class="col-lg-4 text-center d-none d-lg-block">
                <i class="bi bi-ticket-perforated" style="font-size: 7rem; opacity: 0.3;"></i>
            </div>
        </div>
    </div>
</div>

<div class="container my-5">

    <div class="border-start border-danger border-4 ps-3 mb-4">
        <h2 class="fw-bold text-uppercase m-0 text-dark">Tin Khuyến Mãi Mới Nhất</h2>
        <small class="text-muted">Đừng bỏ lỡ những cơ hội sở hữu sản phẩm giá tốt nhất</small>
    </div>

    <div class="row">
        <c:forEach var="p" items="${promotions}">
            <div class="col-xl-3 col-lg-4 col-md-6 mb-4">
                <div class="card h-100 border-0 shadow-sm card-promotion">

                    <div class="position-relative" style="height: 200px; overflow: hidden;">
                        <img src="${root}/resources/${p.thumbnail}"
                             class="card-img-top w-100 h-100"
                             style="object-fit: cover;"
                             alt="${p.title}"
                             onerror="this.src='https://placehold.co/600x400?text=No+Image'">

                        <span class="position-absolute top-0 start-0 badge bg-danger m-3 fs-6 shadow-sm">
                                -${p.discountPercent}%
                            </span>
                    </div>

                    <div class="card-body d-flex flex-column">
                        <h5 class="card-title fw-bold text-dark text-truncate-2" style="height: 48px; overflow: hidden; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical;">
                                ${p.title}
                        </h5>

                        <p class="card-text text-muted small mb-2">
                            <i class="bi bi-calendar-event me-1"></i> ${p.startDate} &rarr; ${p.endDate}
                        </p>

                        <p class="card-text text-secondary small flex-grow-1 text-truncate-3" style="height: 60px; overflow: hidden; display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical;">
                                ${p.content}
                        </p>

                        <a href="${root}/promotionDetail?id=${p.id}" class="btn btn-danger w-100 mt-3 fw-bold">
                            Xem chi tiết <i class="bi bi-arrow-right ms-1"></i>
                        </a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

    <c:if test="${empty promotions}">
        <div class="text-center py-5">
            <i class="bi bi-box-open text-muted" style="font-size: 4rem;"></i>
            <p class="text-muted mt-2">Hiện tại chưa có chương trình khuyến mãi nào diễn ra.</p>
        </div>
    </c:if>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<jsp:include page="footer.jsp"/>
</body>
</html>