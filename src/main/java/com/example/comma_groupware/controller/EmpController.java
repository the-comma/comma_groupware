package com.example.comma_groupware.controller;

import com.example.comma_groupware.dto.Department;
import com.example.comma_groupware.dto.Team;
import com.example.comma_groupware.service.EmpService;
import com.example.comma_groupware.dto.Page;
import com.example.comma_groupware.dto.Salary;
import com.example.comma_groupware.dto.Employee;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.HttpStatus;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/hrm")
public class EmpController {

	@Autowired
	private EmpService empService;

	@GetMapping
	public String employeeList(
			@RequestParam(defaultValue = "1") int currentPage,
			@RequestParam(defaultValue = "10") int rowPerPage,
			@RequestParam(required = false) String searchWord,
			Model model) {

		int totalCount = empService.getEmployeeCount(searchWord);
		Page page = new Page(rowPerPage, currentPage, totalCount, searchWord);
		List<Map<String, Object>> empList = empService.getEmployeeList(page);

		model.addAttribute("empList", empList);
		model.addAttribute("page", page);

		return "emp/hrm";
	}

	@GetMapping("/employee/{empId}")
	@ResponseBody
	public Map<String, Object> getEmployee(@PathVariable String empId) {
		return empService.getEmployee(empId);
	}

	@PostMapping("/register")
	public ResponseEntity<Map<String, Object>> registerEmployee(@RequestBody Map<String, Object> employeeMap) {
		Map<String, Object> response = new HashMap<>();
		try {
			Employee employee = new Employee();
			employee.setEmpName((String) employeeMap.get("empName"));
			employee.setEmpEmail((String) employeeMap.get("empEmail"));
			employee.setEmpPhone((String) employeeMap.get("empPhone"));
			employee.setEmpExp((String) employeeMap.get("empExp"));
			employee.setRole((String) employeeMap.get("role"));
			
			Salary salary = new Salary();
			salary.setSalaryAmount(Long.parseLong(employeeMap.get("salaryAmount").toString()));

			boolean success = empService.registerNewEmployee(employee, salary, (String) employeeMap.get("teamName"), (String) employeeMap.get("rankName"));
			if (success) {
				response.put("success", true);
				response.put("message", "사원 등록이 성공적으로 완료되었습니다.");
				return ResponseEntity.ok(response);
			} else {
				response.put("success", false);
				response.put("message", "사원 등록에 실패했습니다.");
				return ResponseEntity.badRequest().body(response);
			}
		} catch (Exception e) {
			e.printStackTrace();
			response.put("success", false);
			response.put("message", "서버 오류가 발생했습니다.");
			return ResponseEntity.status(500).body(response);
		}
	}

	@GetMapping("/api/ranks")
	@ResponseBody
	public List<String> getRanks() {
		return empService.getAllRanks();
	}


	// @GetMapping("/api/departments")
	// @ResponseBody
	// public List<String> getDepartments() {
	// 	return empService.getAllDepartments();
	// }
	
	// 부서 ID와 이름 모두 가져오는 API
    @GetMapping("/api/departments")
    @ResponseBody
    public List<Department> getAllDepartmentsWithId() {
        return empService.getAllDepartmentsWithId();
    }

	@GetMapping("/api/teams")
	@ResponseBody
	public List<String> getTeamsByDepartment(@RequestParam String deptName) {
		log.debug("deptName::::::::::::::::::::::::::: {}", deptName);
		return empService.getTeamsByDepartment(deptName);
	}
	
	@PostMapping("/edit")
	@ResponseBody
	public Map<String, Object> editEmployee(@RequestBody Map<String, Object> paramMap) {
		Map<String, Object> response = new HashMap<>();
		try {
			int empId = Integer.parseInt((String) paramMap.get("empId"));

			if (paramMap.containsKey("salaryAmount")) {
				Salary salary = new Salary();
				salary.setEmpId(empId);
				salary.setSalaryAmount(Long.parseLong(paramMap.get("salaryAmount").toString()));
				empService.updateEmployeeSalary(salary);
			}

			if (paramMap.containsKey("rankName")) {
				String rankName = (String) paramMap.get("rankName");
				empService.updateEmployeeRank(empId, rankName);
			}

			if (paramMap.containsKey("teamName")) {
				String teamName = (String) paramMap.get("teamName");
				empService.updateEmployeeDepartment(empId, teamName);
			}
			
			if (paramMap.containsKey("empStatus")) {
				Employee employee = new Employee();
				employee.setEmpId(empId);
				employee.setEmpStatus((String) paramMap.get("empStatus"));
				empService.updateEmployeeStatus(employee);
			}
				Employee employee = new Employee();
				employee.setEmpId(empId);
				empService.updateDate(employee);
			response.put("success", true);
			response.put("message", "수정 완료.");
		} catch (Exception e) {
			e.printStackTrace();
			response.put("success", false);
			response.put("message", "수정 실패: " + e.getMessage());
		}
		return response;
	}

	@PostMapping("/api/dept/new")
	@ResponseBody
	public ResponseEntity<String> insertNewDept(@RequestBody Department department) {
		int result = empService.insertNewDept(department);
		if (result > 0) {
			return new ResponseEntity<>("부서 등록 성공", HttpStatus.OK);
		} else {
			return new ResponseEntity<>("부서 등록 실패", HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}

	@PutMapping("/api/dept/update")
	@ResponseBody
	public ResponseEntity<String> updateDeptName(@RequestBody Department department) {
		int result = empService.updateDeptName(department);
		if (result > 0) {
			return new ResponseEntity<>("부서명 수정 성공", HttpStatus.OK);
		} else {
			return new ResponseEntity<>("부서명 수정 실패", HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}

	// 새로운 팀 등록 API (추가)
    @PostMapping("/api/team/new")
    @ResponseBody
    public ResponseEntity<String> insertNewTeam(@RequestBody Team team) {
        int result = empService.insertNewTeam(team);
        if (result > 0) {
            return new ResponseEntity<>("팀 등록 성공", HttpStatus.OK);
        } else {
            return new ResponseEntity<>("팀 등록 실패", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // 팀 정보 수정 API (추가)
    @PutMapping("/api/team/update")
    @ResponseBody
    public ResponseEntity<String> updateTeam(@RequestBody Team team) {
        int result = empService.updateTeam(team);
        if (result > 0) {
            return new ResponseEntity<>("팀 수정 성공", HttpStatus.OK);
        } else {
            return new ResponseEntity<>("팀 수정 실패", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

   
    
    // 특정 부서의 팀 목록 API (ID 포함)
    @GetMapping("/api/teams/by-dept-id")
    @ResponseBody
    public List<Team> getTeamsByDeptId(@RequestParam int deptId) {
        return empService.getTeamsByDeptId(deptId);
    }
}
