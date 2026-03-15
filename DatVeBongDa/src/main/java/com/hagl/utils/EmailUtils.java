package com.hagl.utils;

import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;

public class EmailUtils {
    public static void sendEmail(String to, String subject, String content) {
        // 1. Khai báo thông tin tài khoản
        final String user = "qanh19098@gmail.com";
        final String pass = "pcmo ockf hmzl qzsu"; // App Password 16 ký tự

        // 2. Cấu hình các thuộc tính kết nối
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true"); // Bắt buộc phải có để bảo mật

        // 3. Tạo phiên làm việc (Session)
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(user, pass);
            }
        });

        // 4. Xây dựng nội dung Email trong một Thread riêng (Để không làm treo trang Web)
        new Thread(() -> {
            try {
                MimeMessage message = new MimeMessage(session);
                message.setFrom(new InternetAddress(user));
                message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
                message.setSubject(subject, "UTF-8");
                message.setContent(content, "text/html; charset=UTF-8");

                Transport.send(message);
                System.out.println("Gửi mail thành công tới: " + to);
            } catch (MessagingException e) {
                e.printStackTrace();
            }
        }).start();
    }
}