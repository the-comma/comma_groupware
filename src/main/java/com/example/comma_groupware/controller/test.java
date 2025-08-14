package com.example.comma_groupware.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class test {
	
	@GetMapping({"/","index"})
	public String index() {
		return "index";
	}
}
