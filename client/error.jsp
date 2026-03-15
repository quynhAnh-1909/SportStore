<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Lỗi Hệ Thống - HAGL Tickets</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f0f2f5;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
            text-align: center;
        }
        .error-container {
            background: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            max-width: 500px;
        }
        .error-icon {
            font-size: 80px;
            color: #e41e31; /* Màu đỏ HAGL */
            margin-bottom: 20px;
        }
        h1 { color: #2d3436; margin-bottom: 10px; }
        p { color: #636e72; line-height: 1.6; margin-bottom: 30px; }
        .btn-home {
            background-color: #008f4c; /* Màu xanh HAGL */
            color: white;
            padding: 12px 30px;
            text-decoration: none;
            border-radius: 50px;
            font-weight: bold;
            transition: 0.3s;
        }
        .btn-home:hover {
            background-color: #006b39;
            box-shadow: 0 5px 15px rgba(0, 143, 76, 0.4);
        }
        .error-details {
            margin-top: 20px;
            font-size: 0.8rem;
            color: #b2bec3;
            text-align: left;
            background: #f8f9fa;
            padding: 10px;
            border-radius: 4px;
            display: none; /* Ẩn chi tiết lỗi với người dùng thông thường */
        }
    </style>
</head>
<body>

    <div class="error-container">
        <div class="error-icon">⚠️</div>
        <h1>Đã có lỗi xảy ra!</h1>
        <p>
            Rất tiếc, hệ thống đang gặp sự cố kỹ thuật tạm thời. 
            Vui lòng thử lại sau hoặc quay về trang chủ để tiếp tục mua vé.
        </p>
        
<a href="${pageContext.request.contextPath}/matchList" class="btn-home">Quay lại Trang Chủ</a>

        <%-- Hiển thị lỗi cho lập trình viên khi debug (có thể bật lên nếu cần) --%>
        <c:if test="${not empty pageContext.exception}">
            <div class="error-details" style="display: block;">
                <strong>Chi tiết lỗi:</strong> ${pageContext.exception.message}
            </div>
        </c:if>
    </div>

</body>
</html>