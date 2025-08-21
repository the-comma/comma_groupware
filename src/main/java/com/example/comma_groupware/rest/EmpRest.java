package com.example.comma_groupware.rest;

import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import com.example.comma_groupware.service.EmployeeService;

@RestController
public class EmpRest {

	EmployeeService empSerivce;
	
	public EmpRest(EmployeeService empSerivce) {
		this.empSerivce = empSerivce;
	}
	
	@GetMapping("empListByTeam/{team}")
	public List<Map<String, Object>> empListByTeam(@PathVariable(value="team") String team){
		
		for(Map<String, Object> m : empSerivce.empListByTeam(team)) {	
			System.out.println(m.toString());
		}
		
		return empSerivce.empListByTeam(team);
	}
}
