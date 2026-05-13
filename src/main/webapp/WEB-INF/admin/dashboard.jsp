<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="root" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>

    <!-- Bootstrap CSS -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <!-- Font Awesome -->
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        :root{
            --main-red:#d81f19;
            --dark-red:#b71c17;
            --light-bg:#f7f3f3;
        }

        html, body{
            width:100%;
            /*height:100%;*/
            margin:0;
            padding:0;
            overflow-x:hidden;
            background:var(--light-bg);
            font-family:'Segoe UI', sans-serif;
        }
        body{
            overflow-y:auto;
        }
        #wrapper{
            display:flex;
            width:100%;
            height:100vh;
            overflow-x:hidden;
        }

        #sidebar-wrapper{
            width:260px;
            min-height:100vh;
            background:linear-gradient(180deg,var(--main-red),var(--dark-red));
            position:fixed;
            left:0;
            top:0;
        }

        .sidebar-heading{
            padding:25px;
            text-align:center;
            color:white;
            font-size:22px;
            font-weight:bold;
            border-bottom:1px solid rgba(255,255,255,0.2);
        }

        .list-group-item{
            background:transparent;
            color:white;
            border:none;
            padding:18px 25px;
            font-size:18px;
            font-weight:500;
            transition:0.3s;
        }

        .list-group-item:hover{
            background:rgba(255,255,255,0.15);
            padding-left:35px;
        }

        #page-content-wrapper{
            margin-left:260px;
            width:calc(100% - 260px);
            height:100vh;
            overflow-y:auto;
        }

        .admin-navbar{
            background:white;
            padding:18px 30px;
            box-shadow:0 2px 10px rgba(0,0,0,0.08);
        }

        #mainContent{
            padding:30px;
        }
        #sidebar-wrapper{
            height:100vh;
            overflow-y:auto;
        }
        .dashboard-title{
            font-size:42px;
            font-weight:bold;
            color:var(--main-red);
            margin-bottom:25px;
        }

        .card{
            border:none;
            border-radius:20px;
            box-shadow:0 4px 15px rgba(0,0,0,0.08);
            border-top:5px solid var(--main-red);
        }

        .card-body{
            text-align:center;
            padding:30px;
        }

        .card h5{
            color:var(--main-red);
            font-size:26px;
            font-weight:700;
        }

        .card h2{
            font-size:38px;
            font-weight:bold;
            margin-top:15px;
        }

        .dashboard-box{
            background:white;
            border-radius:15px;
            padding:25px;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.06);
            margin-top: 25px;
        }
    </style>
</head>

<body>

<div id="wrapper">

    <!-- SIDEBAR -->
    <div id="sidebar-wrapper">
        <div class="sidebar-heading">
            <h5 class="fw-bold"><i class="fas fa-store text-success"></i> SPORT SHOP ADMIN</h5>
        </div>
        <div class="list-group list-group-flush pt-3">
            <a href="${root}/admin/dashboard"
               class="list-group-item list-group-item-action"> <i class="fas fa-chart-line me-2"></i> Tổng quan </a>
            <a href="${root}/admin/orders"
               class="list-group-item list-group-item-action"> <i class="fas fa-shopping-cart me-2"></i> Quản lý đơn
                hàng </a>
            <a href="${root}/admin/products"
               class="list-group-item list-group-item-action"> <i class="fas fa-box me-2"></i> Quản lý sản phẩm </a>
            <a href="${root}/admin/categories"
               class="list-group-item list-group-item-action"> <i class="fas fa-layer-group me-2"></i> Quản lý danh mục
            </a>
            <a href="${root}/admin/vouchers"
               class="list-group-item list-group-item-action">
                <i class="fas fa-ticket-alt me-2"></i> Quản lý voucher
            </a>

            <a href="${root}/admin/customers"
               class="list-group-item list-group-item-action">
                <i class="fas fa-users me-2"></i> Quản lý khách hàng
            </a>
            <a href="${root}/admin/banners"
               class="list-group-item list-group-item-action">
               <i class="fas fa-image me-2"></i> Quản lý banner
            </a>

            <div class="border-top my-3"></div>

            <a href="${root}/products"
               class="list-group-item list-group-item-action text-info"> <i class="fas fa-external-link-alt me-2"></i>
                Xem trang khách </a>
        </div>
    </div>


    <div id="page-content-wrapper">

        <!-- NAVBAR -->
        <nav class="navbar admin-navbar px-4 py-2 d-flex justify-content-between">
            <button class="btn btn-outline-secondary btn-sm" id="menu-toggle">
                <i class="fas fa-bars"></i>
            </button>

            <div class="ms-auto">
                <span class="me-3">Xin chào <strong>${sessionScope.user.fullName}</strong></span>
                <a href="${root}/logout" class="btn btn-sm btn-outline-danger">Đăng xuất</a>
            </div>
        </nav>

        <!-- MAIN CONTENT -->
        <div class="container-fluid p-4" id="mainContent">

            <c:choose>
                <c:when test="${not empty contentPage}">
                    <jsp:include page="${contentPage}"/>
                </c:when>
                <c:otherwise>
                    <h3 class="dashboard-title">Dashboard</h3>

                    <div class="row g-4">

                        <div class="col-md-4">
                            <div class="card">
                                <div class="card-body">
                                    <h5>Tổng sản phẩm</h5>
                                    <h2>${productCount}</h2>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="card">
                                <div class="card-body">
                                    <h5>Tổng đơn hàng</h5>
                                    <h2>${orderCount}</h2>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="card">
                                <div class="card-body">
                                    <h5>Doanh thu</h5>
                                    <h2>${revenue}₫</h2>
                                </div>
                            </div>
                        </div>

                    </div>

                    <div class="row">
                        <div class="col-md-8">
                            <div class="dashboard-box">
                                <h4 class="text-danger">🔥 Top sản phẩm bán chạy</h4>
                                <table class="table mt-3">
                                    <tr>
                                        <th>Sản phẩm</th>
                                        <th>Đã bán</th>
                                    </tr>
                                    <tr>
                                        <td>Yonex Astrox 88D</td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td>Adidas Predator Ball</td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td>Nike Air Zoom</td>
                                        <td></td>
                                    </tr>
                                </table>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="dashboard-box">
                                <h4 class="text-success">🔔 Thông báo</h4>
                                <p>🟡 Có đơn mới</p>
                                <p>📦 Sản phẩm đang hoạt động</p>
                            </div>
                        </div>
                    </div>

                    <div class="dashboard-box">
                        <h4 class="text-success">📈 Doanh thu theo tháng</h4>
                        <div style="height:200px;"></div>
                    </div>
                </c:otherwise>
            </c:choose>

        </div>

    </div>

</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Toggle Sidebar -->
<script>
    document.getElementById("menu-toggle").addEventListener("click", function () {
        document.getElementById("wrapper").classList.toggle("toggled");
    });
</script>

</body>
</html>