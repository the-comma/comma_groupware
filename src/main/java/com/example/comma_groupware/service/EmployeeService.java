package com.example.comma_groupware.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import lombok.RequiredArgsConstructor;

import com.example.comma_groupware.dto.Employee;
import com.example.comma_groupware.dto.Department;
import com.example.comma_groupware.dto.RankHistory;
import com.example.comma_groupware.mapper.EmployeeMapper;

@Service
@RequiredArgsConstructor
@Transactional
public class EmployeeService {

    private final EmployeeMapper employeeMapper;

    /**
     * 사원 정보 조회 (ID로)
     */
    @Transactional(readOnly = true)
    public Employee findById(int empId) {
        return employeeMapper.selectById(empId);
    }

    /**
     * 사원의 현재 부서 정보 조회
     */
    @Transactional(readOnly = true)
    public Department getCurrentDepartment(int empId) {
        return employeeMapper.getCurrentDepartment(empId);
    }

    /**
     * 사원의 현재 직급 정보 조회  
     */
    @Transactional(readOnly = true)
    public RankHistory getCurrentRank(int empId) {
        return employeeMapper.getCurrentRank(empId);
    }

    /**
     * 사용자명으로 사원 조회
     */
    @Transactional(readOnly = true)
    public Employee findByUsername(String username) {
        return employeeMapper.selectByUserName(username);
    }
    
    
}