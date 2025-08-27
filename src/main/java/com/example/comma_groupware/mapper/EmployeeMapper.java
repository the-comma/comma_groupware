package com.example.comma_groupware.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.comma_groupware.dto.Department;
import com.example.comma_groupware.dto.Employee;
import com.example.comma_groupware.dto.RankHistory;

import java.util.List;
import java.util.Map;

import com.example.comma_groupware.dto.Page;

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
    
    // SpringSecurity 로그인에 사용
	Employee selectByUserName(@Param("username") String username);

	// 비밀번호 업데이트
	void updatePw(@Param("password") String password, @Param("username") String username);

	int existsByEmail(String email);
	
	// 개인정보 업데이트
	void updateInfo(@Param("username") String username, @Param("email") String email, @Param("phone") String phone);
	
	// SELECT
	List<Map<String,Object>> organizationList(Page p);					// 조직도 조회
	int organizationListCount(Map<String,Object> param);	// 조직도 리스트 전체 데이터 수
	
	Map<String, Object> employeeCard(int empId);
	
	List<Map<String,Object>> empListByTeam(String team);
}
