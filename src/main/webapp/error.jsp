<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>

<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>403 - Truy cập bị từ chối</title>


    <style>
        *{
            margin:0;
            padding:0;
            box-sizing:border-box;
            font-family:'Segoe UI',sans-serif;
        }

        body{
            min-height:100vh;
            display:flex;
            justify-content:center;
            align-items:center;

            background:
                    linear-gradient(
                            135deg,
                            #d81f19,
                            #8b0000
                    );

            overflow:hidden;
        }

        .error-box{
            background:white;
            padding:50px;
            border-radius:25px;

            text-align:center;

            width:550px;
            max-width:90%;

            box-shadow:
                    0 20px 50px rgba(0,0,0,.25);
        }

        .error-code{
            font-size:120px;
            font-weight:900;
            color:#d81f19;
            line-height:1;
        }

        .error-icon{
            font-size:60px;
            margin-bottom:15px;
        }

        .title{
            font-size:30px;
            font-weight:700;
            color:#333;
            margin-bottom:10px;
        }

        .message{
            color:#666;
            font-size:16px;
            line-height:1.7;
            margin-bottom:30px;
        }

        .btn-home{
            display:inline-block;

            padding:14px 30px;

            background:#d81f19;
            color:white;

            text-decoration:none;

            border-radius:30px;

            font-weight:600;

            transition:.3s;
        }

        .btn-home:hover{
            background:#b51612;
            transform:translateY(-2px);
        }

        .warning{
            margin-top:20px;
            font-size:13px;
            color:#999;
        }

        .circle{
            position:absolute;
            border-radius:50%;
            background:rgba(255,255,255,.08);
        }

        .circle1{
            width:250px;
            height:250px;
            top:-80px;
            left:-80px;
        }

        .circle2{
            width:350px;
            height:350px;
            bottom:-120px;
            right:-120px;
        }
    </style>
    ```

</head>
<body>

<div class="circle circle1"></div>
<div class="circle circle2"></div>

<div class="error-box">

    ```
    <div class="error-icon">🚫</div>

    <div class="error-code">403</div>

    <div class="title">
        Truy cập bị từ chối
    </div>

    <div class="message">

        <c:choose>

            <c:when test="${not empty errorMessage}">
                ${errorMessage}
            </c:when>

            <c:otherwise>
                Bạn không có quyền truy cập vào khu vực này.
            </c:otherwise>

        </c:choose>

    </div>

</div>

</body>
</html>
