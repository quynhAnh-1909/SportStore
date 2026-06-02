<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="root" value="${pageContext.request.contextPath}"/>

<style>
    /* Custom CSS để khớp hoàn hảo với hệ thống Dashboard hiện tại của bạn */
    .chat-wrapper {
        display: flex;
        height: calc(100vh - 160px); /* Khớp độ cao còn lại của mainContent */
        background: var(--white);
        border-radius: 20px;
        box-shadow: 0 4px 18px rgba(0,0,0,0.06);
        border: 1px solid var(--border);
        overflow: hidden;
    }

    /* Vùng danh sách khách hàng bên trái */
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

    /* Vùng nội dung chat bên phải */
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

    /* Bubble bong bóng tin nhắn */
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

    /* Thanh nhập liệu phía dưới */
    .chat-input-footer {
        padding: 20px 25px;
        background: var(--white);
        border-top: 1px solid var(--border);
        display: flex;
        gap: 12px;
    }
</style>

<div class="container-fluid p-0">
    <h1 class="dashboard-title">
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
    // Khởi tạo đường dẫn API trỏ trực tiếp đến ChatAdminController của bạn
    const ADMIN_API = "${root}/api/chat-admin";
    let activeCustomerId = null;

    // 1. Tải danh sách khách hàng nhắn tin (action=getChatList)
    function fetchChatCustomers() {
        fetch(ADMIN_API + "?action=getChatList")
                .then(res => res.json())
                .then(customers => {
                    const container = document.getElementById("customerContainer");
                    if (customers.length === 0) {
                        container.innerHTML = '<div class="text-center text-muted py-4 small">Chưa có cuộc hội thoại nào.</div>';
                        return;
                    }

                    let html = "";
                    customers.forEach(id => {
                        let activeClass = (id === activeCustomerId) ? "active-chat" : "";
                        // Hiển thị gọn email hoặc chuỗi Guest
                        let shortId = id.length > 22 ? id.substring(0, 20) + "..." : id;

                        html += `
                        <div class="customer-chat-item ${activeClass}" onclick="selectActiveCustomer('${id}')">
                            <div class="avatar-icon"><i class="fas fa-user"></i></div>
                            <div class="text-truncate">
                                <div class="small text-dark fw-bold" title="${id}">${shortId}</div>
                                <div class="text-muted" style="font-size: 12px;">Đang trực tuyến</div>
                            </div>
                        </div>
                    `;
                    });
                    container.innerHTML = html;
                })
                .catch(err => console.error("Lỗi lấy danh sách chat:", err));
    }

    // 2. Click chọn 1 khách hàng cụ thể
    function selectActiveCustomer(id) {
        activeCustomerId = id;
        document.getElementById("currentChatUser").innerHTML = `<i class="fas fa-user-tag text-danger me-2"></i> Hỗ trợ: <strong class="text-dark">${id}</strong>`;

        // Kích hoạt ô nhập liệu
        document.getElementById("messageInput").disabled = false;
        document.getElementById("sendBtn").disabled = false;
        document.getElementById("messageInput").focus();

        // Cập nhật ngay class active trên giao diện trực quan
        fetchConversationDetail();
    }

    // 3. Lấy lịch sử chat chi tiết (action=getDetail)
    function fetchConversationDetail() {
        if (!activeCustomerId) return;

        fetch(ADMIN_API + "?action=getDetail&customerId=" + encodeURIComponent(activeCustomerId))
                .then(res => res.json())
                .then(messages => {
                    const msgContainer = document.getElementById("messagesContainer");
                    let html = "";

                    messages.forEach(msg => {
                        let bubbleClass = (msg.sender === "ADMIN") ? "admin-type" : "customer-type";
                        html += `<div class="chat-bubble ${bubbleClass}">${msg.text}</div>`;
                    });

                    msgContainer.innerHTML = html;
                    // Tự động cuộn khung chat xuống đáy khi có tin nhắn mới đổ về
                    msgContainer.scrollTop = msgContainer.scrollHeight;
                })
                .catch(err => console.error("Lỗi lấy chi tiết chat:", err));
    }

    // 4. Gửi tin nhắn phản hồi (POST)
    function sendAdminMessage() {
        const input = document.getElementById("messageInput");
        const text = input.value.trim();

        if (text === "" || !activeCustomerId) return;

        // Khóa tạm nút gửi để tránh bấm double click spam dữ liệu trùng lặp
        document.getElementById("sendBtn").disabled = true;

        fetch(ADMIN_API, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
            body: `customerId=${encodeURIComponent(activeCustomerId)}&message=${encodeURIComponent(text)}`
        })
                .then(res => res.json())
                .then(result => {
                    if (result.success) {
                        input.value = ""; // Xóa trắng ô nhập sau khi gửi thành công
                        fetchConversationDetail(); // Re-render tin nhắn mới lên màn hình luôn
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

    // 5. POLLING LOOP: Chạy ngầm quét dữ liệu định kỳ mỗi 2 giây để tạo hiệu ứng realtime đồng bộ
    setInterval(() => {
        fetchChatCustomers();
        fetchConversationDetail();
    }, 2000);

    // Chạy kích hoạt nạp danh sách ngay khi vừa load trang
    fetchChatCustomers();
</script>