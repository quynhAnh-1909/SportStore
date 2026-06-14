<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">

<div class="container-fluid pt-4 px-4">
    <div class="bg-white rounded p-4 shadow-sm border">

        <div class="d-flex align-items-center justify-content-between mb-4">
            <h4 class="mb-0 text-success fw-bold">
                <i class="fas fa-box me-2"></i> Quản lý đơn hàng
            </h4>
            <div class="d-flex gap-2">
                <c:if test="${pendingCount > 0}">
                    <form action="${pageContext.request.contextPath}/admin/orders"
                          method="post"
                          id="confirmAllForm"
                          class="d-inline">
                        <input type="hidden" name="action" value="confirmAll">
                        <button type="submit" id="btnConfirmAll" class="btn btn-success fw-bold shadow-sm">
                            <i class="fas fa-check-double me-2"></i>
                            Xác nhận tất cả (${pendingCount})
                        </button>
                    </form>
                </c:if>

                <a href="${pageContext.request.contextPath}/admin/orders?action=sync" class="btn btn-info text-white fw-bold shadow-sm">
                    <i class="fas fa-sync me-2"></i> Đồng bộ GHN
                </a>
            </div>
        </div>

        <c:if test="${empty orders}">
            <div class="text-center mt-4 p-5 border rounded bg-light">
                <i class="fas fa-box-open fa-3x text-muted mb-3"></i>
                <p class="text-muted m-0">Chưa có đơn hàng nào trong danh mục này.</p>
            </div>
        </c:if>

        <c:if test="${not empty orders}">
            <div class="table-responsive">
                <table id="orderTable" class="table compact-table table-bordered table-hover align-middle text-center mb-0">
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
                    <c:forEach var="order" items="${orders}">
                        <tr>
                            <td class="stt-column"></td>
                            <td class="fw-bold">${order.orderCode}</td>
                            <td class="fw-semibold text-success">${order.userFullName}</td>
                            <td><fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                            <td class="text-danger fw-bold">
                                <fmt:formatNumber value="${order.totalPrice}" type="currency" currencySymbol="₫"/>
                            </td>
                            <td><span class="badge bg-light text-dark border">${order.paymentMethod}</span></td>
                            <td>
                                <c:choose>
                                    <c:when test="${order.status eq 'PENDING'}">
                                        <span class="badge bg-warning text-dark">Chờ xử lý</span>
                                    </c:when>
                                    <c:when test="${order.status eq 'CONFIRMED'}">
                                        <span class="badge bg-info text-white">Chờ lấy hàng</span>
                                    </c:when>
                                    <c:when test="${order.status eq 'SHIPPING'}">
                                        <span class="badge bg-primary text-white">Đang giao</span>
                                    </c:when>
                                    <c:when test="${order.status eq 'COMPLETED'}">
                                        <span class="badge bg-success text-white">Hoàn tất</span>
                                    </c:when>
                                    <c:when test="${order.status eq 'CANCELLED'}">
                                        <span class="badge bg-danger text-white">Đã hủy</span>
                                    </c:when>
                                    <c:when test="${order.status eq 'PENDING_REFUND'}">
                                        <span class="badge bg-warning text-dark">Chờ hoàn tiền</span>
                                    </c:when>
                                    <c:when test="${order.status eq 'REFUNDED'}">
                                        <span class="badge bg-success text-white">Đã hoàn tiền</span>
                                    </c:when>
                                    <c:when test="${order.status eq 'REFUND_REJECTED'}">
                                        <span class="badge bg-danger text-white">Từ chối hoàn</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary text-white">${order.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-truncate" style="max-width:150px;" title="${order.note}">
                                    ${order.note}
                            </td>
                            <td>
                                <div class="d-flex flex-column gap-1">
                                    <div class="d-flex justify-content-center gap-2 flex-wrap">

                                        <c:if test="${order.status eq 'PENDING'}">
                                            <form action="${pageContext.request.contextPath}/admin/orders" method="post" class="d-inline ajax-form"
                                                  data-success-msg="Xác nhận đơn hàng! Đã chuyển sang danh mục Chờ lấy hàng." data-success-color="#198754">
                                                <input type="hidden" name="action" value="confirm">
                                                <input type="hidden" name="id" value="${order.id}">
                                                <button type="submit" class="btn btn-sm btn-success">Xác nhận</button>
                                            </form>

                                            <form action="${pageContext.request.contextPath}/admin/orders" method="post" class="d-inline ajax-form"
                                                  data-success-msg="Đã hủy đơn hàng thành công!" data-success-color="#dc3545">
                                                <input type="hidden" name="action" value="cancel">
                                                <input type="hidden" name="id" value="${order.id}">
                                                <input type="hidden" name="cancelReason" class="cancel-reason-input" value="">
                                                <button type="button" class="btn btn-sm btn-danger btn-trigger-cancel">Hủy</button>
                                            </form>
                                        </c:if>

                                        <c:if test="${order.status eq 'CONFIRMED'}">
                                            <form action="${pageContext.request.contextPath}/admin/orders" method="post" class="d-inline ajax-form"
                                                  data-success-msg="Đã đẩy thông tin sang GHN! Đơn hàng chuyển sang danh mục Đang giao." data-success-color="#0d6efd">
                                                <input type="hidden" name="action" value="shipping">
                                                <input type="hidden" name="id" value="${order.id}">
                                                <button type="submit" class="btn btn-sm btn-primary">
                                                    <i class="fas fa-paper-plane me-1"></i>Giao ĐVVC
                                                </button>
                                            </form>
                                        </c:if>

                                        <c:if test="${order.status eq 'SHIPPING'}">
                                            <button type="button" class="btn btn-sm btn-warning text-dark fw-bold btn-tracking" data-ghncode="${order.ghnCode}">
                                                <i class="fas fa-route me-1"></i> Lịch trình
                                            </button>

                                            <form action="${pageContext.request.contextPath}/admin/orders" method="post" class="d-inline ajax-form"
                                                  data-success-msg="Đã xác nhận hoàn thành đơn hàng thủ công!" data-success-color="#198754">
                                                <input type="hidden" name="action" value="complete">
                                                <input type="hidden" name="id" value="${order.id}">
                                                <button type="submit" class="btn btn-sm btn-success">Hoàn thành</button>
                                            </form>
                                        </c:if>

                                        <c:if test="${order.status eq 'PENDING_REFUND'}">
                                            <form action="${pageContext.request.contextPath}/admin/orders" method="post" class="d-inline ajax-form"
                                                  data-success-msg="Đã phê duyệt và thực hiện hoàn tiền!" data-success-color="#198754">
                                                <input type="hidden" name="action" value="approveRefund">
                                                <input type="hidden" name="id" value="${order.id}">
                                                <button type="button" class="btn btn-sm btn-success btn-trigger-refund">Hoàn tiền</button>
                                            </form>
                                            <form action="${pageContext.request.contextPath}/admin/orders" method="post" class="d-inline ajax-form"
                                                  data-success-msg="Đã từ chối yêu cầu hoàn tiền!" data-success-color="#dc3545">
                                                <input type="hidden" name="action" value="rejectRefund">
                                                <input type="hidden" name="id" value="${order.id}">
                                                <input type="hidden" name="rejectReason" class="reject-reason-input" value="">
                                                <button type="button" class="btn btn-sm btn-danger btn-trigger-reject">Từ Chối</button>
                                            </form>
                                        </c:if>

                                    </div>

                                    <div>
                                        <a href="${pageContext.request.contextPath}/admin/orders/details?orderCode=${order.orderCode}" class="btn btn-sm btn-outline-info w-100">
                                            <i class="fas fa-eye"></i> Chi tiết đơn
                                        </a>
                                    </div>
                                </div>
                            </td>
                        </tr>
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
            <div class="modal-header bg-dark text-white">
                <h5 class="modal-title fw-bold"><i class="fas fa-boxes me-2 text-warning"></i>Hành trình đơn hàng GHN</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" style="background: #f8f9fa;">
                <div class="p-2 mb-3 bg-white border rounded">
                    <span class="text-muted">Mã vận đơn:</span> <strong id="modalGhnCode" class="text-primary">---</strong>
                </div>
                <div class="timeline-container px-2">
                    <ul id="trackingTimeline" class="timeline-list">
                        <li class="text-center text-muted py-3">Đang kết nối API vận đơn...</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
    .compact-table{ table-layout: fixed; font-size: 13px; }
    .compact-table th, .compact-table td{ padding: 12px 8px !important; vertical-align: middle; word-wrap: break-word; }
    .compact-table .btn{ font-size: 12px; padding: 5px 10px; }
    .compact-table .badge{ font-size: 11px; padding: 6px 10px; }
    .timeline-list { list-style-type: none; position: relative; padding-left: 30px; margin: 0; }
    .timeline-list:before { content: ' '; background: #ced4da; display: inline-block; position: absolute; left: 11px; width: 2px; height: 100%; z-index: 400; }
    .timeline-item { margin: 20px 0; position: relative; }
    .timeline-marker { width: 12px; height: 12px; border-radius: 50%; background: #6c757d; position: absolute; left: -24px; top: 5px; z-index: 400; border: 2px solid #fff; }
    .timeline-item:first-child .timeline-marker { background: #198754; box-shadow: 0 0 0 4px rgba(25, 135, 84, 0.3); }
    .timeline-date { font-size: 11px; color: #6c757d; font-weight: bold; }
    .timeline-content { font-size: 13px; color: #212529; margin-top: 2px; }
    .dataTables_wrapper .dataTables_paginate .paginate_button { padding: 0px !important; margin: 2px !important; }
    .dataTables_wrapper .dataTables_length, .dataTables_wrapper .dataTables_filter { margin-bottom: 15px; font-size: 13px; }
</style>

<div id="toast" style="position: fixed; top: 20px; right: 20px; color: white; padding: 12px 20px; border-radius: 8px; display: none; z-index: 9999; box-shadow: 0 4px 10px rgba(0,0,0,0.2); font-weight: bold;"></div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
    function showToast(message, color) {
        const toast = document.getElementById("toast");
        toast.innerText = message;
        toast.style.background = color;
        toast.style.display = "block";
        setTimeout(() => { toast.style.display = "none"; }, 3500);
    }

    function translateGhnStatus(status) {
        const mapping = {
            'ready_to_pick': 'Mới tạo đơn - Chờ lấy hàng',
            'picking': 'Bưu tá đang đi lấy hàng',
            'cancel': 'Đơn hàng đã hủy',
            'picked': 'Đã lấy hàng vào kho GHN',
            'storing': 'Hàng đang ở kho trung chuyển',
            'transporting': 'Đang luân chuyển bưu cục',
            'sorting': 'Đang phân loại hàng hóa',
            'delivering': 'Bưu tá đang đi giao hàng',
            'money_collect_picking': 'Đang thu tiền người gửi',
            'delivered': 'Giao hàng thành công 🎉',
            'delivery_fail': 'Giao hàng không thành công',
            'waiting_to_return': 'Chờ chuyển hoàn',
            'return': 'Đang chuyển hoàn lại kho',
            'returned': 'Đã hoàn trả hàng cho shop thành công',
            'damage': 'Hàng hóa bị hư hỏng',
            'lost': 'Hàng hóa bị thất lạc'
        };
        return mapping[status] || status;
    }

    document.addEventListener("DOMContentLoaded", function() {
        const table = $('#orderTable').DataTable({
            "pageLength": 10,
            "lengthChange": false,
            "ordering": false,
            "info": true,
            "dom": '<"d-flex justify-content-between align-items-center mb-3"f>t<"d-flex justify-content-between align-items-center mt-3"ip>',
            "language": {
                "search": "Tìm kiếm nhanh:",
                "info": "Hiển thị dòng _START_ đến _END_ trên tổng số _TOTAL_ đơn hàng",
                "paginate": {
                    "next": '<i class="fas fa-chevron-right"></i>',
                    "previous": '<i class="fas fa-chevron-left"></i>'
                },
                "zeroRecords": "Không tìm thấy dữ liệu khớp"
            }
        });
        table.on('order.dt search.dt', function () {
            let i = 1;
            table.cells(null, 0, { search: 'applied', order: 'applied' }).every(function (cell) {
                this.data(i++);
            });
        }).draw();

        const confirmAllForm = document.getElementById('confirmAllForm');
        if (confirmAllForm) {
            confirmAllForm.addEventListener('submit', function(event) {
                event.preventDefault();

                const submitBtn = document.getElementById('btnConfirmAll');
                const originalBtnText = submitBtn.innerHTML;
                submitBtn.disabled = true;
                submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Đang xử lý...';

                const actionUrl = this.getAttribute('action');
                const formData = new FormData(this);

                fetch(actionUrl, {
                    method: 'POST',
                    body: new URLSearchParams(formData)
                })
                        .then(response => {
                            if (response.ok) {
                                return response.json().catch(() => {
                                    return { success: true, message: "Đã phê duyệt hàng loạt đơn hàng chờ xử lý thành công!" };
                                });
                            } else {
                                throw new Error('Yêu cầu xử lý từ server thất bại.');
                            }
                        })
                        .then(data => {
                            if (data.success || data.status === "success") {
                                showToast(data.message || "Xác nhận tất cả thành công!", "#198754");
                                setTimeout(() => {
                                    location.reload();
                                }, 1500);
                            } else {
                                showToast(data.message || "Xử lý hàng loạt thất bại!", "#dc3545");
                                submitBtn.disabled = false;
                                submitBtn.innerHTML = originalBtnText;
                            }
                        })
                        .catch(error => {
                            console.error("Error ConfirmAll:", error);
                            showToast("Có lỗi phát sinh trong quá trình xác nhận hàng loạt!", "#dc3545");
                            submitBtn.disabled = false;
                            submitBtn.innerHTML = originalBtnText;
                        });
            });
        }

        const ajaxForms = document.querySelectorAll('.ajax-form');
        ajaxForms.forEach(form => {
            // 1. Xử lý nút HỦY ĐƠN HÀNG thông thường (Trạng thái PENDING)
            const cancelBtn = form.querySelector('.btn-trigger-cancel');
            if (cancelBtn) {
                cancelBtn.addEventListener('click', function() {
                    Swal.fire({
                        title: 'Xác nhận hủy đơn hàng',
                        text: 'Vui lòng nhập lý do hủy đơn hàng này:',
                        input: 'text',
                        inputPlaceholder: 'Lý do hủy đơn...',
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonColor: '#dc3545',
                        cancelButtonColor: '#6c757d',
                        confirmButtonText: 'Xác nhận hủy',
                        cancelButtonText: 'Đóng',
                        inputValidator: (value) => {
                            if (!value || value.trim() === '') {
                                return 'Bạn cần phải nhập lý do hủy đơn!';
                            }
                        }
                    }).then((result) => {
                        if (result.isConfirmed) {
                            const cancelInput = form.querySelector('.cancel-reason-input');
                            if (cancelInput) {
                                cancelInput.value = result.value;
                            }
                            form.requestSubmit();
                        }
                    });
                });
            }

            // 2. Xử lý nút TỪ CHỐI HOÀN TIỀN (Trạng thái PENDING_REFUND)
            const rejectBtn = form.querySelector('.btn-trigger-reject');
            if (rejectBtn) {
                rejectBtn.addEventListener('click', function() {
                    Swal.fire({
                        title: 'Từ chối yêu cầu hoàn tiền',
                        text: 'Vui lòng nhập lý do không đồng ý hoàn tiền:',
                        input: 'text',
                        inputPlaceholder: 'Lý do từ chối hoàn tiền...',
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonColor: '#dc3545',
                        cancelButtonColor: '#6c757d',
                        confirmButtonText: 'Xác nhận từ chối',
                        cancelButtonText: 'Quay lại',
                        inputValidator: (value) => {
                            if (!value || value.trim() === '') {
                                return 'Bạn phải điền lý do từ chối!';
                            }
                        }
                    }).then((result) => {
                        if (result.isConfirmed) {
                            const rejectInput = form.querySelector('.reject-reason-input');
                            if (rejectInput) {
                                rejectInput.value = result.value;
                            }
                            form.requestSubmit();
                        }
                    });
                });
            }

            // 3. Xử lý nút XÁC NHẬN HOÀN TIỀN (Trạng thái PENDING_REFUND)
            const refundBtn = form.querySelector('.btn-trigger-refund');
            if (refundBtn) {
                refundBtn.addEventListener('click', function() {
                    Swal.fire({
                        title: 'Xác nhận hoàn tiền?',
                        text: "Hệ thống sẽ phê duyệt và thực hiện lệnh hoàn trả tiền mặt cho đơn hàng này.",
                        icon: 'question',
                        showCancelButton: true,
                        confirmButtonColor: '#198754',
                        cancelButtonColor: '#6c757d',
                        confirmButtonText: 'Đồng ý hoàn tiền',
                        cancelButtonText: 'Hủy bỏ'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            form.requestSubmit();
                        }
                    });
                });
            }

            // Xử lý gửi Form bằng Fetch API AJAX chung
            form.addEventListener('submit', function(event) {
                event.preventDefault();

                const formData = new FormData(this);
                const actionUrl = this.getAttribute('action');
                const successMsg = this.getAttribute('data-success-msg') || 'Thao tác thành công!';
                const successColor = this.getAttribute('data-success-color') || '#198754';
                const submitBtn = this.querySelector('button');
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
                                        var tableInstance = $('#orderTable').DataTable();
                                        tableInstance.row($(rowElement)).remove().draw(false);
                                    }, 400);
                                }
                            } else {
                                throw new Error('Yêu cầu xử lý thất bại.');
                            }
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            showToast('Có lỗi xảy ra trong quá trình kết nối dữ liệu!', '#dc3545');
                            submitBtn.disabled = false;
                            submitBtn.innerHTML = originalBtnText;
                        });
            });
        });

        const trackingModalElement = document.getElementById('trackingModal');
        if (trackingModalElement) {
            const trackingModal = new bootstrap.Modal(trackingModalElement);
            const timelineContainer = document.getElementById('trackingTimeline');
            const modalGhnCode = document.getElementById('modalGhnCode');

            document.querySelectorAll('.btn-tracking').forEach(btn => {
                btn.addEventListener('click', function() {
                    const ghnCode = this.getAttribute('data-ghncode');
                    if(!ghnCode || ghnCode === "null" || ghnCode.trim() === "") {
                        showToast('Đơn hàng chưa được kích hoạt mã vận đơn vận chuyển!', '#dc3545');
                        return;
                    }

                    modalGhnCode.innerText = ghnCode;
                    timelineContainer.innerHTML = '<div class="text-center py-4"><span class="spinner-border spinner-border-sm text-secondary"></span> Đang tải hành trình từ hệ thống GHN...</div>';
                    trackingModal.show();

                    const formData = new URLSearchParams();
                    formData.append('action', 'tracking');
                    formData.append('ghnCode', ghnCode);

                    fetch('${pageContext.request.contextPath}/admin/orders', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: formData
                    })
                            .then(response => {
                                if(!response.ok) throw new Error("Lỗi kết nối API");
                                return response.json();
                            })
                            .then(res => {
                                if(res && res.code === 200 && res.data && res.data.log && res.data.log.length > 0) {
                                    let htmlContent = "";
                                    res.data.log.forEach(item => {
                                        let formattedTime = "---";
                                        if(item.updated_date) {
                                            const d = new Date(item.updated_date);
                                            formattedTime = d.toLocaleDateString('vi-VN') + " " + d.toLocaleTimeString('vi-VN', {hour: '2-digit', minute:'2-digit'});
                                        }
                                        const statusVietnamese = translateGhnStatus(item.status);
                                        htmlContent += `
                                    <li class="timeline-item">
                                        <div class="timeline-marker"></div>
                                        <div class="timeline-date">${formattedTime}</div>
                                        <div class="timeline-content fw-semibold">${statusVietnamese}</div>
                                    </li>
                                `;
                                    });
                                    timelineContainer.innerHTML = htmlContent;
                                } else {
                                    timelineContainer.innerHTML = `
                                <li class="timeline-item">
                                    <div class="timeline-marker bg-success"></div>
                                    <div class="timeline-date">Hệ thống</div>
                                    <div class="timeline-content fw-semibold text-success">Đã xác nhận tạo đơn hàng thành công trên hệ thống GHN. Đang chờ bưu tá đến lấy hàng.</div>
                                </li>
                            `;
                                }
                            })
                            .catch(error => {
                                console.error("Tracking Error:", error);
                                timelineContainer.innerHTML = '<li class="text-center text-danger py-3"><i class="fas fa-exclamation-triangle me-1"></i> Không thể tải hành trình vận chuyển lúc này. Vui lòng thử lại!</li>';
                            });
                });
            });
        }
    });
</script>