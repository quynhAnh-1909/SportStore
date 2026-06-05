<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="root" value="${pageContext.request.contextPath}" />

<style>
    .bot-chat-container {
        position: fixed;
        bottom: 20px;
        right: 20px;
        z-index: 99999;
        font-family: 'Segoe UI', Roboto, sans-serif;
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
        text-decoration: none;
    }
    .chat-btn-circle:hover {
        transform: scale(1.08) translateY(-2px);
    }
    .zalo-btn {
        background: #0068ff;
        color: white;
        font-weight: bold;
        font-size: 13px;
        text-align: center;
        line-height: 55px;
    }
    .bot-chat-bubble {
        background: #d81f19;
        color: white;
        font-size: 24px;
    }
    .bot-chat-window {
        width: 340px;
        height: 450px;
        background: #ffffff;
        border-radius: 16px;
        box-shadow: 0 8px 30px rgba(0, 0, 0, 0.15);
        display: none;
        flex-direction: column;
        overflow: hidden;
        border: 1px solid rgba(0, 0, 0, 0.05);
        position: absolute;
        bottom: 135px;
        right: 0;
        animation: botChatSlideUp 0.3s ease;
    }
    @keyframes botChatSlideUp {
        from { opacity: 0; transform: translateY(20px); }
        to { opacity: 1; transform: translateY(0); }
    }
    .bot-chat-header {
        background: #d81f19;
        color: white;
        padding: 14px 16px;
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
    }
    .bot-chat-header .close-bot-chat:hover {
        opacity: 1;
    }
    .bot-chat-messages {
        flex: 1;
        padding: 15px;
        overflow-y: auto;
        background: #f8f9fa;
        display: flex;
        flex-direction: column;
        gap: 10px;
        scroll-behavior: smooth;
    }
    .bot-msg {
        padding: 10px 14px;
        border-radius: 16px;
        max-width: 85%;
        font-size: 13.5px;
        line-height: 1.45;
        word-wrap: break-word;
    }
    .bot-msg.user-sent {
        background: #d81f19;
        color: white;
        align-self: flex-end;
        border-bottom-right-radius: 4px;
        box-shadow: 0 2px 4px rgba(216, 31, 25, 0.15);
    }
    .bot-msg.bot-reply {
        background: #ffffff;
        color: #333333;
        align-self: flex-start;
        border-bottom-left-radius: 4px;
        box-shadow: 0 2px 6px rgba(0,0,0,0.05);
        border: 1px solid #f0f0f0;
    }
    .bot-chat-input-area {
        display: flex;
        align-items: center;
        padding: 12px;
        background: #ffffff;
        border-top: 1px solid #eeeeee;
    }
    .bot-chat-input-area input {
        flex: 1;
        border: 1px solid #e0e0e0;
        padding: 10px 16px;
        border-radius: 24px;
        outline: none;
        font-size: 13.5px;
        background: #f8f9fa;
        transition: all 0.2s;
    }
    .bot-chat-input-area input:focus {
        border-color: #d81f19;
        background: #ffffff;
        box-shadow: 0 0 0 3px rgba(216, 31, 25, 0.1);
    }
    .bot-chat-input-area button {
        background: none;
        border: none;
        color: #d81f19;
        font-size: 20px;
        margin-left: 10px;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: transform 0.2s;
    }
    .bot-chat-input-area button:hover {
        transform: scale(1.1);
    }
</style>

<div class="bot-chat-container">
    <div class="bot-chat-window" id="botChatWindow">
        <div class="bot-chat-header">
            <span>Cửa Hàng SportStore</span>
            <span class="close-bot-chat" onclick="toggleBotChat()">✕</span>
        </div>
        <div class="bot-chat-messages" id="botChatMessages">
            <div class="bot-msg bot-reply">
                Xin chào! Em là trợ lý tư vấn tự động của SportStore. <br/><br/>
                Anh/Chị có thể gõ các từ khóa sau để được trả lời nhanh nhất:<br/>
                 <b>giá</b>, <b>ship</b>, <b>địa chỉ</b>, <b>đổi trả</b>, <b>khuyến mãi</b>, <b>thanh toán</b>, <b>bảo hành</b>.
            </div>
        </div>
        <div class="bot-chat-input-area">
            <input type="text" id="botChatInput" placeholder="Nhập tin nhắn..." onkeypress="handleBotChatPress(event)"/>
            <button onclick="sendBotMessage()">➔</button>
        </div>
    </div>

    <a href="https://zalo.me/0987735239" target="_blank" class="chat-btn-circle zalo-btn" title="Chat qua Zalo">Zalo</a>
    <div class="chat-btn-circle bot-chat-bubble" onclick="toggleBotChat()" id="botChatBubble" title="Trợ lý tự động">💬</div>
