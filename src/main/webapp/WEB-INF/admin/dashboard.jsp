<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="vi_VN"/>

<style>
    .dashboard-title {
        font-size: 32px;
        font-weight: 700;
        margin-bottom: 30px;
        color: #333;
    }
    .dashboard-card {
        padding: 30px 25px !important;
        border-radius: 12px !important;
        box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        transition: all 0.3s ease;
    }
    .dashboard-card:hover {
        transform: translateY(-4px);
        box-shadow: 0 8px 20px rgba(0,0,0,0.1);
    }
    .dashboard-card h5 {
        font-size: 16px;
        font-weight: 600;
        color: #6c757d;
        margin-bottom: 15px;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }
    .dashboard-card h2 {
        font-size: 38px;
        font-weight: 800;
        margin-bottom: 0;
        color: #212529;
    }
    .dashboard-box h4 {
        font-size: 22px;
        font-weight: 700;
    }
    .table {
        font-size: 16px;
    }
    .table th {
        font-weight: 600;
        padding: 14px 12px !important;
    }
    .table td {
        padding: 14px 12px !important;
        vertical-align: middle;
    }
    .badge {
        font-size: 14px !important;
        padding: 6px 12px !important;
    }
</style>

<h2 class="dashboard-title">Dashboard Tổng Quan</h2>

<div class="row g-4">
    <div class="col-md-4">
        <div class="dashboard-card bg-white border" data-bs-toggle="collapse" data-bs-target="#collapseProductDetails" aria-expanded="true" aria-controls="collapseProductDetails" style="cursor: pointer;">
            <h5><i class="fas fa-box text-danger me-2"></i>Tổng sản phẩm</h5>
            <h2>
                ${productCount}
                <br>
                <small style="font-size: 13px; color: #8c96a0; font-weight: normal;">(Bấm xem chi tiết kho)</small>
            </h2>
        </div>
    </div>

    <div class="col-md-4">
        <div class="dashboard-card bg-white border h-100 d-flex flex-column justify-content-between">
            <div>
                <h5><i class="fas fa-shopping-cart text-danger me-2"></i>Tổng đơn hàng</h5>
                <h2>${orderCount}</h2>
            </div>

            <div class="border-top pt-3 mt-3" style="border-top: 1px dashed #dee2e6 !important;">
                <h6 class="text-muted mb-2" style="font-size: 14px; font-weight: 600;"><i class="fas fa-ticket-alt text-success me-2"></i>Tỷ lệ sử dụng Voucher</h6>
                <div class="d-flex justify-content-between align-items-center">
                    <span class="fw-bold text-dark" style="font-size: 15px;">
                        ${usedVouchers} <small class="text-muted" style="font-weight: normal; font-size: 13px;">đã dùng</small>
                    </span>
                    <span class="text-muted">/</span>
                    <span class="fw-bold text-primary" style="font-size: 15px;">
                        ${totalVouchers} <small class="text-muted" style="font-weight: normal; font-size: 13px;">tổng số</small>
                    </span>
                </div>
                <div class="progress mt-2" style="height: 8px; border-radius: 4px;">
                    <div class="progress-bar bg-success" role="progressbar"
                         style="width: ${totalVouchers > 0 ? (usedVouchers * 100 / totalVouchers) : 0}%"
                         aria-valuenow="${usedVouchers}" aria-valuemin="0" aria-valuemax="${totalVouchers}"></div>
                </div>
            </div>
        </div>
    </div>

    <div class="col-md-4">
        <div class="dashboard-card bg-white border" data-bs-toggle="collapse" data-bs-target="#collapseChart" aria-expanded="false" aria-controls="collapseChart" style="cursor: pointer;">
            <h5><i class="fas fa-money-bill-wave text-danger me-2"></i>Doanh thu tháng này</h5>
            <h2>
                <fmt:formatNumber value="${revenue.longValue()}" type="number" groupingUsed="true"/> đ
                <br>
                <small style="font-size: 13px; color: #8c96a0; font-weight: normal;">(Bấm xem biểu đồ)</small>
            </h2>
        </div>
    </div>
