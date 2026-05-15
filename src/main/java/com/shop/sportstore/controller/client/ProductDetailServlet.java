package com.shop.sportstore.controller.client;

import com.shop.sportstore.dao.ProductDAO;
import com.shop.sportstore.dao.ProductVoucherDAO;
import com.shop.sportstore.dao.ReviewDAO;
import com.shop.sportstore.dao.VoucherDAO;
import com.shop.sportstore.model.Product;
import com.shop.sportstore.model.Review;
import com.shop.sportstore.model.Voucher;
import com.shop.sportstore.untils.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/productDetail")
public class ProductDetailServlet extends HttpServlet {

    private ProductDAO productDAO;

    @Override
    public void init() {
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        try {
            String idRaw = request.getParameter("id");
            if (idRaw == null || idRaw.trim().isEmpty()) {
                forwardError(request, response, "Thiếu ID sản phẩm");
                return;
            }

            int id = Integer.parseInt(idRaw);

            Product product = productDAO.getProductById(id);

            if (product == null) {
                forwardError(request, response, "Không tìm thấy sản phẩm");
                return;
            }
            Connection conn = DBConnection.getConnection();
            ProductVoucherDAO pvDAO = new ProductVoucherDAO(conn);
            List<Voucher> vouchers = pvDAO.getVouchersByProduct(id);
            product.setVouchers(vouchers);
            request.setAttribute("product", product);

            List<Product> relatedProducts = productDAO.getAll();

            relatedProducts.removeIf(p -> p.getId() == id);

//            String showAll = request.getParameter("showAll");

            request.setAttribute("relatedProducts", relatedProducts);

            ReviewDAO reviewDAO = new ReviewDAO();

            List<Review> reviews =
                    reviewDAO.getReviewsByProduct(id);

            request.setAttribute("reviews", reviews);


//            request.setAttribute("showAll", showAll);
            request.getRequestDispatcher("/productDetail.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            forwardError(request, response, "ID không hợp lệ");

        } catch (Exception e) {
            e.printStackTrace();
            forwardError(request, response, "Lỗi tải chi tiết sản phẩm");
        }

    }

    private void forwardError(HttpServletRequest request,
                              HttpServletResponse response,
                              String message)
            throws ServletException, IOException {

        request.setAttribute("errorMessage", message);
        request.getRequestDispatcher("/WEB-INF/views/client/error.jsp")
                .forward(request, response);
    }

}