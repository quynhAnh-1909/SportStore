package com.shop.sportstore.controller.admin;

import com.shop.sportstore.dao.CustomerDAO;
import com.shop.sportstore.model.Customer;
import com.shop.sportstore.untils.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

import static java.lang.Integer.parseInt;

@WebServlet("/admin/customers")
public class CustomerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            Connection conn = DBConnection.getConnection();
            CustomerDAO dao = new CustomerDAO(conn);

            if (action != null && action.equals("delete")) {
                int id = parseInt(request.getParameter("id"));
                dao.delete(id);
                response.sendRedirect("customers");
                return;
            }

            if (action != null && action.equals("edit")) {
                int id = parseInt(request.getParameter("id"));
                Customer c = dao.findById(id);
                request.setAttribute("customer", c);

                request.setAttribute("contentPage", "/WEB-INF/admin/customerEdit.jsp");
                request.getRequestDispatcher("/WEB-INF/admin/layout-admin.jsp").forward(request, response);
                return;
            }

            if (action != null && action.equals("create")) {
                request.setAttribute("contentPage", "/WEB-INF/admin/customerCreate.jsp");
                request.getRequestDispatcher("/WEB-INF/admin/layout-admin.jsp").forward(request, response);
                return;
            }


            if (action != null && action.equals("view")) {
                int id = parseInt(request.getParameter("id"));

                Customer c = dao.findById(id);
                double[] stats = dao.getCustomerStats(id);
                List<java.util.Map<String, Object>> orderHistory = dao.getOrderHistory(id);


                request.setAttribute("customer", c);
                request.setAttribute("totalOrders", (int)stats[0]);
                request.setAttribute("totalSpent", stats[1]);
                request.setAttribute("orderHistory", orderHistory);

                request.setAttribute("contentPage", "/WEB-INF/admin/customerDetail.jsp");
                request.getRequestDispatcher("/WEB-INF/admin/layout-admin.jsp").forward(request, response);
                return;
            }

            List<Customer> list = dao.getAll();
            request.setAttribute("customers", list);

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("contentPage", "/WEB-INF/admin/customer.jsp");
        request.getRequestDispatcher("/WEB-INF/admin/layout-admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            request.setCharacterEncoding("UTF-8");

            Connection conn = DBConnection.getConnection();
            CustomerDAO dao = new CustomerDAO(conn);

            String action = request.getParameter("action");
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            boolean status = "true".equals(request.getParameter("status"));

            if (fullName == null || fullName.trim().isEmpty() || email == null || email.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng nhập đầy đủ Họ tên và Email");
                doGet(request, response);
                return;
            }

            if ("create".equals(action) && dao.checkEmail(email)) {
                request.setAttribute("error", "Email đã tồn tại trong hệ thống");
                doGet(request, response);
                return;
            }

            Customer c = new Customer();
            c.setFullName(fullName);
            c.setEmail(email);
            c.setPhoneNumber(phone);
            c.setAddress(address);
            c.setStatus(status);

            if ("create".equals(action)) {
                dao.insert(c);
            }

            if ("update".equals(action)) {
                int id = parseInt(request.getParameter("id"));
                c.setUserId(id);
                Customer oldCustomer = dao.findById(id);
                if (!oldCustomer.getEmail().equals(email) && dao.checkEmail(email)) {
                    request.setAttribute("error", "Email đã tồn tại ở tài khoản khác");
                    doGet(request, response);
                    return;
                }
                dao.update(c);
            }
            response.sendRedirect(request.getContextPath() + "/admin/customers");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi: " + e.getMessage());
            doGet(request, response);
        }
    }
}