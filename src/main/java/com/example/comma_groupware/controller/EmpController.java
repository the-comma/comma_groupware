package com.example.comma_groupware.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.comma_groupware.dto.Employee;
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

        // 전체 직원 수
        int totalCount = empService.getEmployeeCount(searchWord);

        // 페이지 DTO 생성
        Page page = new Page(rowPerPage, currentPage, totalCount, searchWord);

        // 직원 리스트
        List<Employee> empList = empService.getEmployeeList(page);

        // JSP로 전달
        model.addAttribute("empList", empList);
        model.addAttribute("page", page);

        return "emp/hrm"; 
    }
}
