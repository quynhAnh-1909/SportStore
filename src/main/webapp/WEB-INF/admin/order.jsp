<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="container-fluid pt-4 px-4">
    <div class="bg-light text-center rounded p-4 shadow-sm">

        <div class="d-flex align-items-center justify-content-between mb-4">
            <h4 class="mb-0 text-success fw-bold">
                <i class="fas fa-box me-2"></i> Quản lý đơn hàng
            </h4>
        </div>

        <c:if test="${empty orders}">
            <div class="text-center mt-4 p-5 border rounded">
                <i class="fas fa-box-open fa-3x text-muted mb-3"></i>
                <p class="text-muted">Chưa có đơn hàng nào.</p>
            </div>
        </c:if>

        <c:if test="${not empty orders}">
            <div class="table-responsive">
                <table class="table compact-table table-bordered table-hover align-middle text-center mb-0">
                    <thead class="table-dark">
                    <tr>
                        <th style="width: 50px;">#</th>
                        <th style="width: 120px;">Mã đơn</th>
                        <th style="width: 150px;">Khách hàng</th>
                        <th style="width: 140px;">Ngày tạo</th>
                        <th style="width: 120px;">Tổng tiền</th>
                        <th style="width: 110px;">Thanh toán</th>
                        <th style="width: 120px;">Trạng thái</th>
                        <th style="width: 150px;">Ghi chú</th>
                        <th style="width: 170px;">Hành động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:set var="stt" value="1"/>
                    <c:forEach var="order" items="${orders}">
                    <tr class="<c:choose>
                                            <c:when test='${order.status eq "PENDING"}'>table-warning</c:when>
                                            <c:when test='${order.status eq "DELIVERED"}'>table-success</c:when>
                                            <c:when test='${order.status eq "CANCELED"}'>table-danger</c:when>
                                       </c:choose>">
                        <td>${stt}</td>
                            <c:set var="stt" value="${stt + 1}"/>

                        <td>${order.orderCode}</td>
                        <td class="fw-semibold text-success">${order.userFullName}</td>
                        <td><fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                        <td class="text-danger fw-bold">
                            <fmt:formatNumber value="${order.totalPrice}" type="currency" currencySymbol="₫"/>
                        </td>
                        <td>${order.paymentMethod}</td>
                        <td>
                            <c:choose>
                                <c:when test="${order.status eq 'PENDING'}">
                                    <span class="badge bg-warning text-dark">Chờ xử lý</span>
                                </c:when>
                                <c:when test="${order.status eq 'DELIVERED'}">
                                    <span class="badge bg-success text-white">Hoàn tất</span>
                                </c:when>
                                <c:when test='${order.status eq "CANCELLED"}'>
                                    <span class="badge bg-danger text-white">Đã hủy</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary text-white">Không xác định</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="text-truncate" style="max-width:150px;">
                                ${order.note}
                        </td>
                        <td>

                            <div class="d-flex flex-column gap-1">

                                <div class="d-flex justify-content-center gap-2 flex-wrap">

                                    <c:if test="${order.status eq 'PENDING'}">

                                        <form action="${root}/admin/orders"
                                              method="post"
                                              class="d-inline ajax-form"
                                              data-success-msg="Xác nhận đơn hàng thành công!"
                                              data-success-color="#198754">

                                            <input type="hidden" name="action" value="confirm">
                                            <input type="hidden" name="id" value="${order.id}">

                                            <button type="submit" class="btn btn-sm btn-success">
                                                Xác nhận
                                            </button>

                                        </form>

                                        <form action="${root}/admin/orders"
                                              method="post"
                                              class="d-inline ajax-form"
                                              data-success-msg="Đã hủy đơn hàng!"
                                              data-success-color="#dc3545">

                                            <input type="hidden" name="action" value="cancel">
                                            <input type="hidden" name="id" value="${order.id}">

                                            <button type="submit" class="btn btn-sm btn-danger">
                                                Hủy
                                            </button>
                                        </form>

                                    </c:if>

                                    <c:if test="${order.status eq 'CONFIRMED'}">

                                        <form action="${root}/admin/ship-order"
                                              method="post"
                                              class="d-inline ajax-form"
                                              data-success-msg="Đã gửi đơn sang GHN!"
                                              data-success-color="#0d6efd">

                                            <input type="hidden" name="id" value="${order.id}">

                                            <button type="submit" class="btn btn-sm btn-primary">
                                                Giao ĐVVC
                                            </button>

                                        </form>

                                    </c:if>

                                    <c:if test="${order.status eq 'SHIPPING'}">

                                        <form action="${root}/admin/orders"
                                              method="post"
                                              class="d-inline ajax-form"
                                              data-success-msg="Đã hoàn thành đơn hàng!"
                                              data-success-color="#198754">

                                            <input type="hidden" name="action" value="complete">
                                            <input type="hidden" name="id" value="${order.id}">

                                            <button type="submit" class="btn btn-sm btn-success">
                                                Hoàn thành
                                            </button>
                                        </form>

                                        <button type="button" class="btn btn-sm btn-info btn-tracking text-white"
                                                data-ghncode="${order.ghnCode}">
                                            <i class="fas fa-route"></i> Hành trình
                                        </button>

                                    </c:if>

                                </div>

                                <div>
                                    <a href="${root}/admin/orders/details?orderCode=${order.orderCode}"
                                       class="btn btn-sm btn-outline-info w-100">
                                        <i class="fas fa-eye"></i>
                                    </a>
                                </div>

                            </div>

                        </td>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>
    </div>
