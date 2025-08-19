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

    // 직원 정보 수정 (AJAX 요청 처리)
    @PostMapping("/hrm/edit")
    @ResponseBody // Map을 JSON으로 변환하여 응답
    public Map<String, Object> editEmployee(@RequestBody Map<String, Object> paramMap) {
        Map<String, Object> response = new HashMap<>();
        try {
            empService.updateEmployee(paramMap);
            response.put("success", true);
            response.put("message", "직원 정보가 성공적으로 수정되었습니다.");
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "직원 정보 수정 실패: " + e.getMessage());
        }
        return response;
    }

    // 직원 삭제 (AJAX 요청 처리)
    @DeleteMapping("/hrm/delete/{empId}")
    @ResponseBody // Map을 JSON으로 변환하여 응답
    public Map<String, Object> deleteEmployee(@PathVariable String empId) {
        Map<String, Object> response = new HashMap<>();
        try {
            empService.deleteEmployee(empId);
            response.put("success", true);
            response.put("message", "직원이 성공적으로 삭제되었습니다.");
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "직원 삭제 실패: " + e.getMessage());
        }
        return response;
    }
}