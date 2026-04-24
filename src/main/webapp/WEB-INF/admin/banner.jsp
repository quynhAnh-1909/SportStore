<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="root" value="${pageContext.request.contextPath}"/>

<div class="container-fluid pt-4 px-4">

    <div class="bg-light rounded p-4 shadow-sm">

        <!-- HEADER -->
        <div class="d-flex align-items-center justify-content-between mb-4">
            <h4 class="mb-0 text-success fw-bold">
                <i class="fas fa-images me-2"></i> Quản lý Banner
            </h4>

            <a href="${root}/admin/banners/add"
               class="btn btn-success rounded-pill px-4 shadow-sm">
                <i class="fas fa-plus me-1"></i> Thêm banner
            </a>
        </div>

        <!-- TABLE -->
        <div class="table-responsive">
            <table class="table table-bordered table-hover align-middle text-center">

                <thead class="table-dark">
                <tr>
                    <th style="width: 80px;">ID</th>
                    <th style="width: 140px;">Hình ảnh</th>
                    <th class="text-start">Tiêu đề</th>
                    <th>Trạng thái</th>
                    <th style="width: 180px;">Thao tác</th>
                </tr>
                </thead>

                <tbody>

                <c:forEach var="b" items="${banners}">
                    <tr>

                        <!-- ID -->
                        <td class="fw-bold text-muted">
                                ${b.id}
                        </td>

                        <!-- IMAGE -->
                        <td>
                            <img src="${root}/uploads/${b.image}"
                                 class="rounded shadow-sm"
                                 style="width:100px;height:60px;object-fit:cover;border:1px solid #dee2e6;">
                        </td>

                        <!-- TITLE -->
                        <td class="text-start fw-semibold">
                                ${b.title}
                        </td>

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
                            <div class="btn-group">

                                <a href="${root}/admin/banners/edit?id=${b.id}"
                                   class="btn btn-sm btn-outline-primary">
                                    <i class="fas fa-edit"></i>
                                </a>

                                <a href="${root}/admin/banners/delete?id=${b.id}"
                                   class="btn btn-sm btn-outline-danger"
                                   onclick="return confirm('Xóa banner này?')">
                                    <i class="fas fa-trash"></i>
                                </a>

                                <a href="${root}/admin/banners/toggle?id=${b.id}"
                                   class="btn btn-sm btn-outline-info">
                                    <i class="fas fa-sync"></i>
                                </a>

                            </div>
                        </td>

                    </tr>
                </c:forEach>

                <!-- EMPTY -->
                <c:if test="${empty banners}">
                    <tr>
                        <td colspan="5" class="text-center text-muted py-4">
                            <i class="fas fa-image fa-2x mb-2"></i><br>
                            Chưa có banner nào
                        </td>
                    </tr>
                </c:if>

                </tbody>
            </table>
        </div>

    </div>
</div>

<!-- STYLE -->
<style>
    table tbody tr:hover {
        background-color: rgba(0, 123, 255, 0.05);
    }

    td, th {
        vertical-align: middle !important;
    }
</style>