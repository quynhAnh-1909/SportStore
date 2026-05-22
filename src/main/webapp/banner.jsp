<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="root" value="${pageContext.request.contextPath}" />


<!-- ===== BANNER + MENU ===== -->
<div style="position: relative; width: 100%;">

    <c:if test="${not empty banners}">

        <!-- ===== CAROUSEL (FROM ADMIN) ===== -->
        <div id="heroCarousel"
             class="carousel slide carousel-fade"
             data-bs-ride="carousel"
             data-bs-interval="1000">

            <!-- INDICATORS -->
            <div class="carousel-indicators">

                <c:forEach var="b" items="${banners}" varStatus="loop">
                    <button type="button"
                            data-bs-target="#heroCarousel"
                            data-bs-slide-to="${loop.index}"
                            class="${loop.first ? 'active' : ''}"
                            aria-current="${loop.first ? 'true' : 'false'}">
                    </button>
                </c:forEach>

            </div>

            <!-- ITEMS -->
            <div class="carousel-inner">

                <c:forEach var="b" items="${banners}" varStatus="loop">

                    <div class="carousel-item ${loop.first ? 'active' : ''}">

                        <c:choose>

                            <c:when test="${not empty b.productId}">

                                <a href="${root}/productDetail?id=${b.productId}">

                                    <img src="${root}/resources/${b.image}"
                                         class="d-block w-100"
                                         style="height:420px; object-fit:cover;"
                                         alt="${b.title}">

                                </a>



                            </c:when>

                            <c:otherwise>

                                <img src="${root}/resources/${b.image}"
                                     class="d-block w-100"
                                     style="height:420px; object-fit:cover;"
                                     alt="${b.title}">

                            </c:otherwise>

                        </c:choose>

                    </div>
                </c:forEach>

            </div>

            <!-- CONTROL -->
            <button class="carousel-control-prev"
                    type="button"
                    data-bs-target="#heroCarousel"
                    data-bs-slide="prev">

                <span class="carousel-control-prev-icon"></span>
            </button>

            <button class="carousel-control-next"
                    type="button"
                    data-bs-target="#heroCarousel"
                    data-bs-slide="next">

                <span class="carousel-control-next-icon"></span>
            </button>

        </div>

    </c:if>

    <!-- ===== CATEGORY MENU ===== -->
    <div class="menu-bar">

        <div class="category-menu">

            <div class="menu-title">
                ☰ Danh mục sản phẩm
            </div>

            <div class="mega-menu">

                <!-- MÔN THỂ THAO -->
                <div class="menu-group">

                    <h5>Môn thể thao</h5>

                    <a href="${root}/products?categoryId=4">Bóng đá</a>
                    <a href="${root}/products?categoryId=5">Bóng rổ</a>
                    <a href="${root}/products?categoryId=6">Gym & Fitness</a>
                    <a href="${root}/products?categoryId=14">Cầu lông</a>
                    <a href="${root}/products?categoryId=15">Tennis</a>

                </div>

                <!-- THỜI TRANG -->
                <div class="menu-group">

                    <h5>Thời trang</h5>

                    <a href="${root}/products?categoryId=7">Áo thể thao</a>
                    <a href="${root}/products?categoryId=8">Quần thể thao</a>

                </div>

                <!-- PHỤ KIỆN -->
                <div class="menu-group">

                    <h5>Phụ kiện</h5>

                    <a href="${root}/products?categoryId=9">Túi thể thao</a>
                    <a href="${root}/products?categoryId=10">Găng tay</a>

                </div>

            </div>

        </div>

    </div>

</div>

<!-- ===== STYLE ===== -->
<style>
    .menu-bar{

        position:relative;

        margin-top:20px;

        margin-bottom:20px;

        z-index:10;
    }

    .category-menu{
        position:relative;
    }

    .menu-title{

        background:#444;

        color:white;

        padding:10px 16px;

        border-radius:8px;

        cursor:pointer;

        font-weight:600;

        font-size:16px;

        width:230px;

        transition:0.3s;
    }

    .menu-title:hover{
        background:#333;
    }

    .mega-menu{

        display:none;

        position:absolute;

        top:100%;
        left:0;

        width:230px;

        background:white;

        border-radius:8px;

        box-shadow:0 8px 20px rgba(0,0,0,0.15);

        padding:12px;

        z-index:9999;
    }

    .category-menu:hover .mega-menu{
        display:block;
    }

    .menu-group{
        margin-bottom:14px;
    }

    .menu-group:last-child{
        margin-bottom:0;
    }

    .menu-group h5{

        color:#d81f19;

        font-size:16px;

        margin-bottom:6px;

        font-weight:700;
    }

    .menu-group a{

        display:block;

        padding:5px 0;

        color:#333;

        text-decoration:none;

        font-size:14px;

        transition:0.2s;
    }

    .menu-group a:hover{

        color:#d81f19;

        padding-left:6px;
    }
</style>

<!-- ===== SCRIPT ===== -->
<script>
    // document.addEventListener("DOMContentLoaded", function () {
    //
    //     const menu = document.querySelector('.category-menu');
    //     const title = document.querySelector('.menu-title');
    //     const mega = document.querySelector('.mega-menu');
    //
    //     if (!menu || !title || !mega) return;
    //
    //     let open = false;
    //
    //     title.addEventListener('click', (e) => {
    //         e.stopPropagation();
    //         open = !open;
    //         mega.style.display = open ? 'grid' : 'none';
    //     });
    //
    //     menu.addEventListener('mouseenter', () => {
    //         mega.style.display = 'grid';
    //         open = true;
    //     });
    //
    //     menu.addEventListener('mouseleave', () => {
    //         mega.style.display = 'none';
    //         open = false;
    //     });
    //
    //     document.addEventListener('click', () => {
    //         mega.style.display = 'none';
    //         open = false;
    //     });
    //
    // });
</script>