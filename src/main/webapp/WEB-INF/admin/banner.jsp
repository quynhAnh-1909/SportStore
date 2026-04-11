<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="root" value="${pageContext.request.contextPath}"/>

<div class="container-fluid">

    <h3 class="dashboard-title">Quản lý Banner</h3>

    <!-- ADD BUTTON -->
    <div class="mb-3">
        <a href="${root}/admin/banners/add" class="btn btn-danger">
            <i class="fas fa-plus me-2"></i> Thêm banner
        </a>
    </div>

    <!-- TABLE -->
    <div class="dashboard-box">
        <table class="table table-hover align-middle">
            <thead class="table-danger">
            <tr>
                <th>ID</th>
                <th>Hình ảnh</th>
                <th>Tiêu đề</th>
                <th>Trạng thái</th>
                <th>Hành động</th>
            </tr>
            </thead>

            <tbody>
            <c:forEach var="b" items="${banners}">
                <tr>
                    <td>${b.id}</td>

                    <!-- IMAGE -->
                    <td>
                        <img src="${root}/uploads/${b.image}"
                             style="width:120px;height:60px;object-fit:cover;border-radius:8px;">
                    </td>

                    <!-- TITLE -->
                    <td>${b.title}</td>

                    <!-- STATUS -->
                    <td>
                        <c:choose>
                            <c:when test="${b.status}">
                                <span class="badge bg-success">Hiển thị</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-secondary">Ẩn</span>
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <!-- ACTION -->
                    <td>
                        <a href="${root}/admin/banners/edit?id=${b.id}"
                           class="btn btn-sm btn-warning">
                            <i class="fas fa-edit"></i>
                        </a>

                        <a href="${root}/admin/banners/delete?id=${b.id}"
                           class="btn btn-sm btn-danger"
                           onclick="return confirm('Xóa banner này?')">
                            <i class="fas fa-trash"></i>
                        </a>

                        <!-- toggle status -->
                        <a href="${root}/admin/banners/toggle?id=${b.id}"
                           class="btn btn-sm btn-info">
                            <i class="fas fa-sync"></i>
                        </a>
                    </td>
                </tr>
            </c:forEach>

            <!-- EMPTY -->
            <c:if test="${empty banners}">
                <tr>
                    <td colspan="5" class="text-center text-muted">
                        Chưa có banner nào
                    </td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>

    </div>
</div>


<style>
    table tbody tr:hover {
        background-color: rgba(0, 123, 255, 0.05);
    }

    td, th {
        vertical-align: middle !important;
    }
</style>
