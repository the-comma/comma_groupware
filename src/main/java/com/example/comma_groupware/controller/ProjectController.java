package com.example.comma_groupware.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.comma_groupware.dto.Project;
import com.example.comma_groupware.service.DepartmentService;
import com.example.comma_groupware.service.ProjectService;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
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
	
	
	@GetMapping("addProject")
	public String addProjectForm(Model model) {
		// 1. 모달창에 쓸 부서/팀 리스트
		List<Map<String,Object>> deptTeamList = deptService.getDeptTeamList();
		model.addAttribute("deptTeamList",deptTeamList);
		
		return "addProject";
	}
	
	@PostMapping("addProject")
	public String addProjectForm(Project project, HttpSession session
								, @RequestParam List<Integer> feList
								, @RequestParam List<Integer> beList
								, @RequestParam List<Integer> plList) {

		// 1. 프로젝트 폼
		// project.setPmId(((Employee)session.getAttribute("loginUser")).getEmpId());
		project.setPmId(1);	// 임시
		project.setProjectStatus("PROGRESS");
		
		List<Map<String,Object>> memberList = new ArrayList<Map<String,Object>>();
		
		inputMember(memberList, feList, "FE");
		inputMember(memberList, beList, "BE");
		inputMember(memberList, plList, "PL");
		
		// service에 프로젝트랑, 멤버 넘기기
		projectService.addProject(project, memberList);
		
		return "redirect:/addProjectForm";
	}

	// FE, BE, PL 리스트 멤버 리스트에 넣는 메서드
	private void inputMember(List<Map<String,Object>> memberList, List<Integer> inputList , String role) {
		for(Integer empId : inputList) {
			Map<String, Object> emp = new HashMap<>();
			
			emp.put("role", role);
			emp.put("empId", empId);
			
			memberList.add(emp);
		}
	}
}
