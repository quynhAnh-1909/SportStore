<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="vi_VN"/>

<h2 class="dashboard-title">Dashboard Tổng Quan</h2>

<div class="row g-4">
    <div class="col-md-4">
        <div class="dashboard-card" data-bs-toggle="collapse" data-bs-target="#collapseProductDetails" aria-expanded="false" aria-controls="collapseProductDetails" style="cursor: pointer;">
            <h5><i class="fas fa-box text-danger me-2"></i>Tổng sản phẩm</h5>
            <h2>
                ${productCount}
                <small style="font-size: 12px; color: #6c757d; font-weight: normal;">(Bấm để xem chi tiết)</small>
            </h2>
        </div>
    </div>

    <div class="col-md-4">
        <div class="dashboard-card h-100 d-flex flex-column justify-content-between">
            <div>
                <h5><i class="fas fa-shopping-cart text-danger me-2"></i>Tổng đơn hàng</h5>
                <h2>${orderCount}</h2>
            </div>

            <div class="border-top pt-2 mt-2" style="border-top: 1px dashed #dee2e6 !important;">
                <h6 class="text-muted mb-1" style="font-size: 13px;"><i class="fas fa-ticket-alt text-success me-2"></i>Tỷ lệ sử dụng Voucher</h6>
                <div class="d-flex justify-content-between align-items-center">
                    <span class="fw-bold text-dark" style="font-size: 14px;">
                        ${usedVouchers} <small class="text-muted" style="font-weight: normal;">đã dùng</small>
                    </span>
                    <span class="text-muted">/</span>
                    <span class="fw-bold text-primary" style="font-size: 14px;">
                        ${totalVouchers} <small class="text-muted" style="font-weight: normal;">tổng số</small>
                    </span>
                </div>
                <div class="progress mt-2" style="height: 6px;">
                    <div class="progress-bar bg-success" role="progressbar"
                         style="width: ${totalVouchers > 0 ? (usedVouchers * 100 / totalVouchers) : 0}%"
                         aria-valuenow="${usedVouchers}" aria-valuemin="0" aria-valuemax="${totalVouchers}"></div>
                </div>
            </div>
        </div>
    </div>

    <div class="col-md-4">
        <div class="dashboard-card" data-bs-toggle="collapse" data-bs-target="#collapseChart" aria-expanded="false" aria-controls="collapseChart" style="cursor: pointer;">
            <h5><i class="fas fa-money-bill-wave text-danger me-2"></i>Doanh thu tháng này</h5>
            <h2>
                <fmt:formatNumber value="${revenue.longValue()}" type="number" groupingUsed="true"/> đ
                <small style="font-size: 12px; color: #6c757d; font-weight: normal;">(Bấm để xem biểu đồ)</small>
            </h2>

            <div class="collapse mt-3" id="collapseChart">
                <div style="position: relative; height:200px; width:100%">
                    <canvas id="revenueChart"></canvas>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="collapse mt-4" id="collapseProductDetails">
    <div class="dashboard-box bg-light p-4 rounded shadow-sm">
        <h4 class="text-danger mb-4"><i class="fas fa-boxes me-2"></i>Thống Kê Chi Tiết Kho Hàng Thực Tế</h4>

        <div class="row g-4">
            <div class="col-md-6">
                <div class="card h-100 border-0 shadow-sm">
                    <div class="card-header bg-secondary text-white fw-bold">📦 Sản phẩm tồn kho nhiều</div>
                    <div class="card-body p-0">
                        <table class="table table-hover mb-0">
                            <thead class="table-dark">
                            <tr><th>Sản phẩm</th><th>Tồn kho</th></tr>
                            </thead>
                            <tbody>
                            <c:forEach var="p" items="${inventoryList}">
                                <tr>
                                    <td><c:out value="${p.name}"/></td>
                                    <td><span class="badge bg-secondary">${p.stockQuantity}</span></td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty inventoryList}">
                                <tr><td colspan="2" class="text-center text-muted">Không có dữ liệu</td></tr>
                            </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <div class="col-md-6">
                <div class="card h-100 border-0 shadow-sm">
                    <div class="card-header bg-warning text-dark fw-bold">⚠️ Sản phẩm ít/Sắp hết hàng</div>
                    <div class="card-body p-0">
                        <table class="table table-hover mb-0">
                            <thead class="table-dark">
                            <tr><th>Sản phẩm</th><th>Còn lại</th></tr>
                            </thead>
                            <tbody>
                            <c:forEach var="p" items="${slowMovingList}">
                                <tr>
                                    <td><c:out value="${p.name}"/></td>
                                    <td><span class="badge bg-danger">${p.stockQuantity}</span></td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty slowMovingList}">
                                <tr><td colspan="2" class="text-center text-muted">Không có dữ liệu</td></tr>
                            </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="row mt-4">
    <div class="col-md-8">
        <div class="dashboard-box">
            <h4 class="text-danger">🔥 Top sản phẩm bán chạy</h4>
            <table class="table table-hover">
                <thead>
                <tr>
                    <th>Sản phẩm</th>
                    <th>Đã bán</th>
                    <th>Trạng thái</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td>Yonex Astrox 88D</td>
                    <td>120</td>
                    <td><span class="badge bg-success badge-status">Best Seller</span></td>
                </tr>
                <tr>
                    <td>Adidas Predator Ball</td>
                    <td>98</td>
                    <td><span class="badge bg-primary badge-status">Hot</span></td>
                </tr>
                <tr>
                    <td>Nike Air Zoom</td>
                    <td>85</td>
                    <td><span class="badge bg-warning text-dark badge-status">Trending</span></td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>

    <div class="col-md-4">
        <div class="dashboard-box">
            <h4 class="text-success">🔔 Thông báo hệ thống</h4>
            <p>🟡 Có đơn hàng mới cần xác nhận</p>
            <p>📦 Các cổng thanh toán hoạt động ổn định</p>
            <p>💰 Doanh thu tuần này tăng trưởng tốt</p>
            <p>🚚 Cập nhật dữ liệu vận chuyển liên kết thành công</p>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const ctx = document.getElementById('revenueChart').getContext('2d');

        const gradient = ctx.createLinearGradient(0, 0, 0, 200);
        gradient.addColorStop(0, 'rgba(216, 31, 25, 0.4)');
        gradient.addColorStop(1, 'rgba(216, 31, 25, 0.0)');

        const dbData = ${yearlyRevenueJson != null ? yearlyRevenueJson : '[0,0,0,0,0,0,0,0,0,0,0,0]'};

        new Chart(ctx, {
            type: 'line',
            data: {
                labels: ['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6', 'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12'],
                datasets: [{
                    label: 'Doanh thu',
                    data: dbData,
                    backgroundColor: gradient,
                    borderColor: '#d81f19',
                    borderWidth: 3,
                    pointBackgroundColor: '#d81f19',
                    pointHoverRadius: 7,
                    fill: true,
                    tension: 0.2
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: {
                            color: 'rgba(0, 0, 0, 0.05)'
                        },
                        ticks: {
                            callback: function(value) {
                                return value.toLocaleString('vi-VN') + ' đ';
                            }
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        }
                    }
                }
            }
        });
    });
</script>