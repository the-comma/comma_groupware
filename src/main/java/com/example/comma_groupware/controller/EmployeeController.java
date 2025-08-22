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
	
	// 템플릿 테스트
	@GetMapping("temp")
	public String newFile() {
		return "temp";
	}
	
	// 사원카드 페이지
	@GetMapping("employeeCard")
	public String employeeCard(Model model,
			@RequestParam Integer id) {
		
		// 해당 사원 한 명 조회
		Map<String,Object> emp = employeeService.employeeCard(id);
		model.addAttribute("emp",emp);
		
		return "employeeCard";
	}
	
	// 조직도 페이지
	@GetMapping("organizationChart")
	public String organizationChart(Model model,
									@RequestParam(required = false) Integer page,
									@RequestParam(defaultValue = "") String name,
									@RequestParam(defaultValue = "") String dept,
									@RequestParam(defaultValue = "") String team,
									@RequestParam(defaultValue = "") String order,
									@RequestParam(defaultValue = "") String sort) {
		
		// 현재 페이지값 없을때 defaultValue
		if(page == null) page = 0;
		
		// 받아온 부서/팀 리스트
		List<Map<String,Object>> deptTeamList = deptmentService.getDeptTeamList();

		// 분류 리스트
		Map<String,List<String>> deptTeam = new HashMap<>();
		
		// key는 부서이고 value 리스트에 해당 부서 소속의 팀들 분류 작업
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
		
		// 전체 데이터 수 구할때 필터링할 param 값들
		Map<String,Object> param = new HashMap<>();
		param.put("name", name);
		param.put("team", team);
		param.put("dept", dept);
		param.put("order", order);
		param.put("sort", sort);
		
		
		// 전체 데이터 수 가져옴
		int totalCount = employeeService.organizationListCount(param);
		
		// 페이징 옵션
		Page p = new Page(10,page,totalCount,param);
		
		// 해당 페이지에 사원 리스트
		List<Map<String,Object>> organiList = employeeService.organizationList(p);
		
		// model 값 전달
		model.addAttribute("organiList",organiList);
		model.addAttribute("totalCount",totalCount);
		model.addAttribute("deptTeam",deptTeam);
		model.addAttribute("name", name);
		model.addAttribute("topbarTitle", "조직도");
		model.addAttribute("page", p);
		return "organizationChart";
	}
}
