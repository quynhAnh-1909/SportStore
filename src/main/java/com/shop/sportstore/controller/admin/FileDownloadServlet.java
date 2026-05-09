package com.shop.sportstore.controller.admin;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;

@WebServlet("/image")
public class FileDownloadServlet
        extends HttpServlet {

    protected void doGet(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws IOException{

        String name=
                req.getParameter("name");

        String path=
                getServletContext()
                        .getRealPath("/resources")
                        +File.separator+name;

        FileInputStream in=
                new FileInputStream(path);

        OutputStream out=
                resp.getOutputStream();

        byte[] b=new byte[1024];
        int n;

        while((n=in.read(b))!=-1){
            out.write(b,0,n);
        }

        in.close();
        out.close();
    }
}