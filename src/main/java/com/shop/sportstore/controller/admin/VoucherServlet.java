package com.shop.sportstore.controller.admin;

import com.shop.sportstore.dao.VoucherDAO;
import com.shop.sportstore.dao.UserDAO;
import com.shop.sportstore.dao.NotificationDAO;
import com.shop.sportstore.model.Voucher;
import com.shop.sportstore.untils.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import static java.lang.Double.parseDouble;
import static java.lang.Integer.parseInt;

@WebServlet("/admin/vouchers")
public class VoucherServlet extends HttpServlet {


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            Connection conn = DBConnection.getConnection();
            VoucherDAO dao = new VoucherDAO(conn);


            if (action != null && action.equals("delete")) {
                int id = parseInt(request.getParameter("id"));
                dao.delete(id);
                response.sendRedirect("vouchers");
                return;
            }


            if (action != null && action.equals("edit")) {
                int id = parseInt(request.getParameter("id"));
                Voucher v = dao.findById(id);
                request.setAttribute("voucher", v);

                request.setAttribute("contentPage", "/WEB-INF/admin/voucherEdit.jsp");
                request.getRequestDispatcher("/WEB-INF/admin/layout-admin.jsp").forward(request, response);
                return;
            }

            if (action != null && action.equals("create")) {
                request.setAttribute("contentPage", "/WEB-INF/admin/voucherCreate.jsp");
                request.getRequestDispatcher("/WEB-INF/admin/layout-admin.jsp").forward(request, response);
                return;
            }


            List<Voucher> list = dao.getAll();
            request.setAttribute("vouchers", list);

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("contentPage", "/WEB-INF/admin/voucher.jsp");
        request.getRequestDispatcher("/WEB-INF/admin/layout-admin.jsp").forward(request, response);
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            request.setCharacterEncoding("UTF-8");

            Connection conn = DBConnection.getConnection();
            VoucherDAO dao = new VoucherDAO(conn);

            String action = request.getParameter("action");


            String code = request.getParameter("code");
            String type = request.getParameter("type");

            double value = parseDouble(request.getParameter("value"));
            double minOrder = parseDouble(request.getParameter("minOrder"));
            double maxDiscount = parseDouble(request.getParameter("maxDiscount"));
            int quantity = parseInt(request.getParameter("quantity"));

            String payment = request.getParameter("paymentMethod");
            double minProductPrice = parseDouble(request.getParameter("minProductPrice"));

            String cate = request.getParameter("categoryId");
            int categoryId = (cate != null && !cate.isEmpty()) ? parseInt(cate) : 0;


            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date startDate = sdf.parse(request.getParameter("startDate"));
            Date expiryDate = sdf.parse(request.getParameter("expiryDate"));

            boolean status = "true".equals(request.getParameter("status"));


            if (code == null || code.trim().isEmpty()) {
                request.setAttribute("error", "Nhập mã voucher");
                doGet(request, response);
                return;
            }

            if ("create".equals(action) && dao.checkCode(code)) {
                request.setAttribute("error", "Mã đã tồn tại");
                doGet(request, response);
                return;
            }

            if (expiryDate.before(startDate)) {
                request.setAttribute("error", "Ngày không hợp lệ");
                doGet(request, response);
                return;
            }


            Voucher v = new Voucher();
            v.setCode(code);
            v.setDiscountType(type);
            v.setDiscountValue(value);
            v.setMinOrderValue(minOrder);
            v.setMaxDiscount(maxDiscount);
            v.setQuantity(quantity);
            v.setPaymentMethod(payment);
            v.setMinProductPrice(minProductPrice);
            v.setCategoryId(categoryId);
            v.setStartDate(startDate);
            v.setExpiryDate(expiryDate);
            v.setStatus(status);


            if ("create".equals(action)) {

                dao.insert(v);


                try {
                    UserDAO userDAO = new UserDAO();
                    NotificationDAO notificationDAO = new NotificationDAO();

                    List<Integer> allUserIds = userDAO.getAllUserIds();

                    if (allUserIds != null && !allUserIds.isEmpty()) {

                        String discountInfo = "PERCENT".equalsIgnoreCase(v.getDiscountType()) ? (int)v.getDiscountValue() + "%" : (int)v.getDiscountValue() + "đ";

                        for (int uId : allUserIds) {
                            notificationDAO.insertNotification(
                                    uId,
                                    " Tặng bạn mã giảm giá mới",
                                    "Nhập ngay mã '" + v.getCode() + "' để được giảm giá " + discountInfo + " cho đơn hàng của bạn. Số lượng có hạn!",
                                    "/vouchers"
                            );
                        }
                    }
                } catch (Exception ex) {
                    System.out.println("Lỗi kích hoạt tự động bắn thông báo voucher: " + ex.getMessage());
                }
            }


            if ("update".equals(action)) {
                int id = parseInt(request.getParameter("id"));
                v.setId(id);
                dao.update(v);
            }

            response.sendRedirect(request.getContextPath() + "/admin/vouchers");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}