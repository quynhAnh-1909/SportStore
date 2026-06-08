package com.shop.sportstore.controller.admin;

import com.shop.sportstore.dao.OrderDAO;
import com.shop.sportstore.dao.ProductDAO;
import com.shop.sportstore.dao.VoucherDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Calendar;
import java.util.StringJoiner;

@WebServlet("/admin/dashboard")
public class DashboardServlet extends HttpServlet {

    private ProductDAO productDAO;
    private OrderDAO orderDAO;

    @Override
    public void init() {
        productDAO = new ProductDAO();
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int productCount = productDAO.countProducts(null, null);
        int orderCount = orderDAO.countOrdersByStatus("COMPLETED");

        int totalVouchers = 0;
        int usedVouchers = 0;
        try (java.sql.Connection conn = com.shop.sportstore.untils.DBConnection.getConnection()) {
            VoucherDAO voucherDAO = new VoucherDAO(conn);
            totalVouchers = voucherDAO.getTotalVoucherQuantity();
            usedVouchers = voucherDAO.getTotalVoucherUsedCount();
        } catch (Exception e) {
            e.printStackTrace();
        }

        Calendar cal = Calendar.getInstance();
        int currentMonth = cal.get(Calendar.MONTH) + 1;
        int currentYear = cal.get(Calendar.YEAR);
        int maxDaysInMonth = cal.getActualMaximum(Calendar.DAY_OF_MONTH);

        double monthlyRevenue = orderDAO.calculateMonthlyRevenue(currentMonth, currentYear);

        StringJoiner sjYear = new StringJoiner(",", "[", "]");
        for (int m = 1; m <= 12; m++) {
            double rev = orderDAO.calculateMonthlyRevenue(m, currentYear);
            sjYear.add(String.valueOf((long) rev));
        }
        String yearlyRevenueJson = sjYear.toString();

        StringJoiner sjMonthData = new StringJoiner(",", "[", "]");
        for (int d = 1; d <= maxDaysInMonth; d++) {
            double revDay = orderDAO.calculateDailyRevenue(d, currentMonth, currentYear);
            sjMonthData.add(String.valueOf((long) revDay));
        }
        String monthlyDailyRevenueJson = sjMonthData.toString();

        StringJoiner sjMonthLabels = new StringJoiner("\",\"", "[\"", "\"]");
        for (int d = 1; d <= maxDaysInMonth; d++) {
            sjMonthLabels.add("Ngày " + d);
        }
        String daysLabelJson = sjMonthLabels.toString();

        request.setAttribute("inventoryList", productDAO.getInventoryProducts());
        request.setAttribute("slowMovingList", productDAO.getSlowMovingProducts());
        request.setAttribute("totalVouchers", totalVouchers);
        request.setAttribute("usedVouchers", usedVouchers);
        request.setAttribute("revenue", monthlyRevenue);
        request.setAttribute("productCount", productCount);
        request.setAttribute("orderCount", orderCount);

        request.setAttribute("yearlyRevenueJson", yearlyRevenueJson);
        request.setAttribute("monthlyDailyRevenueJson", monthlyDailyRevenueJson);
        request.setAttribute("daysLabelJson", daysLabelJson);

        request.setAttribute("contentPage", "/WEB-INF/admin/dashboard.jsp");
        request.getRequestDispatcher("/WEB-INF/admin/layout-admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}