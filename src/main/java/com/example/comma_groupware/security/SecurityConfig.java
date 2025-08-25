package com.example.comma_groupware.security;

import java.util.HashMap;

import jakarta.servlet.DispatcherType;
import jakarta.servlet.http.HttpSession;

import org.springframework.cglib.proxy.Dispatcher;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractConfigAttributeRequestMatcherRegistry;
import org.springframework.security.config.annotation.web.configurers.CsrfConfigurer;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.factory.PasswordEncoderFactories;
import org.springframework.security.crypto.password.DelegatingPasswordEncoder;
import org.springframework.security.crypto.password.NoOpPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.w3c.dom.Node;

import com.example.comma_groupware.CommaGroupwareApplication;

@Configuration
@EnableWebSecurity
public class SecurityConfig {


	
	@Bean  // 암호화 등록
	public PasswordEncoder passwordEncoder() { 
		
		return new LegacyAwarePasswordEncoder();
	}
	
	

	
	
	@Bean
	SecurityFilterChain securityFilterChain(HttpSecurity httpSecurity) throws Exception {
		
		// 토큰 비활성화
		httpSecurity.csrf((csrfConfigurer) -> csrfConfigurer.disable());
		
		httpSecurity.authorizeHttpRequests(requestMatcherRegistry -> requestMatcherRegistry
			    .dispatcherTypeMatchers(DispatcherType.FORWARD, DispatcherType.ERROR).permitAll() //  JSP forward 허용
			    .requestMatchers("/login", "/loginAction", "/findPw", "/login-pin/**", "/resetPw", "/stomp/chat/**",
			                     "/css/**", "/js/**", "/images/**", "/webjars/**", "/favicon.ico", "/HTML/Admin/dist/assets/**" , "/static/assets/**").permitAll()
				/* .requestMatchers("/user/**").hasRole(null)  역할부여 필요 */ 
			    .anyRequest().authenticated()
			);
		
		
		httpSecurity.formLogin(form ->
	    form.loginPage("/login")             // 로그인 페이지
	        .loginProcessingUrl("/loginAction")  
	        .successHandler((request, res, auth) ->{
	        	CustomUserDetails userDetails =  (CustomUserDetails) auth.getPrincipal();
	        	HttpSession session = request.getSession();
	        	session.setAttribute("username", userDetails.getUsername());
	        	if(userDetails.getUsername().equals(userDetails.getPassword())) {
	        		res.sendRedirect("/resetPw");
	        		return;
	        	}
	        	res.sendRedirect("/mainPage");
	        })
	        .failureHandler((req, res, ex) -> {
	            ex.printStackTrace();                     
	            res.sendRedirect("/login?error=true");
	        })
	        
		);

		httpSecurity.logout((LogoutConfigurer) -> 
				LogoutConfigurer.logoutUrl("/logout")
				.invalidateHttpSession(true)
				.logoutSuccessUrl("/login"));
				
	
		// httpSecurity 설정후 빌드하여 SecurityFilterChain 형태로 반환
		return httpSecurity.build();  
		
		}
		
		
	}

	

