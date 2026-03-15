package com.hagl.filter;



import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@WebFilter("/*")
public class LanguageFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpSession session = request.getSession();

        // 1️⃣ Lấy lang từ URL (?lang=en | ?lang=vi)
        String lang = request.getParameter("lang");

        // 2️⃣ Nếu có truyền lang → set vào session
        if (lang != null) {
            session.setAttribute("lang", lang);
        }

        // 3️⃣ Nếu CHƯA có lang → mặc định VI
        if (session.getAttribute("lang") == null) {
            session.setAttribute("lang", "vi");
        }

        // 4️⃣ TẠO isEn cho JSP dùng
        boolean isEn = "en".equals(session.getAttribute("lang"));
        request.setAttribute("isEn", isEn);

        chain.doFilter(req, res);
    }
}
