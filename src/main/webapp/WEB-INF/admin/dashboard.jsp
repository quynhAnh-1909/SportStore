<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="root" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>SPORT SHOP ADMIN</title>

    <!-- Bootstrap -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">

    <!-- Font Awesome -->
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>

        :root{
            --main-red:#d81f19;
            --dark-red:#9f1713;
            --light-bg:#f4f6f9;
            --white:#ffffff;
            --black:#111827;
            --border:#e5e7eb;
        }

        /*RESET*/

        *{
            margin:0;
            padding:0;
            box-sizing:border-box;
        }

        body{
            font-family:'Segoe UI', sans-serif;
            background:var(--light-bg);
            overflow-x:hidden;
            color:#111;
        }

        #wrapper{
            display:flex;
            width:100%;
        }

        /* =========================
            SIDEBAR
        ========================= */

        #sidebar-wrapper{
            width:320px;
            height:100vh;
            background:linear-gradient(180deg,#d81f19,#7f1010);

            position:fixed;
            top:0;
            left:0;

            overflow-y:auto;
            overflow-x:hidden;

            box-shadow:5px 0 20px rgba(0,0,0,0.15);
            z-index:1000;
        }

        /* LOGO */

        .sidebar-heading{
            padding:30px 20px;
            text-align:center;
            border-bottom:1px solid rgba(255,255,255,0.15);
            background:rgba(0,0,0,0.15);
        }

        .sidebar-heading h4{
            color:white;
            font-size:24px;
            font-weight:800;
            letter-spacing:1px;
            margin:0;
        }

        .sidebar-heading i{
            color:#ffd54f;
            margin-right:10px;
            font-size:26px;
        }

        /* MENU */

        .list-group{
            padding:20px 14px;
        }

        .menu-item{
            display:flex;
            align-items:center;
            color:white;
            text-decoration:none;
            padding:16px 18px;
            border-radius:14px;
            margin-bottom:10px;
            transition:0.3s;
            font-size:16px;
            font-weight:600;
            white-space:nowrap;
            border:1px solid transparent;
        }

        .menu-item:hover{
            background:rgba(255,255,255,0.12);
            border:1px solid rgba(255,255,255,0.2);
            color:white;
            transform:translateX(5px);
        }

        .menu-item i{
            width:24px;
            font-size:16px;
        }

        /* SUB MENU */

        .sub-menu-item{
            display:flex;
            align-items:center;
            color:#f5f5f5;
            text-decoration:none;
            padding:13px 18px 13px 58px;
            border-radius:12px;
            margin:6px 0;
            font-size:14px;
            background:rgba(255,255,255,0.06);
            border:1px solid rgba(255,255,255,0.08);
            transition:0.3s;
            white-space:nowrap;
        }

        .sub-menu-item:hover{
            background:rgba(255,255,255,0.15);
            color:white;
            transform:translateX(5px);
        }

        .sub-menu-item i{
            width:22px;
        }

        /* =========================
            PAGE CONTENT
        ========================= */

        #page-content-wrapper{
            margin-left:320px;
            width:calc(100% - 320px);
            min-height:100vh;
            overflow-x:hidden;
        }
        /* =========================
            NAVBAR
        ========================= */

        .admin-navbar{
            background:white;
            padding:18px 30px;
            box-shadow:0 2px 12px rgba(0,0,0,0.06);
            position:sticky;
            top:0;
            z-index:999;
        }

        /* =========================
            MAIN CONTENT
        ========================= */

        #mainContent{
            padding:30px;
        }

        .dashboard-title{
            font-size:38px;
            font-weight:800;
            color:var(--main-red);
            margin-bottom:30px;
        }

        /* =========================
            CARD
        ========================= */

        .dashboard-card{
            background:white;
            border-radius:22px;
            padding:30px;
            box-shadow:0 4px 20px rgba(0,0,0,0.06);
            border:1px solid var(--border);
            border-top:5px solid var(--main-red);
            transition:0.3s;
        }

        .dashboard-card:hover{
            transform:translateY(-5px);
        }

        .dashboard-card h5{
            color:var(--main-red);
            font-size:22px;
            font-weight:700;
        }

        .dashboard-card h2{
            font-size:42px;
            margin-top:15px;
            font-weight:bold;
            color:#111;
        }

        /* =========================
            BOX
        ========================= */

        .dashboard-box{
            background:white;
            border-radius:20px;
            padding:25px;
            margin-top:25px;
            box-shadow:0 4px 18px rgba(0,0,0,0.06);
            border:1px solid var(--border);
        }

        .dashboard-box h4{
            font-weight:700;
            margin-bottom:20px;
        }

        /* =========================
            TABLE
        ========================= */

        .table{
            width:100%;
            margin-bottom:0;
            border-collapse:separate;
            border-spacing:0;
            overflow:hidden;
            border-radius:16px;
            border:1px solid #dcdcdc;
        }

        /* HEADER ĐEN CHỮ TRẮNG */

        .table thead tr{
            background:#111827 !important;
        }

        .table th{
            color:white !important;
            font-size:15px;
            font-weight:700;
            padding:16px 18px !important;
            border:none !important;
            white-space:nowrap;
        }

        /* BODY */

        .table td{
            padding:16px 18px !important;
            background:white;
            color:#111 !important;
            border-top:1px solid #ececec !important;
            vertical-align:middle;
        }

        /* HOVER */

        .table tbody tr{
            transition:0.25s;
        }

        .table tbody tr:hover{
            background:#f9fafb;
        }

        /* =========================
            BADGE
        ========================= */

        .badge-status{
            padding:8px 14px;
            border-radius:30px;
            font-size:13px;
            font-weight:600;
        }

        /* =========================
            BUTTON
        ========================= */

        .btn{
            border-radius:10px;
            font-weight:600;
        }

        /* =========================
            FORM
        ========================= */

        .form-control,
        .form-select{
            border-radius:12px;
            padding:10px 14px;
            border:1px solid #ddd;
            box-shadow:none !important;
        }

        .form-control:focus,
        .form-select:focus{
            border-color:var(--main-red);
        }

        /* =========================
            PAGINATION
        ========================= */

        .pagination .page-link{
            border:none;
            margin:0 4px;
            border-radius:10px;
            color:var(--main-red);
            font-weight:600;
        }

        .pagination .active .page-link{
            background:var(--main-red);
            color:white;
        }

        /* =========================
            SCROLLBAR
        ========================= */

        ::-webkit-scrollbar{
            width:7px;
        }

        ::-webkit-scrollbar-thumb{
            background:#ccc;
            border-radius:20px;
        }
    </style>
