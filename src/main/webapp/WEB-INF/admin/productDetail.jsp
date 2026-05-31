<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="root" value="${pageContext.request.contextPath}" />

<div class="container-fluid pt-4 px-4">

    <div class="bg-light rounded p-4 shadow-sm">

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h4 class="text-success fw-bold mb-0">
                <i class="fas fa-box-open me-2"></i>
                Chi tiết sản phẩm
            </h4>

            <a href="${root}/admin/products"
               class="btn btn-secondary rounded-pill px-4">
                <i class="fas fa-arrow-left me-1"></i>
                Quay lại
            </a>
        </div>

        <div class="card border-0 shadow-sm">

            <div class="card-body p-4">

                <div class="row g-4">

                    <!-- IMAGE -->
                    <div class="col-lg-4">

                        <div class="product-image-card text-center">

                            <c:choose>
                                <c:when test="${not empty product.imageUrl}">
                                    <img src="${root}/resources/${product.imageUrl}"
                                         class="product-image">
                                </c:when>

                                <c:otherwise>
                                    <img src="${root}/resources/no-image.png"
                                         class="product-image">
                                </c:otherwise>
                            </c:choose>

                        </div>

                    </div>

                    <!-- INFO -->
                    <div class="col-lg-8">

                        <div class="product-info-card">

                            <div class="d-flex justify-content-between align-items-start">

                                <div>
                        <span class="badge bg-primary mb-2">
                            #${product.id}
                        </span>

                                    <h2 class="fw-bold mb-2">
                                        ${product.name}
                                    </h2>

                                    <p class="text-muted mb-0">
                                        ${product.categoryName}
                                    </p>
                                </div>

                                <div class="text-end">

                                    <div class="price-box">
                                        <fmt:formatNumber
                                                value="${product.price}"
                                                groupingUsed="true"/>
                                        ₫
                                    </div>

                                </div>

                            </div>

                            <hr>

                            <div class="row g-3">

                                <div class="col-md-6">
                                    <div class="info-box">
                                        <span>Thương hiệu</span>
                                        <strong>
                                            ${empty product.brand ? 'Chưa cập nhật' : product.brand}
                                        </strong>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="info-box">
                                        <span>Kích thước</span>
                                        <strong>
                                            ${empty product.size ? '--' : product.size}
                                        </strong>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="info-box">
                                        <span>Màu sắc</span>
                                        <strong>
                                            ${empty product.color ? '--' : product.color}
                                        </strong>
                                    </div>
                                </div>

                            </div>

                            <hr>

                            <div class="stock-box">

                                <div class="fw-bold mb-2">
                                    Tình trạng kho
                                </div>

                                <c:choose>

                                    <c:when test="${product.stockQuantity <= 0}">
                            <span class="badge bg-danger px-3 py-2">
                                Hết hàng
                            </span>
                                    </c:when>

                                    <c:when test="${product.stockQuantity < 10}">
                            <span class="badge bg-warning text-dark px-3 py-2">
                                Còn ${product.stockQuantity} sản phẩm
                            </span>
                                    </c:when>

                                    <c:otherwise>
                            <span class="badge bg-success px-3 py-2">
                                Còn ${product.stockQuantity} sản phẩm
                            </span>
                                    </c:otherwise>

                                </c:choose>

                            </div>

                        </div>

                    </div>

                </div>

                <!-- DESCRIPTION -->

                <div class="description-card mt-4">

                    <div class="description-header">
                        <i class="fas fa-file-alt me-2"></i>
                        Mô tả sản phẩm
                    </div>

                    <div class="description-body">

                        <c:choose>

                            <c:when test="${not empty product.description}">
                                ${product.description}
                            </c:when>

                            <c:otherwise>
                    <span class="text-muted">
                        Chưa có mô tả sản phẩm.
                    </span>
                            </c:otherwise>

                        </c:choose>

                    </div>

                </div>

            </div>

    </div>

</div>
</div>

<style>
    .product-image-card{
        background:#fff;
        border-radius:20px;
        padding:20px;
        box-shadow:0 5px 20px rgba(0,0,0,.08);
    }

    .product-image{
        width:100%;
        max-height:400px;
        object-fit:cover;
        border-radius:15px;
        transition:.3s;
    }

    .product-image:hover{
        transform:scale(1.03);
    }

    .product-info-card{
        background:linear-gradient(180deg,#ffffff,#fafbfc);
        border:1px solid #eef1f4;
        border-radius:20px;
        padding:25px;
        box-shadow:0 10px 30px rgba(0,0,0,.08);
        height:100%;
    }
    .price-box{
        font-size:30px;
        font-weight:700;
        color:#dc3545;
    }

    .info-box{
        background:#f8f9fa;
        border-radius:12px;
        padding:15px;
    }

    .info-box span{
        display:block;
        color:#6c757d;
        font-size:13px;
        margin-bottom:5px;
    }

    .info-box strong{
        font-size:16px;
    }

    .stock-box{
        background:#f8f9fa;
        border-radius:12px;
        padding:15px;
    }

    .description-card{
        background:#fff;
        border-radius:20px;
        overflow:hidden;
        box-shadow:0 5px 20px rgba(0,0,0,.08);
    }

    .description-header{
        background:linear-gradient(135deg,#198754,#20c997);
        color:white;
        padding:15px 20px;
        font-weight:600;
    }

    .description-body{
        padding:25px;
        line-height:1.8;
    }

    .badge{
        font-size:.9rem;
    }
</style>