package com.example.comma_groupware.controller;

import java.time.LocalDate;
import java.time.LocalDateTime;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.example.comma_groupware.dto.Project;
import com.example.comma_groupware.service.ProjectService;

import jakarta.servlet.http.HttpSession;

@Controller
public class ProjectController {

	ProjectService projectService;
	
	public ProjectController(ProjectService projectService) {
		this.projectService = projectService;
	}
	
	
	@GetMapping("projectMain")
	public String projectMain() {
		return "projectMain";
	}
	
	
	@GetMapping("addProjectForm")
	public String addProjectForm() {
		return "addProjectForm";
	}
	
	@PostMapping("addProjectForm")
	public String addProjectForm(Project project, HttpSession session) {
		
		// project.setPmId(((Employee)session.getAttribute("loginUser")).getEmpId());
		project.setStartDate(LocalDate.now());
		project.setProjectStatus("진행중");
		
		System.out.println(project.getEndDate());
		
		projectService.addProject(project);
		return "redirect:/addProjectForm";
	}
}
