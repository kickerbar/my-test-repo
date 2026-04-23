package com.example;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import java.net.InetAddress;

@RestController
public class WebController {

    @GetMapping("/")
    public String home() {
        try {
            String hostName = InetAddress.getLocalHost().getHostName();
            String ip = InetAddress.getLocalHost().getHostAddress();

            return "<div style='text-align:center; margin-top:50px; font-family:sans-serif;'>" +
                   "<h1>🚀 CI/CD 배포 성공!</h1>" +
                   "<hr style='width:50%'>" +
                   "<h3>현재 응답 중인 서버 정보</h3>" +
                   "<p><b>Host Name:</b> " + hostName + "</p>" +
                   "<p><b>IP Address:</b> " + ip + "</p>" +
                   "<p style='color:blue;'>Apache Reverse Proxy를 통해 정상 연결되었습니다.</p>" +
                   "</div>";
        } catch (Exception e) {
            return "Hello Jenkins! (Error getting host info)";
        }
    }
}
