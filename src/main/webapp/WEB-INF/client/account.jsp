<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Tài khoản cá nhân</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .container {
            max-width: 1000px;
        }
        .avatar {
            width: 150px;
            height: 150px;
            object-fit: cover;
            border-radius: 50%;
            border: 3px solid #007bff;
        }
        .card-profile {
            padding: 20px;
            border-radius: 15px;
            background-color: #ffffff;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        .card-profile h2 {
            color: #007bff;
            margin-bottom: 20px;
        }
        .btn-primary {
            background-color: #007bff;
            border-color: #007bff;
        }
        .table th {
            background-color: #007bff;
            color: #fff;
        }
        .table td, .table th {
            vertical-align: middle;
        }
        .table-striped tbody tr:nth-of-type(odd) {
            background-color: #f2f6fc;
        }
        .table-bordered {
            border: 1px solid #dee2e6;
        }
        .btn-sm {
            font-size: 0.85rem;
        }
    </style>
</head>
<jsp:include page="/WEB-INF/layout/index.jsp" />
<body class="p-5">
<div class="container">

    <!-- Thông tin cá nhân -->
    <div class="card card-profile">
        <h2 class="text-center">Thông tin cá nhân</h2>
        <div class="row align-items-center">
            <div class="col-md-4 text-center mb-3">
                <img src="${user.avatar != null ? user.avatar : pageContext.request.contextPath + '/images/default-avatar.png'}"
                     class="avatar img-thumbnail" alt="Avatar">
            </div>
            <div class="col-md-8">
                <form action="${pageContext.request.contextPath}/editAccount" method="post" enctype="multipart/form-data">
                    <div class="mb-3">
                        <label>Họ và tên</label>
                        <input type="text" name="fullName" value="${user.fullName}" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label>Email</label>
                        <input type="email" name="email" value="${user.email}" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label>Số điện thoại</label>
                        <input type="text" name="phone" value="${user.phoneNumber}" class="form-control">
                    </div>
                    <div class="mb-3">
                        <label>Avatar</label>
                        <input type="file" name="avatar" class="form-control">
                    </div>
                    <button type="submit" class="btn btn-primary">Cập nhật</button>
                </form>
            </div>
        </div>
    </div>

    <!-- Lịch sử mua hàng -->
    <div class="card card-profile">
        <h2 class="text-center">Lịch sử mua hàng</h2>
        <table class="table table-striped table-bordered mt-3">
            <thead>
            <tr>
                <th>Mã đơn</th>
                <th>Ngày đặt</th>
                <th>Tổng tiền</th>
                <th>Trạng thái</th>
                <th>Chi tiết</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="order" items="${orderHistory}">
                <tr>
                    <td>${order.orderCode}</td>
                    <td>${order.createdAt}</td>
                    <td>${order.totalPrice} VND</td>
                    <td>${order.status}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/orderDetail?orderCode=${order.orderCode}"
                           class="btn btn-sm btn-info">Xem</a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

</div>
</body>
<jsp:include page="/footer.jsp" />
</html>