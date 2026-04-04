package com.shop.sportstore.untils;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.shop.sportstore.model.GoogleUser;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;

public class GoogleUtils {

    private static final String CLIENT_ID = "YOUR_CLIENT_ID";
    private static final String CLIENT_SECRET = "YOUR_CLIENT_SECRET";
    private static final String REDIRECT_URI = "http://localhost:8080/your-app/login-google";

    public static String getToken(String code) throws Exception {

        String url = "https://oauth2.googleapis.com/token";

        String params = "code=" + code
                + "&client_id=" + CLIENT_ID
                + "&client_secret=" + CLIENT_SECRET
                + "&redirect_uri=" + REDIRECT_URI
                + "&grant_type=authorization_code";

        URL obj = new URL(url);
        HttpURLConnection conn = (HttpURLConnection) obj.openConnection();

        conn.setRequestMethod("POST");
        conn.setDoOutput(true);

        OutputStreamWriter writer = new OutputStreamWriter(conn.getOutputStream());
        writer.write(params);
        writer.flush();

        BufferedReader reader = new BufferedReader(
                new InputStreamReader(conn.getInputStream())
        );

        StringBuilder response = new StringBuilder();
        String line;

        while ((line = reader.readLine()) != null) {
            response.append(line);
        }

        Gson gson = new Gson();
        JsonObject json = gson.fromJson(response.toString(), JsonObject.class);

        return json.get("access_token").getAsString();
    }

    public static GoogleUser getUserInfo(String accessToken) throws Exception {

        String url = "https://www.googleapis.com/oauth2/v2/userinfo?access_token=" + accessToken;

        URL obj = new URL(url);
        HttpURLConnection conn = (HttpURLConnection) obj.openConnection();

        BufferedReader reader = new BufferedReader(
                new InputStreamReader(conn.getInputStream())
        );

        StringBuilder response = new StringBuilder();
        String line;

        while ((line = reader.readLine()) != null) {
            response.append(line);
        }

        Gson gson = new Gson();

        return gson.fromJson(response.toString(), GoogleUser.class);
    }
}