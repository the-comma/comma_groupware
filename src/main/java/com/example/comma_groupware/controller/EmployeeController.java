package com.example.comma_groupware.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.comma_groupware.service.EmployeeService;

import jakarta.servlet.http.HttpSession;

@Controller
public class EmployeeController {
	private final EmployeeService employeeService;
	
	public EmployeeController(EmployeeService employeeService) {
		this.employeeService = employeeService;
	}
	
	@GetMapping("/login") // 로그인 페이지 이동
	public String login() {
		return "login";
	}
	
	@GetMapping("/findPw") // 비밀번호 찾기 페이지 이동
	public String findPw() {
		return "findPw";
	}
	
	@GetMapping("/mainPage") // 메인페이지로 이동
	public String mainPage() {
		return "mainPage";
	}
	
	@GetMapping("/resetPw") // 비밀번호 재설정 페이지로 이동
	public String createPw() {
		return "resetPw";
	}
	
	
	@PostMapping("/findPw")
	public String findPw(@RequestParam("username") String username, @RequestParam("emp_email") String email) {
		employeeService.sendEmail(username,email);
		
		return email;
		
	}
	
	
	@PostMapping("/resetPw") // 비밀번호 재설정
	public String resetPw(@RequestParam("new-password") String password, HttpSession session) {
		String username = (String) session.getAttribute("username");
		employeeService.updatePw(password, username);
		
		session.invalidate();
		return "redirect:/login";
	}
	
	
}
