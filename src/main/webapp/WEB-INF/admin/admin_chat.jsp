<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="root" value="${pageContext.request.contextPath}"/>

<style>
    .chat-wrapper {
        display: flex;
        height: calc(100vh - 200px);
        background: var(--white);
        border-radius: 20px;
        box-shadow: 0 4px 18px rgba(0,0,0,0.06);
        border: 1px solid var(--border);
        overflow: hidden;
    }
    .chat-sidebar {
        width: 300px;
        border-right: 1px solid var(--border);
        display: flex;
        flex-direction: column;
        background: #fafafa;
    }
    .chat-sidebar-header {
        padding: 20px;
        background: var(--black);
        color: var(--white);
        font-weight: 700;
        font-size: 16px;
    }
    .customer-list-group {
        flex: 1;
        overflow-y: auto;
    }
    .customer-chat-item {
        padding: 15px 20px;
        border-bottom: 1px solid #f0f0f0;
        cursor: pointer;
        display: flex;
        align-items: center;
        gap: 12px;
        transition: all 0.2s ease;
    }
    .customer-chat-item:hover {
        background: #f1f3f5;
    }
    .customer-chat-item.active-chat {
        background: rgba(216, 31, 25, 0.08);
        border-left: 4px solid var(--main-red);
        font-weight: 600;
    }
    .avatar-icon {
        width: 40px;
        height: 40px;
        background: #e2e8f0;
        color: #4a5568;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 16px;
    }
    .chat-main {
        flex: 1;
        display: flex;
        flex-direction: column;
        background: var(--light-bg);
    }
    .chat-main-header {
        padding: 18px 25px;
        background: var(--white);
        border-bottom: 1px solid var(--border);
        font-weight: 700;
        color: var(--black);
        font-size: 18px;
    }
    .chat-messages-container {
        flex: 1;
        padding: 25px;
        overflow-y: auto;
        display: flex;
        flex-direction: column;
        gap: 12px;
    }
    .chat-bubble {
        max-width: 65%;
        padding: 12px 16px;
        border-radius: 16px;
        font-size: 15px;
        line-height: 1.4;
        word-wrap: break-word;
    }
    .chat-bubble.customer-type {
        background: var(--white);
        color: var(--black);
        align-self: flex-start;
        box-shadow: 0 2px 6px rgba(0,0,0,0.04);
        border-bottom-left-radius: 4px;
    }
    .chat-bubble.admin-type {
        background: var(--main-red);
        color: var(--white);
        align-self: flex-end;
        border-bottom-right-radius: 4px;
        box-shadow: 0 2px 6px rgba(216,31,25,0.2);
    }
    .chat-input-footer {
        padding: 20px 25px;
        background: var(--white);
        border-top: 1px solid var(--border);
        display: flex;
        gap: 12px;
    }
</style>

<div class="container-fluid p-0">
    <h1 class="dashboard-title" style="font-size: 28px; font-weight: 800; color: var(--main-red); margin-bottom: 25px;">
        <i class="fas fa-comments me-2"></i>Tư vấn trực tuyến Realtime
    </h1>

    <div class="chat-wrapper">
        <div class="chat-sidebar">
            <div class="chat-sidebar-header">
                <i class="fas fa-list me-2"></i>Hội thoại gần đây
            </div>
            <div class="customer-list-group" id="customerContainer">
                <div class="text-center text-muted py-4 small">Đang tải danh sách...</div>
            </div>
        </div>

        <div class="chat-main">
            <div class="chat-main-header" id="currentChatUser">
                <span class="text-muted font-monospace" style="font-size: 15px;">Vui lòng chọn một khách hàng để hỗ trợ</span>
            </div>

            <div class="chat-messages-container" id="messagesContainer">
                <div class="text-center text-muted my-auto">
                    <i class="far fa-comment-dots d-block mb-3" style="font-size: 4rem; color: #ccc;"></i>
                    Chọn khách hàng từ danh sách bên trái để xem nội dung tin nhắn.
                </div>
            </div>

            <div class="chat-input-footer">
                <input type="text" id="messageInput" class="form-control" placeholder="Nhập câu trả lời tư vấn..." disabled onkeypress="handleKeyPress(event)">
                <button class="btn btn-danger px-4" id="sendBtn" onclick="sendAdminMessage()" disabled>
                    <i class="fas fa-paper-plane"></i>
                </button>
            </div>
        </div>
    </div>
