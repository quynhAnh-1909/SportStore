<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tài khoản cá nhân</title>
    <link class="sheet" rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body{
            background: #f5f6fa;
        }
        .profile-card{
            border: none;
            border-radius: 18px;
            background: white;
            box-shadow: 0 4px 18px rgba(0,0,0,0.05);
            overflow: hidden;
        }
        .profile-header{
            background: linear-gradient(135deg, #d81f19, #ff4d4f);
            padding: 35px;
            color: white;
        }
        .profile-header h2{
            font-weight: 700;
            margin: 0;
        }
        .profile-body{
            padding: 35px;
        }
        .avatar-wrapper{
            text-align: center;
        }
        .avatar{
            width: 160px;
            height: 160px;
            object-fit: cover;
            border-radius: 50%;
            border: 5px solid #fff;
            box-shadow: 0 4px 15px rgba(0,0,0,0.15);
        }
        .info-label{
            font-weight: 600;
            margin-bottom: 6px;
            color: #444;
        }
        .form-control{
            border-radius: 10px;
            padding: 10px 14px;
        }
        .form-control:focus{
            border-color: #d81f19;
            box-shadow: 0 0 0 0.15rem rgba(216,31,25,0.15);
        }
        .btn-save{
            background: #d81f19;
            border: none;
            border-radius: 10px;
            padding: 10px 25px;
            font-weight: 600;
            color: white;
            transition: 0.3s;
        }
        .btn-save:hover{
            background: #b31914;
        }
        .profile-info-box{
            background: #fafafa;
            border-radius: 14px;
            padding: 25px;
            height: 100%;
        }
        .divider{
            border-top: 1px solid #eee;
            margin: 35px 0;
        }
        .btn-password{
            background:#e60000;
            color:white;
            border:none;
            border-radius:12px;
            padding:12px 28px;
            font-weight:600;
            transition:0.3s;
        }
        .btn-password:hover{
            background:#c40000;
            transform:translateY(-2px);
        }
        .password-wrapper{
            position:relative;
        }
        .password-wrapper input{
            padding-right:50px;
        }
        .password-wrapper i{
            position:absolute;
            right:15px;
            top:50%;
            transform:translateY(-50%);
            cursor:pointer;
            color:#777;
            font-size:18px;
        }
        .section-title{
            color:#e60000;
            font-size:24px;
            font-weight:700;
            padding-bottom:10px;
            border-bottom:2px solid #f1f1f1;
            margin-bottom:25px;
        }
        .custom-tabs {
            border-bottom: 2px solid #eee;
        }
        .custom-tabs .nav-link {
            color: #555;
            font-weight: 600;
            font-size: 18px;
            border: none;
            padding: 12px 25px;
            background: none;
            transition: 0.3s;
            position: relative;
        }
        .custom-tabs .nav-link:hover {
            color: #d81f19;
        }
        .custom-tabs .nav-link.active {
            color: #d81f19;
            background: none;
            font-weight: 700;
        }
        .custom-tabs .nav-link.active::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 100%;
            height: 3px;
            background-color: #d81f19;
            border-radius: 3px;
        }

        .badge-tier {
            padding: 6px 14px;
            border-radius: 50px;
            font-weight: 700;
            font-size: 13px;
            text-transform: uppercase;
            display: inline-block;
            box-shadow: 0 3px 10px rgba(0,0,0,0.08);
            margin-top: 8px;
        }
        .tier-dong { background: linear-gradient(135deg, #a770ef, #cf8bf3); color: white; }
        .tier-bac { background: linear-gradient(135deg, #bdc3c7, #2c3e50); color: white; }
        .tier-vang { background: linear-gradient(135deg, #ffe259, #ffa751); color: #5d4037; }
        .tier-kimcuong { background: linear-gradient(135deg, #00c6ff, #0072ff); color: white; }

        .spending-box {
            background: #ffffff;
            border: 1px solid #ebedf0;
            border-radius: 14px;
            padding: 18px;
            margin-top: 20px;
            text-align: left;
        }
        .progress-sm {
            height: 8px;
            border-radius: 10px;
            background-color: #e9ecef;
            overflow: hidden;
        }
        .progress-sm .progress-bar {
            background: linear-gradient(135deg, #d81f19, #ff4d4f);
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/layout/index.jsp" />


<script>
    function toggleLoyaltyContent() {
        console.log("Hàm kích hoạt đã chạy thành công!");
        var contentArea = document.getElementById('loyaltyContentArea');
        if (contentArea) {
            if (contentArea.classList.contains('d-none')) {
                contentArea.classList.remove('d-none');
            } else {
                contentArea.classList.add('d-none');
            }
        } else {
            console.log("Không tìm thấy loyaltyContentArea");
        }
    }
</script>

<div class="container py-5">

    <c:if test="${not empty sessionScope.successMsg}">
        <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm mb-4 rounded-3" role="alert">
            <i class="fas fa-check-circle me-2"></i> ${sessionScope.successMsg}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="successMsg" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.errorMsg}">
        <div class="alert alert-danger alert-dismissible fade show border-0 shadow-sm mb-4 rounded-3" role="alert">
            <i class="fas fa-exclamation-circle me-2"></i> ${sessionScope.errorMsg}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="errorMsg" scope="session"/>
    </c:if>

    <div class="profile-card mb-5">
        <div class="profile-header d-flex justify-content-between align-items-center flex-wrap">
            <div>
                <h2>
                    <i class="fas fa-user-circle me-2"></i>
                    Tài khoản cá nhân
                </h2>
                <p class="mb-0 mt-2 opacity-75">
                    Quản lý thông tin tài khoản của bạn
                </p>
            </div>
        </div>

        <div class="profile-body">
            <div class="row g-4 align-items-start">

                <div class="col-lg-4">
                    <div class="profile-info-box avatar-wrapper d-flex flex-column align-items-center justify-content-center text-center">

                        <div class="position-relative mb-3">
                            <c:choose>
                                <c:when test="${not empty user.avatar and !fn:contains(user.avatar, 'default-avatar.png')}">
                                    <img src="${pageContext.request.contextPath}${user.avatar}"
                                         class="avatar"
                                         alt="Avatar"
                                         onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/resources/default-avatar.png';">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/resources/default-avatar.png"
                                         class="avatar"
                                         alt="Default Avatar">
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <h5 class="mt-2 fw-bold mb-1 text-dark">
                            <c:out value="${user.fullName}" default="Khách hàng" />
                        </h5>
                        <p class="text-muted small mb-3">
                            <c:out value="${user.email}" />
                        </p>

                        <div class="mb-3">
                            <c:choose>
                                <c:when test="${fn:toLowerCase(user.tierName) == 'bạc'}">
                                    <span class="badge-tier tier-bac"><i class="fas fa-medal me-1"></i> Thành viên Bạc</span>
                                </c:when>
                                <c:when test="${fn:toLowerCase(user.tierName) == 'vàng'}">
                                    <span class="badge-tier tier-vang"><i class="fas fa-crown me-1"></i> Thành viên Vàng</span>
                                </c:when>
                                <c:when test="${fn:toLowerCase(user.tierName) == 'kim cương'}">
                                    <span class="badge-tier tier-kimcuong"><i class="fas fa-gem me-1"></i> Thành viên Kim Cương</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge-tier tier-dong"><i class="fas fa-award me-1"></i> Thành viên Đồng</span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="spending-box shadow-sm w-100">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <span class="text-muted small"><i class="fas fa-wallet me-1"></i> Tổng chi tiêu:</span>
                                <strong class="text-danger">
                                    <fmt:formatNumber value="${not empty user.totalSpending ? user.totalSpending : 0}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                </strong>
                            </div>

                            <c:choose>
                                <c:when test="${empty user.loyal || !user.loyal}">
                                    <div class="p-2 mt-3 text-center rounded" style="background-color: #f8f9fa; border: 1px dashed #d81f19;">
                                        <p class="small text-muted mb-2" style="font-size: 12px; line-height: 1.4;">
                                            Trở thành <strong>Khách hàng quen</strong> để nhận đặc quyền tích lũy thăng hạng & giảm giá lên tới 10%!
                                        </p>
                                        <button type="button" class="btn btn-sm btn-danger w-100 fw-bold border-0"
                                                onclick="toggleLoyaltyContent()"
                                                style="background: linear-gradient(135deg, #d81f19, #ff4d4f); border-radius: 8px; padding: 8px 0; position: relative; z-index: 999;">
                                            <i class="fas fa-crown me-1"></i> Tìm Hiểu & Kích Hoạt
                                        </button>
                                    </div>

                                    <div id="loyaltyContentArea" class="d-none mt-3 text-start">
                                        <div class="card card-body border-danger p-3 bg-white shadow-sm" style="border-radius: 12px; font-size: 13px;">
                                            <h6 class="fw-bold text-danger mb-2"><i class="fas fa-gem me-1"></i> Điều kiện & Quyền lợi:</h6>
                                            <p class="text-muted mb-3" style="font-size: 11px; line-height: 1.4;">Hệ thống tự động tính lũy điểm từ tất cả đơn hàng thành công (`COMPLETED`):</p>

                                            <div class="table-responsive mb-3">
                                                <table class="table table-sm table-bordered text-center mb-0" style="font-size: 11px;">
                                                    <thead class="table-dark">
                                                    <tr>
                                                        <th>Hạng</th>
                                                        <th>Mức tích lũy</th>
                                                        <th>Ưu đãi</th>
                                                    </tr>
                                                    </thead>
                                                    <tbody>
                                                    <tr>
                                                        <td class="fw-bold text-secondary">BẠC</td>
                                                        <td>Từ 5M đ</td>
                                                        <td class="text-danger fw-bold">Giảm 2%</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="fw-bold text-warning" style="color:#ffa751 !important;">VÀNG</td>
                                                        <td>Từ 15M đ</td>
                                                        <td class="text-danger fw-bold">Giảm 5%</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="fw-bold text-primary">KIM CƯƠNG</td>
                                                        <td>Từ 40M đ</td>
                                                        <td class="text-danger fw-bold">Giảm 10%</td>
                                                    </tr>
                                                    </tbody>
                                                </table>
                                            </div>

                                            <form action="${pageContext.request.contextPath}/register-loyalty" method="POST" class="m-0">
                                                <button type="submit" class="btn btn-sm btn-success w-100 fw-bold border-0 shadow-sm py-2" style="border-radius: 8px;">
                                                    <i class="fas fa-check-circle me-1"></i> Đồng Ý & Kích Hoạt Ngay
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </c:when>

                                <c:otherwise>
                                    <c:if test="${not empty nextTierProgress}">
                                        <div class="progress progress-sm mb-1 mt-3" style="height: 8px;">
                                            <div class="progress-bar progress-bar-striped progress-bar-animated"
                                                 role="progressbar"
                                                 style="width: ${nextTierProgress}%"
                                                 aria-valuenow="${nextTierProgress}"
                                                 aria-valuemin="0"
                                                 aria-valuemax="100"></div>
                                        </div>
                                        <div class="d-flex justify-content-between" style="font-size: 11px;">
                                            <span class="text-muted">Tiến trình lên hạng</span>
                                            <span class="fw-bold text-dark">${nextTierProgress}%</span>
                                        </div>
                                    </c:if>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <div class="col-lg-8">
                    <div class="profile-info-box">
                        <h2 class="section-title">Thông tin cá nhân</h2>

                        <form action="${pageContext.request.contextPath}/account"
                              method="post"
                              enctype="multipart/form-data"
                              onsubmit="return validateForm()">

                            <input type="hidden" name="action" value="editProfile">

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="info-label">Họ và tên</label>
                                    <input type="text" name="fullName" value="${user.fullName}" class="form-control" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="info-label">Email</label>
                                    <input type="email" value="${user.email}" class="form-control" disabled>
                                    <small class="text-muted">Email không thể thay đổi</small>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="info-label">Số điện thoại</label>
                                <input type="text" id="phoneInput" name="phone" value="${user.phoneNumber}" class="form-control">
                                <div id="phoneError" class="text-danger small mt-1 fw-bold"></div>
                            </div>

                            <div class="mb-4">
                                <label class="info-label">Địa chỉ của bạn</label>
                                <input type="text"
                                       name="address"
                                       value="${user.address}"
                                       class="form-control"
                                       placeholder="Ví dụ: 123 Nguyễn Trãi, Quận 1, TP. Hồ Chí Minh">
                            </div>

                            <div class="mb-4">
                                <label class="info-label">Ảnh đại diện</label>
                                <input type="file" name="avatar" class="form-control">
                            </div>

                            <button type="submit" class="btn-save">
                                <i class="fas fa-save me-2"></i>Lưu thay đổi
                            </button>
                        </form>

                        <div class="security-box mt-5">
                            <h2 class="section-title">
                                <i class="fas fa-shield-alt me-2"></i>Bảo mật tài khoản
                            </h2>

                            <form action="${pageContext.request.contextPath}/change-password" method="post">
                                <div class="mb-3">
                                    <label class="info-label">Mật khẩu hiện tại</label>
                                    <div class="password-wrapper">
                                        <input type="password" id="currentPassword" name="currentPassword" class="form-control" required>
                                        <i class="fas fa-eye" onclick="togglePassword('currentPassword',this)"></i>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label class="info-label">Mật khẩu mới</label>
                                    <div class="password-wrapper">
                                        <input type="password" id="newPassword" name="newPassword" class="form-control" required>
                                        <i class="fas fa-eye" onclick="togglePassword('newPassword',this)"></i>
                                    </div>
                                </div>

                                <div class="mb-4">
                                    <label class="info-label">Xác nhận mật khẩu mới</label>
                                    <div class="password-wrapper">
                                        <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" required>
                                        <i class="fas fa-eye" onclick="togglePassword('confirmPassword', this)"></i>
                                    </div>
                                </div>

                                <button type="submit" class="btn-password">
                                    <i class="fas fa-key me-2"></i>Đổi mật khẩu
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="divider"></div>

    <ul class="nav nav-tabs custom-tabs mb-4" id="accountTabs" role="tablist">
        <li class="nav-item" role="presentation">
            <button class="nav-link active" id="order-tab" data-bs-toggle="tab" data-bs-target="#order-content" type="button" role="tab" aria-controls="order-content" aria-selected="true">
                <i class="fas fa-history me-2"></i>Lịch sử mua hàng
            </button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" id="voucher-tab" data-bs-toggle="tab" data-bs-target="#voucher-content" type="button" role="tab" aria-controls="voucher-content" aria-selected="false">
                <i class="fas fa-ticket-alt me-2"></i>Kho Voucher của tôi
            </button>
        </li>
    </ul>

    <div class="tab-content" id="accountTabsContent">
        <div class="tab-pane fade show active" id="order-content" role="tabpanel" aria-labelledby="order-tab">
            <jsp:include page="/WEB-INF/client/order-history.jsp" />
        </div>
        <div class="tab-pane fade" id="voucher-content" role="tabpanel" aria-labelledby="voucher-tab">
            <jsp:include page="/WEB-INF/client/voucher-wallet.jsp" />
        </div>
    </div>

</div>

<jsp:include page="/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
    function validateForm() {
        const phoneInput = document.getElementById("phoneInput") ? document.getElementById("phoneInput").value.trim() : "";
        const errorDiv = document.getElementById("phoneError");

        if (errorDiv) { errorDiv.innerText = ""; }
        if (phoneInput === "") { return true; }

        const phoneRegex = /^(0[3|5|7|8|9])+([0-9]{8})$/;
        if (!phoneRegex.test(phoneInput)) {
            if (errorDiv) {
                errorDiv.innerText = "Số điện thoại không hợp lệ! Phải gồm 10 chữ số và bắt đầu bằng các đầu số VN (03, 05, 07, 08, 09).";
            }
            return false;
        }
        return true;
    }

    function togglePassword(id, icon){
        const input = document.getElementById(id);
        if(input.type === "password"){
            input.type = "text";
            icon.classList.remove("fa-eye");
            icon.classList.add("fa-eye-slash");
        }else{
            input.type = "password";
            icon.classList.remove("fa-eye-slash");
            icon.classList.add("fa-eye");
        }
    }

    document.getElementById('order-tab').addEventListener('shown.bs.tab', function () {
        const activeSubTab = document.querySelector("#orderTabs .nav-link.active");
        if (activeSubTab && typeof filterTableRows === "function") {
            filterTableRows(activeSubTab.getAttribute("data-filter"));
        }
    });
</script>

<c:if test="${not empty sessionScope.passwordSuccess or not empty passwordSuccess}">
    <script>
        Swal.fire({
            icon:'success',
            title:'Thành công',
            text:'${not empty sessionScope.passwordSuccess ? sessionScope.passwordSuccess : passwordSuccess}',
            confirmButtonColor:'#d81f19'
        });
    </script>
    <c:remove var="passwordSuccess" scope="session"/>
</c:if>

<c:if test="${not empty sessionScope.passwordError or not empty passwordError}">
    <script>
        Swal.fire({
            icon:'error',
            title:'Lỗi',
            text:'${not empty sessionScope.passwordError ? sessionScope.passwordError : passwordError}',
            confirmButtonColor:'#d81f19'
        });
    </script>
    <c:remove var="passwordError" scope="session"/>
</c:if>
</body>
</html>