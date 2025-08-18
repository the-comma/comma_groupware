package com.example.comma_groupware.security;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.example.comma_groupware.dto.Employee;
import com.example.comma_groupware.mapper.EmployeeMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class CustomUserDetailService implements UserDetailsService {
	private final EmployeeMapper employeeMapper;
	
	public CustomUserDetailService (EmployeeMapper employeeMapper) {
		this.employeeMapper = employeeMapper;
	}

	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		Employee employee = employeeMapper.selectByUserName(username);
		
		
		log.info("employee: " + employee);
	
		if(employee == null) {
			 throw new UsernameNotFoundException(username+ "라는 username이 없습니다.");
			
		}
		
		return new CustomUserDetails(employee);
		
	}
	
	
}
