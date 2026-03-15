<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="root" value="${pageContext.request.contextPath}" />
<c:set var="isEn" value="${sessionScope.lang == 'en'}" />

<!DOCTYPE html>
<html lang="${isEn ? 'en' : 'vi'}">
<head>
<meta charset="UTF-8">

<title>
${isEn ? 'Login - Sport Store' : 'Đăng nhập - Sport Store'}
</title>

<style>

body{
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background:#f4f6f9;
    margin:0;
}

/* LOGIN CARD */

.login-box{
    max-width:420px;
    margin:80px auto;
    padding:35px;
    border-radius:12px;
    box-shadow:0 10px 30px rgba(0,0,0,0.1);
    background:white;
    text-align:center;
    position:relative;
}
	
/* ACCENT LINE GIỐNG PRODUCT CARD */

.card-accent{
    position:absolute;
    top:0;
    left:0;
    width:100%;
    height:4px;
    background:#004d31;
}

/* TITLE */

.login-box h2{
    color: #d81f19;
    margin-bottom:20px;
    text-transform:uppercase;
}

/* INPUT */

.input-field{
    width:100%;
    padding:12px;
    margin:10px 0;
    border:1px solid #ddd;
    border-radius:6px;
    box-sizing:border-box;
    font-size:14px;
}

.input-field:focus{
    border-color: #d81f19;
    outline:none;
}

/* BUTTON */

.btn-submit{
    width:100%;
    padding:14px;
    background: #d81f19;
    color:white;
    border:none;
    cursor:pointer;
    margin-top:15px;
    border-radius:8px;
    font-weight:bold;
    font-size:1rem;
    transition:0.2s;
}

.btn-submit:hover{
    background: #d81f19;
}

/* MESSAGE */

.error-msg{
    color:#e41e31;
    font-weight:bold;
    font-size:0.9rem;
}

.success-msg{
    color:#28a745;
    font-weight:bold;
    font-size:0.9rem;
}

</style>
</head>

<body>

<jsp:include page="header.jsp" />

<main class="login-box">

<div class="card-accent"></div>

<img src="${root}/resources/sport_store.jpg"
     alt="SPORT STORE"
     style="height:70px;margin-bottom:15px;">

<h2>
${isEn ? 'Login' : 'Đăng nhập'}
</h2>

<!-- ERROR MESSAGE -->
<c:if test="${not empty errorMessage}">
<p class="error-msg">${errorMessage}</p>
</c:if>

<!-- SUCCESS MESSAGE -->
<c:if test="${not empty successMessage}">
<p class="success-msg">${successMessage}</p>
</c:if>

<form action="${root}/login" method="POST">

<input type="email"
       name="email"
       class="input-field"
       placeholder="${isEn ? 'Email' : 'Email'}"
       required />

<input type="password"
       name="password"
       class="input-field"
       placeholder="${isEn ? 'Password' : 'Mật khẩu'}"
       required />

<button type="submit" class="btn-submit">
${isEn ? 'LOGIN' : 'ĐĂNG NHẬP'}
</button>

<p style="margin-top:20px;font-size:0.9rem;color: #666;">
<c:choose>

<c:when test="${isEn}">
Don’t have an account?
<a href="${root}/register"
   style="color:#008f4c;font-weight:bold;">
Register now
</a>
</c:when>

<c:otherwise>
Bạn chưa có tài khoản?
<a href="${root}/register"
   style="color:#008f4c;font-weight:bold;">
Đăng ký ngay
</a>
</c:otherwise>

</c:choose>
</p>

</form>

</main>

<jsp:include page="footer.jsp" />

</body>
</html>