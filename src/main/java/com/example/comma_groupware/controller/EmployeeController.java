package com.example.comma_groupware.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class EmployeeController {
	
	@GetMapping("/login") // 로그인 페이지 이동
	public String login() {
		return "login";
	}
	
	@GetMapping("/findPw") // 비밀번호 찾기 페이지 이동
	public String findPw() {
		return "findPw";
	}
	
	@GetMapping("/mainPage")
	public String mainPage() {
		return "mainPage";
	}
	
}
