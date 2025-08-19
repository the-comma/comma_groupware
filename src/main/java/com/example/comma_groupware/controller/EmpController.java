package com.example.comma_groupware.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.comma_groupware.dto.Page;
import com.example.comma_groupware.service.EmpService;

import lombok.extern.slf4j.Slf4j;
@Slf4j
@Controller
public class EmpController {

    @Autowired
    private EmpService empService;

    @GetMapping("/hrm")
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
    // 특정 직원 상세 정보 조회
    @GetMapping("/hrm/employee/{empId}")
    @ResponseBody 
    public Map<String, Object> getEmployee(@PathVariable String empId) {    
        return empService.getEmployee(empId);
    }
    // 모든 직급 목록을 반환하는 API
    @GetMapping("/api/ranks")
    @ResponseBody
    public List<String> getRanks() {
        return empService.getAllRanks();
    }

    // 모든 부서 목록을 반환하는 API
    @GetMapping("/api/departments")
    @ResponseBody
    public List<String> getDepartments() {
        return empService.getAllDepartments();
    }

    // 특정 부서에 속한 팀 목록을 반환하는 API
    @GetMapping("/api/teams")
    @ResponseBody
    public List<String> getTeamsByDepartment(@RequestParam("deptName") String deptName) {
    	log.debug("deptName::::::::::::::::::::::::::: {}", deptName);
        return empService.getTeamsByDepartment(deptName);
    }
    
    // 직원 정보 수정 
    @PostMapping("/hrm/edit")
    @ResponseBody 
    public Map<String, Object> editEmployee(@RequestBody Map<String, Object> paramMap) {
        Map<String, Object> response = new HashMap<>();
        try {
            empService.updateEmployee(paramMap);
            response.put("success", true);
            response.put("message", "수정 완료.");
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "수정 실패: " + e.getMessage());
        }
        return response;
    }

    // 직원 삭제 
    @DeleteMapping("/hrm/delete/{empId}")
    @ResponseBody 
    public Map<String, Object> deleteEmployee(@PathVariable String empId) {
        Map<String, Object> response = new HashMap<>();
        try {
            empService.deleteEmployee(empId);
            response.put("success", true);
            response.put("message", "삭제 성공.");
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "삭제 실패: " + e.getMessage());
        }
        return response;
    }
}