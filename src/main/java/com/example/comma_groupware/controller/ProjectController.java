package com.example.comma_groupware.controller;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.example.comma_groupware.dto.Project;
import com.example.comma_groupware.service.DepartmentService;
import com.example.comma_groupware.service.ProjectService;

import jakarta.servlet.http.HttpSession;

@Controller
public class ProjectController {

	ProjectService projectService;
	DepartmentService deptService;
	
	public ProjectController(ProjectService projectService, DepartmentService deptService) {
		this.projectService = projectService;
		this.deptService = deptService;
	}
	
	
	@GetMapping("projectMain")
	public String projectMain() {
		return "projectMain";
	}
	
	
	@GetMapping("addProjectForm")
	public String addProjectForm(Model model) {
		// 1. 모달창에 쓸 부서/팀 리스트
		List<Map<String,Object>> deptTeamList = deptService.getDeptTeamList();
		model.addAttribute("deptTeamList",deptTeamList);
		
		return "addProjectForm";
	}
	
	@PostMapping("addProjectForm")
	public String addProjectForm(Project project, HttpSession session) {

		// 1. 프로젝트 폼
		
		// project.setPmId(((Employee)session.getAttribute("loginUser")).getEmpId());
		project.setPmId(1);	// 임시
		project.setProjectStatus("PROGRESS");
		
		projectService.addProject(project);
		
		return "redirect:/addProjectForm";
	}


	private void getDeptTeamList() {
		// TODO Auto-generated method stub
		
	}
}