</div>

<script>
    const CHAT_ROOT = "${pageContext.request.contextPath}";
    const loggedUser = "${sessionScope.user.email}";

    const customerId =
            (loggedUser && loggedUser.trim() !== "")
                    ? loggedUser
                    : (localStorage.getItem("chat_guest_id") || "GUEST_" + Date.now());

    if (!loggedUser || loggedUser.trim() === "") {
        localStorage.setItem("chat_guest_id", customerId);
    }

    const botBrain = {
        "hi": "Chào anh/chị! Chúc anh/chị một ngày mua sắm vui vẻ tại SportStore ",
        "hello": "Xin chào! Em có thể hỗ trợ gì cho anh/chị?",
        "giá": "<b>Về giá sản phẩm:</b> Tất cả sản phẩm của SportStore đều được niêm yết công khai trên website kèm giá đã giảm (nếu có). Anh/chị bấm vào từng sản phẩm để chọn size và xem giá chính xác nhé!",
        "ship": "<b>Chính sách giao hàng:</b><br>- FREESHIP toàn quốc cho đơn hàng từ 500.000đ.<br>- Đơn hàng dưới 500.000đ, phí ship đồng giá là 30.000đ.<br>- Thời gian nhận hàng: Nội thành 1-2 ngày, tỉnh thành khác 3-4 ngày.",
        "địa chỉ": "<b>THÔNG TIN HỆ THỐNG SPORTSTORE</b><br>" +
                "▪️ <b>Địa chỉ:</b> 123 Nguyễn Huệ, Quận 1, TP. Hồ Chí Minh.<br>" +
                "▪️ <b>Giờ mở cửa:</b> 08:00 – 22:00 (Tất cả các ngày trong tuần kể cả lễ, Tết).<br>" +
                "▪️ <b>Hotline CSKH:</b> 1900 6886<br>" +
                "▪️ <b>Email liên hệ:</b> support@sportstore.vn<br>" +
                "<i>Cửa hàng tọa lạc tại vị trí trung tâm, có chỗ đỗ xe thuận tiện. Rất hân hạnh được đón tiếp quý khách ghé trải nghiệm sản phẩm!</i>",
        "đổi trả": "<b>Chính sách đổi trả:</b> SportStore hỗ trợ đổi size/đổi mẫu trong vòng 7 ngày kể từ khi nhận hàng. Điều kiện sản phẩm còn nguyên tem mác, chưa qua sử dụng và không bị dơ bẩn.",
        "khuyến mãi": "<b>Chương trình ưu đãi:</b> Hiện tại shop đang có chương trình Tặng voucher giảm 10% cho khách hàng mới và áp dụng giảm giá trực tiếp lên tới 30% cho nhiều mẫu giày thể thao hot nhất tuần này!",
        "thanh toán": "<b>Hình thức thanh toán:</b> Shop hỗ trợ 2 hình thức:<br>1. Thanh toán khi nhận hàng (COD).<br>2. Chuyển khoản ngân hàng qua mã QR (Quét mã nhanh khi đặt hàng).",
        "bảo hành": "🛡<b>Chính sách bảo hành:</b> Toàn bộ sản phẩm chính hãng tại SportStore được bảo hành keo, chỉ và các lỗi từ nhà sản xuất trong vòng 6 tháng. Lỗi 1 đổi 1 trong tháng đầu tiên nếu có lỗi nặng."
    };

    let hiểnThịMessagesSet = new Set();
    let isChatOpenFirstTime = true;

    function toggleBotChat() {
        const chatWindow = document.getElementById("botChatWindow");
        if (chatWindow.style.display === "flex") {
            chatWindow.style.display = "none";
        } else {
            chatWindow.style.display = "flex";
            if (isChatOpenFirstTime) {
                document.getElementById("botChatMessages").innerHTML = "";
                hiểnThịMessagesSet.clear();
                loadWelcomeMessage();
                loadCustomerMessages();
                isChatOpenFirstTime = false;
            } else {

                const box = document.getElementById("botChatMessages");
                box.scrollTop = box.scrollHeight;
            }
        }
    }

    function loadWelcomeMessage() {
        const box = document.getElementById("botChatMessages");
        const welcome = document.createElement("div");
        welcome.className = "bot-msg bot-reply";
        welcome.innerHTML =
                "Xin chào! Em là trợ lý SportStore <br><br>" +
                "Anh/Chị có thể gõ các từ khóa sau để được trả lời nhanh nhất:<br>" +
                " <b>giá</b>, <b>ship</b>, <b>địa chỉ</b>, " +
                "<b>đổi trả</b>, <b>khuyến mãi</b>, " +
                "<b>thanh toán</b>, <b>bảo hành</b>.<br><br>" +
                "<i>Nếu câu hỏi nằm ngoài từ khóa, hệ thống sẽ tự động chuyển tiếp tới nhân viên tư vấn. Vui lòng đợi trong giây lát!</i>";
        box.appendChild(welcome);
    }

    function handleBotChatPress(event) {
        if (event.key === "Enter") {
            sendBotMessage();
        }
    }

    function sendBotMessage() {
        const input = document.getElementById("botChatInput");
        const text = input.value.trim();
        if (text === "") return;

        input.value = "";


        appendLocalMessage("customer", text);


        fetch(CHAT_ROOT + "/api/chat-client", {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8" },
            body: "customerId=" + encodeURIComponent(customerId) + "&sender=customer" + "&message=" + encodeURIComponent(text)
        })
                .then(res => res.text())
                .then(() => {

                    let reply = null;
                    const lower = text.toLowerCase().trim();

                    if (lower === "hi" || lower === "hello") {
                        reply = botBrain[lower];
                    } else {
                        for (let key in botBrain) {
                            if (key !== "hi" && key !== "hello" && lower.includes(key)) {
                                reply = botBrain[key];
                                break;
                            }
                        }
                    }

                    if (!reply && (lower.split(/\s+/).includes("hi") || lower.split(/\s+/).includes("hello"))) {
                        reply = botBrain[lower.includes("hello") ? "hello" : "hi"];
                    }


                    if (reply) {
                        setTimeout(() => {
                            appendLocalMessage("admin", reply);


                            fetch(CHAT_ROOT + "/api/chat-client", {
                                method: "POST",
                                headers: { "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8" },
                                body: "customerId=" + encodeURIComponent(customerId) + "&sender=admin&message=" + encodeURIComponent(reply)
                            });
                        }, 600);
                    }
                })
                .catch(err => console.error("Lỗi gửi tin nhắn:", err));
    }

    function loadCustomerMessages() {
        fetch(CHAT_ROOT + "/api/chat-client?customerId=" + encodeURIComponent(customerId))
                .then(res => {
                    if (!res.ok) throw new Error("Lỗi HTTP: " + res.status);
                    return res.json();
                })
                .then(messages => {
                    if (!Array.isArray(messages)) return;

                    const box = document.getElementById("botChatMessages");
                    let hasNewMessage = false;

                    messages.forEach(msg => {
                        const isCustomer = msg.sender && msg.sender.toLowerCase() === "customer";
                        const content = msg.message || msg.text || "";

                        const uniqueKey = msg.id ? "msg_id_" + msg.id : (isCustomer ? "cust_" : "adm_") + content;


                        if (!hiểnThịMessagesSet.has(uniqueKey)) {
                            hiểnThịMessagesSet.add(uniqueKey);

                            const div = document.createElement("div");
                            div.className = "bot-msg " + (isCustomer ? "user-sent" : "bot-reply");

                            if (isCustomer) {
                                div.textContent = content;
                            } else {
                                div.innerHTML = content;
                            }
                            box.appendChild(div);
                            hasNewMessage = true;
                        }
                    });


                    if (hasNewMessage) {
                        box.scrollTop = box.scrollHeight;
                    }
                })
                .catch(err => console.error("Lỗi đồng bộ tin nhắn ngầm:", err));
    }
    function appendLocalMessage(role, text) {
        if (!text) return;
        const box = document.getElementById("botChatMessages");

        const uniqueKey = (role === "customer" ? "cust_" : "adm_") + text;
        if (hiểnThịMessagesSet.has(uniqueKey)) return;
        hiểnThịMessagesSet.add(uniqueKey);

        const div = document.createElement("div");
        div.className = "bot-msg " + (role === "customer" ? "user-sent" : "bot-reply");

        if (role === "customer") {
            div.textContent = text;
        } else {
            div.innerHTML = text;
        }

        box.appendChild(div);
        box.scrollTop = box.scrollHeight;
    }


    setInterval(() => {
        loadCustomerMessages();
    }, 3000);
</script>