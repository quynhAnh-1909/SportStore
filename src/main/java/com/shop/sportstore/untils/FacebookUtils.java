package com.shop.sportstore.untils;


import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.shop.sportstore.model.FacebookUser;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;

public class FacebookUtils {

    public static String getToken(String code) throws Exception {

        String appId = "YOUR_FB_APP_ID";
        String appSecret = "YOUR_FB_SECRET";
        String redirectUri = "http://localhost:8080/your-app/login-facebook";

        String link = "https://graph.facebook.com/v18.0/oauth/access_token?"
                + "client_id=" + appId
                + "&redirect_uri=" + redirectUri
                + "&client_secret=" + appSecret
                + "&code=" + code;

        URL url = new URL(link);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();

        BufferedReader reader = new BufferedReader(
                new InputStreamReader(conn.getInputStream())
        );

        StringBuilder response = new StringBuilder();
        String line;

        while ((line = reader.readLine()) != null) {
            response.append(line);
        }

        Gson gson = new Gson();
        return gson.fromJson(response.toString(), JsonObject.class)
                .get("access_token").getAsString();
    }

    public static FacebookUser getUserInfo(String accessToken) throws Exception {

        String link = "https://graph.facebook.com/me?fields=id,name,email,picture"
                + "&access_token=" + accessToken;

        URL url = new URL(link);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();

        BufferedReader reader = new BufferedReader(
                new InputStreamReader(conn.getInputStream())
        );

        StringBuilder response = new StringBuilder();
        String line;

        while ((line = reader.readLine()) != null) {
            response.append(line);
        }

        Gson gson = new Gson();
        return gson.fromJson(response.toString(), FacebookUser.class);
    }
}