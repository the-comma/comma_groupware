package com.example.comma_groupware.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.comma_groupware.dto.Page;
import com.example.comma_groupware.service.DepartmentService;
import com.example.comma_groupware.service.EmployeeService;

@Controller
public class EmployeeController {

	// Service
	EmployeeService employeeService;
	DepartmentService deptmentService;
	
	// 생성자
	public EmployeeController(EmployeeService employeeService, DepartmentService deptmentService) {
		this.employeeService = employeeService;
		this.deptmentService = deptmentService;
	}
	
	// 조직도 페이지
	@GetMapping("organizationChart")
	public String organizationChart(Model model,
									@RequestParam(required = false) Integer page,
									@RequestParam(defaultValue = "") String name,
									@RequestParam(defaultValue = "") String dept,
									@RequestParam(defaultValue = "") String team) {
		if(page == null) page = 0;
		
		List<Map<String,Object>> deptTeamList = deptmentService.getDeptTeamList();

		// 부서 리스트
		Map<String,List<String>> deptTeam = new HashMap<>();
		
		for(Map<String,Object> dt : deptTeamList) {
			String key = (String) dt.get("deptName");
			String val = (String) dt.get("teamName");
			if(deptTeam.containsKey(key)) {
				deptTeam.get(key).add(val);
			}
			else {
				List<String> list = new ArrayList<>();
				list.add(val);
				deptTeam.put(key, list);
			}
		}
		
		int totalCount = employeeService.organizationListCount(name, team, dept);
		Page p = new Page(10,page,totalCount,name);
		List<Map<String,Object>> organiList = employeeService.organizationList(p);
		model.addAttribute("organiList",organiList);
		model.addAttribute("deptTeam",deptTeam);
		model.addAttribute("name", name);
		model.addAttribute("page", p);
		return "organizationChart";
	}
}
