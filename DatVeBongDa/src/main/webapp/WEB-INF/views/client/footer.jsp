<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<footer class="footer">

<style>

.footer{
background:#aa1814;
color:white;
padding:40px 20px;
font-family:Segoe UI, Arial;
}

.footer-container{
max-width:1200px;
margin:auto;
display:flex;
flex-wrap:wrap;
justify-content:space-between;
}

.footer-column{
width:23%;
min-width:220px;
margin-bottom:25px;
}

.title-menu{
color:#00AA44;
margin-bottom:12px;
font-size:16px;
font-weight:bold;
}

/* LINKS */

.footer-column a{
color:white;
text-decoration:none;
}

.footer-column a:hover{
text-decoration:underline;
}

/* SOCIAL */

.social{
display:flex;
gap:10px;
margin-top:10px;
}

.social a{
width:45px;
height:45px;
display:flex;
align-items:center;
justify-content:center;
border-radius:8px;
color:white;
font-size:18px;
text-decoration:none;
transition:0.3s;
}

.social a:hover{
transform:scale(1.1);
}

/* SOCIAL COLORS */

.fb{background:#1877F2;}
.tw{background:#8aa4c3;}
.yt{background:#cc0000;}
.ig{
background:linear-gradient(45deg,#f58529,#dd2a7b,#8134af,#515bd4);
}

/* PAYMENT */

.payment-accept{
display:flex;
align-items:center;
gap:10px;
margin-top:10px;
}

.payment-accept img{
width:65px;
height:38px;
background:white;
border-radius:4px;
padding:4px;
object-fit:contain;
}

/* FOOTER BOTTOM */

.footer-bottom{
text-align:center;
border-top:1px solid rgba(255,255,255,0.3);
margin-top:20px;
padding-top:15px;
font-size:13px;
}

</style>


<div class="footer-container">

<!-- CONTACT -->
<div class="footer-column">

<h4 class="title-menu">
<c:choose>
<c:when test="${sessionScope.lang == 'en'}">CONTACT</c:when>
<c:otherwise>LIÊN HỆ</c:otherwise>
</c:choose>
</h4>

<p>Công ty Cổ phần Bóng đá Hoàng Anh Gia Lai</p>

<p>
<c:choose>
<c:when test="${sessionScope.lang == 'en'}">Address</c:when>
<c:otherwise>Địa chỉ</c:otherwise>
</c:choose>
: SVĐ Pleiku, Gia Lai
</p>

<p>Email: contact@haglfc.com.vn</p>

<p>
<c:choose>
<c:when test="${sessionScope.lang == 'en'}">Hotline</c:when>
<c:otherwise>Hotline</c:otherwise>
</c:choose>
: 1900 6868
</p>

</div>


<!-- POLICY -->
<div class="footer-column">

<h4 class="title-menu">
<c:choose>
<c:when test="${sessionScope.lang == 'en'}">POLICY</c:when>
<c:otherwise>CHÍNH SÁCH</c:otherwise>
</c:choose>
</h4>

<ul style="list-style:none;padding:0">

<li>
<a href="${pageContext.request.contextPath}/privacy">
<c:choose>
<c:when test="${sessionScope.lang == 'en'}">Privacy Policy</c:when>
<c:otherwise>Chính sách bảo mật</c:otherwise>
</c:choose>
</a>
</li>

<li>
<a href="${pageContext.request.contextPath}/terms">
<c:choose>
<c:when test="${sessionScope.lang == 'en'}">Terms of Use</c:when>
<c:otherwise>Điều khoản sử dụng</c:otherwise>
</c:choose>
</a>
</li>

<li>
<a href="${pageContext.request.contextPath}/guide">
<c:choose>
<c:when test="${sessionScope.lang == 'en'}">Shopping Guide</c:when>
<c:otherwise>Hướng dẫn mua hàng</c:otherwise>
</c:choose>
</a>
</li>

</ul>

</div>


<!-- SOCIAL -->
<div class="footer-column">

<h4 class="title-menu">
<c:choose>
<c:when test="${sessionScope.lang == 'en'}">FOLLOW US</c:when>
<c:otherwise>Liên kết xã hội</c:otherwise>
</c:choose>
</h4>

<div class="social">

<a href="https://www.facebook.com/hagl.fc.official"
target="_blank"
class="fb">f</a>

<a href="https://twitter.com"
target="_blank"
class="tw">t</a>

<a href="https://www.youtube.com/@HAGLFC"
target="_blank"
class="yt">▶</a>

<a href="https://www.instagram.com/hagl_fc/"
target="_blank"
class="ig">◎</a>

</div>

</div>


<!-- PAYMENT -->
<div class="footer-column">

<h4 class="title-menu">
<c:choose>
<c:when test="${sessionScope.lang == 'en'}">PAYMENT METHOD</c:when>
<c:otherwise>Phương thức thanh toán</c:otherwise>
</c:choose>
</h4>

<div class="payment-accept">

<img src="https://upload.wikimedia.org/wikipedia/commons/2/2a/VN_PAY.jpg" alt="VNPay">

<img src="https://upload.wikimedia.org/wikipedia/commons/2/29/momo.jpg" alt="MoMo">

<img src="https://upload.wikimedia.org/wikipedia/commons/6/6b/zaloPay.jpg" alt="ZaloPay">

<img src="https://upload.wikimedia.org/wikipedia/commons/5/5e/visa.jpg" alt="Visa">

</div>

</div>

</div>


<div class="footer-bottom">

© 2025 Hoàng Anh Gia Lai FC

<c:choose>
<c:when test="${sessionScope.lang == 'en'}">
All rights reserved
</c:when>
<c:otherwise>
Bảo lưu mọi quyền
</c:otherwise>
</c:choose>

</div>

</footer>