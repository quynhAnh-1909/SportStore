<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="root" value="${pageContext.request.contextPath}"/>
<c:set var="currentUri" value="${requestScope['jakarta.servlet.forward.request_uri']}"/>
<c:if test="${empty currentUri}">
    <c:set var="currentUri" value="${pageContext.request.requestURI}"/>
</c:if>

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
        z-index: 9999;
    }

    .auth-box {
        width: 420px;
        background: white;
        border-radius: 12px;
        padding: 30px;
        box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
        position: relative;
        animation: fadeIn .3s ease;
        z-index: 10000;
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
        display: block;
        width: 100%;
    }

    .password-wrapper input {
        padding-right: 45px;
    }


    .toggle-eye {
        position: absolute;
        right: 12px;
        top: 50%;
        transform: translateY(-50%);
        cursor: pointer;
        z-index: 10005;
        font-size: 18px;
        user-select: none;
        padding: 5px;
        transition: opacity 0.2s ease;
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
    }

    .req-invalid { color: #ea3838; }
    .req-valid { color: #2ed573; font-weight: 500; }
</style>

<div class="overlay" id="authOverlay">
    <div class="auth-box">
        <div class="close-btn" onclick="closeAuth()">✖</div>

        <div class="logo">
            <img src="${root}/resources/sport_store.jpg" alt="Logo">
        </div>

        <div class="auth-tabs">
            <span id="tabLogin" class="active" onclick="switchTab('login')">Đăng nhập</span>
            <span id="tabRegister" onclick="switchTab('register')">Đăng ký</span>
        </div>

        <form id="loginForm" action="${root}/login" method="post" onsubmit="return validateLogin()">
            <input type="hidden" name="redirectUri" value="${currentUri}">

            <div class="form-group">
                <label>Email <span class="required">*</span></label>
                <input type="text" name="email" id="loginEmail" oninput="checkDetailedEmail(this, 'loginEmailError')" value="${activeTab == 'login' && oldUser != null ? oldUser.email : ''}">
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
        </form>

        <form id="registerForm" action="${root}/register" method="post" onsubmit="return validateRegister()" style="display:none;">
            <input type="hidden" name="redirectUri" value="${currentUri}">

            <div class="form-group">
                <label>Họ tên <span class="required">*</span></label>
                <input type="text" name="fullName" id="regName" value="${activeTab == 'register' && oldUser != null ? oldUser.fullName : ''}">
                <div class="error" id="regNameError"></div>
            </div>

            <div class="form-group">
                <label>Email <span class="required">*</span></label>
                <input type="text" name="email" id="regEmail" oninput="checkDetailedEmail(this, 'regEmailError')" value="${activeTab == 'register' && oldUser != null ? oldUser.email : ''}">
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
                    <div class="requirement-item req-invalid" id="reqSpecial">Ít nhất 1 ký tự đặc biệt (@, $, !, ...)</div>
                </div>

                <div class="error" id="regPassError"></div>
            </div>

            <div class="form-group">
                <label>Xác nhận mật khẩu <span class="required">*</span></label>
                <div class="password-wrapper">
                    <input type="password" id="regConfirmPass" oninput="matchConfirmPassword()">
                    <span class="toggle-eye" onclick="togglePassword('regConfirmPass', this)">👁️</span>
                </div>
                <div class="error" id="regConfirmPassError"></div>
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
                <img src="${root}/resources/gg.jpg" alt="Google"> Google
            </div>
            <div class="social-btn" onclick="location.href='${root}/login-facebook'">
                <img src="${root}/resources/fb.jpg" alt="Facebook"> Facebook
            </div>
        </div>

        <div class="link" id="linkSwitch">
            Chưa có tài khoản? <a href="#" onclick="switchTab('register');return false;">Đăng ký</a>
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


    function togglePassword(inputId, eyeIcon) {
        let passwordInput = document.getElementById(inputId);

        if (passwordInput.type === "password") {
            passwordInput.type = "text";
            eyeIcon.style.opacity = "0.3";
        } else {
            passwordInput.type = "password";
            eyeIcon.style.opacity = "1";
    }

    function checkDetailedEmail(inputElement, errorElementId) {
        let value = inputElement.value.trim();
        let errorBlock = document.getElementById(errorElementId);

        if (value === "") {
            errorBlock.innerText = "";
            inputElement.classList.remove("input-success");
            return false;
        }

        errorBlock.className = "error";
        inputElement.classList.remove("input-success");

        if (/\s/.test(value)) { errorBlock.innerText = " Email không được chứa khoảng trắng!"; return false; }
        if (/[àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ]/i.test(value)) { errorBlock.innerText = " Email không chứa dấu tiếng Việt!"; return false; }
        if (!value.includes("@")) { errorBlock.innerText = " Thiếu ký tự '@'"; return false; }
        if ((value.match(/@/g) || []).length > 1) { errorBlock.innerText = " Chỉ được chứa 1 ký tự '@'!"; return false; }

        let parts = value.split("@");
        if (parts[0] === "") { errorBlock.innerText = "Thiếu tên người dùng!"; return false; }
        if (parts[1] === "" || !parts[1].includes(".")) { errorBlock.innerText = "Tên miền không hợp lệ!"; return false; }

        let emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
        if (!emailRegex.test(value)) { errorBlock.innerText = " Định dạng email sai!"; return false; }

        errorBlock.className = "success-text";
        errorBlock.innerText = " Định dạng email hợp lệ";
        inputElement.classList.add("input-success");
        return true;
    }

    function validatePasswordFormat(password) {
        let inputField = document.getElementById("regPass");
        let block = document.getElementById("passRequirementsBlock");
        if (password === "") { block.style.display = "none"; return false; }
        block.style.display = "block";

        let hasLength = password.length >= 6;
        let hasUpper = /[A-Z]/.test(password);
        let hasLower = /[a-z]/.test(password);
        let hasNumber = /[0-9]/.test(password);
        let hasSpecial = /[^A-Za-z0-9]/.test(password);

        updateRequirementStatus("reqLength", hasLength, " Tối thiểu 6 ký tự", "Tối thiểu 6 ký tự");
        updateRequirementStatus("reqUppercase", hasUpper, " Có chữ hoa (A-Z)", "Thiếu chữ hoa (A-Z)");
        updateRequirementStatus("reqLowercase", hasLower, " Có chữ thường (a-z)", "Thiếu chữ thường (a-z)");
        updateRequirementStatus("reqNumber", hasNumber, "Có chữ số (0-9)", " Thiếu chữ số (0-9)");
        updateRequirementStatus("reqSpecial", hasSpecial, "Có ký tự đặc biệt", " Thiếu ký tự đặc biệt");

        if (hasLength && hasUpper && hasLower && hasNumber && hasSpecial) {
            inputField.classList.add("input-success");
            return true;
        } else {
            inputField.classList.remove("input-success");
            return false;
        }
    }

    function updateRequirementStatus(elementId, isValid, validText, invalidText) {
        let item = document.getElementById(elementId);
        if (item) {
            item.className = isValid ? "requirement-item req-valid" : "requirement-item req-invalid";
            item.innerHTML = isValid ? validText : invalidText;
        }
    }

    function matchConfirmPassword() {
        let pass = document.getElementById("regPass").value;
        let confirmPass = document.getElementById("regConfirmPass").value;
        let displayArea = document.getElementById("regConfirmPassError");
        let confirmInputField = document.getElementById("regConfirmPass");

        if (confirmPass === "") { displayArea.innerHTML = ""; return false; }

        if (pass === confirmPass) {
            displayArea.className = "success-text";
            displayArea.innerHTML = " Mật khẩu chính xác";
            confirmInputField.classList.add("input-success");
            return true;
        } else {
            displayArea.className = "error";
            displayArea.innerHTML = " Mật khẩu xác nhận không trùng khớp!";
            confirmInputField.classList.remove("input-success");
            return false;
        }
    }

    function checkPhoneLocation(inputElement) {
        let displayArea = document.getElementById("regPhoneError");
        let rawPhone = inputElement.value.replace(/\D/g, '');
        if (rawPhone.length > 10) rawPhone = rawPhone.substr(0, 10);

        let formattedPhone = "";
        if (rawPhone.length > 0) {
            if (rawPhone.length <= 4) formattedPhone = rawPhone;
            else if (rawPhone.length <= 7) formattedPhone = rawPhone.substr(0, 4) + " " + rawPhone.substr(4);
            else formattedPhone = rawPhone.substr(0, 4) + " " + rawPhone.substr(4, 3) + " " + rawPhone.substr(7);
        }
        inputElement.value = formattedPhone;

        if (rawPhone === "") { displayArea.innerHTML = ""; return false; }
        if (rawPhone.length < 10) { displayArea.className = "error"; displayArea.innerText = " Đang nhập... (Cần đủ 10 số)"; return false; }

        let carrier = "";
        let prefix3 = rawPhone.substr(0, 3);
        if (["032", "033", "034", "035", "036", "037", "038", "039", "086", "096", "097", "098"].includes(prefix3)) carrier = "Viettel";
        else if (["070", "076", "077", "078", "079", "089", "090", "093"].includes(prefix3)) carrier = "MobiFone";
        else if (["081", "082", "083", "084", "085", "088", "091", "094"].includes(prefix3)) carrier = "VinaPhone";

        if (carrier !== "") {
            displayArea.className = "success-text";
            displayArea.innerText = " SĐT hợp lệ - " + carrier;
            inputElement.classList.add("input-success");
            return true;
        } else {
            displayArea.className = "error";
            displayArea.innerText = " Đầu số không tồn tại!";
            inputElement.classList.remove("input-success");
            return false;
        }
    }

    function validateLogin() {
        let emailInput = document.getElementById("loginEmail");
        let emailError = document.getElementById("loginEmailError");
        let pass = document.getElementById("loginPass").value.trim();
        let emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;

        if (emailInput.value.trim() === "" || !emailRegex.test(emailInput.value.trim())) {
            emailError.className = "error";
            emailError.innerText = "Email không đúng định dạng!";
            return false;
        }
        if (pass === "") {
            document.getElementById("loginPassError").innerText = "Vui lòng nhập mật khẩu";
            return false;
        }
        return true;
    }

    function validateRegister() {
        let name = document.getElementById("regName").value.trim();
        let emailInput = document.getElementById("regEmail");
        let passValue = document.getElementById("regPass").value;
        let confirmPassValue = document.getElementById("regConfirmPass").value;
        let confirmError = document.getElementById("regConfirmPassError");
        let phoneField = document.getElementById("regPhone");

        if (name === "") { document.getElementById("regNameError").innerText = "Vui lòng nhập họ tên"; return false; }

        if (!checkDetailedEmail(emailInput, 'regEmailError')) { return false; }

        if (!validatePasswordFormat(passValue)) { return false; }

        if (confirmPassValue === "") {
            confirmError.className = "error";
            confirmError.innerHTML = "Vui lòng xác nhận lại mật khẩu!";
            return false;
        }
        if (passValue !== confirmPassValue) { return false; }

        if (phoneField.value !== "" && !phoneField.classList.contains("input-success")) { return false; }

        return true;
    }

    window.addEventListener('DOMContentLoaded', (event) => {
        <c:if test="${not empty errorMessage}">
        let targetTab = '${activeTab != null ? activeTab : "login"}';
        openAuth(targetTab);
        </c:if>
    });
</script>