</div>

<div class="collapse mt-4 show" id="collapseProductDetails" data-bs-parent=".dashboard-title">
    <div class="dashboard-box bg-white p-4 rounded shadow-sm border">
        <h4 class="text-danger mb-4"><i class="fas fa-boxes me-2"></i>Thống Kê Chi Tiết Kho Hàng Thực Tế</h4>

        <div class="row g-4">
            <div class="col-md-6">
                <div class="card h-100 border-0 shadow-sm">
                    <div class="card-header bg-secondary text-white fw-bold py-3" style="font-size: 16px;">📦 Sản phẩm tồn kho nhiều</div>
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
                                <tr><td colspan="2" class="text-center text-muted py-4">Không có dữ liệu</td></tr>
                            </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <div class="col-md-6">
                <div class="card h-100 border-0 shadow-sm">
                    <div class="card-header bg-warning text-dark fw-bold py-3" style="font-size: 16px;">⚠️ Sản phẩm ít/Sắp hết hàng</div>
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
                                <tr><td colspan="2" class="text-center text-muted py-4">Không có dữ liệu</td></tr>
                            </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="collapse mt-4" id="collapseChart" data-bs-parent=".dashboard-title">
    <div class="dashboard-box bg-white p-4 rounded shadow-sm border">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h4 class="text-danger mb-0"><i class="fas fa-chart-line me-2"></i>Biểu Đồ Phân Tích Doanh Thu</h4>
            <div class="d-flex align-items-center">
                <label for="viewFilter" class="me-2 fw-bold text-muted mb-0" style="font-size: 15px;">Xem theo:</label>
                <select id="viewFilter" class="form-select" style="width: 160px; height: 40px; cursor: pointer; font-size: 15px;">
                    <option value="year" selected>Doanh thu Năm</option>
                    <option value="month">Doanh thu Tháng</option>
                </select>
            </div>
        </div>
        <div style="position: relative; height:380px; width:100%">
            <canvas id="revenueChart"></canvas>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const ctx = document.getElementById('revenueChart').getContext('2d');

        const gradient = ctx.createLinearGradient(0, 0, 0, 320);
        gradient.addColorStop(0, 'rgba(216, 31, 25, 0.4)');
        gradient.addColorStop(1, 'rgba(216, 31, 25, 0.0)');

        const dataYear = ${yearlyRevenueJson != null ? yearlyRevenueJson : '[0,0,0,0,0,0,0,0,0,0,0,0]'};
        const dataMonth = ${monthlyDailyRevenueJson != null ? monthlyDailyRevenueJson : '[]'};

        const labelsYear = ['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6', 'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12'];
        const labelsMonth = ${daysLabelJson != null ? daysLabelJson : '[]'};

        const revenueChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: labelsYear,
                datasets: [{
                    label: 'Doanh thu',
                    data: dataYear,
                    backgroundColor: gradient,
                    borderColor: '#d81f19',
                    borderWidth: 3.5,
                    pointBackgroundColor: '#d81f19',
                    pointHoverRadius: 8,
                    fill: true,
                    tension: 0.2
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: { color: 'rgba(0, 0, 0, 0.04)' },
                        ticks: {
                            font: { size: 13 },
                            callback: function(value) {
                                return value.toLocaleString('vi-VN') + ' đ';
                            }
                        }
                    },
                    x: {
                        grid: { display: false },
                        ticks: { font: { size: 13 } }
                    }
                }
            }
        });

        document.getElementById('viewFilter').addEventListener('change', function () {
            if (this.value === 'month') {
                revenueChart.data.labels = labelsMonth;
                revenueChart.data.datasets[0].data = dataMonth;
            } else {
                revenueChart.data.labels = labelsYear;
                revenueChart.data.datasets[0].data = dataYear;
            }
            revenueChart.update();
        });
    });
</script>