<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="root" value="${pageContext.request.contextPath}" />

<div class="container-fluid pt-4 px-4">

    <div class="bg-light rounded p-4 shadow-sm">

        <!-- HEADER -->
        <div class="d-flex justify-content-between align-items-center mb-4">

            <h4 class="fw-bold text-success mb-0">
                <i class="fas fa-images me-2"></i>
                Thêm Banner
            </h4>

            <a href="${root}/admin/banners"
               class="btn btn-outline-secondary rounded-pill px-4">

                <i class="fas fa-arrow-left me-1"></i>
                Quay lại

            </a>

        </div>

        <!-- FORM -->
        <form action="${root}/admin/banners?action=add"
              method="post"
              enctype="multipart/form-data">

            <div class="row">

                <!-- LEFT -->
                <div class="col-lg-8">

                    <!-- TITLE -->
                    <div class="mb-4">

                        <label class="form-label fw-semibold">
                            Tiêu đề Banner
                        </label>

                        <input type="text"
                               name="title"
                               class="form-control form-control-lg"
                               placeholder="Nhập tiêu đề banner..."
                               required>

                    </div>

                    <!-- PRODUCT -->
                    <div class="mb-4">

                        <label class="form-label fw-semibold">
                            Sản phẩm liên kết
                        </label>

                        <select name="productId"
                                class="form-select form-select-lg">

                            <option value="">
                                -- Chọn sản phẩm --
                            </option>

                            <c:forEach var="p" items="${products}">

                                <option value="${p.id}">
                                        ${p.name}
                                </option>

                            </c:forEach>

                        </select>

                    </div>

                    <!-- IMAGE -->
                    <div class="mb-4">

                        <label class="form-label fw-semibold">
                            Hình ảnh Banner
                        </label>

                        <input type="file"
                               name="image"
                               id="imageInput"
                               class="form-control form-control-lg"
                               accept="image/*"
                               required>

                        <small class="text-muted">
                            Nên dùng ảnh ngang tỷ lệ 16:9
                        </small>

                        <!-- PREVIEW -->
                        <div class="mt-3">

                            <img id="previewImage"
                                 class="rounded shadow-sm border"
                                 style="width:100%;
                    max-height:250px;
                    object-fit:cover;
                    display:none;">

                        </div>

                    </div>

                <!-- RIGHT -->
                <div class="col-lg-4">

                    <div class="border rounded p-4 bg-white shadow-sm">

                        <h6 class="fw-bold mb-3 text-success">
                            <i class="fas fa-info-circle me-2"></i>
                            Thông tin
                        </h6>

                        <ul class="text-muted small ps-3 mb-0">

                            <li class="mb-2">
                                Banner sẽ hiển thị ngoài trang chủ
                            </li>

                            <li class="mb-2">
                                Có thể liên kết tới sản phẩm
                            </li>

                            <li>
                                Ảnh lớn giúp hiển thị đẹp hơn
                            </li>

                        </ul>

                    </div>

                </div>

            </div>

            <!-- BUTTON -->
            <div class="mt-4">

                <button type="submit"
                        class="btn btn-success px-5 py-2 rounded-pill shadow-sm">

                    <i class="fas fa-save me-2"></i>
                    Lưu Banner

                </button>

            </div>

        </form>

    </div>

</div>

<style>

    .form-control:focus,
    .form-select:focus {

        border-color: #198754;
        box-shadow: 0 0 0 .15rem rgba(25,135,84,.15);

    }

</style>
<script>

    const imageInput =
            document.getElementById("imageInput");

    const previewImage =
            document.getElementById("previewImage");

    imageInput.addEventListener("change", function () {

        const file = this.files[0];

        if (file) {

            const reader = new FileReader();

            reader.onload = function (e) {

                previewImage.src = e.target.result;

                previewImage.style.display = "block";
            };

            reader.readAsDataURL(file);
        }

    });

</script>