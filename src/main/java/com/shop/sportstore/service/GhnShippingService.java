package com.shop.sportstore.service;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.HashMap;
import java.util.Map;

public class GhnShippingService {

    private final String apiToken;
    private final String shopId;
    private static final String API_URL = "https://dev-online-gateway.ghn.vn/shiip/public-api/v2/shipping-order/fee";
    private final HttpClient httpClient;
    private final Gson gson;


    public GhnShippingService(String apiToken, String shopId) {
        this.apiToken = apiToken;
        this.shopId = shopId;
        this.httpClient = HttpClient.newBuilder().connectTimeout(Duration.ofSeconds(10)).build();
        this.gson = new Gson();
    }


    public int calculateShippingFee(int serviceId, int fromDistrictId, String fromWardCode,
                                    int toDistrictId, String toWardCode,
                                    int weight, int length, int width, int height, int insuranceValue) {


        Map<String, Object> requestBodyMap = new HashMap<>();
        requestBodyMap.put("service_id", serviceId);
        requestBodyMap.put("from_district_id", fromDistrictId);
        requestBodyMap.put("from_ward_code", fromWardCode);
        requestBodyMap.put("to_district_id", toDistrictId);
        requestBodyMap.put("to_ward_code", toWardCode);
        requestBodyMap.put("weight", weight);
        requestBodyMap.put("length", length);
        requestBodyMap.put("width", width);
        requestBodyMap.put("height", height);
        requestBodyMap.put("insurance_value", insuranceValue);


        String jsonPayload = gson.toJson(requestBodyMap);

        try {

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(API_URL))
                    .header("Content-Type", "application/json")
                    .header("Token", this.apiToken)
                    .header("ShopId", this.shopId)
                    .POST(HttpRequest.BodyPublishers.ofString(jsonPayload))
                    .build();


            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());


            if (response.statusCode() == 200) {
                JsonObject jsonObject = gson.fromJson(response.body(), JsonObject.class);

                if (jsonObject.get("code").getAsInt() == 200) {
                    JsonObject dataObject = jsonObject.getAsJsonObject("data");
                    return dataObject.get("total").getAsInt();
                }
            }
        } catch (Exception e) {
            System.err.println("Lỗi gọi API Giao Hàng Nhanh: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }
}