</head>

<body>

<div id="wrapper">




    <!-- =========================
         SIDEBAR
    ========================== -->

    <div id="sidebar-wrapper">

        <div class="sidebar-heading">
            <h4>
                <i class="fas fa-store text-warning"></i>
                SPORT STORE ADMIN
            </h4>
        </div>

        <div class="list-group">

            <a href="${root}/admin/dashboard" class="menu-item">
                <i class="fas fa-chart-line"></i>
                Tổng quan
            </a>

            <!-- ORDER MENU -->
            <!-- ORDER MENU -->
            <a class="menu-item d-flex justify-content-between align-items-center"
               data-bs-toggle="collapse"
               href="#orderMenu"
               role="button">

    <span>
        <i class="fas fa-shopping-cart"></i>
        Quản lý đơn hàng
    </span>

                <i class="fas fa-chevron-down small"></i>
            </a>

            <!-- SUB MENU -->
            <div class="collapse" id="orderMenu">

                <!-- CHỜ XÁC NHẬN -->
                <a href="${root}/admin/orders?status=pending"
                   class="sub-menu-item">
                    <i class="fas fa-clock text-warning"></i>
                    Chờ xác nhận
                </a>

                <!-- CHỜ LẤY HÀNG -->
                <a href="${root}/admin/orders?status=pickup"
                   class="sub-menu-item">
                    <i class="fas fa-box text-info"></i>
                    Chờ lấy hàng
                </a>

                <!-- ĐANG GIAO -->
                <a href="${root}/admin/orders?status=shipping"
                   class="sub-menu-item">
                    <i class="fas fa-truck text-primary"></i>
                    Đang giao
                </a>

                <!-- ĐÃ GIAO -->
                <a href="${root}/admin/orders?status=completed"
                   class="sub-menu-item">
                    <i class="fas fa-check-circle text-success"></i>
                    Đã giao
                </a>

                <!-- YÊU CẦU HOÀN TIỀN -->
                <a href="${root}/admin/orders?status=refund_request"
                   class="sub-menu-item">
                    <i class="fas fa-money-bill-wave text-danger"></i>
                    Yêu cầu hoàn tiền
                </a>

                <!-- ĐÃ HOÀN TIỀN -->
                <a href="${root}/admin/orders?status=refunded"
                   class="sub-menu-item">
                    <i class="fas fa-undo text-secondary"></i>
                    Đã hoàn tiền
                </a>

                <!-- ĐÃ HỦY -->
                <a href="${root}/admin/orders?status=cancelled"
                   class="sub-menu-item">
                    <i class="fas fa-times-circle text-dark"></i>
                    Đã hủy
                </a>

            </div>
            <a href="${root}/admin/products" class="menu-item">
                <i class="fas fa-box"></i>
                Quản lý sản phẩm
            </a>

            <a href="${root}/admin/categories" class="menu-item">
                <i class="fas fa-layer-group"></i>
                Quản lý danh mục
            </a>

            <a href="${root}/admin/vouchers" class="menu-item">
                <i class="fas fa-ticket-alt"></i>
                Quản lý voucher
            </a>

            <a href="${root}/admin/customers" class="menu-item">
                <i class="fas fa-users"></i>
                Quản lý khách hàng
            </a>

            <a href="${root}/admin/banners" class="menu-item">
                <i class="fas fa-image"></i>
                Quản lý banner
            </a>

            <hr class="text-white">

            <a href="${root}/products"
               class="menu-item text-warning">
                <i class="fas fa-external-link-alt"></i>
                Xem trang khách
            </a>

        </div>

    </div>

    <!-- =========================
         PAGE CONTENT
    ========================== -->

    <div id="page-content-wrapper">

        <!-- NAVBAR -->

        <nav class="navbar admin-navbar">

            <div>
                <button class="btn btn-outline-danger btn-sm">
                    <i class="fas fa-bars"></i>
                </button>
            </div>

            <div class="ms-auto d-flex align-items-center">

                <span class="me-3">
                    Xin chào
                    <strong>${sessionScope.user.fullName}</strong>
                </span>

                <a href="${root}/logout"
                   class="btn btn-outline-danger btn-sm">
                    Đăng xuất
                </a>

            </div>

        </nav>

        <!-- CONTENT -->

        <div id="mainContent">

            <c:choose>

                <c:when test="${not empty contentPage}">
                    <jsp:include page="${contentPage}"/>
                </c:when>

                <c:otherwise>

                    <h2 class="dashboard-title">
                        Dashboard Admin
                    </h2>

                    <!-- STATISTIC -->

                    <div class="row g-4">

                        <div class="col-md-4">
                            <div class="dashboard-card">

                                <h5>
                                    <i class="fas fa-box text-danger"></i>
                                    Tổng sản phẩm
                                </h5>

                                <h2>${productCount}</h2>

                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="dashboard-card">

                                <h5>
                                    <i class="fas fa-shopping-cart text-danger"></i>
                                    Tổng đơn hàng
                                </h5>

                                <h2>${orderCount}</h2>

                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="dashboard-card">

                                <h5>
                                    <i class="fas fa-money-bill-wave text-danger"></i>
                                    Doanh thu
                                </h5>

                                <h2>${revenue}₫</h2>

                            </div>
                        </div>

                    </div>

                    <!-- TABLE + NOTIFICATION -->

                    <div class="row">

                        <div class="col-md-8">

                            <div class="dashboard-box">

                                <h4 class="text-danger">
                                    🔥 Top sản phẩm bán chạy
                                </h4>

                                <table class="table table-hover">

                                    <thead>
                                    <tr>
                                        <th>Sản phẩm</th>
                                        <th>Đã bán</th>
                                        <th>Trạng thái</th>
                                    </tr>
                                    </thead>

                                    <tbody>

                                    <tr>
                                        <td>Yonex Astrox 88D</td>
                                        <td>120</td>
                                        <td>
                                            <span class="badge bg-success badge-status">
                                                Best Seller
                                            </span>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>Adidas Predator Ball</td>
                                        <td>98</td>
                                        <td>
                                            <span class="badge bg-primary badge-status">
                                                Hot
                                            </span>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>Nike Air Zoom</td>
                                        <td>85</td>
                                        <td>
                                            <span class="badge bg-warning text-dark badge-status">
                                                Trending
                                            </span>
                                        </td>
                                    </tr>

                                    </tbody>

                                </table>

                            </div>

                        </div>

                        <div class="col-md-4">

                            <div class="dashboard-box">

                                <h4 class="text-success">
                                    🔔 Thông báo
                                </h4>

                                <p>🟡 Có đơn hàng mới cần xác nhận</p>
                                <p>📦 12 sản phẩm đang hoạt động</p>
                                <p>💰 Doanh thu hôm nay tăng 15%</p>
                                <p>🚚 5 đơn đang giao hàng</p>

                            </div>

                        </div>

                    </div>

                    <!-- REVENUE -->

                    <div class="dashboard-box">

                        <h4 class="text-success">
                            📈 Doanh thu theo tháng
                        </h4>

                        <div class="d-flex justify-content-center align-items-center"
                             style="height:220px; color:#999;">

                            Biểu đồ doanh thu sẽ hiển thị tại đây

                        </div>

                    </div>

                </c:otherwise>

            </c:choose>

        </div>

    </div>

</div>


<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>