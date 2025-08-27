package com.example.comma_groupware.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import com.example.comma_groupware.dto.Department;

import java.util.List;
import java.util.Map;

@Mapper
public interface DepartmentMapper {

    /**
     * 모든 부서 조회
     */
    List<Department> selectAll();

    /**
     * 부서 ID로 조회
     */
    Department selectById(@Param("deptId") int deptId);

    /**
     * 부서명으로 조회
     */
    Department selectByName(@Param("deptName") String deptName);

    /**
     * 활성 부서만 조회
     */
    List<Department> selectActiveDepartments();

    /**
     * 부서 생성
     */
    int insert(Department department);

    /**
     * 부서 수정
     */
    int update(Department department);

    /**
     * 부서 삭제
     */
    int delete(@Param("deptId") int deptId);

    /**
     * 부서별 직원 수 조회
     */
    int countEmployees(@Param("deptId") int deptId);

    // SELECT
	List<Map<String,Object>> getDeptTeamList();	// 부서/팀 가져오기
}
