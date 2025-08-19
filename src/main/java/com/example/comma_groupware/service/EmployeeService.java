package com.example.comma_groupware.service;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.comma_groupware.dto.Employee;
import com.example.comma_groupware.mapper.EmployeeMapper;
import com.example.comma_groupware.security.LegacyAwarePasswordEncoder;


@Service
public class EmployeeService {

	private final EmployeeMapper employeeMapper;
	private final PasswordEncoder passwordEncoder;
	
	public EmployeeService(EmployeeMapper employeeMapper, PasswordEncoder passwordEncoder) {
		this.employeeMapper = employeeMapper;
		this.passwordEncoder = passwordEncoder; 
	}

	// 비밀번호 변경
	public void updatePw(String password, String username) { 
		String encodePw = passwordEncoder.encode(password); // 패스워드 암호화
		employeeMapper.updatePw(encodePw, username);
		
	}

	public boolean checkPassword(String newPassword, String username) {
		Employee employee = employeeMapper.selectByUserName(username);
	
		
		if(passwordEncoder.matches(newPassword, employee.getPassword())){
		return true;
		} 
		
		
		return false;
	}

	
	
	
	
}
