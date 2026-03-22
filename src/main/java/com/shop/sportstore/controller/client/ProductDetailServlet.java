package com.shop.sportstore.controller.client;

import com.shop.sportstore.dao.ProductDAO;
import com.shop.sportstore.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

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

        // ✅ Set encoding (tránh lỗi tiếng Việt)
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        try {
            String idRaw = request.getParameter("id");

            // ✅ Validate id
            if (idRaw == null || idRaw.trim().isEmpty()) {
                forwardError(request, response, "Thiếu ID sản phẩm");
                return;
            }

            int id = Integer.parseInt(idRaw);

            Product product = productDAO.getProductById(id);

            // ✅ Check null
            if (product == null) {
                forwardError(request, response, "Không tìm thấy sản phẩm");
                return;
            }

            // ✅ Set data
            request.setAttribute("product", product);

            // 👉 Forward sang JSP
            request.getRequestDispatcher("/productDetail.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            forwardError(request, response, "ID không hợp lệ");

        } catch (Exception e) {
            e.printStackTrace();
            forwardError(request, response, "Lỗi tải chi tiết sản phẩm");
        }
    }

    // ✅ Tách hàm xử lý lỗi cho clean code
    private void forwardError(HttpServletRequest request,
                              HttpServletResponse response,
                              String message)
            throws ServletException, IOException {

        request.setAttribute("errorMessage", message);
        request.getRequestDispatcher("/WEB-INF/views/client/error.jsp")
                .forward(request, response);
    }
}