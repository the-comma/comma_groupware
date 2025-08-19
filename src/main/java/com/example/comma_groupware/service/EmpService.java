package com.example.comma_groupware.service;

import java.util.List;
import java.util.Map;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional; // Transactional 어노테이션 임포트
import com.example.comma_groupware.dto.Page;
import com.example.comma_groupware.mapper.EmpMapper;

@Service
public class EmpService {

    @Autowired
    private EmpMapper empMapper;

    // 직원 수 조회
    public int getEmployeeCount(String searchWord) {
        return empMapper.selectEmployeeCount(searchWord);
    }

    // 직원 리스트 조회 (Map 반환)
    public List<Map<String, Object>> getEmployeeList(Page page) {
        Map<String, Object> param = new HashMap<>();
        param.put("beginRow", page.getBeginRow());
        param.put("rowPerPage", page.getRowPerPage());
        param.put("searchWord", page.getSearchWord());

        return empMapper.selectEmployeeList(param);
    }
    // 직급 목록
    public List<String> getAllRanks() {
        return empMapper.selectAllRanks();
    }

    // 부서 목록
    public List<String> getAllDepartments() {
        return empMapper.selectAllDepartments();
    }

    // 부서 이름으로 팀 목록을 가져옴
    public List<String> getTeamsByDepartment(String deptName) {
        return empMapper.selectTeamsByDepartment(deptName);
    }

    // 직원 정보 업데이트
    @Transactional // 이 메서드의 모든 DB 작업이 하나의 트랜잭션으로 처리됩니다.
    public void updateEmployee(Map<String, Object> paramMap) {
        // 1. 급여 업데이트
        if (paramMap.containsKey("salaryAmount")) {
            empMapper.updateSalary(paramMap);
        }
        
        // 2. 직급 업데이트 (rank_history에 새 이력 추가)
        if (paramMap.containsKey("rankName")) {
            // 기존 직급의 end_date 업데이트
            empMapper.updateRankHistoryEndDate(paramMap);
            // 새로운 직급 이력 추가
            empMapper.insertRankHistory(paramMap);
        }

        // 3. 부서/팀 업데이트 (department_history에 새 이력 추가)
        if (paramMap.containsKey("teamName")) {
            // 기존 부서/팀의 end_date 업데이트
            empMapper.updateDeptHistoryEndDate(paramMap);
            // 새로운 부서/팀 이력 추가
            empMapper.insertDeptHistory(paramMap);
        }
    }

    // 직원 삭제
    @Transactional 
    public void deleteEmployee(String empId) {
        // 익명 게시판 관련 데이터 삭제
        empMapper.deleteAnonymousLike(empId);
        empMapper.deleteAnonymousComment(empId);
        empMapper.deleteAnonymousPost(empId);

        // 급여, 직급, 부서 이력 삭제
        empMapper.deleteSalary(empId);
        empMapper.deleteRankHistory(empId);
        empMapper.deleteDepartmentHistory(empId);

        // employee 테이블 삭제
        empMapper.deleteEmployee(empId);
    }
    //사원번호로 직원 1명 조회 
    public Map<String, Object> getEmployee(String empId) {
        return empMapper.selectEmployeeById(empId);
    }
}