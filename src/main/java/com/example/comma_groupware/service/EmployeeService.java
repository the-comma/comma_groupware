package com.example.comma_groupware.service;

import org.springframework.stereotype.Service;

import com.example.comma_groupware.mapper.EmployeeMapper;

@Service
public class EmployeeService {

	private final EmployeeMapper employeeMapper;
	
	public EmployeeService(EmployeeMapper employeeMapper) {
		this.employeeMapper = employeeMapper;
	}
	
	
	
}
