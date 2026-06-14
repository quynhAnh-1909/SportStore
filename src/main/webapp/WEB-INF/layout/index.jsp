<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="root" value="${pageContext.request.contextPath}" />

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

<style>
    .top-bar .container {

        display:flex;
        align-items:center;
        padding:0 25px;
        height:70px;
        gap:20px;
    }


    .logo {

        display:flex;
        align-items:center;
        gap:10px;
        min-width:180px;

    }

    .logo img {
        height:60px;

    }

    .logo-text {
        font-size:22px;
        font-weight:bold;
        color:white;

    }
    .search-bar {
        flex:1;
        max-width:500px;
        position:relative;

    }

    .search-bar button {

        position:absolute;
        right:5px;
        top:50%;
        transform:translateY(-50%);
        border:none;
        background:#b71c1c;
        color:white;
        padding:6px 10px;
        border-radius:50%;

    }

    .user-actions {
        display:flex;
        gap:18px;
        align-items:center;
        margin-left:auto;

    }

    .cart {
        font-size:24px;

    }

    .account {

        background:white;
        color:#d81f19;
        padding:7px 14px;
        border-radius:20px;
        font-weight:600;

    }
    .user-actions a {
        color:white;
        text-decoration:none;

    }


    .dropdown {

        position: relative;

    }

    .dropdown-menu {

        display: none;
        position: absolute;
        top: 120%;
        left: 0;
        min-width: 220px;
        background: white;
        border-radius: 12px;
        padding: 10px 0;
        box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        z-index: 9999;
        border: none;

    }


    .dropdown:hover .dropdown-menu {

        display: block;

    }


    .dropdown-menu a {
        display: block;
        padding: 12px 18px;
        color: #333 !important;
        text-decoration: none;
        font-weight: 500;
        transition: 0.2s;

    }

    .dropdown-menu a:hover {
        background: #f5f5f5 !important;
        color: #d81f19 !important;

    }


    .nav-links > a,
    .dropdown > a
    {

        color:white;
        text-decoration:none;
        font-weight:600;
        padding:8px 14px;
        border-radius:20px;
        transition:0.25s;

    }

    .nav-links > a:hover,
    .dropdown > a:hover
    {

        background:white;
        color:#d81f19;

    }

    .nav-links {
        display:flex;
        align-items:center;
        gap:15px;

    }

    .nav-links a {

        color:white;
        text-decoration:none;
        font-weight:600;
        padding:8px 14px;
        border-radius:20px;
        transition:0.3s;

    }

    .nav-links a:hover {

        background:white;
        color:#d81f19;

    }
    .top-bar {

        background:#d81f19;
        color:white;
        position:sticky;
        top:0;
        z-index:950;
        box-shadow:0 2px 10px rgba(0,0,0,0.2);

    }

    .search-bar input {

        width:100%;
        padding:10px 45px 10px 20px;
        border-radius:30px;
        border:none;
        font-size:14px;

    }

    .badge {

        background:yellow;
        color:black;
        border-radius:50%;
        padding:3px 7px;
        font-size:12px;

    }

    .cart-wrapper {
        position: relative;
        font-size:24px;
        color:white;
        text-decoration:none;
        cursor:pointer;
    }


    .cart-badge {

        position:absolute;
        top:-5px;
        right:-8px;

        background:yellow;
        color:black;

        font-size:11px;
        font-weight:bold;

        padding:2px 6px;

        border-radius:50%;

        min-width:18px;

        text-align:center;

        border:2px solid #d81f19;

        animation:pop 0.3s ease;
    }

    @keyframes pop {

        0% { transform: scale(0.5); }

        100% { transform: scale(1); }

    }


    .cart-dropdown {

        position: absolute;
        top: 120%;
        right: 0;
        width: 300px;
        background: white;
        border-radius: 10px;
        box-shadow: 0 8px 25px rgba(0,0,0,0.2);
        display: none;
        padding: 10px;
        z-index: 999;

    }


    .cart-item {
        display: flex;
        gap: 10px;
        margin-bottom: 10px;

    }

    .cart-item img {
        width: 50px;
        height: 50px;
        object-fit: cover;

    }

    .cart-item-name {
        font-size: 13px;

    }

    .cart-item-price {
        color: red;
        font-weight: bold;
        font-size: 13px;

    }

    .cart-footer {

        border-top: 1px solid #eee;
        padding-top: 10px;

    }

    .cart-wrapper:hover .cart-dropdown {
        display: block;

    }

    .suggestion-item {
        display: flex;
        align-items: center;
        color:#333;
        gap: 12px;
        padding: 12px;
        cursor: pointer;
        border-bottom: 1px solid #eee;
        transition: 0.2s;
        overflow: hidden;

    }

    .suggestion-img {

        width: 55px !important;
        height: 55px !important;
        min-width: 55px;
        min-height: 55px;
        object-fit: contain !important;
        border-radius: 8px;
        background: #fafafa;
        display: block;
        flex-shrink: 0;

    }
    .suggestion-info {

        flex: 1;

    }

    .suggestion-name {

        font-size: 14px;
        color: #333;

    }

    .suggestion-price {

        color: #d81f19;
        font-weight: bold;
        margin-top: 4px;
        font-size: 13px;

    }

    .search-suggestions img {

        width: 55px !important;
        height: 55px !important;
        object-fit: contain !important;

    }

    .cart-item-image{

        width:50px;
        height:50px;
        object-fit:cover;
        border-radius:8px;

    }
    .bot-chat-container {
        position: fixed;
        bottom: 20px;
        right: 20px;
        z-index: 99999;
        font-family: 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
        display: flex;
        flex-direction: column;
        align-items: flex-end;
        gap: 12px;
    }


    .chat-btn-circle {
        width: 55px;
        height: 55px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        box-shadow: 0 4px 16px rgba(0, 0, 0, 0.2);
        transition: all 0.3s ease;
    }

    .chat-btn-circle:hover {
        transform: scale(1.08) translateY(-2px);
    }


    .zalo-btn {
        background: #0068ff;
        color: white;
        text-decoration: none;
        font-weight: bold;
        font-size: 13px;
    }


    .bot-chat-bubble {
        background: #d81f19;
        color: white;
        font-size: 24px;
        margin-left: auto;
    }

    .bot-chat-bubble:hover {
        box-shadow: 0 6px 20px rgba(216, 31, 25, 0.4);
    }


    .bot-chat-window {
        width: 330px;
        height: 430px;
        background: #ffffff;
        border-radius: 16px;
        box-shadow: 0 8px 30px rgba(0, 0, 0, 0.15);
        display: none;
        flex-direction: column;
        overflow: hidden;
        border: 1px solid rgba(0, 0, 0, 0.05);
        animation: botChatSlideUp 0.3s ease;
        position: absolute;
        bottom: 135px;
        right: 0;
    }

    @keyframes botChatSlideUp {
        from { opacity: 0; transform: translateY(20px); }
        to { opacity: 1; transform: translateY(0); }
    }


    .bot-chat-header {
        background: #d81f19;
        color: white;
        padding: 12px 16px;
        font-weight: 600;
        font-size: 15px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .bot-chat-header .close-bot-chat {
        cursor: pointer;
        opacity: 0.8;
        font-size: 18px;
        transition: 0.2s;
    }
    .bot-chat-header .close-bot-chat:hover { opacity: 1; }


    .bot-chat-messages {
        flex: 1;
        padding: 15px;
        overflow-y: auto;
        background: #f8f9fa;
        display: flex;
        flex-direction: column;
        gap: 8px;
    }


    .bot-msg {
        padding: 8px 14px;
        border-radius: 14px;
        max-width: 80%;
        font-size: 13px;
        line-height: 1.4;
        word-wrap: break-word;
    }
    .bot-msg.user-sent {
        background: #d81f19;
        color: white;
        align-self: flex-end;
        border-bottom-right-radius: 4px;
    }
    .bot-msg.bot-reply {
        background: #ffffff;
        color: #333333;
        align-self: flex-start;
        border-bottom-left-radius: 4px;
        box-shadow: 0 2px 5px rgba(0,0,0,0.05);
    }


    .bot-chat-input-area {
        display: flex;
        align-items: center;
        padding: 10px 12px;
        background: #ffffff;
        border-top: 1px solid #eeeeee;
    }

    .bot-chat-input-area input {
        flex: 1;
        border: 1px solid #e0e0e0;
        padding: 8px 14px;
        border-radius: 20px;
        outline: none;
        font-size: 13px;
        background: #f8f9fa;
        transition: 0.2s;
    }

    .bot-chat-input-area input:focus {
        border-color: #d81f19;
        background: #ffffff;
    }

    .bot-chat-input-area button {
        background: none;
        border: none;
        color: #d81f19;
        font-size: 18px;
        margin-left: 8px;
        cursor: pointer;
        transition: 0.2s;
    }




    .search-history-box{
        position: absolute;
        top: 58px;
        left: 0;
        width: 100%;

        background: white;
        border-radius: 14px;

        box-shadow:
                0 8px 24px rgba(0,0,0,0.12);

        overflow: hidden;

        z-index: 9999;

        display: none;

        animation: fadeDropdown .18s ease;
    }

    .search-suggestions{

        position:absolute;

        top:58px;

        left:0;

        width:100%;

        background:white;

        border-radius:14px;

        box-shadow:0 8px 24px rgba(0,0,0,.12);

        z-index:9999;

        display:none;

        overflow:hidden;
    }

    .history-icon{
        width: 34px;
        height: 34px;

        display: flex;
        align-items: center;
        justify-content: center;

        background: #f1f3f5;

        border-radius: 50%;

        font-size: 15px;

        flex-shrink: 0;
    }


    .history-header{
        display: flex;
        justify-content: space-between;
        align-items: center;

        padding: 14px 18px;

        background: #fafafa;

        border-bottom: 1px solid #eee;
    }

    .history-header span:first-child{
        font-size: 14px;
        color: #666;
        font-weight: 600;
    }


    .clear-history{
        color: #e53935;
        font-weight: 600;
        cursor: pointer;
        transition: 0.2s;
    }

    .clear-history:hover{
        transform: scale(1.05);
    }



    .history-item{
        display: flex;
        align-items: center;
        gap: 12px;

        padding: 14px 18px;

        cursor: pointer;

        border-bottom: 1px solid #f3f3f3;

        transition: all .18s ease;
    }

    .history-item:hover{
        background: #f8f9fa;
        padding-left: 22px;
    }

    .history-text{
        font-size: 15px;
        color: #333;

        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;

        flex: 1;
    }

    .suggestion-item:hover{
        background:#f5f5f5;
    }

    .icon{

        margin-right:10px;

    }

    .keyword{

        color:black !important;

        font-size:16px !important;

        display:inline !important;
    }

    .history-arrow{
        color: #bbb;
        font-size: 14px;
    }

    @keyframes fadeDropdown{
        from{
            opacity:0;
            transform: translateY(-8px);
        }

        to{
            opacity:1;
            transform: translateY(0);
        }
    }

    .search-bar{
        flex:1;
        max-width:500px;
        position:relative;
    }


    .notification-bell .dropdown-toggle::after {
        display: none !important;
    }
    .noti-item {
        border-bottom: 1px solid #f8f9fa;
        transition: background-color 0.2s;
        padding: 12px 16px;
        display: block;
        color: #333 !important;
        text-decoration: none !important;
        text-align: left;
    }
    .noti-item:hover {
        background-color: #f1f3f5 !important;
    }
    .noti-item.unread {
        background-color: #edf2fa !important;
    }
    .noti-item.unread:hover {
        background-color: #e2ebf9 !important;
    }
</style>
<jsp:include page="/WEB-INF/layout/auth.jsp"/>

<div class="top-bar">

    <div class="container">

        <div class="logo">

            <a href="${root}/products">

                <img src="${root}/resources/sport_store.jpg">

            </a>

            <span class="logo-text">SportStore</span>

        </div>

        <form class="search-bar"
              id="searchForm"
              action="${root}/products"
              method="get">

            <input
                    type="text"
                    id="searchInput"
                    name="keyword"
                    placeholder="Tìm kiếm sản phẩm..."
                    autocomplete="off">

            <button type="submit"
                    id="searchBtn">

                🔍

            </button>

            <div id="searchSuggestions"
                 class="search-suggestions"></div>

            <div id="searchHistory"
                 class="search-history-box"></div>

        </form>

        <div class="nav-links">
            <a href="${root}/products">Trang chủ</a>
            <div class="dropdown">
                <a href="${root}/promotions">Khuyến mãi</a>
            </div>
            <div class="dropdown">
                <a href="#">Thành viên</a>
            </div>
        </div>

        <div class="user-actions">
            <c:set var="cartCount" value="0"/>
            <c:if test="${not empty sessionScope.cart}">
                <c:forEach var="item" items="${sessionScope.cart}">
                    <c:set var="cartCount" value="${cartCount + item.quantity}"/>
                </c:forEach>
            </c:if>
            <div class="cart-wrapper">
                <a href="${root}/cart" class="cart-icon">🛒</a>
                <span class="cart-badge" style="${cartCount == 0 ? 'display:none' : ''}">
                    ${cartCount}
                </span>
                <div class="cart-dropdown">
                    <div id="cart-items"></div>
                    <div class="cart-footer">
                        <a href="${root}/cart" class="btn btn-danger w-100">
                            Xem giỏ hàng
                        </a>
                    </div>
                </div>
            </div>

            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <div class="dropdown notification-bell d-inline-block align-middle" style="position: relative; z-index: 1050; cursor: pointer;">
                        <a class="nav-link position-relative p-0 dropdown-toggle" href="#" id="notiDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false" style="display: inline-block; vertical-align: middle;">
                            <i class="fas fa-bell" style="font-size: 22px; color: white; vertical-align: middle;"></i>
                            <span id="noti-badge" class="badge bg-danger position-absolute text-white" style="top: -8px; right: -10px; border-radius: 50%; font-size: 9px; padding: 3px 5px; display: none; min-width: 16px; text-align: center;">0</span>
                        </a>
                        <div class="dropdown-menu dropdown-menu-end" aria-labelledby="notiDropdown" style="width: 340px; max-height: 400px; overflow-y: auto; box-shadow: 0 8px 25px rgba(0,0,0,0.15); border-radius: 12px; border: none; padding: 0; margin-top: 15px;">
                            <div class="dropdown-header d-flex justify-content-between align-items-center" style="border-bottom: 1px solid #eee; padding: 12px 16px; background: #fafafa; border-top-left-radius: 12px; border-top-right-radius: 12px;">
                                <h6 class="m-0 font-weight-bold" style="color: #333; font-size: 14px;">Thông báo cá nhân</h6>
                                <a href="javascript:void(0);" id="mark-all-read" style="font-size: 12px; color: #007bff; font-weight: 600; text-decoration: none;">Đọc tất cả</a>
                            </div>
                            <div id="noti-list-box" style="min-height: 60px;">
                                <p class="text-center text-muted m-0" style="padding: 20px 10px; font-size: 13px;">Đang tải thông báo...</p>
                            </div>
                        </div>
                    </div>

                    <div class="dropdown">
                        <button class="account dropdown-toggle" type="button" id="accountMenu" data-bs-toggle="dropdown" aria-expanded="false">
                            👤 ${sessionScope.user.fullName}
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="accountMenu">
                            <li><a class="dropdown-item" href="${root}/account">Thông tin cá nhân</a></li>
                            <c:if test="${sessionScope.user.role == 'ADMIN'}">
                                <li><a class="dropdown-item" href="${root}/admin/dashboard">⚙️ Trang quản trị</a></li>
                            </c:if>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="${root}/logout">🚪 Đăng xuất</a></li>
                        </ul>
                    </div>
                </c:when>
                <c:otherwise>
                    <a href="#" onclick="openAuth('login')">Đăng nhập</a>
                    <span>/</span>
                    <a href="#" onclick="openAuth('register')">Đăng ký</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
<script>

    const input = document.getElementById("searchInput");

    const form = document.getElementById("searchForm");

    const suggestions =
            document.getElementById("searchSuggestions");

    const historyBox =
            document.getElementById("searchHistory");

    function loadCartDropdown() {
        fetch(ROOT + "/cart?action=get")

                .then(res => res.json())
                .then(data => {
                    const container = document.getElementById("cart-items");

                    if (!container) return;
                    if (data.length === 0) {
                        container.innerHTML = "<div>Giỏ hàng trống</div>";
                        return;
                    }
                    let html = "";
                    data.forEach(item => {
                        html += '<div class="cart-item">' + '<img src="/resources/' + item.image + '" ' + 'class="cart-item-image">' +
                                '<div>' + '<div class="cart-item-name">' + item.name +
                                '</div>' +
                                '<div class="cart-item-price">' + item.price + ' x ' + item.quantity + '</div>' + '</div>' + '</div>';
                    });
                    container.innerHTML = html;
                });

    }
    document.addEventListener("DOMContentLoaded", function () {
        const cart =
                document.querySelector(".cart-wrapper");

        if (cart) {
            cart.addEventListener("mouseenter", loadCartDropdown
            );
        }

    });

    function goToProduct(id){

        const keyword = input.value.trim();

        if(keyword !== ""){
            saveSearchHistory(keyword);
        }

        window.location.href =
                ROOT + "/productDetail?id=" + id;
    }



    function getSearchHistory(){

        return JSON.parse(
                localStorage.getItem("searchHistory")
        ) || [];

    }


    function saveSearchHistory(keyword){

        keyword = keyword.trim();


        if(keyword === ""){
            return;
        }

        let history = getSearchHistory();


        history = history.filter(item =>
                item.trim() !== ""
        );


        history = history.filter(item =>
                item !== keyword
        );

        history.unshift(keyword);

        history = history.slice(0,5);

        localStorage.setItem(
                "searchHistory",
                JSON.stringify(history)
        );
    }


    function showSearchHistory(){

        suggestions.style.display = "none";

        const history =
                getSearchHistory().filter(item =>
                        item.trim() !== ""
                );

        if(history.length === 0){

            historyBox.style.display = "none";

            return;
        }

        let html = `
    <div class="history-header">

        <span>Lịch sử tìm kiếm</span>

        <span class="clear-history"
              onclick="clearSearchHistory()">

            Xóa

        </span>

    </div>
`;

        history.forEach(function(item){

            html +=
                    '<div class="history-item" onclick="selectHistory(\'' + item + '\')">' +

                    '<div class="history-icon">🕘</div>' +

                    '<div class="history-text">' +
                    item +
                    '</div>' +

                    '<div class="history-arrow">›</div>' +

                    '</div>';
        });

        historyBox.innerHTML = html;
        console.log("AFTER INSERT =", historyBox.innerHTML);
        historyBox.style.display = "block";
    }



    function selectHistory(keyword){

        input.value = keyword;

        saveSearchHistory(keyword);

        form.submit();
    }



    function clearSearchHistory(){

        localStorage.removeItem("searchHistory");

        historyBox.style.display = "none";
    }



    input.addEventListener("focus", function(){

        if(this.value.trim() === ""){

            showSearchHistory();
        }

    });

    form.addEventListener("submit", function(){

        const keyword = input.value.trim();

        if(keyword !== ""){

            saveSearchHistory(keyword);
        }

    });



    document.addEventListener("click", function(e){

        if(!form.contains(e.target)){

            suggestions.style.display = "none";

            historyBox.style.display = "none";
        }

    });

    let typingTimer;
    input.addEventListener("input", function(){

        clearTimeout(typingTimer);

        const keyword = this.value.trim();

        typingTimer = setTimeout(() => {

            if(keyword === ""){

                suggestions.style.display = "none";

                showSearchHistory();

                return;
            }

            fetch(
                    ROOT +
                    "/searchSuggestion?keyword=" +
                    encodeURIComponent(keyword)
            )
                    .then(res => res.text())
                    .then(data => {

                        historyBox.style.display = "none";

                        if(data.trim() !== ""){

                            suggestions.innerHTML = data;

                            suggestions.style.display = "block";

                        } else {

                            suggestions.style.display = "none";
                        }
                    });

        },300);
    });
</script>


<div class="bot-chat-container">
    <div class="bot-chat-window" id="botChatWindow">
        <div class="bot-chat-header">
            <span>Cửa Hàng SportStore </span>
            <span class="close-bot-chat" onclick="toggleBotChat()">✕</span>
        </div>
        <div class="bot-chat-messages" id="botChatMessages">
            <div class="bot-msg bot-reply">
                Xin chào! Em là trợ lý tư vấn tự động của SportStore. 🌸<br><br>
                Anh/Chị có thể gõ các từ khóa sau để được trả lời nhanh nhất:<br>
                👉 <b>giá</b>, <b>ship</b>, <b>địa chỉ</b>, <b>đổi trả</b>, <b>khuyến mãi</b>, <b>thanh toán</b>, <b>bảo hành</b>.
            </div>
        </div>
        <div class="bot-chat-input-area">
            <input type="text" id="botChatInput" placeholder="Nhập tin nhắn..." onkeypress="handleBotChatPress(event)">
            <button onclick="sendBotMessage()">➔</button>
        </div>
    </div>

    <a href="https://zalo.me/0987735239" target="_blank" class="chat-btn-circle zalo-btn" title="Chat qua Zalo">
        Zalo
    </a>

    <div class="chat-btn-circle bot-chat-bubble" onclick="toggleBotChat()" id="botChatBubble" title="Trợ lý tự động">💬</div>
</div>

<script>
    const botBrain = {
        "hi": "Chào anh/chị! Chúc anh/chị một ngày mua sắm vui vẻ tại SportStore. 🥰",
        "hello": "Xin chào! Em có thể giúp gì cho anh/chị ạ?",

        "giá": "💰 <b>Về giá sản phẩm:</b> Tất cả sản phẩm của SportStore đều được niêm yết công khai trên website kèm giá đã giảm (nếu có). Anh/chị bấm vào từng sản phẩm để chọn size và xem giá chính xác nhé!",

        "ship": "🚚 <b>Chính sách giao hàng:</b><br>- FREESHIP toàn quốc cho đơn hàng từ 500.000đ.<br>- Đơn hàng dưới 500.000đ, phí ship đồng giá là 30.000đ.<br>- Thời gian nhận hàng: Nội thành 1-2 ngày, tỉnh thành khác 3-4 ngày.",

        "địa chỉ": "📍 <b>Địa chỉ hệ thống:</b><br>- Cửa hàng: Quận 1, TP. Hồ Chí Minh.<br>⏰ Giờ mở cửa: 8:00 - 22:00 (Tất cả các ngày trong tuần kể cả lễ, Tết).",

        "đổi trả": "🔄 <b>Chính sách đổi trả:</b> SportStore hỗ trợ đổi size/đổi mẫu trong vòng 7 ngày kể từ khi nhận hàng. Điều kiện sản phẩm còn nguyên tem mác, chưa qua sử dụng và không bị dơ bẩn.",

        "khuyến mãi": "🎁 <b>Chương trình ưu đãi:</b> Hiện tại shop đang có chương trình Tặng voucher giảm 10% cho khách hàng mới và áp dụng giảm giá trực tiếp lên tới 30% cho nhiều mẫu giày thể thao hot nhất tuần này!",

        "thanh toán": "💳 <b>Hình thức thanh toán:</b> Shop hỗ trợ 2 hình thức:<br>1. Thanh toán khi nhận hàng (COD).<br>2. Chuyển khoản ngân hàng qua mã QR (Quét mã nhanh khi đặt hàng).",

        "bảo hành": "🛡️ <b>Chính sách bảo hành:</b> Toàn bộ sản phẩm chính hãng tại SportStore được bảo hành keo, chỉ và các lỗi từ nhà sản xuất trong vòng 6 tháng. Lỗi 1 đổi 1 trong tháng đầu tiên nếu có lỗi nặng.",

        "liên hệ": "📞 <b>Hỗ trợ trực tiếp:</b> Nếu cần gặp nhân viên hỗ trợ ngay lập tức, anh/chị vui lòng gọi vào hotline: <b>1900.xxxx</b> hoặc click vào nút <b>Zalo</b> ngay phía trên bong bóng chat này nha!"
    };

    function toggleBotChat() {
        const win = document.getElementById("botChatWindow");
        if (win.style.display === "none" || win.style.display === "") {
            win.style.display = "flex";
        } else {
            win.style.display = "none";
        }
    }

    function sendBotMessage() {
        const chatInput = document.getElementById("botChatInput");
        const userText = chatInput.value.trim();
        if (userText === "") return;

        appendBotMessage(userText, "user-sent");
        chatInput.value = "";

        const lowerText = userText.toLowerCase();
        let replyText = "Dạ, từ khóa này nằm ngoài danh mục trả lời tự động của em mất rồi. Anh/chị có thể click nút <b>Zalo</b> ngay phía trên để nhắn tin trực tiếp cho nhân viên tư vấn của shop nhé! 🥰";

        for (let key in botBrain) {
            if (lowerText.includes(key)) {
                replyText = botBrain[key];
                break;
            }
        }

        setTimeout(function() {
            appendBotMessage(replyText, "bot-reply");
        }, 700);
    }

    function handleBotChatPress(e) {
        if (e.key === 'Enter') {
            sendBotMessage();
        }
    }

    function appendBotMessage(text, type) {
        const msgDiv = document.getElementById("botChatMessages");
        if (!msgDiv) return;
        const newMsg = document.createElement("div");
        newMsg.className = `bot-msg ${type}`;
        newMsg.innerHTML = text;
        msgDiv.appendChild(newMsg);
        msgDiv.scrollTop = msgDiv.scrollHeight;
    }
</script>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $(document).ready(function() {

        if ($("#notiDropdown").length > 0) {
            loadNotifications();


            setInterval(loadNotifications, 30000);
        }

        function loadNotifications() {
            $.ajax({
                url: "${pageContext.request.contextPath}/notifications?action=list",
                type: "GET",
                dataType: "json",
                success: function(data) {
                    var html = "";
                    var unreadCount = 0;

                    if (data && data.length > 0) {
                        $.each(data, function(index, noti) {
                            if (!noti.isRead) {
                                unreadCount++;
                            }

                            var unreadClass = noti.isRead ? "" : "unread";


                            var itemLink = "javascript:void(0);";
                            if (noti.linkUrl && noti.linkUrl !== "#") {
                                if (noti.linkUrl.startsWith("${pageContext.request.contextPath}")) {
                                    itemLink = noti.linkUrl;
                                } else {
                                    itemLink = "${pageContext.request.contextPath}" + noti.linkUrl;
                                }
                            }

                            html += '<a href="' + itemLink + '" class="noti-item ' + unreadClass + '" data-id="' + noti.id + '">';
                            html += '  <div style="font-weight: 600; font-size: 13.5px; color: #212529; margin-bottom: 2px;">' + noti.title + '</div>';
                            html += '  <div style="font-size: 12.5px; color: #495057; line-height: 1.4;">' + noti.content + '</div>';
                            html += '</a>';
                        });

                        $("#noti-list-box").html(html);
                    } else {
                        $("#noti-list-box").html('<p class="text-center text-muted m-0" style="padding: 20px 10px; font-size: 13px;">Bạn chưa có thông báo nào.</p>');
                    }

                    if (unreadCount > 0) {
                        $("#noti-badge").text(unreadCount).show();
                    } else {
                        $("#noti-badge").hide();
                    }
                },
                error: function() {
                    console.log("Hệ thống thông báo chưa nhận diện được session hoặc Servlet chưa sẵn sàng.");
                }
            });
        }


        $(document).on("click", "#mark-all-read", function(e) {
            e.preventDefault();
            $.ajax({
                url: "${pageContext.request.contextPath}/notifications?action=readAll",
                type: "POST",
                success: function() {
                    loadNotifications();
                }
            });
        });

        $(document).on("click", ".noti-item", function() {
            var notiId = $(this).data("id");
            var $this = $(this);
            if ($this.hasClass("unread")) {
                $.ajax({
                    url: "${pageContext.request.contextPath}/notifications?action=read",
                    type: "POST",
                    data: { id: notiId },
                    success: function() {
                        $this.removeClass("unread");
                        loadNotifications();
                    }
                });
            }
        });
    });
</script>