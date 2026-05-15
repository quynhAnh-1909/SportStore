package com.shop.sportstore.controller.client;

import com.shop.sportstore.dao.ProductDAO;
import com.shop.sportstore.model.Product;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/searchSuggestion")
public class SearchSuggestionServlet extends HttpServlet {

    private ProductDAO productDAO;

    @Override
    public void init() {
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws IOException {

        String keyword = request.getParameter("keyword");

        List<Product> list =
                productDAO.searchSuggestions(keyword);

        response.setContentType("text/html;charset=UTF-8");

        PrintWriter out = response.getWriter();

        for (Product p : list) {

            out.println("""
                    <div class="suggestion-item"
                         onclick="goToProduct(%d)">
                
                        <img src="%s/resources/%s"
                             class="suggestion-img">
                
                        <div class="suggestion-info">
                
                            <div class="suggestion-name">
                                %s
                            </div>
                
                            <div class="suggestion-price">
                                %,.0f VNĐ
                            </div>
                
                        </div>
                
                    </div>
                """.formatted(
                    p.getId(),
                    request.getContextPath(),
                    p.getImageUrl(),
                    p.getName(),
                    p.getPrice()
            ));
        }
    }
}