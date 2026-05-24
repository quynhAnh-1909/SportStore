package com.shop.sportstore.controller.client;

import com.shop.sportstore.service.GhnShippingService;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

@WebServlet("/api/ghn/ward")
public class GhnWardServlet extends HttpServlet {

    private static final String TOKEN = "xxx";

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        String districtId = req.getParameter("districtId");

        String api = "https://dev-online-gateway.ghn.vn/shiip/public-api/master-data/ward?district_id="
                + districtId;

        HttpURLConnection conn = (HttpURLConnection) new URL(api).openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Token", TOKEN);

        BufferedReader br = new BufferedReader(
                new InputStreamReader(conn.getInputStream())
        );

        resp.getWriter().write(br.lines().reduce("", String::concat));
    }
}