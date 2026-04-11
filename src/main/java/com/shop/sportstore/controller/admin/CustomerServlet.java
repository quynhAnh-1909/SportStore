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

            // DELETE
            if (action != null && action.equals("delete")) {
                int id = parseInt(request.getParameter("id"));
                dao.delete(id);
                response.sendRedirect("customers");
                return;
            }

            // EDIT
            if (action != null && action.equals("edit")) {
                int id = parseInt(request.getParameter("id"));
                Customer c = dao.findById(id);
                request.setAttribute("customer", c);

                request.setAttribute("contentPage", "/WEB-INF/admin/customerEdit.jsp");
                request.getRequestDispatcher("/WEB-INF/admin/dashboard.jsp").forward(request, response);
                return;
            }

            // CREATE PAGE
            if (action != null && action.equals("create")) {
                request.setAttribute("contentPage", "/WEB-INF/admin/customerCreate.jsp");
                request.getRequestDispatcher("/WEB-INF/admin/dashboard.jsp").forward(request, response);
                return;
            }

            // VIEW (Xem chi tiết Profile & Lịch sử mua hàng)
            if (action != null && action.equals("view")) {
                int id = parseInt(request.getParameter("id"));

                // Lấy thông tin cơ bản
                Customer c = dao.findById(id);
                // Lấy thống kê (Tổng đơn, Tổng tiền)
                double[] stats = dao.getCustomerStats(id);
                // Lấy lịch sử đơn hàng
                List<java.util.Map<String, Object>> orderHistory = dao.getOrderHistory(id);

                // Xếp hạng khách hàng đơn giản dựa trên tổng chi tiêu (để JSP hiển thị Badge)
                String rank = "Khách Mới";
                if (stats[1] >= 10000000) rank = "Khách VIP 👑";
                else if (stats[1] >= 2000000) rank = "Khách Thân Thiết 🌟";

                // Đẩy data sang JSP
                request.setAttribute("customer", c);
                request.setAttribute("totalOrders", (int)stats[0]);
                request.setAttribute("totalSpent", stats[1]);
                request.setAttribute("orderHistory", orderHistory);
                request.setAttribute("customerRank", rank); // Gửi rank sang JSP

                request.setAttribute("contentPage", "/WEB-INF/admin/customerDetail.jsp");
                request.getRequestDispatcher("/WEB-INF/admin/dashboard.jsp").forward(request, response);
                return;
            }


            // LIST DEFAULT
            List<Customer> list = dao.getAll();
            request.setAttribute("customers", list);

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("contentPage", "/WEB-INF/admin/customer.jsp");
        request.getRequestDispatcher("/WEB-INF/admin/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            request.setCharacterEncoding("UTF-8");

            Connection conn = DBConnection.getConnection();
            CustomerDAO dao = new CustomerDAO(conn);

            String action = request.getParameter("action");

            // ===== LẤY DATA =====
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");

            // Lấy status (từ checkbox hoặc select)
            boolean status = "true".equals(request.getParameter("status"));

            // ===== VALIDATE =====
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

            // ===== SET OBJECT =====
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
                // Sửa thành setUserId để khớp với Model Customer mới
                c.setUserId(id);

                // Nếu sửa email, cần check xem email mới có bị trùng với user khác không
                Customer oldCustomer = dao.findById(id);
                if (!oldCustomer.getEmail().equals(email) && dao.checkEmail(email)) {
                    request.setAttribute("error", "Email đã tồn tại ở tài khoản khác");
                    doGet(request, response);
                    return;
                }

                dao.update(c);
            }

            // Xử lý xong thì trả về trang danh sách
            response.sendRedirect(request.getContextPath() + "/admin/customers");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi: " + e.getMessage());
            doGet(request, response);
        }
    }
}