package com.hagl.controller.client;

import com.hagl.dao.ProductDAO;
import com.hagl.model.CartItem;
import com.hagl.model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.*;

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

        if("remove".equals(action)){

            int id = Integer.parseInt(request.getParameter("id"));

            cart.removeIf(item -> item.getProduct().getId() == id);
        }

        session.setAttribute("cart",cart);

        request.getRequestDispatcher("/WEB-INF/views/client/cart.jsp")
               .forward(request,response);
    }

    @Override
    protected void doPost(HttpServletRequest request,HttpServletResponse response)
            throws ServletException,IOException{

        String action = request.getParameter("action");

        HttpSession session = request.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if(cart == null){
            cart = new ArrayList<>();
        }

        int productId = Integer.parseInt(request.getParameter("productId"));

        try{
        	if("count".equals(action)){

        	    int total = 0;

        	    for(CartItem item : cart){
        	        total += item.getQuantity();
        	    }

        	    response.setContentType("text/plain");
        	    response.getWriter().print(total);
        	    return;
        	}

            if("add".equals(action)){

                Product product = productDAO.getProductById(productId);

                boolean found = false;

                for(CartItem item : cart){

                    if(item.getProduct().getId()==productId){

                        item.setQuantity(item.getQuantity()+1);
                        found = true;
                        break;
                    }
                }

                if(!found){
                    cart.add(new CartItem(product,1));
                }
            }

            if("update".equals(action)){

                int quantity = Integer.parseInt(request.getParameter("quantity"));

                for(CartItem item : cart){

                    if(item.getProduct().getId()==productId){

                        item.setQuantity(quantity);
                    }
                }
            }

        }catch(SQLException e){
            e.printStackTrace();
        }

        session.setAttribute("cart", cart);

        response.sendRedirect(
            request.getContextPath() + "/productDetail?id=" + productId);
    }
}