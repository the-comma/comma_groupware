package com.example.comma_groupware.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ProjectController {

	@GetMapping("projectMain")
	public String projectMain() {
		return "projectMain";
	}
	
	@GetMapping("addProjectForm")
	public String addProjectForm() {
		return "addProjectForm";
	}
}
