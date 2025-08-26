package com.example.comma_groupware.mapper;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.comma_groupware.dto.Department;
import com.example.comma_groupware.dto.DepartmentHistory;
import com.example.comma_groupware.dto.Employee;
import com.example.comma_groupware.dto.RankHistory;
import com.example.comma_groupware.dto.Salary;
import com.example.comma_groupware.dto.Team;

@Mapper // MyBatis 매퍼임을 나타냅니다.
public interface HrmMapper {
    
    // 직원 수 조회
    int selectEmployeeCount(@Param("searchWord") String searchWord);

    // 직원 리스트 조회
    List<Map<String, Object>> selectEmployeeList(Map<String, Object> paramMap);
    
    // 직원 등록
    int insertEmployee(Employee employee);
    
    // 급여 등록
    int insertSalary(Salary salary);
    
    // 급여 업데이트
    int updateSalary(Salary salary);

    // 기존 직급 이력 종료 (end_date 업데이트)
    int updateRankHistoryEndDate(RankHistory rankHistory);

    // 새로운 직급 이력 추가
    int insertRankHistory(RankHistory rankHistory);
    
    // 새로운 부서/팀 이력 추가
    int insertDeptHistory(DepartmentHistory deptHistory);

    // 기존 부서/팀 이력 종료
    int updateDeptHistoryEndDate(DepartmentHistory deptHistory);
    
    int updateStatus(Employee employee);
    
    //직급 이름으로 직급 ID 조회
    int selectRankIdByRankName(@Param("rankName") String rankName);
    
    //업데이트 일시 수정
    void updateDate(Employee employee);
    //특정 직원 정보 조회
    Map<String, Object> selectEmployeeById(@Param("empId") String empId);
    
    // 모든 직급 목록
    List<String> selectAllRanks();


    // 특정 부서(deptName)에 속한 모든 팀 목록
    List<String> selectTeamsByDepartment(@Param("deptName") String deptName);

    // 팀명으로 팀 ID 조회
    Integer selectTeamIdByTeamName(@Param("teamName") String teamName);
    
    // 모든 부서 조회 (ID와 이름 모두 포함)
    List<Department> getAllDepartmentsWithId(); 
    
    //부서 등록
    int insertNewDept(Department department);
 
    //부서명 수정
    int updateDeptName(Department department);
    
    //팀 등록
    int insertNewTeam(Team team);
    
    // 팀 수정 
    int updateTeam(Team team);
    
    //부서별 모든 팀 조회
    List<Team> getTeamsByDeptId(int deptId);
  
}
