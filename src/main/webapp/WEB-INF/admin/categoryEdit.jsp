<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="root" value="${pageContext.request.contextPath}" />

<div class="container-fluid pt-4 px-4">

    ```
    <div class="bg-light rounded p-4 shadow-sm">

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h4 class="text-warning fw-bold mb-0">
                <i class="fas fa-edit me-2"></i>
                Cập nhật danh mục
            </h4>

            <a href="${root}/admin/categories"
               class="btn btn-secondary rounded-pill px-4">
                <i class="fas fa-arrow-left me-1"></i>
                Quay lại
            </a>
        </div>

        <div class="card border-0 shadow-sm">

            <div class="card-body p-4">

                <form action="${root}/admin/categories" method="post">

                    <input type="hidden"
                           name="action"
                           value="edit">

                    <input type="hidden"
                           name="id"
                           value="${category.id}">

                    <!-- Tên danh mục -->
                    <div class="mb-4">

                        <label class="form-label fw-semibold">
                            Tên danh mục
                        </label>

                        <input type="text"
                               name="name"
                               value="${category.name}"
                               class="form-control form-control-lg"
                               required>

                    </div>

                    <!-- Danh mục cha -->
                    <div class="mb-4">

                        <label class="form-label fw-semibold">
                            Danh mục cha
                        </label>

                        <select name="parentId"
                                class="form-select form-select-lg">

                            <option value="">
                                -- Không có --
                            </option>

                            <c:forEach items="${categories}" var="c">

                                <c:if test="${c.id != category.id}">

                                    <option value="${c.id}"
                                        ${c.id == category.parentId ? 'selected' : ''}>

                                            ${c.name}

                                    </option>

                                </c:if>

                            </c:forEach>

                        </select>

                    </div>

                    <div class="text-end">

                        <button type="submit"
                                class="btn btn-warning px-4">
                            <i class="fas fa-save me-1"></i>
                            Cập nhật
                        </button>

                    </div>

                </form>

            </div>

        </div>

    </div>
    ```

</div>

<style>
    .card{
        border-radius:16px;
    }

    .form-control,
    .form-select{
        border-radius:12px;
    }

    .btn{
        border-radius:12px;
    }

    .form-label{
        color:#495057;
    }
</style>
