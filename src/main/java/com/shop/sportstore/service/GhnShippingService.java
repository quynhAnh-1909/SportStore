package com.shop.sportstore.service;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
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

    private static final String BASE_URL =
            "https://dev-online-gateway.ghn.vn/shiip/public-api";

    private final HttpClient httpClient;
    private final Gson gson;

    public GhnShippingService(String apiToken, String shopId) {
        this.apiToken = apiToken;
        this.shopId = shopId;

        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(10))
                .build();

        this.gson = new Gson();
    }

    // ===========================
    // GET SERVICE ID
    // ===========================
    public int getServiceId(int fromDistrictId, int toDistrictId) {

        String api = BASE_URL + "/v2/shipping-order/available-services";

        try {
            Map<String, Object> body = new HashMap<>();
            body.put("shop_id", Integer.parseInt(shopId));
            body.put("from_district", fromDistrictId);
            body.put("to_district", toDistrictId);

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(api))
                    .header("Content-Type", "application/json")
                    .header("Token", apiToken)
                    .POST(HttpRequest.BodyPublishers.ofString(gson.toJson(body)))
                    .build();

            HttpResponse<String> response =
                    httpClient.send(request, HttpResponse.BodyHandlers.ofString());

            JsonObject obj = gson.fromJson(response.body(), JsonObject.class);

            if (obj.get("code").getAsInt() != 200) {
                System.out.println("GHN SERVICE ERROR: " + response.body());
                return -1;
            }

            JsonArray data = obj.getAsJsonArray("data");

            if (data == null || data.isEmpty()) {
                System.out.println("NO SERVICE AVAILABLE");
                return -1;
            }

            return data.get(0)
                    .getAsJsonObject()
                    .get("service_id")
                    .getAsInt();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return -1;
    }

    // ===========================
    // CALCULATE FEE
    // ===========================
    public int calculateShippingFee(
            int fromDistrictId,
            int toDistrictId,
            String toWardCode,
            int weight,
            int length,
            int width,
            int height,
            int insuranceValue
    ) {

        try {

            if (toWardCode == null || toWardCode.isBlank()) {
                throw new RuntimeException("WARD_CODE NULL");
            }

            int serviceId = getServiceId(fromDistrictId, toDistrictId);

            if (serviceId == -1) {
                throw new RuntimeException("NO_SERVICE_AVAILABLE");
            }

            String api = BASE_URL + "/v2/shipping-order/fee";

            Map<String, Object> body = new HashMap<>();
            body.put("service_id", serviceId);
            body.put("service_type_id", 2);

            body.put("from_district_id", fromDistrictId);
            body.put("to_district_id", toDistrictId);
            body.put("to_ward_code", toWardCode);

            body.put("weight", weight);
            body.put("length", length);
            body.put("width", width);
            body.put("height", height);

            body.put("insurance_value", insuranceValue);

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(api))
                    .header("Content-Type", "application/json")
                    .header("Token", apiToken)
                    .header("ShopId", shopId)
                    .POST(HttpRequest.BodyPublishers.ofString(gson.toJson(body)))
                    .build();

            HttpResponse<String> response =
                    httpClient.send(request, HttpResponse.BodyHandlers.ofString());

            JsonObject obj = gson.fromJson(response.body(), JsonObject.class);

            if (obj.get("code").getAsInt() != 200) {
                System.out.println("GHN FEE ERROR: " + response.body());
                return -1;
            }

            return obj.getAsJsonObject("data")
                    .get("total")
                    .getAsInt();

        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }
}