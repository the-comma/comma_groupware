package com.example.comma_groupware.security;

import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.NoOpPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;


public class LegacyAwarePasswordEncoder implements PasswordEncoder { // PasswordEncoder 용이하게 변경

    private final PasswordEncoder bcrypt = new BCryptPasswordEncoder(10);
 
	
	@Override // 암호화 
	public String encode(CharSequence rawPassword) { 
		
		return bcrypt.encode(rawPassword);
	}

	@Override  // rawPassword: 사용자가 입력한 평문 비밀번호 , encodedPassword: DB에 저장된 비밀번호  
	public boolean matches(CharSequence rawPassword, String encodedPassword) {  
		if(encodedPassword == null) {
			return false;
		}
		
		if(encodedPassword.startsWith("$2a$") ||
		   encodedPassword.startsWith("$2b$") ||
		   encodedPassword.startsWith("$2y$")
		  ) {
			return bcrypt.matches(rawPassword, encodedPassword);    
		}  else {
			return rawPassword.toString().equals(encodedPassword);
		}
		
		
	}

	
	
}
