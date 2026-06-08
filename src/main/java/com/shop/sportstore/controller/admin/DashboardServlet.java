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

        double monthlyRevenue = orderDAO.calculateMonthlyStats("revenue", currentMonth, currentYear);

        StringJoiner revYear = new StringJoiner(",", "[", "]");
        StringJoiner ordYear = new StringJoiner(",", "[", "]");
        StringJoiner prodYear = new StringJoiner(",", "[", "]");

        for (int m = 1; m <= 12; m++) {
            revYear.add(String.valueOf(orderDAO.calculateMonthlyStats("revenue", m, currentYear)));
            ordYear.add(String.valueOf(orderDAO.calculateMonthlyStats("orders", m, currentYear)));
            prodYear.add(String.valueOf(orderDAO.calculateMonthlyStats("products", m, currentYear)));
        }

        StringJoiner revMonth = new StringJoiner(",", "[", "]");
        StringJoiner ordMonth = new StringJoiner(",", "[", "]");
        StringJoiner prodMonth = new StringJoiner(",", "[", "]");

        for (int d = 1; d <= maxDaysInMonth; d++) {
            revMonth.add(String.valueOf(orderDAO.calculateDailyStats("revenue", d, currentMonth, currentYear)));
            ordMonth.add(String.valueOf(orderDAO.calculateDailyStats("orders", d, currentMonth, currentYear)));
            prodMonth.add(String.valueOf(orderDAO.calculateDailyStats("products", d, currentMonth, currentYear)));
        }

        StringJoiner sjMonthLabels = new StringJoiner("\",\"", "[\"", "\"]");
        for (int d = 1; d <= maxDaysInMonth; d++) {
            sjMonthLabels.add("Ngày " + d);
        }

        request.setAttribute("inventoryList", productDAO.getInventoryProducts());
        request.setAttribute("slowMovingList", productDAO.getSlowMovingProducts());
        request.setAttribute("totalVouchers", totalVouchers);
        request.setAttribute("usedVouchers", usedVouchers);
        request.setAttribute("revenue", monthlyRevenue);
        request.setAttribute("productCount", productCount);
        request.setAttribute("orderCount", orderCount);

        request.setAttribute("revYearJson", revYear.toString());
        request.setAttribute("ordYearJson", ordYear.toString());
        request.setAttribute("prodYearJson", prodYear.toString());

        request.setAttribute("revMonthJson", revMonth.toString());
        request.setAttribute("ordMonthJson", ordMonth.toString());
        request.setAttribute("prodMonthJson", prodMonth.toString());

        request.setAttribute("daysLabelJson", sjMonthLabels.toString());

        request.setAttribute("contentPage", "/WEB-INF/admin/dashboard.jsp");
        request.getRequestDispatcher("/WEB-INF/admin/layout-admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}