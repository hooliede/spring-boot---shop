package com.example.sp.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.firewall.HttpFirewall;
import org.springframework.security.web.firewall.StrictHttpFirewall;

@Configuration
public class SecurityConfig {

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
    
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                .anyRequest().permitAll() // ✅ 모든 요청을 인증 없이 허용
            )
            .csrf(csrf -> csrf.disable()); // ✅ CSRF 비활성화 (운영 환경에서는 활성화 필요)

        return http.build();
    }

    
    // ✅ Spring Security의 `StrictHttpFirewall`을 수정하여 `//` 허용
    @Bean
    public HttpFirewall allowUrlDoubleSlash() {
        StrictHttpFirewall firewall = new StrictHttpFirewall();
        firewall.setAllowUrlEncodedDoubleSlash(true); // ✅ "//" 허용 설정
        return firewall;
    }
}
