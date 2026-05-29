package com.shop.sportstore.service;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.shop.sportstore.model.Order;
import com.shop.sportstore.model.OrderDetail;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

public class GhnOrderService {

    private static final String API_URL =
            "https://dev-online-gateway.ghn.vn/shiip/public-api/v2/shipping-order/create";

    private final HttpClient client =
            HttpClient.newHttpClient();

    private final Gson gson =
            new Gson();

    private final String token;

    private final String shopId;

    public GhnOrderService(
            String token,
            String shopId
    ) {

        this.token = token;
        this.shopId = shopId;
    }

    public String createOrder(Order order) {

        try {

            JsonObject body = new JsonObject();

            /* =========================
               SHOP INFO
            ========================= */

            body.addProperty(
                    "from_name",
                    "SportStore"
            );

            body.addProperty(
                    "from_phone",
                    "0388035132"
            );

            body.addProperty(
                    "from_address",
                    "Đại Học Nông Lâm - Quốc Lộ 1, Đông Hòa, Dĩ An, Bình Dương"
            );

            body.addProperty(
                    "from_ward_name",
                    "Đông Hòa"
            );

            body.addProperty(
                    "from_district_name",
                    "Dĩ An"
            );

            body.addProperty(
                    "from_province_name",
                    "Bình Dương"
            );

            /* =========================
               CUSTOMER INFO
            ========================= */

            String phone =
                    order.getReceiverPhone()
                            .replaceAll("[^0-9]", "");

            body.addProperty(
                    "to_name",
                    order.getReceiverName()
            );

            body.addProperty(
                    "to_phone",
                    phone
            );

            body.addProperty(
                    "to_address",
                    order.getAddress()
            );

            body.addProperty("to_district_id", order.getDistrictId());
            body.addProperty("to_ward_code", order.getWardCode());

            /* =========================
               ORDER INFO
            ========================= */

            body.addProperty(
                    "client_order_code",
                    order.getOrderCode()
            );

            body.addProperty(
                    "payment_type_id",
                    2
            );

            body.addProperty(
                    "required_note",
                    "KHONGCHOXEMHANG"
            );

            body.addProperty(
                    "note",
                    order.getNote() != null
                            ? order.getNote()
                            : ""
            );

            int codAmount = "COD".equals(order.getPaymentMethod())
                    ? (int) order.getTotalPrice()
                    : 0;
            body.addProperty(
                    "cod_amount",
                    codAmount
            );

            /* =========================
               SERVICE
            ========================= */

            body.addProperty(
                    "service_type_id",
                    2
            );

            /* =========================
               SIZE
            ========================= */

            body.addProperty(
                    "weight",
                    1000
            );

            body.addProperty(
                    "length",
                    20
            );

            body.addProperty(
                    "width",
                    20
            );

            body.addProperty(
                    "height",
                    10
            );

            body.addProperty(
                    "insurance_value",
                    (int) order.getTotalPrice()
            );

            /* =========================
               PICK SHIFT
            ========================= */

            JsonArray shift =
                    new JsonArray();

            shift.add(2);

            body.add("pick_shift", shift);

            /* =========================
               ITEMS
            ========================= */

            JsonArray items =
                    new JsonArray();

            if (order.getOrderDetails() != null) {

                for (OrderDetail detail
                        : order.getOrderDetails()) {

                    JsonObject item =
                            new JsonObject();

                    item.addProperty(
                            "name",
                            detail.getProduct().getName()
                    );

                    item.addProperty(
                            "quantity",
                            detail.getQuantity()
                    );

                    item.addProperty(
                            "price",
                            (int) detail.getPrice()
                    );

                    item.addProperty(
                            "length",
                            20
                    );

                    item.addProperty(
                            "width",
                            20
                    );

                    item.addProperty(
                            "height",
                            10
                    );

                    item.addProperty(
                            "weight",
                            500
                    );

                    items.add(item);
                }
            }

            body.add("items", items);

            /* =========================
               DEBUG
            ========================= */

            System.out.println(
                    "TOKEN = " + token
            );

            System.out.println(
                    "SHOP_ID = " + shopId
            );

            System.out.println(
                    "GHN JSON = "
                            + gson.toJson(body)
            );

            /* =========================
               SEND REQUEST
            ========================= */

            HttpRequest request =
                    HttpRequest.newBuilder()

                            .uri(
                                    URI.create(API_URL)
                            )

                            .header(
                                    "Content-Type",
                                    "application/json"
                            )

                            .header(
                                    "Token",
                                    token
                            )

                            .header(
                                    "ShopId",
                                    shopId
                            )

                            .POST(
                                    HttpRequest
                                            .BodyPublishers
                                            .ofString(
                                                    gson.toJson(body)
                                            )
                            )

                            .build();

            HttpResponse<String> response =
                    client.send(
                            request,
                            HttpResponse
                                    .BodyHandlers
                                    .ofString()
                    );

            System.out.println(
                    "GHN RESPONSE = "
                            + response.body()
            );

            JsonObject res =
                    gson.fromJson(
                            response.body(),
                            JsonObject.class
                    );

            if (res.has("code")
                    && res.get("code").getAsInt() == 200) {

                return res
                        .getAsJsonObject("data")
                        .get("order_code")
                        .getAsString();
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return null;
    }

    public String getOrderTracking(String ghnCode) throws Exception {
        String apiUrl = "https://dev-online-gateway.ghn.vn/shiip/public-api/v2/shipping-order/detail";

        URL url = new URL(apiUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setRequestProperty("Token", this.token);
        conn.setDoOutput(true);
        String jsonInputString = "{\"order_code\": \"" + ghnCode + "\"}";

        try (OutputStream os = conn.getOutputStream()) {
            byte[] input = jsonInputString.getBytes("utf-8");
            os.write(input, 0, input.length);
        }
        int responseCode = conn.getResponseCode();
        if (responseCode == HttpURLConnection.HTTP_OK) {
            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"));
            String inputLine;
            StringBuilder response = new StringBuilder();

            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
            in.close();
            return response.toString();
        } else {
            throw new RuntimeException("Lỗi khi tra cứu GHN, HTTP Code: " + responseCode);
        }
    }
}