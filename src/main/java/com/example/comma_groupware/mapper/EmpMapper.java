package com.example.comma_groupware.mapper;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper // MyBatis 매퍼임을 나타냅니다.
public interface EmpMapper {
    
    // 직원 수 조회
    int selectEmployeeCount(@Param("searchWord") String searchWord);

    // 직원 리스트 조회 (Map 형태로 반환)
    List<Map<String, Object>> selectEmployeeList(Map<String, Object> paramMap);

    // 급여 업데이트
    int updateSalary(Map<String, Object> paramMap);

    // 기존 직급 이력 종료 (end_date 업데이트)
    int updateRankHistoryEndDate(Map<String, Object> paramMap);

    // 새로운 직급 이력 추가
    int insertRankHistory(Map<String, Object> paramMap);

    // 기존 부서/팀 이력 종료
    int updateDeptHistoryEndDate(Map<String, Object> paramMap);

    // 새로운 부서/팀 이력 추가
    int insertDeptHistory(Map<String, Object> paramMap);

    // 직원 삭제
    int deleteEmployee(@Param("empId") String empId);

    // 외래 키 제약 조건에 따른 선행 삭제
    int deleteAnonymousLike(@Param("empId") String empId);
    int deleteAnonymousComment(@Param("empId") String empId);
    int deleteAnonymousPost(@Param("empId") String empId);
    int deleteSalary(@Param("empId") String empId);
    int deleteRankHistory(@Param("empId") String empId);
    int deleteDepartmentHistory(@Param("empId") String empId);
}