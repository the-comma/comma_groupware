package com.example.comma_groupware.service;

import com.example.comma_groupware.dto.Salary;
import com.example.comma_groupware.dto.Team;
import com.example.comma_groupware.dto.Employee;
import com.example.comma_groupware.dto.RankHistory;
import com.example.comma_groupware.dto.Department;
import com.example.comma_groupware.dto.DepartmentHistory;
import com.example.comma_groupware.dto.Page;
import com.example.comma_groupware.mapper.EmpMapper;

import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;


@Service
public class EmpService {

    @Autowired
    private EmpMapper empMapper;

    // 직원 수 조회
    public int getEmployeeCount(String searchWord) {
        return empMapper.selectEmployeeCount(searchWord);
    }

    // 직원 리스트 조회 
    public List<Map<String, Object>> getEmployeeList(Page page) {
        Map<String, Object> param = new HashMap<>();
        param.put("beginRow", page.getBeginRow());
        param.put("rowPerPage", page.getRowPerPage());
        param.put("searchWord", page.getSearchWord());

        return empMapper.selectEmployeeList(param);
    }
  
    //사원번호로 사원 1명 조회 
    public Map<String, Object> getEmployee(String empId) {
        return empMapper.selectEmployeeById(empId);
    }
  
    //사원 등록
   	@Transactional
   	public boolean registerNewEmployee(Employee employee, Salary salary , String rankName, String teamName ) {
   		try {
   			// 사번 등록 4자리 난수 생성 
   			Random random = new Random();
   			int min = 1000;
   			int max = 9999;
   			String newEmpId;
   			Map<String, Object> existingEmployee;

   			// 중복 사원번호 조회
   			do {
   				newEmpId = String.valueOf(random.nextInt(max - min + 1) + min);
   				existingEmployee = empMapper.selectEmployeeById(newEmpId);
   			} while (existingEmployee != null && !existingEmployee.isEmpty());

   			employee.setEmpId(Integer.parseInt(newEmpId));
   			employee.setPassword(newEmpId); // 초기 비밀번호는 사원 아이디와 동일
         
               // rankName을 통해 rankId를 조회 후 DTO에 삽입
               int rankId = empMapper.selectRankIdByRankName(rankName);
               RankHistory rankHistory = new RankHistory();
               rankHistory.setEmpId(Integer.parseInt(newEmpId));
               rankHistory.setRankId(rankId);

               // teamName을 통해 teamId를 조회 후 DTO에 삽입
               int teamId = empMapper.selectTeamIdByTeamName(teamName);
               DepartmentHistory deptHistory = new DepartmentHistory();
   			deptHistory.setEmpId(Integer.parseInt(newEmpId));
               deptHistory.setTeamId(teamId);

   			salary.setEmpId(Integer.parseInt(newEmpId));

   			empMapper.insertEmployee(employee); //사원 등록
   			empMapper.insertRankHistory(rankHistory); //신규 사원 직급 등록
   			empMapper.insertDeptHistory(deptHistory); //신규 사원 부서 등록
   			empMapper.insertSalary(salary);
   			return true;
   		} catch (Exception e) {
   			e.printStackTrace();
   			return false;
   		}
   	}


    // 직급 목록
    public List<String> getAllRanks() {
        return empMapper.selectAllRanks();
    }
    
    // 기존의 모든 부서 목록 조회 메서드는 삭제했습니다.
    // public List<String> getAllDepartments() {
    //     return empMapper.selectAllDepartments();
    // }

    // 부서 이름으로 팀 목록을 가져옴
    public List<String> getTeamsByDepartment(String deptName) {
        return empMapper.selectTeamsByDepartment(deptName);
    }
    
    // 사원 정보 업데이트 - 급여
    @Transactional
    public void updateEmployeeSalary(Salary salary) {
        empMapper.updateSalary(salary);
    }

    // 사원 정보 업데이트 - 직급
    @Transactional
    public void updateEmployeeRank(int empId, String rankName) {
        // rankName을 사용하여 rankId 조회
        int rankId = empMapper.selectRankIdByRankName(rankName);

        RankHistory rankHistory = new RankHistory();
        rankHistory.setEmpId(empId);
        rankHistory.setRankId(rankId);

        // 기존 직급의 end_date 업데이트
        empMapper.updateRankHistoryEndDate(rankHistory);
        // 새로운 직급 이력 추가
        empMapper.insertRankHistory(rankHistory);
    }

    // 직원 정보 업데이트 - 부서/팀
    @Transactional
    public void updateEmployeeDepartment(int empId, String teamName) {
        // teamName을 사용하여 teamId 조회
        int teamId = empMapper.selectTeamIdByTeamName(teamName);

        DepartmentHistory deptHistory = new DepartmentHistory();
        deptHistory.setEmpId(empId);
        deptHistory.setTeamId(teamId);

        // 기존 부서 이력 종료일 업데이트
        empMapper.updateDeptHistoryEndDate(deptHistory);
        // 새로운 부서 이력 추가
        empMapper.insertDeptHistory(deptHistory);
    }

    // 직원 정보 업데이트 - 재직 상태
    @Transactional
    public void updateEmployeeStatus(Employee employee) {
        empMapper.updateStatus(employee);
    }
    // 업데이트 일시 수정
    @Transactional
    public void updateDate(Employee employhee) {
    	empMapper.updateDate(employhee);
    }
    
    //새로운 부서 등록
    public int insertNewDept(Department department) {
        int result = empMapper.insertNewDept(department);
        return result;
    }
    
    //부서명 수정
    public int updateDeptName(Department department) {
        int result = empMapper.updateDeptName(department);
        return result;
    }
    // 팀 관리 관련 메서드 추가
    public int insertNewTeam(Team team) {
        return empMapper.insertNewTeam(team);
    }
    //팀 수정 
    public int updateTeam(Team team) {
        return empMapper.updateTeam(team);
    }
    //부서별 모든 팀 조회
    public List<Team> getTeamsByDeptId(int deptId) {
        return empMapper.getTeamsByDeptId(deptId);
    }
    //모든 부서 조회 (ID와 이름 모두)
    public List<Department> getAllDepartmentsWithId() {
        return empMapper.getAllDepartmentsWithId();
    }
}
