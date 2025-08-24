package com.example.comma_groupware.service;


import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.comma_groupware.dto.Employee;
import com.example.comma_groupware.mapper.EmployeeMapper;





@Service
public class EmployeeService {

	private final EmployeeMapper employeeMapper;
	private final PasswordEncoder passwordEncoder;
	private final JavaMailSender mailSender;
	private final JwtEmailOtpService otpService;


	
	
	public EmployeeService(EmployeeMapper employeeMapper,
			PasswordEncoder passwordEncoder
			,JavaMailSender mailSender 
			,JwtEmailOtpService otpService
			)
	{
		this.employeeMapper = employeeMapper;
		this.passwordEncoder = passwordEncoder;
		this.mailSender = mailSender;
		this.otpService = otpService;
		

	}

	// 비밀번호 변경
	public void updatePw(String password, String username) { 
		String encodePw = passwordEncoder.encode(password); // 패스워드 암호화
		employeeMapper.updatePw(encodePw, username);
		
	}
	
	// 비밀번호 확인
	public boolean checkPassword(String newPassword, String username) { // 비밀번호 변경
		Employee employee = employeeMapper.selectByUserName(username);
	
		
		if(passwordEncoder.matches(newPassword, employee.getPassword())){ // 이전 비밀번호와 동일한 패스워드인지 확인
		return true;
		} 
		
		
		return false;
	}

	// 이메일 보내기
	public Map<String, Object> sendEmail(String username, String email) {
		int row =employeeMapper.existsByEmail(email);
		if(row == 0) { // 존재하는 이메일 0개면 반환
			throw new IllegalArgumentException("이메일이 존재하지 않습니다.");
		}
		
		
		var issue  = otpService.issue(email, "RESET_PW", 300); // 유효시간 : 5분
		
		SimpleMailMessage msg = new SimpleMailMessage();
		msg.setTo(email);
		msg.setSubject("[비밀번호 찾기] 이메일 인증 코드");
		msg.setText("""
				안녕하세요, %s 님.
				
				아래 6자리 인증코드를 입력해주세요.
				
				인증코드: %s
				유효시간: %d분
				
				본 메일을 요청하지 않으셨다면 이 메시지를 무시하세요.
				
				""".formatted(username, issue.code(), issue.ttlSeconds()/60));   // 메세지 내용
		
		 mailSender.send(msg);
				
		 return Map.of(
				 "token" , issue.token(),
				 "ttlSeconds" , issue.ttlSeconds()
				 );
		
	}
	
	// 사원 휴대폰, 이메일 정보 가져오기
	public Employee selectEmpInfo(String username) {
		Employee employee = employeeMapper.selectByUserName(username);
		
		return employee;
	}

	public void updateInfo(String username, String email, String phone) {
		employeeMapper.updateInfo(username,email,phone);
	}




 
}
	