</div>

<div class="modal fade" id="trackingModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header bg-info text-white">
                <h5 class="modal-title"><i class="fas fa-truck"></i> Hành trình đơn hàng</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <ul id="trackingTimeline" class="list-group list-group-flush">
                    <li class="list-group-item text-center text-muted">Đang tải dữ liệu...</li>
                </ul>
            </div>
        </div>
    </div>
</div>

<style>
    .table-hover tbody tr:hover {
        background-color: rgba(0,0,0,0.05);
        transition: background 0.3s;
    }
    .compact-table{
        table-layout: fixed;
        font-size: 13px;
    }

    .compact-table th,
    .compact-table td{
        padding: 8px !important;
        vertical-align: middle;
        word-wrap: break-word;
    }

    .compact-table .btn{
        font-size: 12px;
        padding: 4px 8px;
    }

    .compact-table .badge{
        font-size: 11px;
    }
</style>

<div id="toast"
     style="
        position: fixed;
        top: 20px;
        right: 20px;
        color: white;
        padding: 12px 20px;
        border-radius: 8px;
        display: none;
        z-index: 9999;
        box-shadow: 0 4px 10px rgba(0,0,0,0.2);
     ">
</div>

<script>
    function showToast(message, color) {
        const toast = document.getElementById("toast");
        toast.innerText = message;
        toast.style.background = color;
        toast.style.display = "block";

        setTimeout(() => {
            toast.style.display = "none";
        }, 3000);
    }

    document.addEventListener("DOMContentLoaded", function() {
        const ajaxForms = document.querySelectorAll('.ajax-form');

        ajaxForms.forEach(form => {
            form.addEventListener('submit', function(event) {
                event.preventDefault();

                const formData = new FormData(this);
                const actionUrl = this.getAttribute('action');
                const successMsg = this.getAttribute('data-success-msg') || 'Thao tác thành công!';
                const successColor = this.getAttribute('data-success-color') || '#198754';
                const submitBtn = this.querySelector('button[type="submit"]');
                const originalBtnText = submitBtn.innerHTML;

                submitBtn.disabled = true;
                submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>';

                const rowElement = this.closest('tr');

                fetch(actionUrl, {
                    method: 'POST',
                    body: new URLSearchParams(formData)
                })
                        .then(response => {
                            if (response.ok) {
                                showToast(successMsg, successColor);
                                if (rowElement) {
                                    rowElement.style.transition = "opacity 0.4s ease";
                                    rowElement.style.opacity = "0";
                                    setTimeout(() => {
                                        rowElement.remove();
                                        const tbody = document.querySelector('table tbody');
                                        if (tbody && tbody.children.length === 0) {
                                            tbody.innerHTML = '<tr><td colspan="9" class="text-center text-muted py-4">Đã hết đơn hàng trong mục này.</td></tr>';
                                        }
                                    }, 400);
                                }
                            } else {
                                throw new Error('Network response was not ok.');
                            }
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            showToast('Có lỗi xảy ra, vui lòng thử lại!', '#dc3545');
                            submitBtn.disabled = false;
                            submitBtn.innerHTML = originalBtnText;
                        });
            });
        });

        const trackingModalElement = document.getElementById('trackingModal');
        if (trackingModalElement) {
            const trackingModal = new bootstrap.Modal(trackingModalElement);
            const timelineContainer = document.getElementById('trackingTimeline');

            document.querySelectorAll('.btn-tracking').forEach(btn => {
                btn.addEventListener('click', function() {
                    const ghnCode = this.getAttribute('data-ghncode');
                    if(!ghnCode) {
                        showToast('Đơn hàng này chưa có mã vận đơn GHN!', '#dc3545');
                        return;
                    }

                    timelineContainer.innerHTML = '<li class="list-group-item text-center text-muted spinner-border spinner-border-sm mx-auto d-block my-3"></li>';
                    trackingModal.show();

                    const formData = new URLSearchParams();
                    formData.append('action', 'tracking');
                    formData.append('ghnCode', ghnCode);

                    fetch('${root}/admin/orders', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: formData
                    })
                            .then(response => {
                                if(!response.ok) throw new Error("Lỗi tải dữ liệu");
                                return response.json();
                            })
                            .then(data => {
                                if(data.code === 200 && data.data && data.data.log) {
                                    const logs = data.data.log;
                                    let html = '';

                                    logs.reverse().forEach(log => {
                                        const time = new Date(log.updated_date).toLocaleString('vi-VN');
                                        html += `
                                    <li class="list-group-item">
                                        <div class="fw-bold text-primary">\${log.status}</div>
                                        <div class="small text-muted"><i class="far fa-clock"></i> \${time}</div>
                                    </li>
                                `;
                                    });

                                    timelineContainer.innerHTML = html;
                                } else {
                                    timelineContainer.innerHTML = '<li class="list-group-item text-danger">Không tìm thấy thông tin hành trình.</li>';
                                }
                            })
                            .catch(error => {
                                console.error(error);
                                timelineContainer.innerHTML = '<li class="list-group-item text-danger">Lỗi kết nối đến máy chủ!</li>';
                            });
                });
            });
        }
    });
</script>