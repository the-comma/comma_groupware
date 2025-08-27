package com.example.comma_groupware.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.comma_groupware.dto.Department;
import com.example.comma_groupware.dto.Employee;
import com.example.comma_groupware.dto.RankHistory;

import java.util.List;

@Mapper
public interface EmployeeMapper {
    
    // 기본 CRUD
    void insert(Employee employee);
    Employee selectById(int empId);
    List<Employee> selectAll();
    void update(Employee employee);
    void delete(int empId);
    
    Department getCurrentDepartment(@Param("empId") int empId);
    RankHistory getCurrentRank(@Param("empId") int empId);
    
    // 로그인용 - 하나만 선언
    Employee selectByUserName(@Param("username") String username);
    
    // 부서별 조회
    List<Employee> selectByDeptId(int deptId);
    
    // 팀별 조회
    List<Employee> selectByTeamId(int teamId);
    
    // 직급별 조회
    List<Employee> selectByRankId(int rankId);
    
    // 검색
    List<Employee> searchEmployees(@Param("keyword") String keyword);
    
    // 상태별 조회
    List<Employee> selectByStatus(@Param("status") String status);
    
}