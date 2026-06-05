<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>


<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">
    <title>Tài khoản cá nhân</title>
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

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
        .section-title{

            font-size: 22px;

            font-weight: 700;
            color: #d81f19;
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
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/layout/index.jsp" />


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

            <div class="row g-4 align-items-center">


                <div class="col-lg-4">

                    <div class="profile-info-box avatar-wrapper">

                        <img src="${not empty user.avatar
                                ? user.avatar
                                : pageContext.request.contextPath.concat('/resources/default-avatar.png')}"
                             class="avatar"
                             alt="Avatar">

                        <h5 class="mt-3 fw-bold">
                            ${user.fullName}
                        </h5>

                        <p class="text-muted mb-0">
                            ${user.email}
                        </p>

                    </div>

                </div>

                <div class="col-lg-8">

                    <div class="profile-info-box">

                        <h2 class="section-title">
                            Thông tin cá nhân
                        </h2>

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

                                    <label class="info-label">
                                        Email
                                    </label>

                                    <input type="email"
                                           value="${user.email}"
                                           class="form-control"
                                           disabled>

                                    <small class="text-muted">
                                        Email không thể thay đổi
                                    </small>

                                </div>

                            </div>


                            <div class="mb-3">

                                <label class="info-label">
                                    Số điện thoại
                                </label>

                                <input type="text"
                                       id="phoneInput"
                                       name="phone"
                                       value="${user.phoneNumber}"
                                       class="form-control">

                                <div id="phoneError" class="text-danger small mt-1 fw-bold"></div>

                            </div>

                            <div class="mb-4">
                                <label class="info-label">Địa chỉ của bạn</label>
                                <input type="text"
                                       name="address"
                                       value="${sessionScope.user.address}"
                                       class="form-control"
                                       placeholder="Ví dụ: 123 Nguyễn Trãi, Quận 1, TP. Hồ Chí Minh">
                            </div>

                            <div class="mb-4">

                                <label class="info-label">
                                    Ảnh đại diện
                                </label>

                                <input type="file"
                                       name="avatar"
                                       class="form-control">

                            </div>

                            <button type="submit"
                                    class="btn-save">

                                <i class="fas fa-save me-2"></i>
                                Lưu thay đổi

                            </button>
                        </form>

                        <div class="security-box mt-5">

                            <h2 class="section-title">
                                <i class="fas fa-shield-alt me-2"></i>
                                Bảo mật tài khoản
                            </h2>

                            <form action="${pageContext.request.contextPath}/change-password"
                                  method="post">

                                <div class="mb-3">

                                    <label class="info-label">
                                        Mật khẩu hiện tại
                                    </label>

                                    <div class="password-wrapper">

                                        <input type="password"
                                               id="currentPassword"
                                               name="currentPassword"
                                               class="form-control"
                                               required>

                                        <i class="fas fa-eye"
                                           onclick="togglePassword('currentPassword',this)">
                                        </i>

                                    </div>

                                </div>

                                <div class="mb-3">

                                    <label class="info-label">
                                        Mật khẩu mới
                                    </label>

                                    <div class="password-wrapper">

                                        <input type="password"
                                               id="newPassword"
                                               name="newPassword"
                                               class="form-control"
                                               required>

                                        <i class="fas fa-eye"
                                           onclick="togglePassword('newPassword',this)">
                                        </i>

                                    </div>

                                </div>

                                <div class="mb-4">

                                    <label class="info-label">
                                        Xác nhận mật khẩu mới
                                    </label>

                                    <div class="password-wrapper">

                                        <input type="password"
                                               id="confirmPassword"
                                               name="confirmPassword"
                                               class="form-control"
                                               required>

                                        <i class="fas fa-eye"
                                           onclick="togglePassword('confirmPassword', this)">
                                        </i>

                                    </div>

                                </div>

                                <button type="submit" class="btn-password">
                                    <i class="fas fa-key me-2"></i>
                                    Đổi mật khẩu
                                </button>

                            </form>

                        </div>

                        <c:if test="${not empty passwordSuccess}">
                            <script>
                                Swal.fire({
                                    icon: 'success',
                                    title: 'Thành công',
                                    text: '${passwordSuccess}',
                                    confirmButtonColor: '#dc3545'
                                });
                            </script>
                            <c:remove var="passwordSuccess" scope="session"/>
                        </c:if>

                        <c:if test="${not empty passwordError}">
                            <script>
                                Swal.fire({
                                    icon: 'error',
                                    title: 'Lỗi',
                                    text: '${passwordError}',
                                    confirmButtonColor: '#dc3545'
                                });
                            </script>
                            <c:remove var="passwordError" scope="session"/>
                        </c:if>

                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="divider"></div>

    <jsp:include page="/WEB-INF/client/order-history.jsp" />

</div>

<jsp:include page="/footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function validateForm() {

        const phoneInput = document.getElementById("phoneInput") ? document.getElementById("phoneInput").value.trim() : "";
        const errorDiv = document.getElementById("phoneError");

        if (errorDiv) {
            errorDiv.innerText = "";
        }

        if (phoneInput === "") {
            return true;
        }

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

        const input =
                document.getElementById(id);

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
</script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<c:if test="${not empty sessionScope.passwordSuccess}">
    <script>
        Swal.fire({
            icon:'success',
            title:'Thành công',
            text:'${sessionScope.passwordSuccess}',
            confirmButtonColor:'#d81f19'
        });
    </script>
    <c:remove var="passwordSuccess" scope="session"/>
</c:if>

<c:if test="${not empty sessionScope.passwordError}">
    <script>
        Swal.fire({
            icon:'error',
            title:'Lỗi',
            text:'${sessionScope.passwordError}',
            confirmButtonColor:'#d81f19'
        });
    </script>
    <c:remove var="passwordError" scope="session"/>
</c:if>
</body>
</html>