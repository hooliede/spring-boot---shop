package com.example.sp.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        String os = System.getProperty("os.name").toLowerCase();
        System.out.println("현재 운영체제: " + os);  // 로그로 확인

        if (os.contains("win")) {
            // Windows 환경
            registry.addResourceHandler("/product/**")
                    .addResourceLocations("file:///C:/upload/product/");
            registry.addResourceHandler("/board/**")
                    .addResourceLocations("file:///C:/upload/board/");
            registry.addResourceHandler("/img/**")
                    .addResourceLocations("classpath:/static/img/");
        } else {
            // Ubuntu 환경
            registry.addResourceHandler("/product/**")
                    .addResourceLocations("file:/home/ubuntu/sp-images/");
            registry.addResourceHandler("/img/**")
                    .addResourceLocations("file:/home/ubuntu/sp-images/");
        }

        // 공통 리소스
        registry.addResourceHandler("/css/**")
                .addResourceLocations("classpath:/static/css/");
    }

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/reply/**")
                .allowedOrigins("http://localhost:8080")
                .allowedMethods("POST", "GET", "PUT", "DELETE");
    }
}

