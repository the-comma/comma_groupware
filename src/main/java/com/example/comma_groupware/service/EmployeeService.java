package com.example.comma_groupware.service;

import org.springframework.beans.factory.annotation.Autowired;
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
	
	
	public EmployeeService(EmployeeMapper employeeMapper, PasswordEncoder passwordEncoder
			,JavaMailSender mailSender ) {
		this.employeeMapper = employeeMapper;
		this.passwordEncoder = passwordEncoder;
		this.mailSender = mailSender;
	}

	// 비밀번호 변경
	public void updatePw(String password, String username) { 
		String encodePw = passwordEncoder.encode(password); // 패스워드 암호화
		employeeMapper.updatePw(encodePw, username);
		
	}

	public boolean checkPassword(String newPassword, String username) { // 비밀번호 변경
		Employee employee = employeeMapper.selectByUserName(username);
	
		
		if(passwordEncoder.matches(newPassword, employee.getPassword())){ // 이전 비밀번호와 동일한 패스워드인지 확인
		return true;
		} 
		
		
		return false;
	}

	public void sendEmail(String username, String email) { // 이메일 보내기
		
		int row =employeeMapper.existsByEmail(email);
		if(row == 0) { // 존재하는 이메일 0개면 반환
			return;
		}
		
	}

	
	
	
	
}
