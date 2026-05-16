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

            <div class="menu-title">☰ Danh mục sản phẩm</div>

            <div class="mega-menu">

                <c:forEach var="parent" items="${categories}">
                    <div class="menu-column">

                        <h6>${parent.name}</h6>

                        <c:forEach var="child" items="${parent.children}">
                            <a href="${root}/products?categoryId=${child.id}">
                                    ${child.name}
                            </a>
                        </c:forEach>

                    </div>
                </c:forEach>

            </div>

        </div>

    </div>

</div>

<!-- ===== STYLE ===== -->
<style>
    .menu-bar{
        position:absolute;

        top:10px;
        left:20px;

        z-index:10;

        background:rgba(0,0,0,0.6);
        border-radius:6px;
        padding:8px 12px;
    }

    .menu-title{
        color:white;
        cursor:pointer;
        font-weight:bold;
        user-select:none;
    }

    .category-menu{
        position:relative;
    }

    .mega-menu{
        display:none;

        position:absolute;
        top:40px;
        left:0;

        width:900px;

        background:white;
        box-shadow:0 10px 40px rgba(0,0,0,0.3);

        padding:20px;
        border-radius:8px;

        z-index:20;

        grid-template-columns:repeat(5,1fr);
        gap:20px;
    }

    .menu-column h6{
        font-weight:bold;
        margin-bottom:10px;
        color:#d81f19;
    }

    .menu-column a{
        display:block;
        color:#333;
        text-decoration:none;
        margin-bottom:5px;
        font-size:14px;
    }

    .menu-column a:hover{
        color:#d81f19;
    }

</style>

<!-- ===== SCRIPT ===== -->
<script>
    document.addEventListener("DOMContentLoaded", function () {

        const menu = document.querySelector('.category-menu');
        const title = document.querySelector('.menu-title');
        const mega = document.querySelector('.mega-menu');

        if (!menu || !title || !mega) return;

        let open = false;

        title.addEventListener('click', (e) => {
            e.stopPropagation();
            open = !open;
            mega.style.display = open ? 'grid' : 'none';
        });

        menu.addEventListener('mouseenter', () => {
            mega.style.display = 'grid';
            open = true;
        });

        menu.addEventListener('mouseleave', () => {
            mega.style.display = 'none';
            open = false;
        });

        document.addEventListener('click', () => {
            mega.style.display = 'none';
            open = false;
        });

    });
</script>