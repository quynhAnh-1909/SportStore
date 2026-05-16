<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<html>
<head>
    <title>Tài khoản cá nhân</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body { background-color: #f4f6f9; }
        .card-profile {
            padding: 30px;
            border-radius: 15px;
            background: #fff;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            margin-bottom: 30px;
            border: none;
        }
        .avatar {
            width: 150px; height: 150px;
            object-fit: cover; border-radius: 50%;
            border: 4px solid #d81f19; /* Đổi màu đỏ cho tone-sur-tone với header */
        }
        .btn-primary { background-color: #d81f19; border-color: #d81f19; }
        .btn-primary:hover { background-color: #b31914; }
        .table thead { background-color: #343a40; color: white; }
        .badge-status { padding: 5px 10px; border-radius: 20px; font-size: 12px; }
    </style>
</head>

<jsp:include page="/WEB-INF/layout/index.jsp" />

<body class="py-5">
<div class="container mt-5">

    <%-- KHỐI THÔNG TIN CÁ NHÂN --%>
    <div class="card card-profile">
        <h2 class="mb-4 text-dark fw-bold">👤 Thông tin cá nhân</h2>
        <div class="row">
            <div class="col-md-4 text-center mb-4">
                <img src="${not empty user.avatar ? user.avatar : pageContext.request.contextPath.concat('/resources/default-avatar.png')}"
                     class="avatar img-thumbnail" alt="Avatar">
            </div>
            <div class="col-md-8">
                <form action="${pageContext.request.contextPath}/edit-account" method="post" enctype="multipart/form-data">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Họ và tên</label>
                            <input type="text" name="fullName" value="${user.fullName}" class="form-control" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Email</label>
                            <input type="email" value="${user.email}" class="form-control" disabled>
                            <small class="text-muted">Email không thể thay đổi</small>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Số điện thoại</label>
                        <input type="text" name="phone" value="${user.phoneNumber}" class="form-control">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Thay đổi ảnh đại diện</label>
                        <input type="file" name="avatar" class="form-control">
                    </div>
                    <button type="submit" class="btn btn-primary px-4">Lưu thay đổi</button>
                </form>
            </div>
        </div>
    </div>


    <div class="card card-profile">
        <h2 class="mb-4 text-dark fw-bold">📜 Lịch sử mua hàng</h2>
        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead>
                <tr class="text-center">
                    <th>Mã đơn</th>
                    <th>Ngày đặt</th>
                    <th>Tổng tiền</th>
                    <th>Trạng thái</th>
                    <th>Hành động</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="order" items="${orders}">
                    <tr>
                        <td class="text-center fw-bold text-danger">#${order.orderCode}</td>
                        <td class="text-center">
                            <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                        </td>
                        <td class="text-center fw-bold">
                            <fmt:formatNumber value="${order.totalPrice}" type="number" /> đ
                        </td>
                        <td class="text-center">
                            <c:choose>
                                <c:when test="${order.status == 'PENDING'}">
                                    <span class="badge bg-warning text-dark">Chờ xác nhận</span>
                                </c:when>
                                <c:when test="${order.status == 'DELIVERED'}">
                                    <span class="badge bg-success">Thành công</span>
                                </c:when>
                                <c:when test="${order.status == 'CANCELLED'}">
                                    <span class="badge bg-danger">Đã hủy</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-info">${order.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="text-center">
                            <a href="${pageContext.request.contextPath}/order-detail?id=${order.id}"
                               class="btn btn-sm btn-outline-dark px-3">Xem chi tiết</a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty orders}">
                    <tr>
                        <td colspan="5" class="text-center py-4 text-muted">Bạn chưa có đơn hàng nào.</td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>

</div>
<jsp:include page="/footer.jsp" />
</body>
</html>