package com.shop.sportstore.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;

@WebServlet("/upload")
@MultipartConfig
public class FileUploadServlet extends HttpServlet {

    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException, ServletException {

        // thư mục lưu ảnh
        String uploadPath =
                getServletContext()
                        .getRealPath("/resources");

        File dir = new File(uploadPath);

        if (!dir.exists()) {
            dir.mkdirs();
        }

        Part part = request.getPart("imageFile");

        String originalName =
                part.getSubmittedFileName();

        String fileName =
                System.currentTimeMillis()
                        + "_" + originalName;

        // lưu file
        part.write(
                uploadPath
                        + File.separator
                        + fileName
        );

        // trả tên file về
        response.getWriter().print(fileName);
    }
}