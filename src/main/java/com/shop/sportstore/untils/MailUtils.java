package com.shop.sportstore.untils;

import jakarta.mail.*;
import jakarta.mail.internet.*;

import java.util.Properties;

public class MailUtils {

    private static final String EMAIL =
            "nguyenjolly70@gmail.com";

    private static final String APP_PASSWORD =
            "";

    public static void sendOTP(String to, String otp)
            throws Exception {

        Properties props = new Properties();

        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props,
                new Authenticator() {
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(
                                EMAIL,
                                APP_PASSWORD
                        );
                    }
                });

        Message message = new MimeMessage(session);

        message.setFrom(new InternetAddress(EMAIL));

        message.setRecipients(
                Message.RecipientType.TO,
                InternetAddress.parse(to)
        );

        message.setSubject("SportStore OTP Reset Password");

        message.setText(
                "Mã OTP của bạn là: " + otp
        );

        Transport.send(message);
    }

    public static void main(String[] args) throws Exception {
        sendOTP(
                "thuchuynh2223@gmail.com",
                "123456"
        );
    }
}