<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="root" value="${pageContext.request.contextPath}" />

<div class="container-fluid pt-4 px-4">

    <div class="bg-light rounded p-4 shadow-sm">

        <!-- HEADER -->
        <div class="d-flex justify-content-between align-items-center mb-4">

            <h4 class="fw-bold text-success mb-0">
                <i class="fas fa-images me-2"></i>
                Quản lý Banner
            </h4>

            <a href="${root}/admin/banners?action=add"
               class="btn btn-success rounded-pill px-4 shadow-sm">

                <i class="fas fa-plus me-1"></i>
                Thêm banner

            </a>

        </div>

        <!-- TABLE -->
        <div class="table-responsive">

            <table class="table table-bordered table-hover align-middle text-center">

                <thead class="table-dark">
                <tr>
                    <th style="width: 80px;">ID</th>
                    <th style="width: 160px;">Hình ảnh</th>
                    <th class="text-start">Tiêu đề</th>
                    <th>Trạng thái</th>
                    <th style="width: 220px;">Thao tác</th>
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
                                 style="width:120px;height:65px;object-fit:cover;">

                        </td>

                        <!-- TITLE -->
                        <td class="text-start fw-semibold">
                                ${b.title}
                        </td>

                        <!-- STATUS -->
                        <td>

                            <c:choose>

                                <c:when test="${b.status}">
                                    <span class="badge bg-success px-3 py-2">
                                        Hiển thị
                                    </span>
                                </c:when>

                                <c:otherwise>
                                    <span class="badge bg-secondary px-3 py-2">
                                        Ẩn
                                    </span>
                                </c:otherwise>

                            </c:choose>

                        </td>

                        <!-- ACTION -->
                        <td>

                            <div class="btn-group">

                                <!-- EDIT -->
                                <a href="${root}/admin/banners?action=edit&id=${b.id}"
                                   class="btn btn-sm btn-outline-primary">

                                    <i class="fas fa-edit"></i>

                                </a>

                                <!-- DELETE -->
                                <a href="${root}/admin/banners?action=delete&id=${b.id}"
                                   class="btn btn-sm btn-outline-danger"
                                   onclick="return confirmDelete(event,this.href)">

                                    <i class="fas fa-trash"></i>

                                </a>

                                <!-- TOGGLE -->
                                <a href="${root}/admin/banners?action=toggle&id=${b.id}"
                                   class="btn btn-sm btn-outline-info">

                                    <i class="fas fa-sync"></i>

                                </a>

                            </div>

                        </td>

                    </tr>

                </c:forEach>

                </tbody>

            </table>

        </div>

        <!-- EMPTY -->
        <c:if test="${empty banners}">

            <div class="text-center p-5">

                <i class="fas fa-images fa-3x text-muted mb-3"></i>

                <p class="text-muted">
                    Chưa có banner nào
                </p>

            </div>

        </c:if>

    </div>

</div>

<style>

    table tbody tr:hover {
        background-color: rgba(0,123,255,0.05);
    }

    td, th {
        vertical-align: middle !important;
    }

</style>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>

    function confirmDelete(event, url) {

        event.preventDefault();

        Swal.fire({
            title: 'Bạn chắc chắn?',
            text: 'Banner sẽ bị xóa!',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Xóa',
            cancelButtonText: 'Hủy'
        }).then((result) => {

            if (result.isConfirmed) {
                window.location.href = url;
            }

        });

        return false;
    }

</script>