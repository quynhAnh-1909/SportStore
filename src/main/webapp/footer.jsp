<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<footer class="footer">

    <style>
        .footer {
            background: #aa1814;
            color: white;
            padding: 40px 20px;
            font-family: Segoe UI, Arial;
        }

        .footer-container {
            max-width: 1200px;
            margin: auto;
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
        }

        .footer-column {
            width: 23%;
            min-width: 220px;
            margin-bottom: 25px;
        }

        .title-menu {
            color: #00AA44;
            margin-bottom: 12px;
            font-size: 16px;
            font-weight: bold;
        }

        .footer-column a {
            color: white;
            text-decoration: none;
        }

        .footer-column a:hover {
            text-decoration: underline;
        }

        .social {
            display: flex;
            gap: 10px;
            margin-top: 10px;
        }

        .social a {
            width: 45px;
            height: 45px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 8px;
            color: white;
            font-size: 18px;
            text-decoration: none;
            transition: 0.3s;
        }

        .social a:hover {
            transform: scale(1.1);
        }

        .fb { background: #1877F2; }
        .tw { background: #8aa4c3; }
        .yt { background: #cc0000; }
        .ig { background: linear-gradient(45deg, #f58529, #dd2a7b, #8134af, #515bd4); }

        .payment-accept {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-top: 10px;
        }

        .payment-accept img {
            width: 65px;
            height: 38px;
            background: white;
            border-radius: 4px;
            padding: 4px;
            object-fit: contain;
        }

        .footer-bottom {
            text-align: center;
            border-top: 1px solid rgba(255, 255, 255, 0.3);
            margin-top: 20px;
            padding-top: 15px;
            font-size: 13px;
        }
    </style>

    <div class="footer-container">

        <!-- LIÊN HỆ -->
        <div class="footer-column">
            <h4 class="title-menu">LIÊN HỆ</h4>

            <p>Sport Store - Chuyên đồ thể thao chính hãng</p>

            <p>Địa chỉ: 123 Nguyễn Huệ, Quận 1, TP. Hồ Chí Minh</p>

            <p>Email: support@sportstore.vn</p>

            <p>Hotline: 1900 6886</p>
        </div>

        <!-- CHÍNH SÁCH -->
        <div class="footer-column">
            <h4 class="title-menu">CHÍNH SÁCH</h4>

            <ul style="list-style: none; padding: 0">
                <li><a href="${pageContext.request.contextPath}/privacy">Chính sách bảo mật</a></li>
                <li><a href="${pageContext.request.contextPath}/terms">Điều khoản & điều kiện</a></li>
                <li><a href="${pageContext.request.contextPath}/guide">Hướng dẫn giao hàng</a></li>
            </ul>
        </div>

        <!-- MẠNG XÃ HỘI -->
        <div class="footer-column">
            <h4 class="title-menu">MẠNG XÃ HỘI</h4>

            <div class="social">
                <a href="https://www.facebook.com/hagl.fc.official" target="_blank" class="fb">f</a>
                <a href="https://twitter.com" target="_blank" class="tw">t</a>
                <a href="https://www.youtube.com/@HAGLFC" target="_blank" class="yt">▶</a>
                <a href="https://www.instagram.com/hagl_fc/" target="_blank" class="ig">◎</a>
            </div>
        </div>

        <!-- THANH TOÁN -->
        <div class="footer-column">
            <h4 class="title-menu">PHƯƠNG THỨC THANH TOÁN</h4>

            <div class="payment-accept">
                <img src="${pageContext.request.contextPath}/resources/visa.jpg" alt="Visa">
                <img src="${pageContext.request.contextPath}/resources/momo.jpg" alt="MoMo">
                <img src="${pageContext.request.contextPath}/resources/VN_PAY.jpg" alt="VNPay">
                <img src="${pageContext.request.contextPath}/resources/zaloPay.jpg" alt="ZaloPay">
            </div>
        </div>

    </div>

    <div class="footer-bottom">
        © 2025 Sport Store | Bảo lưu mọi quyền | Dành cho người yêu thể thao
    </div>

</footer>