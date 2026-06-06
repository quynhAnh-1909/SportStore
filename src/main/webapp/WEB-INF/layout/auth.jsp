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
        z-index: 1000;
    }

    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(30px); }
        to { opacity: 1; transform: translateY(0); }
    }

    .close-btn {
        position: absolute;
        top: 10px;
        right: 15px;
        font-size: 20px;
        cursor: pointer;
        color: #999;
    }

    .close-btn:hover { color: #d81f19; }

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
        text-align: left;
    }

    label {
        font-weight: 600;
        font-size: 14px;
        display: block;
        margin-bottom: 5px;
    }

    .required { color: #d81f19; }

    input {
        width: 100%;
        padding: 12px;
        border: 1px solid #ddd;
        border-radius: 6px;
        box-sizing: border-box;
        background-color: white !important;
        transition: border-color 0.2s ease, box-shadow 0.2s ease;
    }

    .input-success {
        border-color: #2ed573 !important;
        box-shadow: 0 0 5px rgba(46, 213, 115, 0.3);
    }

    .error {
        color: #d81f19;
        font-size: 13px;
        margin-top: 4px;
    }

    .success-text {
        color: #2ed573;
        font-size: 13px;
        margin-top: 4px;
        font-weight: 500;
    }

    .server-error-msg {
        background-color: #fff5f5;
        border: 1px solid #ebccd1;
        color: #d81f19;
        padding: 12px;
        border-radius: 6px;
        font-size: 13px;
        margin-top: 10px;
        margin-bottom: 10px;
        text-align: center;
        font-weight: 600;
        display: block;
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

    .social-btn img { width: 20px; }

    .link {
        text-align: center;
        margin-top: 15px;
    }

    .password-wrapper {
        position: relative;
    }

    .password-wrapper input {
        padding-right: 40px;
    }

    .toggle-eye {
        position: absolute;
        right: 12px;
        top: 50%;
        transform: translateY(-50%);
        cursor: pointer;
        z-index: 1002;
        font-size: 18px;
        user-select: none;
    }

    .gender-group {
        display: flex;
        gap: 30px;
        margin-top: 5px;
    }

    .gender-option {
        display: flex;
        align-items: center;
    }

    input[type="radio"] {
        width: auto;
        margin-right: 8px;
        cursor: pointer;
    }

    .gender-label {
        font-weight: normal;
        cursor: pointer;
        margin: 0;
    }

    .password-requirements {
        background-color: #f9f9f9;
        padding: 10px 12px;
        border-radius: 6px;
        margin-top: 8px;
        font-size: 12px;
        color: #777;
        border: 1px solid #eee;
    }

    .requirement-item {
        margin-bottom: 3px;
        display: flex;
        align-items: center;
        gap: 5px;
        transition: color 0.2s ease;
    }

    .forgot-password{
        text-align:center;
        margin-top:10px;
    }

    .forgot-password a{
        color:#0d6efd;
        text-decoration:none;
        font-size:14px;
    }

    .forgot-password a:hover{
        text-decoration:underline;
    }


    .req-invalid { color: #ea3838; }
    .req-valid { color: #2ed573; font-weight: 500; }
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

        <form id="loginForm" action="${root}/login" method="post" onsubmit="return validateLogin()">
            <div class="form-group">
                <label>Email <span class="required">*</span></label>
                <input type="email" name="email" id="loginEmail" value="${activeTab == 'login' && oldUser != null ? oldUser.email : ''}">
                <div class="error" id="loginEmailError"></div>
            </div>

            <div class="form-group">
                <label>Mật khẩu <span class="required">*</span></label>
                <div class="password-wrapper">
                    <input type="password" name="password" id="loginPass">
                    <span class="toggle-eye" onclick="togglePassword('loginPass', this)">👁️</span>
                </div>
                <div class="error" id="loginPassError"></div>
            </div>

            <c:if test="${not empty errorMessage && activeTab == 'login'}">
                <div class="server-error-msg">${errorMessage}</div>
            </c:if>

            <button type="submit" class="btn-submit">ĐĂNG NHẬP</button>
            <div class="forgot-password">
                <a href="#"
                   onclick="openForgotModal();return false;">
                    Quên mật khẩu?
                </a>
            </div>
        </form>

        <form id="registerForm" action="${root}/register" method="post" onsubmit="return validateRegister()" style="display:none;">
            <div class="form-group">
                <label>Họ tên <span class="required">*</span></label>
                <input type="text" name="hoTen" id="regName" value="${activeTab == 'register' && oldUser != null ? oldUser.fullName : ''}">
                <div class="error" id="regNameError"></div>
            </div>

            <div class="form-group">
                <label>Email <span class="required">*</span></label>
                <input type="email" name="email" id="regEmail" value="${activeTab == 'register' && oldUser != null ? oldUser.email : ''}">
                <div class="error" id="regEmailError"></div>
            </div>

            <div class="form-group">
                <label>Mật khẩu <span class="required">*</span></label>
                <div class="password-wrapper">
                    <input type="password" name="matKhau" id="regPass" oninput="validatePasswordFormat(this.value); matchConfirmPassword();">
                    <span class="toggle-eye" onclick="togglePassword('regPass', this)">👁️</span>
                </div>

                <div class="password-requirements" id="passRequirementsBlock" style="display: none;">
                    <div class="requirement-item req-invalid" id="reqLength"> Tối thiểu 6 ký tự</div>
                    <div class="requirement-item req-invalid" id="reqUppercase"> Ít nhất 1 chữ hoa (A-Z)</div>
                    <div class="requirement-item req-invalid" id="reqLowercase"> Ít nhất 1 chữ thường (a-z)</div>
                    <div class="requirement-item req-invalid" id="reqNumber">Ít nhất 1 chữ số (0-9)</div>
                    <div class="requirement-item req-invalid" id="reqSpecial">Ít nhất 1 ký tự đặc biệt (@, $, !, ...)}</div>
                </div>

                <div class="error" id="regPassError"></div>
            </div>

            <div class="form-group">
                <label>Xác nhận mật khẩu <span class="required">*</span></label>
                <div class="password-wrapper">
                    <input type="password" id="regConfirmPass" oninput="matchConfirmPassword()">
                    <span class="toggle-eye" onclick="togglePassword('regConfirmPass', this)">👁️</span>
                </div>
                <div id="regConfirmPassError"></div>
            </div>

            <div class="form-group">
                <label>Giới tính <span class="required">*</span></label>
                <div class="gender-group">
                    <div class="gender-option">
                        <input type="radio" name="gioiTinh" id="genderMale" value="Nam" ${activeTab == 'register' && oldUser != null && oldUser.gioiTinh == 'Nam' ? 'checked' : ''}>
                        <label class="gender-label" for="genderMale">Nam</label>
                    </div>
                    <div class="gender-option">
                        <input type="radio" name="gioiTinh" id="genderFemale" value="Nữ" ${activeTab == 'register' && oldUser != null && oldUser.gioiTinh == 'Nữ' ? 'checked' : ''}>
                        <label class="gender-label" for="genderFemale">Nữ</label>
                    </div>
                </div>
                <div class="error" id="regGenderError"></div>
            </div>

            <div class="form-group">
                <label>Số điện thoại</label>
                <input type="text" name="soDienThoai" id="regPhone" oninput="checkPhoneLocation(this)" value="${activeTab == 'register' && oldUser != null ? oldUser.phoneNumber : ''}">
                <div id="regPhoneError"></div>
            </div>

            <c:if test="${not empty errorMessage && activeTab == 'register'}">
                <div class="server-error-msg">${errorMessage}</div>
            </c:if>

            <button type="submit" class="btn-submit">ĐĂNG KÝ</button>
        </form>

        <div class="social-login">
            <div class="social-btn" onclick="location.href='${root}/login-google'">
                <img src="${root}/resources/gg.jpg"> Google
            </div>
            <div class="social-btn" onclick="location.href='${root}/login-facebook'">
                <img src="${root}/resources/fb.jpg"> Facebook
            </div>
        </div>

        <div class="link" id="linkSwitch">
            Chưa có tài khoản? <a href="#" onclick="switchTab('register');return false;">Đăng ký</a>
        </div>
    </div>

</div>

<div class="overlay" id="forgotOverlay">

    <div class="auth-box">

        <div class="close-btn"
             onclick="closeForgotModal()">
            ✖
        </div>

        <h3>Quên mật khẩu</h3>

        <div class="form-group">

            <label>Email</label>

            <input
                    type="email"
                    id="forgotEmail">

        </div>

        <button
                type="button"
                class="btn-submit"
                onclick="sendOTP()">

            Gửi OTP

        </button>

    </div>

</div>

<div class="overlay" id="otpOverlay">

    <div class="auth-box">

        <div class="close-btn"
             onclick="closeOTPModal()">
            ✖
        </div>

        <h2 style="text-align:center">
            Xác nhận OTP
        </h2>

        <div class="form-group">

            <label>Mã OTP</label>

            <input
                    type="text"
                    id="otpCode"
                    placeholder="Nhập mã OTP">

        </div>

        <button
                type="button"
                class="btn-submit"
                onclick="verifyOTP()">

            XÁC NHẬN

        </button>

    </div>

</div>

<div class="overlay" id="resetOverlay">

    <div class="auth-box">

        <div class="close-btn"
             onclick="closeResetModal()">
            ✖
        </div>

        <h2 style="text-align:center">
            Đặt lại mật khẩu
        </h2>

        <div class="form-group">

            <label>Mật khẩu mới</label>

            <input
                    type="password"
                    id="newPassword">

        </div>

        <div class="form-group">

            <label>Xác nhận mật khẩu</label>

            <input
                    type="password"
                    id="confirmPassword">

        </div>

        <button
                type="button"
                class="btn-submit"
                onclick="resetPassword()">

            ĐỔI MẬT KHẨU

        </button>

    </div>

</div>

<script>
    function openAuth(tab) {
        document.getElementById('authOverlay').style.display = 'flex';
        switchTab(tab);
    }

    function closeAuth() {
        document.getElementById('authOverlay').style.display = 'none';
        clearServerErrors();
    }

    function clearServerErrors() {
        let errors = document.querySelectorAll('.server-error-msg');
        errors.forEach(el => el.style.display = 'none');
    }

    function switchTab(type) {
        let login = document.getElementById('loginForm');
        let register = document.getElementById('registerForm');
        let tabLogin = document.getElementById('tabLogin');
        let tabRegister = document.getElementById('tabRegister');
        let link = document.getElementById('linkSwitch');

        clearServerErrors();

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

    function validatePasswordFormat(password) {
        let inputField = document.getElementById("regPass");
        let block = document.getElementById("passRequirementsBlock");

        if (password === "") {
            block.style.display = "none";
            inputField.classList.remove("input-success");
            return;
        }

        block.style.display = "block";

        let hasLength = password.length >= 6;
        let hasUpper = /[A-Z]/.test(password);
        let hasLower = /[a-z]/.test(password);
        let hasNumber = /[0-9]/.test(password);
        let hasSpecial = /[^A-Za-z0-9]/.test(password);

        updateRequirementStatus("reqLength", hasLength, "✓ Tối thiểu 6 ký tự", "Tối thiểu 6 ký tự");
        updateRequirementStatus("reqUppercase", hasUpper, " Có chữ hoa (A-Z)", "Thiếu chữ hoa (A-Z)");
        updateRequirementStatus("reqLowercase", hasLower, " Có chữ thường (a-z)", "Thiếu chữ thường (a-z)");
        updateRequirementStatus("reqNumber", hasNumber, "Có chữ số (0-9)", " Thiếu chữ số (0-9)");
        updateRequirementStatus("reqSpecial", hasSpecial, "Có ký tự đặc biệt", " Thiếu ký tự đặc biệt (@, $, !, ...)");

        if (hasLength && hasUpper && hasLower && hasNumber && hasSpecial) {
            inputField.classList.add("input-success");
        } else {
            inputField.classList.remove("input-success");
        }
    }

    function updateRequirementStatus(elementId, isValid, validText, invalidText) {
        let item = document.getElementById(elementId);
        if (isValid) {
            item.className = "requirement-item req-valid";
            item.innerHTML = validText;
        } else {
            item.className = "requirement-item req-invalid";
            item.innerHTML = invalidText;
        }
    }

    function matchConfirmPassword() {
        let pass = document.getElementById("regPass").value;
        let confirmPass = document.getElementById("regConfirmPass").value;
        let displayArea = document.getElementById("regConfirmPassError");
        let confirmInputField = document.getElementById("regConfirmPass");

        if (confirmPass === "") {
            displayArea.innerHTML = "";
            confirmInputField.classList.remove("input-success");
            return;
        }

        if (pass === confirmPass) {
            displayArea.className = "success-text";
            displayArea.innerHTML = "✓ Mật khẩu chính xác";
            confirmInputField.classList.add("input-success");
        } else {
            displayArea.className = "error";
            displayArea.innerHTML = "✘ Mật khẩu xác nhận không trùng khớp!";
            confirmInputField.classList.remove("input-success");
        }
    }


    function checkPhoneLocation(inputElement) {
        let displayArea = document.getElementById("regPhoneError");
        let rawPhone = inputElement.value.replace(/\D/g, '');

        if (rawPhone.length > 10) {
            rawPhone = rawPhone.substr(0, 10);
        }

        let formattedPhone = "";
        if (rawPhone.length > 0) {
            if (rawPhone.length <= 4) {
                formattedPhone = rawPhone;
            } else if (rawPhone.length <= 7) {
                formattedPhone = rawPhone.substr(0, 4) + " " + rawPhone.substr(4);
            } else {
                formattedPhone = rawPhone.substr(0, 4) + " " + rawPhone.substr(4, 3) + " " + rawPhone.substr(7);
            }
        }
        inputElement.value = formattedPhone;

        if (rawPhone === "") {
            displayArea.innerHTML = "";
            inputElement.classList.remove("input-success");
            return;
        }

        if (rawPhone.length < 10) {
            displayArea.className = "error";
            displayArea.innerText = " Đang nhập... (Cần đủ 10 chữ số)";
            inputElement.classList.remove("input-success");
            return;
        }

        if (rawPhone.length === 10) {
            let uniqueChars = new Set(rawPhone);
            if (uniqueChars.size === 1) {
                displayArea.className = "error";
                displayArea.innerText = "SĐT ảo không hợp lệ (Chuỗi số lặp)!";
                inputElement.classList.remove("input-success");
                return;
            }

            if (rawPhone === "0123456789" || rawPhone === "9876543210") {
                displayArea.className = "error";
                displayArea.innerText = " SĐT ảo không hợp lệ (Chuỗi số liên tiếp)!";
                inputElement.classList.remove("input-success");
                return;
            }

            let carrier = "";
            let prefix3 = rawPhone.substr(0, 3);

            const viettel = ["032", "033", "034", "035", "036", "037", "038", "039", "086", "096", "097", "098"];
            const mobifone = ["070", "076", "077", "078", "079", "089", "090", "093"];
            const vinaphone = ["081", "082", "083", "084", "085", "088", "091", "094"];
            const vietnamobile = ["056", "058", "092"];
            const itel_wintel = ["055", "059", "087"];

            if (viettel.includes(prefix3)) carrier = "Viettel";
            else if (mobifone.includes(prefix3)) carrier = "MobiFone";
            else if (vinaphone.includes(prefix3)) carrier = "VinaPhone";
            else if (vietnamobile.includes(prefix3)) carrier = "Vietnamobile";
            else if (itel_wintel.includes(prefix3)) carrier = "Mạng ảo (Wintel/iTel...)";

            if (carrier !== "") {
                displayArea.className = "success-text";
                displayArea.innerText = "✓ SĐT hợp lệ - Nhà mạng: " + carrier;
                inputElement.classList.add("input-success");
            } else {
                displayArea.className = "error";
                displayArea.innerText = " Đầu số không tồn tại tại VN!";
                inputElement.classList.remove("input-success");
            }
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
        document.getElementById("regConfirmPassError").innerHTML = "";
        document.getElementById("regGenderError").innerText = "";

        let phoneField = document.getElementById("regPhone");
        let phoneError = document.getElementById("regPhoneError");

        let name = document.getElementById("regName").value.trim();
        let email = document.getElementById("regEmail").value.trim();
        let pass = document.getElementById("regPass").value.trim();
        let confirmPass = document.getElementById("regConfirmPass").value.trim();
        let rawPhone = phoneField.value.replace(/\D/g, '');
        let isMaleChecked = document.getElementById("genderMale").checked;
        let isFemaleChecked = document.getElementById("genderFemale").checked;

        let emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

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

        let hasLength = pass.length >= 6;
        let hasUpper = /[A-Z]/.test(pass);
        let hasLower = /[a-z]/.test(pass);
        let hasNumber = /[0-9]/.test(pass);
        let hasSpecial = /[^A-Za-z0-9]/.test(pass);

        if (!hasLength || !hasUpper || !hasLower || !hasNumber || !hasSpecial) {
            document.getElementById("regPassError").innerText = "Mật khẩu chưa đạt yêu cầu bảo mật định dạng!";
            valid = false;
        }
        if (confirmPass === "") {
            document.getElementById("regConfirmPassError").className = "error";
            document.getElementById("regConfirmPassError").innerText = "Vui lòng xác nhận lại mật khẩu";
            valid = false;
        } else if (pass !== confirmPass) {
            document.getElementById("regConfirmPassError").className = "error";
            document.getElementById("regConfirmPassError").innerText = "Mật khẩu xác nhận không trùng khớp!";
            valid = false;
        }
        if (!isMaleChecked && !isFemaleChecked) {
            document.getElementById("regGenderError").innerText = "Vui lòng chọn giới tính";
            valid = false;
        }

        if (rawPhone !== "" && !phoneField.classList.contains("input-success")) {
            phoneError.className = "error";
            phoneError.innerText = "Số điện thoại không hợp lệ hoặc không thuộc hệ thống VN!";
            valid = false;
        }

        return valid;
    }


    function togglePassword(inputId, iconElement) {
        let input = document.getElementById(inputId);
        if (input.type === "password") {
            input.type = "text";
            iconElement.innerHTML = "🙈";
        } else {
            input.type = "password";
            iconElement.innerHTML = "👁️";
        }
    }

    window.onload = function() {
        <c:if test="${not empty errorMessage}">
        let targetTab = '${activeTab != null ? activeTab : "login"}';
        openAuth(targetTab);
        </c:if>
    };

    function openForgotModal(){
        document.getElementById("forgotOverlay")
                .style.display="flex";
    }

    function closeForgotModal(){
        document.getElementById("forgotOverlay")
                .style.display="none";
    }

    function openOTPModal(){
        document.getElementById("otpOverlay")
                .style.display="flex";
    }

    function closeOTPModal(){
        document.getElementById("otpOverlay")
                .style.display="none";
    }

    function openResetModal(){
        document.getElementById("resetOverlay")
                .style.display="flex";
    }

    function closeResetModal(){
        document.getElementById("resetOverlay")
                .style.display="none";
    }

    async function sendOTP(){

        let email =
                document.getElementById(
                        "forgotEmail"
                ).value;

        let response =
                await fetch(
                        "${root}/forgot-password",
                        {
                            method:"POST",

                            headers:{
                                "Content-Type":
                                        "application/x-www-form-urlencoded"
                            },

                            body:
                                    "email="
                                    + encodeURIComponent(email)
                        }
                );

        let result =
                await response.json();

        if(result.success){

            alert("OTP đã gửi tới email");

            closeForgotModal();

            openOTPModal();

        }else{

            alert(result.message);
        }
    }

    async function verifyOTP(){

        let otp =
                document.getElementById(
                        "otpCode"
                ).value;

        let response =
                await fetch(
                        "${root}/verify-otp",
                        {
                            method:"POST",

                            headers:{
                                "Content-Type":
                                        "application/x-www-form-urlencoded"
                            },

                            body:
                                    "otp="
                                    + encodeURIComponent(otp)
                        }
                );

        let result =
                await response.json();

        if(result.success){

            closeOTPModal();

            openResetModal();

        }else{

            alert("OTP không đúng");
        }
    }

    async function resetPassword(){

        let pass =
                document.getElementById(
                        "newPassword"
                ).value;

        let confirm =
                document.getElementById(
                        "confirmPassword"
                ).value;

        if(pass !== confirm){

            alert(
                    "Mật khẩu xác nhận không khớp"
            );

            return;
        }

        let response =
                await fetch(
                        "${root}/reset-password",
                        {
                            method:"POST",

                            headers:{
                                "Content-Type":
                                        "application/x-www-form-urlencoded"
                            },

                            body:
                                    "password="
                                    + encodeURIComponent(pass)
                        }
                );

        let result =
                await response.json();

        if(result.success){

            alert(
                    "Đổi mật khẩu thành công"
            );

            closeResetModal();

            openAuth("login");

        }else{

            alert(
                    "Không thể đổi mật khẩu"
            );
        }
    }
</script>