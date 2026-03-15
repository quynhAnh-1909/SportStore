<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="root" value="${pageContext.request.contextPath}" />
<c:set var="isEn" value="${sessionScope.lang == 'en'}" />

<!DOCTYPE html>
<html lang="${isEn ? 'en' : 'vi'}">
<head>
    <meta charset="UTF-8">

    <title>
        ${isEn ? 'Register - HAGL Tickets' : 'Đăng ký - HAGL Tickets'}
    </title>

    <!-- DÙNG CHUNG FONT + STYLE VỚI LOGIN -->
    <style>

			body{
			    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
			    background:#f4f6f9;
			    margin:0;
			}
			
			/* REGISTER CARD */
			
			.register-box{
			    max-width:420px;
			    margin:80px auto;
			    padding:35px;
			    border-radius:12px;
			    box-shadow:0 10px 30px rgba(0,0,0,0.1);
			    background:white;
			    text-align:center;
			    position:relative;
			}
			
			/* ACCENT LINE */
			
			.card-accent{
			    position:absolute;
			    top:0;
			    left:0;
			    width:100%;
			    height:4px;
			    background:#004d31;
			}
			
			/* TITLE */
			
			.register-box h2{
			    color:#d81f19;
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
			    border-color:#d81f19;
			    outline:none;
			}
			
			/* BUTTON */
			
			.btn-submit{
			    width:100%;
			    padding:14px;
			    background:#d81f19;
			    color:white;
			    border:none;
			    cursor:pointer;
			    margin-top:15px;
			    border-radius:8px;
			    font-weight:bold;
			    font-size:1rem;
			}
			
			.btn-submit:hover{
			    background:#d81f19;
			}
			
			/* MESSAGE */
			
			.error-msg{
			    color:#e41e31;
			    font-weight:bold;
			    font-size:0.9rem;
			}
	
	</style>
</head>

<body>

<jsp:include page="header.jsp" />

<main class="register-box">
	
	<div class="card-accent"></div>

    <img src="${root}/resources/sport_store.jpg"
         alt="HAGL Logo"
         style="height: 70px; margin-bottom: 15px;">

    <h2>
        ${isEn ? 'Register' : 'Đăng ký'}
    </h2>

    <!-- ERROR -->
    <c:if test="${not empty errorMessage}">
        <p class="error-msg">${errorMessage}</p>
    </c:if>

    <form action="${root}/register" method="POST">

        <input type="text"
               name="hoTen"
               class="input-field"
               placeholder="${isEn ? 'Full name' : 'Họ và tên'}"
               required />

        <input type="email"
               name="email"
               class="input-field"
               placeholder="Email"
               required />

        <input type="password"
               name="matKhau"
               class="input-field"
               placeholder="${isEn ? 'Password' : 'Mật khẩu'}"
               required />

        <input type="text"
               name="soDienThoai"
               class="input-field"
               placeholder="${isEn ? 'Phone number' : 'Số điện thoại'}" />

        <button type="submit" class="btn-submit">
            ${isEn ? 'REGISTER' : 'ĐĂNG KÝ'}
        </button>

        <p style="margin-top: 20px; font-size: 0.9rem; color: #666;">
            ${isEn ? 'Already have an account?' : 'Đã có tài khoản?'}
            <a href="${root}/login"
               style="color:#008f4c;font-weight:bold;">
                ${isEn ? 'Login' : 'Đăng nhập'}
            </a>
        </p>

    </form>
</main>

<jsp:include page="footer.jsp" />

</body>
</html>
