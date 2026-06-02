<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="root" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>SPORT SHOP ADMIN</title>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        :root{
            --main-red:#d81f19;
            --dark-red:#9f1713;
            --light-bg:#f4f6f9;
            --white:#ffffff;
            --black:#111827;
            --border:#e5e7eb;
        }

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

        .menu-item:hover, .menu-item.active-menu{
            background:rgba(255,255,255,0.15) !important;
            border:1px solid rgba(255,255,255,0.25) !important;
            color:#ffd54f !important;
            font-weight:700;
        }

        .menu-item i{
            width:24px;
            font-size:16px;
        }

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

        #page-content-wrapper{
            margin-left:320px;
            width:calc(100% - 320px);
            min-height:100vh;
            overflow-x:hidden;
        }

        .admin-navbar{
            background:white;
            padding:18px 30px;
            box-shadow:0 2px 12px rgba(0,0,0,0.06);
            position:sticky;
            top:0;
            z-index:999;
        }

        #mainContent{
            padding:30px;
        }

        .dashboard-title{
            font-size:38px;
            font-weight:800;
            color:var(--main-red);
            margin-bottom:30px;
        }

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

        .table{
            width:100%;
            margin-bottom:0;
            border-collapse:separate;
            border-spacing:0;
            overflow:hidden;
            border-radius:16px;
            border:1px solid #dcdcdc;
        }

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

        .table td{
            padding:16px 18px !important;
            background:white;
            color:#111 !important;
            border-top:1px solid #ececec !important;
            vertical-align:middle;
        }

        .table tbody tr{
            transition:0.25s;
        }

        .table tbody tr:hover{
            background:#f9fafb;
        }

        .badge-status{
            padding:8px 14px;
            border-radius:30px;
            font-size:13px;
            font-weight:600;
        }

        .btn{
            border-radius:10px;
            font-weight:600;
        }

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

    <div id="sidebar-wrapper">
        <div class="sidebar-heading">
            <h4>
                <i class="fas fa-store text-warning"></i>
                SPORT STORE ADMIN
            </h4>
        </div>

        <div class="list-group">
            <c:set var="currentURI" value="${pageContext.request.requestURI}" />

            <a href="${root}/admin/dashboard" class="menu-item ${currentURI.contains('analytics') ? 'active-menu' : ''}">
                <i class="fas fa-chart-bar"></i>
                Thống kê
            </a>

            <c:set var="isOrderMenuOpen" value="${
                param.status == 'pending' or
                param.status == 'pickup' or
                param.status == 'shipping' or
                param.status == 'completed' or
                param.status == 'cancelled' or
                param.status == 'refund_pending' or
                param.status == 'refunded' or
                param.status == 'refund_rejected' or
                currentURI.contains('orders')
            }" />

            <a class="menu-item d-flex justify-content-between align-items-center ${isOrderMenuOpen ? '' : 'collapsed'}"
               data-bs-toggle="collapse"
               href="#orderMenu"
               aria-expanded="${isOrderMenuOpen ? 'true' : 'false'}"
               role="button">
                <span>
                    <i class="fas fa-shopping-cart"></i>
                    Quản lý đơn hàng
                </span>
                <i class="fas fa-chevron-down small"></i>
            </a>

            <div class="collapse ${isOrderMenuOpen ? 'show' : ''}" id="orderMenu">
                <a href="${root}/admin/orders?status=pending"
                   class="sub-menu-item ${param.status == 'pending' ? 'fw-bold bg-white text-danger shadow-sm' : ''}">
                    <i class="fas fa-clock me-2"></i>Chờ xử lý
                </a>

                <a href="${root}/admin/orders?status=pickup"
                   class="sub-menu-item ${param.status == 'pickup' ? 'fw-bold bg-white text-danger shadow-sm' : ''}">
                    <i class="fas fa-boxes me-2"></i>Chờ lấy hàng
                </a>

                <a href="${root}/admin/orders?status=shipping"
                   class="sub-menu-item ${param.status == 'shipping' ? 'fw-bold bg-white text-danger shadow-sm' : ''}">
                    <i class="fas fa-truck me-2"></i>Đang giao
                </a>

                <a href="${root}/admin/orders?status=completed"
                   class="sub-menu-item ${param.status == 'completed' ? 'fw-bold bg-white text-danger shadow-sm' : ''}">
                    <i class="fas fa-check-circle me-2"></i>Đã giao (Hoàn tất)
                </a>

                <a href="${root}/admin/orders?status=cancelled"
                   class="sub-menu-item ${param.status == 'cancelled' ? 'fw-bold bg-white text-danger shadow-sm' : ''}">
                    <i class="fas fa-times-circle me-2"></i>Đã hủy
                </a>

                <div class="ps-4 border-start ms-4 border-2 mb-2 mt-1"
                     style="border-color: rgba(255,255,255,0.3) !important;">
                    <a href="${root}/admin/orders?status=refund_pending"
                       class="sub-menu-item ${param.status == 'refund_pending' ? 'fw-bold bg-white text-danger shadow-sm' : ''} py-2">
                        <i class="fas fa-money-bill-wave text-warning" style="font-size: 0.9em;"></i> Yêu cầu hoàn tiền
                    </a>

                    <a href="${root}/admin/orders?status=refunded"
                       class="sub-menu-item ${param.status == 'refunded' ? 'fw-bold bg-white text-danger shadow-sm' : ''} py-2">
                        <i class="fas fa-check-circle text-success" style="font-size: 0.9em;"></i> Đã hoàn tiền
                    </a>

                    <a href="${root}/admin/orders?status=refund_rejected"
                       class="sub-menu-item ${param.status == 'refund_rejected' ? 'fw-bold bg-white text-danger shadow-sm' : ''} py-2">
                        <i class="fas fa-times-circle text-danger" style="font-size: 0.9em;"></i> Từ chối hoàn tiền
                    </a>
                </div>
            </div>

            <a href="${root}/admin/products" class="menu-item ${currentURI.contains('products') ? 'active-menu' : ''}">
                <i class="fas fa-box"></i> Quản lý sản phẩm
            </a>

            <a href="${root}/admin/categories" class="menu-item ${currentURI.contains('categories') ? 'active-menu' : ''}">
                <i class="fas fa-layer-group"></i> Quản lý danh mục
            </a>

            <a href="${root}/admin/vouchers" class="menu-item ${currentURI.contains('vouchers') ? 'active-menu' : ''}">
                <i class="fas fa-ticket-alt"></i> Quản lý voucher
            </a>

            <a href="${root}/admin/customers" class="menu-item ${currentURI.contains('customers') ? 'active-menu' : ''}">
                <i class="fas fa-users"></i> Quản lý khách hàng
            </a>

            <a href="${root}/admin/banners" class="menu-item ${currentURI.contains('banners') ? 'active-menu' : ''}">
                <i class="fas fa-image"></i> Quản lý banner
            </a>
            <a href="${pageContext.request.contextPath}/api/chat-admin" class="menu-item ${currentURI.contains('chat') ? 'active-menu' : ''}">
                <i class="fas fa-comments text-white"></i> Tư vấn trực tuyến
            </a>

            <hr class="text-white">

            <a href="${root}/products" class="menu-item text-warning">
                <i class="fas fa-external-link-alt"></i> Xem trang khách
            </a>

        </div>
    </div>

    <div id="page-content-wrapper">
        <nav class="navbar admin-navbar">
            <div>
                <button class="btn btn-outline-danger btn-sm">
                    <i class="fas fa-bars"></i>
                </button>
            </div>

            <div class="ms-auto d-flex align-items-center">
                <span class="me-3">
                    Xin chào <strong>${sessionScope.user.fullName}</strong>
                </span>
                <a href="${root}/logout" class="btn btn-outline-danger btn-sm">Đăng xuất</a>
            </div>
        </nav>

        <div id="mainContent">
            <c:choose>
                <c:when test="${not empty contentPage}">
                    <jsp:include page="${contentPage}"/>
                </c:when>
                <c:otherwise>
                    <div class="container-fluid pt-2">
                        <div class="alert alert-warning border-0 shadow-sm d-flex align-items-center" role="alert">
                            <i class="fas fa-exclamation-triangle me-3 fs-4 text-warning"></i>
                            <div>
                                <h5 class="alert-heading fw-bold mb-1">Không tìm thấy nội dung trang!</h5>
                                <p class="mb-0 small text-muted">Vui lòng kiểm tra cấu hình thuộc tính <code>contentPage</code> truyền từ Servlet.</p>
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>