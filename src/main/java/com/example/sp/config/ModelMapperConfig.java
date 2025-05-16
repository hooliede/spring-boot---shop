package com.example.sp.config;

import org.modelmapper.ModelMapper;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;


/* modelmapper : 객체 간의 (entity와 dto)데이터 변환 자동화 + 자동 매핑 */


/*  Bean을 정의하는 설정 클래스 */
@Configuration
public class ModelMapperConfig {
	
	@Bean
	ModelMapper modelMapper() {
		return new ModelMapper();
	}
}
