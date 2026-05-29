<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tra cứu hành trình đơn hàng</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        body {
            background-color: #f8f9fa;
        }

        .text-danger-custom {
            color: #d81f19 !important;
        }

        .btn-danger-custom {
            background-color: #d81f19 !important;
            border-color: #d81f19 !important;
            color: #ffffff !important;
        }

        .btn-danger-custom:hover {
            background-color: #b31410 !important;
            border-color: #b31410 !important;
        }

        .search-card, .result-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
        }

        .result-card {
            display: none;
        }

        .ghn-timeline {
            position: relative;
            padding-left: 35px;
            margin-left: 15px;
            border-left: 3px dashed #e2e8f0;
        }

        .ghn-time-node {
            position: relative;
            padding-bottom: 35px;
        }

        .ghn-time-node:last-child {
            padding-bottom: 0;
        }

        .ghn-time-node::before {
            content: "";
            position: absolute;
            left: -44px;
            top: 4px;
            width: 16px;
            height: 16px;
            border-radius: 50%;
            background-color: #cbd5e1;
            border: 3px solid #fff;
            box-shadow: 0 0 0 3px #cbd5e1;
            transition: all 0.3s ease;
        }

        .ghn-time-node.active::before {
            background-color: #ff6600;
            box-shadow: 0 0 0 5px rgba(255, 102, 0, 0.25);
        }

        .ghn-time-node.active .node-title {
            color: #ff6600;
            font-weight: 700;
        }

        .ghn-time-node.done::before {
            background-color: #10b981;
            box-shadow: 0 0 0 5px rgba(16, 185, 129, 0.25);
        }

        .ghn-time-node.done .node-title {
            color: #10b981;
            font-weight: 600;
        }

        .ghn-time-node.fail::before {
            background-color: #ef4444;
            box-shadow: 0 0 0 5px rgba(239, 68, 68, 0.25);
        }

        .ghn-time-node.fail .node-title {
            color: #ef4444;
            font-weight: 600;
        }

        .node-title {
            font-size: 1.05rem;
            margin-bottom: 4px;
            color: #334155;
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/layout/index.jsp" />

<div class="container my-5 py-4">
    <nav aria-label="breadcrumb" class="mb-2">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/" class="text-danger-custom text-decoration-none"><i class="fas fa-home"></i> Trang chủ</a></li>
            <li class="breadcrumb-item active" aria-current="page"><span class="text-secondary fw-semibold">Tra cứu đơn hàng</span></li>
        </ol>
    </nav>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold mb-0 text-danger-custom"><i class="fas fa-truck-fast me-2"></i>Tra cứu hành trình đơn hàng</h2>
        <a href="${pageContext.request.contextPath}/order-history" class="btn btn-danger-custom fw-bold shadow-sm"><i class="fas fa-history me-2"></i>Lịch sử đơn hàng</a>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-9">
            <div class="card p-4 search-card bg-white mb-4 shadow-sm">
                <p class="text-muted mb-3 small">Vui lòng nhập mã bưu kiện (Ví dụ: ORD...) hoặc Số điện thoại mua hàng để kiểm tra vị trí đơn hàng thời gian thực.</p>
                <div class="input-group input-group-lg shadow-sm rounded">
                    <span class="input-group-text bg-white border-end-0"><i class="fa-solid fa-magnifying-glass text-muted"></i></span>
                    <input type="text" id="keywordInput" class="form-control border-start-0 ps-2 fs-6" placeholder="Nhập mã đơn hàng hoặc số điện thoại của bạn..." onkeypress="if(event.key === 'Enter') performTracking()">
                    <button class="btn btn-danger-custom px-4 fs-6 fw-bold" type="button" id="btnSearch" onclick="performTracking()">Tìm kiếm</button>
                </div>
                <div id="errorMessage" class="text-danger mt-3 small fw-bold"></div>
            </div>

            <div class="card p-4 result-card bg-white shadow-sm" id="resultArea">
                <div class="d-flex justify-content-between align-items-center border-bottom pb-3 mb-4">
                    <div>
                        <h5 class="fw-bold text-dark mb-1">Mã vận đơn: <span id="resOrderId" class="text-primary"></span></h5>
                        <small class="text-muted">Ngày tạo hóa đơn: <span id="resOrderDate"></span></small>
                    </div>
                    <div class="text-end">
                        <span class="text-muted small d-block mb-1">Trạng thái hiện tại:</span>
                        <span class="badge bg-warning text-dark px-3 py-2 fs-6 rounded-pill" id="resStatusBadge"></span>
                    </div>
                </div>

                <div class="row g-3 bg-light p-3 rounded-3 mb-4 mx-1 border">
                    <div class="col-md-6">
                        <span class="text-muted small d-block">Người nhận bưu kiện:</span>
                        <strong id="resReceiverName" class="text-dark"></strong>
                    </div>
                    <div class="col-md-6 text-md-end">
                        <span class="text-muted small d-block">Tổng số tiền thu hộ (COD):</span>
                        <strong id="resTotalPrice" class="text-danger-custom fs-5"></strong>
                    </div>
                </div>

                <h6 class="fw-bold text-secondary text-uppercase mb-4"><i class="fa-solid fa-map-location-dot me-2"></i>Lịch trình vận chuyển chi tiết từ GHN:</h6>

                <div class="ghn-timeline">
                    <div class="ghn-time-node" id="node-delivered">
                        <div class="node-title">Giao hàng thành công 🎉</div>
                        <p class="text-muted small mb-0">Shipper Giao Hàng Nhanh đã phát bưu kiện và thu tiền COD hoàn tất.</p>
                    </div>
                    <div class="ghn-time-node" id="node-shipping">
                        <div class="node-title">Đang vận chuyển / Đi giao 🚚</div>
                        <p class="text-muted small mb-0">Bưu kiện đang nằm trên xe trung chuyển liên tỉnh hoặc bưu tá đang đi phát tới địa chỉ của bạn.</p>
                    </div>
                    <div class="ghn-time-node" id="node-processing">
                        <div class="node-title">Shop đang chuẩn bị hàng / Đang phân loại</div>
                        <p class="text-muted small mb-0">Yêu cầu giao hàng đã được tiếp nhận, bưu kiện đang nằm trong luồng phân loại kho bưu cục GHN.</p>
                    </div>
                    <div class="ghn-time-node" id="node-pending">
                        <div class="node-title">Đơn hàng khởi tạo thành công</div>
                        <p class="text-muted small mb-0">Hóa đơn mua sắm đã được ghi nhận thành công vào cơ sở dữ liệu hệ thống SportStore.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    const CONTEXT_PATH = '${pageContext.request.contextPath}';

    window.addEventListener('DOMContentLoaded', () => {
        const keywordInput = document.getElementById("keywordInput");
        const urlParams = new URLSearchParams(window.location.search);
        const keywordParam = urlParams.get('keyword');
        if (keywordParam && keywordInput) {
            keywordInput.value = keywordParam;
            performTracking();
        }
    });
    function performTracking() {
        let keyword = document.getElementById("keywordInput").value.trim();
        const errorDiv = document.getElementById("errorMessage");
        const resultArea = document.getElementById("resultArea");
        const btnSearch = document.getElementById("btnSearch");

        // Reset trạng thái ban đầu
        errorDiv.innerText = "";

        if (!keyword) {
            errorDiv.innerText = "⚠️ Vui lòng cung cấp mã đơn hàng hoặc số điện thoại của bạn trước!";
            resultArea.style.display = "none";
            return;
        }

        if (keyword.startsWith("#")) keyword = keyword.substring(1);

        // Hiệu ứng xoay vòng lúc bấm nút
        btnSearch.innerHTML = `<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Đang xử lý...`;
        btnSearch.disabled = true;

        fetch(`${CONTEXT_PATH}/api/track-order?keyword=${encodeURIComponent(keyword)}`)
                .then(response => {
                    if (!response.ok) throw new Error("Mã phản hồi từ Server không hợp lệ (" + response.status + ")");
                    return response.json();
                })
                .then(res => {
                    // Trả lại trạng thái nút ban đầu
                    btnSearch.innerHTML = "Tìm kiếm";
                    btnSearch.disabled = false;

                    // Nếu Backend trả về trạng thái lỗi (không tìm thấy đơn, lỗi API GHN...)
                    if (res.status === "error") {
                        resultArea.style.display = "none";
                        errorDiv.innerHTML = `<div class="alert alert-danger shadow-sm py-2 px-3"><i class="fa-solid fa-circle-exclamation me-2"></i>${res.message}</div>`;
                        return;
                    }

                    // Nếu thành công -> Hiện thị vùng dữ liệu và đổ thông tin vào các thẻ
                    resultArea.style.display = "block";
                    document.getElementById("resOrderId").innerText = res.orderId;
                    document.getElementById("resOrderDate").innerText = res.orderDate;
                    document.getElementById("resReceiverName").innerText = res.receiverName;
                    document.getElementById("resTotalPrice").innerText = res.totalPrice;

                    const badge = document.getElementById("resStatusBadge");
                    badge.innerText = res.orderStatus;
                    resetTimelineStyles();

                    const code = res.statusCode;

                    // Đắp class màu sắc dựa theo các đầu mã trạng thái (statusCode)
                    if (code === 4) {
                        setNodeStatus("node-pending", "done");
                        setNodeStatus("node-processing", "done");
                        setNodeStatus("node-shipping", "done");
                        setNodeStatus("node-delivered", "done");
                        badge.className = "badge bg-success text-white px-3 py-2 fs-6 rounded-pill";
                    }
                    else if (code === 5) {
                        setNodeStatus("node-pending", "done");
                        setNodeStatus("node-processing", "fail");
                        setNodeStatus("node-shipping", "fail");
                        setNodeStatus("node-delivered", "fail");
                        badge.className = "badge bg-danger text-white px-3 py-2 fs-6 rounded-pill";
                    }
                    else if (code === 3) {
                        setNodeStatus("node-pending", "done");
                        setNodeStatus("node-processing", "done");
                        setNodeStatus("node-shipping", "active");
                        badge.className = "badge bg-primary text-white px-3 py-2 fs-6 rounded-pill";
                    }
                    else if (code === 2) {
                        setNodeStatus("node-pending", "done");
                        setNodeStatus("node-processing", "active");
                        badge.className = "badge bg-warning text-dark px-3 py-2 fs-6 rounded-pill";
                    }
                    else {
                        setNodeStatus("node-pending", "active");
                        badge.className = "badge bg-secondary text-white px-3 py-2 fs-6 rounded-pill";
                    }
                })
                .catch(err => {
                    btnSearch.innerHTML = "Tìm kiếm";
                    btnSearch.disabled = false;
                    resultArea.style.display = "none";
                    errorDiv.innerHTML = `<div class="alert alert-danger shadow-sm py-2 px-3"><i class="fa-solid fa-triangle-exclamation me-2"></i>Lỗi kết nối: Không thể kết nối tới máy chủ hoặc thiếu thư viện JSON!</div>`;
                    console.error("Lỗi chi tiết:", err);
                });

    }

    function setNodeStatus(nodeId, className) {
        const el = document.getElementById(nodeId);
        if (el) el.classList.add(className);
    }

    function resetTimelineStyles() {
        const nodes = ["node-pending", "node-processing", "node-shipping", "node-delivered"];
        nodes.forEach(id => {
            const el = document.getElementById(id);
            if (el) el.classList.remove("active", "done", "fail");
        });
    }
</script>
</body>
</html>
