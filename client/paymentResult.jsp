<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<c:set var="root" value="${pageContext.request.contextPath}" />
<c:set var="isEn" value="${sessionScope.lang == 'en'}" />

<!DOCTYPE html>
<html lang="${isEn ? 'en' : 'vi'}">
<head>
    <meta charset="UTF-8">
    <title>
        ${isEn ? 'Payment Result - HAGL Tickets' : 'Kết quả thanh toán - HAGL Tickets'}
    </title>

    <style>
        .result-body {
            background-color: #f0f2f5;
            min-height: 80vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .result-card {
            background: white;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            text-align: center;
            max-width: 500px;
            width: 90%;
        }
        .icon { font-size: 80px; margin-bottom: 20px; }
        .success-icon { color: #2ecc71; }
        .error-icon { color: #e74c3c; }
        .warning-icon { color: #f1c40f; }

        .result-title { font-size: 26px; font-weight: bold; margin-bottom: 10px; color: #2d3436; }
        .result-msg { color: #636e72; margin-bottom: 30px; line-height: 1.6; font-size: 1.1rem; }

        .info-table { width: 100%; margin-bottom: 30px; border-collapse: collapse; text-align: left; }
        .info-table td { padding: 15px 10px; border-bottom: 1px solid #f1f2f6; }
        .info-table td:first-child { color: #b2bec3; font-weight: 500; }
        .info-table td:last-child { text-align: right; font-weight: bold; color: #2d3436; }

        .btn-home {
            background-color: #004d31;
            color: white;
            padding: 14px 40px;
            border-radius: 10px;
            text-decoration: none;
            font-weight: bold;
            display: inline-block;
            transition: all 0.3s;
        }
        .btn-home:hover { background-color: #003321; transform: translateY(-2px); }
    </style>
</head>

<body>
<jsp:include page="header.jsp" />

<div class="result-body">
    <div class="result-card">
        <c:choose>

            <%-- THÀNH CÔNG --%>
            <c:when test="${status == 'success'}">
                <div class="icon success-icon">✔</div>
                <div class="result-title">
                    ${isEn ? 'Payment Successful!' : 'Giao dịch thành công!'}
                </div>
                <p class="result-msg">${message}</p>

                <table class="info-table">
                    <tr>
                        <td>${isEn ? 'Order ID' : 'Mã đơn hàng'}</td>
                        <td>${param.vnp_TxnRef}</td>
                    </tr>
                    <tr>
                        <td>${isEn ? 'Amount' : 'Số tiền'}</td>
                        <td>
                            <fmt:formatNumber value="${param.vnp_Amount / 100}"
                                              type="currency" currencyCode="VND"/>
                        </td>
                    </tr>
                    <tr>
                        <td>${isEn ? 'Bank' : 'Ngân hàng'}</td>
                        <td>${param.vnp_BankCode}</td>
                    </tr>
                    <tr>
                        <td>${isEn ? 'Payment Time' : 'Thời gian'}</td>
                        <td>${param.vnp_PayDate}</td>
                    </tr>
                </table>

                <p style="font-size: 0.95rem; color: #7f8c8d; margin-bottom: 25px; font-style: italic;">
                    ${isEn
                        ? '* Your e-ticket has been saved in your ticket purchase history.'
                        : '* Vé điện tử đã được lưu trong mục "Lịch sử mua vé" của bạn.'}
                </p>
            </c:when>

            <%-- CẢNH BÁO --%>
            <c:when test="${status == 'warning'}">
                <div class="icon warning-icon">⚠</div>
                <div class="result-title">
                    ${isEn ? 'Security Warning' : 'Cảnh báo bảo mật'}
                </div>
                <p class="result-msg">${message}</p>
            </c:when>

            <%-- THẤT BẠI --%>
            <c:otherwise>
                <div class="icon error-icon">✘</div>
                <div class="result-title">
                    ${isEn ? 'Payment Failed' : 'Giao dịch thất bại'}
                </div>
                <p class="result-msg">${message}</p>

                <p style="margin-bottom: 30px; color: #e74c3c;">
                    ${isEn ? 'Error code:' : 'Mã lỗi:'} ${param.vnp_ResponseCode}<br>
                    ${isEn
                        ? 'Please check your balance or contact your bank.'
                        : 'Vui lòng kiểm tra số dư hoặc liên hệ ngân hàng.'}
                </p>
            </c:otherwise>

        </c:choose>

        <div style="margin-top: 20px;">
            <a href="${root}/productList" class="btn-home">
                ${isEn ? 'CONTINUE BUYING TICKETS' : 'TIẾP TỤC MUA VÉ'}
            </a>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" />
</body>
</html>
