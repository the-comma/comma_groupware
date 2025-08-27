package com.example.comma_groupware.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import lombok.RequiredArgsConstructor;

import com.example.comma_groupware.dto.Department;
import com.example.comma_groupware.mapper.DepartmentMapper;

import java.util.List;
import java.util.Map;

@Service
@Transactional
public class DepartmentService {

    private final DepartmentMapper departmentMapper;

	public DepartmentService(DepartmentMapper departmentMapper) {
		this.departmentMapper = departmentMapper;
	}
	

    /**
     * 모든 부서 조회
     */
    @Transactional(readOnly = true)
    public List<Department> findAll() {
        return departmentMapper.selectAll();
    }

    /**
     * 부서 ID로 조회
     */
    @Transactional(readOnly = true)
    public Department findById(int deptId) {
        return departmentMapper.selectById(deptId);
    }

    /**
     * 부서명으로 조회
     */
    @Transactional(readOnly = true)
    public Department findByName(String deptName) {
        return departmentMapper.selectByName(deptName);
    }

    /**
     * 활성 부서만 조회
     */
    @Transactional(readOnly = true)
    public List<Department> findActiveDepartments() {
        return departmentMapper.selectActiveDepartments();
    }

    /**
     * 부서 생성
     */
    public void create(Department department) {
        if (department.getDeptName() == null || department.getDeptName().trim().isEmpty()) {
            throw new IllegalArgumentException("부서명은 필수입니다.");
        }
        
        // 중복 부서명 체크
        if (findByName(department.getDeptName()) != null) {
            throw new IllegalStateException("이미 존재하는 부서명입니다.");
        }
        
        departmentMapper.insert(department);
    }

    /**
     * 부서 정보 수정
     */
    public void update(Department department) {
        if (department.getDeptId() <= 0) {
            throw new IllegalArgumentException("부서 ID가 필요합니다.");
        }
        
        Department existing = findById(department.getDeptId());
        if (existing == null) {
            throw new IllegalArgumentException("존재하지 않는 부서입니다.");
        }
        
        departmentMapper.update(department);
    }

    /**
     * 부서 삭제
     */
    public void delete(int deptId) {
        Department existing = findById(deptId);
        if (existing == null) {
            throw new IllegalArgumentException("존재하지 않는 부서입니다.");
        }
        
        // 부서에 소속된 직원이 있는지 체크
        if (hasEmployees(deptId)) {
            throw new IllegalStateException("소속 직원이 있는 부서는 삭제할 수 없습니다.");
        }
        
        departmentMapper.delete(deptId);
    }

    /**
     * 부서에 소속된 직원 여부 확인
     */
    @Transactional(readOnly = true)
    public boolean hasEmployees(int deptId) {
        return departmentMapper.countEmployees(deptId) > 0;
    }

    /**
     * 부서별 직원 수 조회
     */
    @Transactional(readOnly = true)
    public int getEmployeeCount(int deptId) {
        return departmentMapper.countEmployees(deptId);
    }

    public List<Map<String,Object>> getDeptTeamList(){
		return departmentMapper.getDeptTeamList();
	}
}
