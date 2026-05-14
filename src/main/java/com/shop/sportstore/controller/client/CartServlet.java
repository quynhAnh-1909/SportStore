package com.shop.sportstore.controller.client;

import com.shop.sportstore.dao.ProductDAO;
import com.shop.sportstore.model.CartItem;
import com.shop.sportstore.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    private ProductDAO productDAO;

    @Override
    public void init() {
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        HttpSession session = request.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if(cart == null){
            cart = new ArrayList<>();
        }
        if ("get".equals(action)) {

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            StringBuilder json = new StringBuilder("[");

            for (int i = 0; i < cart.size(); i++) {
                CartItem item = cart.get(i);

                String context = request.getContextPath();

                json.append("{")
                        .append("\"id\":").append(item.getProduct().getId()).append(",")
                        .append("\"name\":\"").append(item.getProduct().getName()).append("\",")
                        .append("\"image\":\"")
                        .append(item.getProduct().getImageUrl())
                        .append("\",")
                        .append("\"price\":").append(item.getProduct().getPrice()).append(",")
                        .append("\"quantity\":").append(item.getQuantity())
                        .append("}");

                if (i < cart.size() - 1) json.append(",");
            }

            json.append("]");

            response.getWriter().write(json.toString());
            return; // 🔥 QUAN TRỌNG
        }

        if ("count".equals(action)) {
            int total = cart.stream().mapToInt(CartItem::getQuantity).sum();
            response.getWriter().print(total);
            return;
        }

        if("remove".equals(action)){

            int id = Integer.parseInt(request.getParameter("id"));

            cart.removeIf(item -> item.getProduct().getId() == id);
        }

        session.setAttribute("cart",cart);

        request.getRequestDispatcher("/WEB-INF/client/cart.jsp")
                .forward(request,response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String action = request.getParameter("action");

        HttpSession session = request.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (cart == null) cart = new ArrayList<>();

        // COUNT (AJAX)
        if ("count".equals(action)) {
            int total = cart.stream().mapToInt(CartItem::getQuantity).sum();
            response.getWriter().print(total);
            return;
        }

        int productId = Integer.parseInt(request.getParameter("productId"));

        // ADD
        if ("add".equals(action)) {
            Product product = productDAO.getProductById(productId);

            boolean found = false;

            for (CartItem item : cart) {
                if (item.getProduct().getId() == productId) {
                    item.setQuantity(item.getQuantity() + 1);
                    found = true;
                    break;
                }
            }

            if (!found) cart.add(new CartItem(product, 1));
        }

        // UPDATE
        if ("update".equals(action)) {
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            for (CartItem item : cart) {
                if (item.getProduct().getId() == productId) {
                    item.setQuantity(quantity);
                }
            }
        }

        // REMOVE
        if ("remove".equals(action)) {
            cart.removeIf(i -> i.getProduct().getId() == productId);
        }

        session.setAttribute("cart", cart);
        if ("update".equals(action) || "add".equals(action) || "remove".equals(action)) {
            response.setContentType("text/plain");
            response.getWriter().print("OK");
            return;
        }
        response.sendRedirect(request.getContextPath() + "/cart");
    }
}