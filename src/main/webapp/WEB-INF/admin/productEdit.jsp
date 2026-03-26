<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="root" value="${pageContext.request.contextPath}"/>

<style>
  .image-picker-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(100px, 1fr));
    gap: 10px;
    max-height: 250px;
    overflow-y: auto;
    padding: 10px;
    border: 1px solid #ddd;
    background: #fdfdfd;
  }

  .img-option {
    cursor: pointer;
    border: 2px solid transparent;
    padding: 2px;
  }

  .img-option.active {
    border-color: #28a745;
    background: #e8f5e9;
  }

  .img-option img {
    width: 100%;
    height: 80px;
    object-fit: cover;
  }
</style>

<div class="container">
  <h2 class="text-primary">Chỉnh sửa sản phẩm</h2>

  <form action="${root}/admin/products" method="post" enctype="multipart/form-data">
    <input type="hidden" name="action" value="edit"/>
    <input type="hidden" name="id" value="${product.id}"/>

    <div class="row">

      <!-- LEFT -->
      <div class="col-md-7">

        <div class="form-group mb-3">
          <label>Tên sản phẩm</label>
          <input type="text" name="name" class="form-control"
                 value="${product.name}" required>
        </div>

        <div class="row">

          <div class="col-md-4 mb-3">
            <label>Giá</label>
            <input type="number" name="price" class="form-control"
                   value="${product.price.intValue()}" required>
          </div>

          <div class="col-md-4 mb-3">
            <label>Đơn vị</label>
            <input type="text" name="unit" class="form-control"
                   value="${product.unit}">
          </div>

          <div class="col-md-4 mb-3">
            <label>Số lượng</label>
            <input type="number" name="stockQuantity" class="form-control"
                   value="${product.stockQuantity}">
          </div>

        </div>

        <!-- hidden image -->
        <input type="hidden" name="imageUrl" id="hiddenImageUrl"
               value="${product.imageUrl}">

        <!-- gallery -->
        <div class="form-group mb-3">
          <label class="text-primary">Chọn ảnh có sẵn</label>

          <div class="image-picker-grid">
            <c:forEach var="img" items="${imageList}">
              <div class="img-option"
                   onclick="selectGalleryImage(this, '${root}/resources/${img}')">
                <img src="${root}/resources/${img}">
              </div>
            </c:forEach>
          </div>
        </div>

        <!-- upload -->
        <div class="form-group mb-3">
          <label class="text-danger">Upload ảnh mới</label>
          <input type="file" name="imageFile" class="form-control"
                 id="fileInput" onchange="previewNewFile(this)">
        </div>

        <!-- category -->
        <select name="categoryId" class="form-control mb-3">

          <c:forEach var="parent" items="${categories}">
            <option disabled>== ${parent.name} ==</option>

            <c:forEach var="child" items="${parent.children}">
              <option value="${child.id}"
                ${child.id == product.categoryId ? 'selected' : ''}>
                ├ ${child.name}
              </option>
            </c:forEach>

          </c:forEach>

        </select>

        <button type="submit" class="btn btn-primary">Cập nhật</button>
        <a href="${root}/admin/products" class="btn btn-secondary">Quay lại</a>

      </div>

      <!-- RIGHT -->
      <div class="col-md-5 text-center">

        <label>Ảnh hiện tại</label>

        <div class="mt-2">
          <img id="finalPreview"
               src="${root}/resources/${product.imageUrl}"
               class="img-thumbnail"
               style="max-height:300px;">
        </div>

      </div>

    </div>
  </form>
</div>

<script>
  function selectGalleryImage(element, url) {
    document.querySelectorAll('.img-option').forEach(el => el.classList.remove('active'));
    element.classList.add('active');

    document.getElementById('hiddenImageUrl').value = url;
    document.getElementById('finalPreview').src = url;

    document.getElementById('fileInput').value = '';
  }

  function previewNewFile(input) {
    if (input.files && input.files[0]) {
      let reader = new FileReader();
      reader.onload = function (e) {
        document.getElementById('finalPreview').src = e.target.result;
        document.getElementById('hiddenImageUrl').value = '';
      }
      reader.readAsDataURL(input.files[0]);
    }
  }
</script>