</div>

<script>
    const ADMIN_API = "${root}/api/chat-admin";
    let activeCustomerId = null;
    let isFirstLoadDetail = false;


    function fetchChatCustomers() {
        fetch(ADMIN_API + "?action=getChatList")
                .then(res => res.json())
                .then(customers => {
                    const container = document.getElementById("customerContainer");
                    if (!customers || customers.length === 0) {
                        container.innerHTML = '<div class="text-center text-muted py-4 small">Chưa có cuộc hội thoại nào.</div>';
                        return;
                    }

                    let html = "";
                    customers.forEach(id => {

                        let activeClass = (id === activeCustomerId) ? "active-chat" : "";
                        let shortId = id.length > 22 ? id.substring(0, 20) + "..." : id;

                        html += '<div class="customer-chat-item ' + activeClass + '" onclick="selectActiveCustomer(\'' + id + '\')">' +
                                '<div class="avatar-icon"><i class="fas fa-user"></i></div>' +
                                '<div class="text-truncate" style="flex: 1;">' +
                                '<div class="small text-dark fw-bold" title="' + id + '">' + shortId + '</div>' +
                                '<div class="text-muted" style="font-size: 12px;">Đang trực tuyến</div>' +
                                '</div>' +
                                '</div>';
                    });
                    container.innerHTML = html;
                })
                .catch(err => console.error("Lỗi lấy danh sách chat:", err));
    }


    function selectActiveCustomer(id) {

        if (activeCustomerId === id) return;

        activeCustomerId = id;
        isFirstLoadDetail = true;

        document.getElementById("currentChatUser").innerHTML = '<i class="fas fa-user-tag text-danger me-2"></i> Hỗ trợ: <strong class="text-dark">' + id + '</strong>';

        document.getElementById("messageInput").disabled = false;
        document.getElementById("sendBtn").disabled = false;
        document.getElementById("messageInput").focus();


        fetchChatCustomers();
        fetchConversationDetail();
    }


    function fetchConversationDetail() {
        if (!activeCustomerId) return;

        fetch(ADMIN_API + "?action=getDetail&customerId=" + encodeURIComponent(activeCustomerId))
                .then(res => res.json())
                .then(messages => {
                    const msgContainer = document.getElementById("messagesContainer");
                    let html = "";

                    if (messages && messages.length > 0) {
                        messages.forEach(msg => {

                            let bubbleClass = (msg.sender && msg.sender.toUpperCase() === "ADMIN") ? "admin-type" : "customer-type";
                            html += '<div class="chat-bubble ' + bubbleClass + '">' + msg.text + '</div>';
                        });
                    } else {
                        html = '<div class="text-center text-muted my-auto">Chưa có tin nhắn nào.</div>';
                    }


                    const mangCuonXuong = msgContainer.scrollHeight - msgContainer.scrollTop <= msgContainer.clientHeight + 100;

                    msgContainer.innerHTML = html;


                    if (isFirstLoadDetail || mangCuonXuong) {
                        msgContainer.scrollTop = msgContainer.scrollHeight;
                        isFirstLoadDetail = false;
                    }
                })
                .catch(err => console.error("Lỗi lấy chi tiết chat:", err));
    }


    function sendAdminMessage() {
        const input = document.getElementById("messageInput");
        const text = input.value.trim();

        if (text === "" || !activeCustomerId) return;
        document.getElementById("sendBtn").disabled = true;

        fetch(ADMIN_API, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
            body: 'customerId=' + encodeURIComponent(activeCustomerId) + '&message=' + encodeURIComponent(text)
        })
                .then(res => res.json())
                .then(result => {
                    if (result.success) {
                        input.value = "";
                        isFirstLoadDetail = true; // Gửi xong ép cuộn màn hình xuống đáy để xem tin nhắn mới
                        fetchConversationDetail();
                    }
                })
                .catch(err => console.error("Lỗi gửi tin nhắn:", err))
                .finally(() => {
                    document.getElementById("sendBtn").disabled = false;
                });
    }

    function handleKeyPress(event) {
        if (event.key === 'Enter') {
            sendAdminMessage();
        }
    }


    setInterval(() => {
        fetchChatCustomers();
        if (activeCustomerId) {
            fetchConversationDetail();
        }
    }, 2500);


    fetchChatCustomers();
</script>