<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="root" value="${pageContext.request.contextPath}" />
<jsp:include page="/WEB-INF/layout/index.jsp" />

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>Chi tiết đơn hàng #${order.id}</title>
    <style>
        *{
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body{
            font-family: Arial, sans-serif;
            background: #f4f6f9;
            padding: 30px;
            color: #333;
        }
        .container{
            max-width: 1200px;
            margin: auto;
        }


        .breadcrumb {
            margin-bottom: 15px;
            font-size: 14px;
        }
        .breadcrumb a {
            color: #007bff;
            text-decoration: none;
            font-weight: bold;
        }
        .breadcrumb span {
            margin: 0 5px;
            color: #888;
        }
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }
        .page-title{
            font-size: 32px;
            font-weight: bold;
            color: #222;
        }


        .top-grid {
            display: grid;
            grid-template-columns: 3fr 2fr;
            gap: 20px;
            margin-bottom: 25px;
        }


        .info-card {
            background: white;
            border-radius: 18px;
            padding: 25px;
            box-shadow: 0 4px 18px rgba(0,0,0,0.08);
            height: 100%;
        }
        .box-title {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .text-success { color: #28a745; }
        .text-warning { color: #d39e00; }

        .info-row {
            margin-bottom: 12px;
            font-size: 15px;
        }
        .info-row strong {
            display: inline-block;
            width: 120px;
            color: #555;
        }


        .note-box {
            margin-top: 20px;
            padding: 15px;
            background: #fff5f5;
            border-left: 4px solid #dc3545;
            border-radius: 8px;
        }
        .note-box strong { color: #dc3545; font-size: 14px;}
        .note-box p { margin-top: 5px; font-size: 14px; font-style: italic; color: #666; }


        .badge{
            padding: 8px 16px;
            border-radius: 999px;
            color: white;
            font-size: 13px;
            font-weight: bold;
            display: inline-block;
        }
        .bg-success { background: #28a745; }
        .bg-warning { background: #ffc107; color: #333; }
        .bg-secondary { background: #6c757d; }


        .alert-info {
            background: #e1f5fe;
            color: #0277bd;
            padding: 12px;
            border-radius: 8px;
            font-size: 13px;
            margin-bottom: 15px;
        }


        .btn {
            border: none;
            padding: 12px 20px;
            border-radius: 8px;
            cursor: pointer;
            font-weight: bold;
            text-decoration: none;
            transition: 0.3s;
            display: inline-flex;
            justify-content: center;
            align-items: center;
            gap: 8px;
            font-size: 14px;
        }
        .btn-outline { background: transparent; color: #007bff; border: 2px solid #007bff; }
        .btn-outline:hover { background: #007bff; color: white; }
        .btn-danger { background: #dc3545; color: white; width: 100%; margin-bottom: 10px; }
        .btn-danger:hover { background: #b52a37; }
        .btn-secondary-outline { background: transparent; color: #6c757d; border: 2px solid #6c757d; width: 100%; }
        .btn-secondary-outline:hover { background: #6c757d; color: white; }

        /* BẢNG SẢN PHẨM */
        .table-card {
            background: white;
            border-radius: 18px;
            padding: 25px;
            box-shadow: 0 4px 18px rgba(0,0,0,0.08);
            overflow-x: auto;
        }
        .custom-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }
        .custom-table th {
            background: #f8f9fc;
            padding: 15px;
            text-align: left;
            color: #555;
            font-size: 14px;
            border-bottom: 2px solid #eee;
        }
        .custom-table td {
            padding: 15px;
            border-bottom: 1px solid #eee;
            vertical-align: middle;
        }
        .product-col {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .product-img {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 8px;
            border: 1px solid #ddd;
        }
        .product-name { font-weight: bold; color: #222; }


        .tfoot-row td {
            padding: 12px 15px;
            border: none;
            font-size: 15px;
        }
        .tfoot-row td:first-child { text-align: right; font-weight: bold; color: #555; }
        .tfoot-row td:last-child { text-align: right; font-weight: bold; }
        .tfoot-total td {
            border-top: 2px solid #eee;
            font-size: 18px !important;
            color: #222;
        }
        .text-price-total { color: #dc3545 !important; }

        /* MOBILE RESPOSNIVE */
        @media(max-width: 768px){
            .top-grid { grid-template-columns: 1fr; }
            .page-header { flex-direction: column; align-items: flex-start; gap: 15px; }
            .custom-table th, .custom-table td { white-space: nowrap; }
        }
    </style>
</head>

<body>

<div class="container">

    <div class="breadcrumb">
        <a href="${root}/home">🏠 Trang chủ</a>
        <span>/</span>
        <a href="${root}/order-history">Lịch sử đơn hàng</a>
        <span>/</span>
        <span style="color: #222; font-weight: bold;">Chi tiết #${order.id}</span>
    </div>

    <div class="page-header">
        <h1 class="page-title">ℹ️ Chi tiết đơn hàng #${order.id}</h1>
        <a class="btn btn-outline" href="${root}/order-history">
            🔙 Quay lại danh sách
        </a>
    </div>

    <div class="top-grid">

        <div class="info-card" style="border: 1px solid #c3e6cb; background: #f8fdf9;">
            <div class="box-title text-success">🚚 Thông tin nhận hàng</div>

            <div class="info-row">
                <strong>Người nhận:</strong> ${not empty order.receiverName ? order.receiverName : sessionScope.user.fullName}
            </div>
            <div class="info-row">
                <strong>SĐT:</strong> ${not empty order.receiverPhone ? order.receiverPhone : sessionScope.user.phoneNumber}
            </div>
            <div class="info-row">
                <strong>Địa chỉ:</strong> ${order.address}
            </div>
            <div class="info-row">
                <strong>Ngày đặt:</strong>
                <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm" />
            </div>

            <c:if test="${not empty order.note}">
                <div class="note-box">
                    <strong>📝 Ghi chú:</strong>
                    <p>"${order.note}"</p>
                </div>
            </c:if>
        </div>

        <%-- Phần Trạng thái đơn hàng --%>
        <div class="info-card" style="border: 1px solid #ffeeba; background: #fff9f0;">
            <div class="box-title text-warning">💳 Trạng thái đơn hàng</div>

            <div class="info-row">
                <strong>Phương thức:</strong> ${order.paymentMethod}
            </div>

            <div class="info-row" style="display: flex; align-items: center; gap: 10px;">
                <strong>Tình trạng:</strong>
                <c:choose>
                    <c:when test="${order.status eq 'CANCELLED'}">
                        <span class="badge bg-secondary">🚫 Đã hủy</span>
                    </c:when>
                    <c:when test="${order.status eq 'DELIVERED'}">
                        <span class="badge bg-success">✅ Thành công</span>
                    </c:when>
                    <c:when test="${order.status eq 'SHIPPING'}">
                        <span class="badge bg-primary">🚚 Đang giao</span>
                    </c:when>
                    <c:when test="${order.status eq 'PENDING'}">
                        <span class="badge bg-warning">⏳ Chờ xác nhận</span>
                    </c:when>
                    <c:otherwise>
                        <span class="badge bg-info">${order.status}</span>
                    </c:otherwise>
                </c:choose>
            </div>

            <hr style="border: 0; border-top: 1px solid #ddd; margin: 20px 0;">

            <%-- Nút Hủy đơn hàng (Chỉ cho phép khi đơn hàng đang PENDING) --%>
            <c:if test="${order.status eq 'PENDING'}">
                <form action="${root}/cancel-order" method="post" onsubmit="return confirm('Bạn có chắc chắn muốn hủy đơn này?')">
                    <input type="hidden" name="orderCode" value="${order.orderCode}" />
                    <button type="submit" class="btn btn-secondary-outline">
                        ❌ HỦY ĐƠN HÀNG
                    </button>
                </form>
            </c:if>
        </div>

    <div class="table-card">
        <div class="box-title text-success" style="margin-bottom: 10px;">
            🛒 Danh sách sản phẩm
        </div>

        <table class="custom-table">
            <thead>
            <tr>
                <th>Sản phẩm</th>
                <th style="text-align: center;">Đơn giá</th>
                <th style="text-align: center;">Số lượng</th>
                <th style="text-align: right;">Thành tiền</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="item" items="${order.orderDetails}">
                <tr>
                    <td>
                        <div class="product-col">
                            <img src="${empty item.product.imageUrl ? root.concat('/images/default-prod.png') : item.product.imageUrl}"
                                 alt="Hình ảnh" class="product-img">
                            <span class="product-name">${item.product.name}</span>
                        </div>
                    </td>
                    <td style="text-align: center;">
                        <fmt:formatNumber value="${item.price}" type="number"/> đ
                    </td>
                    <td style="text-align: center; font-weight: bold;">
                            ${item.quantity}
                    </td>
                    <td style="text-align: right; font-weight: bold; color: #28a745;">
                        <fmt:formatNumber value="${item.price * item.quantity}" type="number"/> đ
                    </td>
                </tr>
            </c:forEach>
            </tbody>
            <tfoot>
            <tr class="tfoot-row">
                <td colspan="3">Tiền hàng:</td>
                <td><fmt:formatNumber value="${order.totalPrice - order.shippingFee}" type="number"/> đ</td>
            </tr>
            <tr class="tfoot-row">
                <td colspan="3">Phí vận chuyển:</td>
                <td><fmt:formatNumber value="${order.shippingFee}" type="number"/> đ</td>
            </tr>
            <tr class="tfoot-row tfoot-total">
                <td colspan="3">TỔNG CỘNG:</td>
                <td class="text-price-total"><fmt:formatNumber value="${order.totalPrice}" type="number"/> đ</td>
            </tr>
            </tfoot>
        </table>
    </div>

</div>

</body>
</html>