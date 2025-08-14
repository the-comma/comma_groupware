package com.example.comma_groupware.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.comma_groupware.domain.Employee;
import com.example.comma_groupware.dto.EmpDeptDeptHistory;

@Controller
public class index {
	public void test3() {
		
		Employee e = new Employee();
		e.setUsername("test");
		
		EmpDeptDeptHistory t = new EmpDeptDeptHistory(e);
	}
	
	@GetMapping({"/","index"})
	public String test2() {
		return "index";
	}
}
