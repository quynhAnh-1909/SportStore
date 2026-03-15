package com.hagl.controller.admin;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.hagl.dao.OrderDAO;
import com.hagl.dao.ProductDAO;
import com.hagl.dao.TicketDAO;
import com.hagl.model.User;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		ProductDAO productDAO = new ProductDAO();
		OrderDAO orderDAO = new OrderDAO();

//		request.setAttribute("productCount", productDAO.countProducts(null, null));
//		request.setAttribute("orderCount", orderDAO.countOrders());
//		request.setAttribute("revenue", orderDAO.totalRevenue());

		request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp")
				.forward(request, response);
	}
}