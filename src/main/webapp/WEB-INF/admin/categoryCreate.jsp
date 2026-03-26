<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="root" value="${pageContext.request.contextPath}"/>
<div class="container">
    <h4 class="text-success mb-3">Thêm danh mục</h4>

    <form action="${root}/admin/categories" method="post">
        <input type="hidden" name="action" value="create"/>

        <div class="mb-3">
            <label>Tên danh mục</label>
            <input type="text" name="name" class="form-control" required>
        </div>

        <div class="mb-3">
            <label>Danh mục cha</label>
            <select name="parentId" class="form-control">
                <option value="">-- Danh mục gốc --</option>

                <c:forEach var="parent" items="${categories}">
                    <option value="${parent.id}">${parent.name}</option>

                    <c:forEach var="child" items="${parent.children}">
                        <option value="${child.id}">
                            ├ ${child.name}
                        </option>
                    </c:forEach>

                </c:forEach>
            </select>
        </div>

        <button class="btn btn-success">Lưu</button>
        <a href="${root}/admin/categories" class="btn btn-secondary">Quay lại</a>
    </form>
</div>