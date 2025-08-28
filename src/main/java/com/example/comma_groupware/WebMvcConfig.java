package com.example.comma_groupware;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

	// [윤성권] 파일 다운로드 경로 설정
	
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
    	
        // 로컬 경로 → URL 매핑
        registry.addResourceHandler("/upload/**") // URL 패턴
                .addResourceLocations("file:///C:/project/upload/"); // 실제 저장 경로
    }
}
