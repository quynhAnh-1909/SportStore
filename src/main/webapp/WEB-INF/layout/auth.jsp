<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="root" value="${pageContext.request.contextPath}"/>

<style>

    .overlay {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.6);
        display: none;
        justify-content: center;
        align-items: center;
        z-index: 999;
    }

    .auth-box {
        width: 420px;
        background: white;
        border-radius: 12px;
        padding: 30px;
        box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
        position: relative;
        animation: fadeIn .3s ease;
    }

    @keyframes fadeIn {
        from {
            opacity: 0;
            transform: translateY(30px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    .close-btn {
        position: absolute;
        top: 10px;
        right: 15px;
        font-size: 20px;
        cursor: pointer;
        color: #999;
    }

    .close-btn:hover {
        color: #d81f19;
    }

    .auth-box .logo img {
        height: 60px;
        display: block;
        margin: 0 auto 10px;
    }

    .auth-tabs {
        display: flex;
        justify-content: space-around;
        margin-bottom: 20px;
        font-weight: bold;
    }

    .auth-tabs span {
        cursor: pointer;
        padding: 5px 10px;
    }

    .auth-tabs .active {
        color: #d81f19;
        border-bottom: 2px solid #d81f19;
    }

    .form-group {
        margin-bottom: 15px;
    }

    label {
        font-weight: 600;
        font-size: 14px;
    }

    .required {
        color: #d81f19;
    }

    input {
        width: 100%;
        padding: 12px;
        border: 1px solid #ddd;
        border-radius: 6px;
        margin-top: 5px;
        position: relative;
        z-index: 1001;
        background-color: white !important;
    }

    .auth-box {
        z-index: 1000;
    }

    .error {
        color: #d81f19;
        font-size: 13px;
        margin-top: 3px;
    }

    .btn-submit {
        width: 100%;
        padding: 13px;
        background: #d81f19;
        color: white;
        border: none;
        border-radius: 8px;
        font-weight: bold;
        margin-top: 10px;
        cursor: pointer;
    }

    .social-login {
        display: flex;
        gap: 10px;
        margin-top: 20px;
    }

    .social-btn {
        flex: 1;
        padding: 10px;
        border: 1px solid #ddd;
        border-radius: 6px;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        cursor: pointer;
    }

    .social-btn img {
        width: 20px;
    }

    .link {
        text-align: center;
        margin-top: 15px;
    }
</style>


<div class="overlay" id="authOverlay">
    <div class="auth-box">

        <div class="close-btn" onclick="closeAuth()">✖</div>

        <div class="logo">
            <img src="${root}/resources/sport_store.jpg">
        </div>

        <div class="auth-tabs">
            <span id="tabLogin" class="active" onclick="switchTab('login')">Đăng nhập</span>
            <span id="tabRegister" onclick="switchTab('register')">Đăng ký</span>
        </div>

        <!-- LOGIN -->
        <form id="loginForm" action="${root}/login" method="post" onsubmit="return validateLogin()">
            <div class="form-group">
                <label>Email <span class="required">*</span></label>
                <input type="email" name="email" id="loginEmail"
                       value="${oldUser!=null?oldUser.email:''}">
                <div class="error" id="loginEmailError">
                    ${errorMessage != null && activeTab=='login'? errorMessage : ''}
                </div>
            </div>

            <div class="form-group">
                <label>Mật khẩu <span class="required">*</span></label>
                <input type="password" name="password" id="loginPass">
                <div class="error" id="loginPassError"></div>
            </div>

            <button type="submit" class="btn-submit">ĐĂNG NHẬP</button>
        </form>

        <!-- REGISTER -->
        <form id="registerForm" action="${root}/register" method="post"
              onsubmit="return validateRegister()" style="display:none;">

            <div class="form-group">
                <label>Họ tên <span class="required">*</span></label>
                <input type="text" name="hoTen" id="regName"
                       value="${oldUser!=null?oldUser.fullName:''}">
                <div class="error" id="regNameError">
                    ${errorMessage != null && activeTab=='register'? errorMessage : ''}
                </div>
            </div>

            <div class="form-group">
                <label>Email <span class="required">*</span></label>
                <input type="email" name="email" id="regEmail"
                       value="${oldUser!=null?oldUser.email:''}">
                <div class="error" id="regEmailError"></div>
            </div>

            <div class="form-group">
                <label>Mật khẩu <span class="required">*</span></label>
                <input type="password" name="matKhau" id="regPass">
                <div class="error" id="regPassError"></div>
            </div>

            <div class="form-group">
                <label>Số điện thoại</label>
                <input type="text" name="soDienThoai" id="regPhone"
                       value="${oldUser!=null?oldUser.phoneNumber:''}">
                <div class="error" id="regPhoneError"></div>
            </div>

            <button type="submit" class="btn-submit">ĐĂNG KÝ</button>
        </form>

        <!-- SOCIAL -->
        <div class="social-login">
            <div class="social-btn" onclick="location.href='${root}/login-google'">
                <img src="${root}/resources/gg.jpg"> Google
            </div>

            <div class="social-btn" onclick="location.href='${root}/login-facebook'">
                <img src="${root}/resources/fb.jpg"> Facebook
            </div>
        </div>

        <div class="link" id="linkSwitch">
            Chưa có tài khoản?
            <a href="#" onclick="switchTab('register');return false;">Đăng ký</a>
        </div>

    </div>
</div>

<script>
    function openAuth(tab) {
        document.getElementById('authOverlay').style.display = 'flex';
        switchTab(tab);
    }

    function closeAuth() {
        document.getElementById('authOverlay').style.display = 'none';
    }

    function switchTab(type) {
        let login = document.getElementById('loginForm');
        let register = document.getElementById('registerForm');
        let tabLogin = document.getElementById('tabLogin');
        let tabRegister = document.getElementById('tabRegister');
        let link = document.getElementById('linkSwitch');

        if (type === 'login') {
            login.style.display = 'block';
            register.style.display = 'none';
            tabLogin.classList.add('active');
            tabRegister.classList.remove('active');
            link.innerHTML = 'Chưa có tài khoản? <a href="#" onclick="switchTab(\'register\');return false;">Đăng ký</a>';
        } else {
            login.style.display = 'none';
            register.style.display = 'block';
            tabLogin.classList.remove('active');
            tabRegister.classList.add('active');
            link.innerHTML = 'Đã có tài khoản? <a href="#" onclick="switchTab(\'login\');return false;">Đăng nhập</a>';
        }
    }

    function validateLogin() {
        let valid = true;
        document.getElementById("loginEmailError").innerText = "";
        document.getElementById("loginPassError").innerText = "";

        let email = document.getElementById("loginEmail").value.trim();
        let pass = document.getElementById("loginPass").value.trim();
        let emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

        if (email === "") {
            document.getElementById("loginEmailError").innerText = "Vui lòng nhập email";
            valid = false;
        } else if (!emailRegex.test(email)) {
            document.getElementById("loginEmailError").innerText = "Email không hợp lệ";
            valid = false;
        }

        if (pass === "") {
            document.getElementById("loginPassError").innerText = "Vui lòng nhập mật khẩu";
            valid = false;
        }

        return valid;
    }

    function validateRegister() {
        let valid = true;

        document.getElementById("regNameError").innerText = "";
        document.getElementById("regEmailError").innerText = "";
        document.getElementById("regPassError").innerText = "";
        document.getElementById("regPhoneError").innerText = "";

        let name = document.getElementById("regName").value.trim();
        let email = document.getElementById("regEmail").value.trim();
        let pass = document.getElementById("regPass").value.trim();
        let phone = document.getElementById("regPhone").value.trim();

        let emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        let phoneRegex = /^[0-9]{9,12}$/;

        if (name === "") {
            document.getElementById("regNameError").innerText = "Vui lòng nhập họ tên";
            valid = false;
        }

        if (email === "") {
            document.getElementById("regEmailError").innerText = "Vui lòng nhập email";
            valid = false;
        } else if (!emailRegex.test(email)) {
            document.getElementById("regEmailError").innerText = "Email không hợp lệ";
            valid = false;
        }

        if (pass.length < 6) {
            document.getElementById("regPassError").innerText = "Mật khẩu tối thiểu 6 ký tự";
            valid = false;
        }

        if (phone !== "" && !phoneRegex.test(phone)) {
            document.getElementById("regPhoneError").innerText = "Số điện thoại không hợp lệ";
            valid = false;
        }

        return valid;
    }

    <c:if test="${not empty errorMessage}">
    openAuth('${activeTab != null ? activeTab : "login"}');
    </c:if>
</script>