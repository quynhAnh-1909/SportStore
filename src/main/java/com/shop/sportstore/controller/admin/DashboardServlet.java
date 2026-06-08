package com.shop.sportstore.controller.admin;

import com.shop.sportstore.dao.OrderDAO;
import com.shop.sportstore.dao.ProductDAO;
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

        Calendar cal = Calendar.getInstance();
        int currentMonth = cal.get(Calendar.MONTH) + 1;
        int currentYear = cal.get(Calendar.YEAR);

        double monthlyRevenue = orderDAO.calculateMonthlyRevenue(currentMonth, currentYear);

        StringJoiner sj = new StringJoiner(",", "[", "]");
        for (int m = 1; m <= 12; m++) {
            double rev = orderDAO.calculateMonthlyRevenue(m, currentYear);
            sj.add(String.valueOf((long) rev));
        }
        String yearlyRevenueJson = sj.toString();

        // --- ĐOẠN ĐẨY DỮ LIỆU TỒN KHO SANG JSP ---
        request.setAttribute("inventoryList", productDAO.getInventoryProducts());
        request.setAttribute("slowMovingList", productDAO.getSlowMovingProducts());
        // ----------------------------------------

        request.setAttribute("revenue", monthlyRevenue);
        request.setAttribute("productCount", productCount);
        request.setAttribute("orderCount", orderCount);
        request.setAttribute("yearlyRevenueJson", yearlyRevenueJson);

        request.setAttribute("contentPage", "/WEB-INF/admin/dashboard.jsp");
        request.getRequestDispatcher("/WEB-INF/admin/layout-admin.jsp").forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}