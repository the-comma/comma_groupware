package com.example.comma_groupware.restcontroller;


import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.comma_groupware.service.EmployeeService;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api")
public class EmployeeRestController {

	private final EmployeeService employeeService;
	

	public EmployeeRestController(EmployeeService employeeService) {
		this.employeeService = employeeService;
	}
	
	@PostMapping("/auth/check-password")
	public ResponseEntity<?>checkPassword(@RequestParam("new-password") String newPassword, HttpSession session){
		String username =  (String) session.getAttribute("username");
		boolean reused = employeeService.checkPassword(newPassword, username); // 일치여부 결과값 true시 이전비밀번호와 일치
		
		log.info("reused:" + reused);
		
		return ResponseEntity.ok(reused);
		
		
		
		
	}
}
