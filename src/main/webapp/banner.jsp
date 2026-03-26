<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="root" value="${pageContext.request.contextPath}" />

<!-- ===== BANNER + MENU ===== -->
<div style="position: relative; width: 100%;">

    <!-- ===== CAROUSEL ===== -->
    <div id="heroCarousel" class="carousel slide carousel-fade"
         data-bs-ride="carousel" data-bs-interval="1000">

        <div class="carousel-inner">
            <div class="carousel-item active">
                <img src="${root}/resources/baner1.jpg"
                     class="d-block w-100"
                     style="height:420px; object-fit:cover;">
            </div>

            <div class="carousel-item">
                <img src="${root}/resources/banner2.jpg"
                     class="d-block w-100"
                     style="height:420px; object-fit:cover;">
            </div>

            <div class="carousel-item">
                <img src="${root}/resources/banner3.jpg"
                     class="d-block w-100"
                     style="height:420px; object-fit:cover;">
            </div>
        </div>

        <!-- indicator -->
        <div class="carousel-indicators">
            <button data-bs-target="#heroCarousel" data-bs-slide-to="0" class="active"></button>
            <button data-bs-target="#heroCarousel" data-bs-slide-to="1"></button>
            <button data-bs-target="#heroCarousel" data-bs-slide-to="2"></button>
        </div>

        <!-- control -->
        <button class="carousel-control-prev" data-bs-target="#heroCarousel" data-bs-slide="prev">
            <span class="carousel-control-prev-icon"></span>
        </button>

        <button class="carousel-control-next" data-bs-target="#heroCarousel" data-bs-slide="next">
            <span class="carousel-control-next-icon"></span>
        </button>
    </div>

    <!-- ===== MENU NỔI ===== -->
    <div class="menu-bar">

        <!-- CATEGORY -->
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

        <!-- MENU NGANG -->
        <a href="${root}/products?category=Pickleball" class="menu-item">
            Pickleball chính hãng
        </a>

    </div>
</div>

<!-- ===== STYLE ===== -->
<style>
    .menu-bar{
        position:absolute;
        top:20px;
        left:20px;
        z-index:1000;
        background:rgba(0,0,0,0.6);
        border-radius:6px;
        padding:8px 12px;
        display:flex;
        gap:10px;
        align-items:center;
    }

    .menu-title{
        color:white;
        cursor:pointer;
        font-weight:bold;
    }

    .menu-item{
        color:white;
        text-decoration:none;
    }

    .category-menu{
        position:relative;
    }

    .mega-menu{
        display:none; /* chỉ để 1 cái này */
        position:absolute;
        top:40px;
        left:0;
        width:1000px;
        background:white;
        box-shadow:0 10px 40px rgba(0,0,0,0.3);
        padding:20px;
        border-radius:8px;

        grid-template-columns:repeat(5,1fr);
        gap:20px;
    }

    .menu-column h6{
        font-weight:bold;
        margin-bottom:10px;
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

        let isOpen = false;

        // 👉 CLICK để mở (quan trọng nhất)
        title.addEventListener('click', (e) => {
            e.stopPropagation();
            isOpen = !isOpen;
            mega.style.display = isOpen ? 'grid' : 'none';
        });

        // 👉 Hover vẫn giữ menu (PC)
        menu.addEventListener('mouseenter', () => {
            mega.style.display = 'grid';
            isOpen = true;
        });

        menu.addEventListener('mouseleave', () => {
            setTimeout(() => {
                if (!menu.matches(':hover')) {
                    mega.style.display = 'none';
                    isOpen = false;
                }
            }, 150);
        });

        // 👉 Click ngoài → đóng menu
        document.addEventListener('click', () => {
            mega.style.display = 'none';
            isOpen = false;
        });

    });
</script>