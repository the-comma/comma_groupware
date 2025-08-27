package com.example.comma_groupware.service;


import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.comma_groupware.dto.Employee;
import com.example.comma_groupware.mapper.EmployeeMapper;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import lombok.RequiredArgsConstructor;

import com.example.comma_groupware.dto.Employee;
import com.example.comma_groupware.dto.Department;
import com.example.comma_groupware.dto.RankHistory;
import com.example.comma_groupware.dto.Page;
import com.example.comma_groupware.mapper.EmployeeMapper;

@Service
@Transactional
public class EmployeeService {

    EmployeeMapper employeeMapper;
	private final PasswordEncoder passwordEncoder;
	private final JavaMailSender mailSender;
	private final JwtEmailOtpService otpService;

	public EmployeeService(EmployeeMapper employeeMapper,
			PasswordEncoder passwordEncoder
			,JavaMailSender mailSender 
			,JwtEmailOtpService otpService
			)
	{
		this.employeeMapper = employeeMapper;
		this.passwordEncoder = passwordEncoder;
		this.mailSender = mailSender;
		this.otpService = otpService;
	}

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

	// 비밀번호 변경
	public void updatePw(String password, String username) { 
		String encodePw = passwordEncoder.encode(password); // 패스워드 암호화
		employeeMapper.updatePw(encodePw, username);
		
	}
	
	// 비밀번호 확인
	public boolean checkPassword(String newPassword, String username) { // 비밀번호 변경
		Employee employee = employeeMapper.selectByUserName(username);
	
		
		if(passwordEncoder.matches(newPassword, employee.getPassword())){ // 이전 비밀번호와 동일한 패스워드인지 확인
		return true;
		} 
		
		
		return false;
	}

	// 이메일 보내기
	public Map<String, Object> sendEmail(String username, String email) {
		int row =employeeMapper.existsByEmail(email);
		if(row == 0) { // 존재하는 이메일 0개면 반환
			throw new IllegalArgumentException("이메일이 존재하지 않습니다.");
		}
		
		
		var issue  = otpService.issue(email, "RESET_PW", 300); // 유효시간 : 5분
		
		SimpleMailMessage msg = new SimpleMailMessage();
		msg.setTo(email);
		msg.setSubject("[비밀번호 찾기] 이메일 인증 코드");
		msg.setText("""
				안녕하세요, %s 님.
				
				아래 6자리 인증코드를 입력해주세요.
				
				인증코드: %s
				유효시간: %d분
				
				본 메일을 요청하지 않으셨다면 이 메시지를 무시하세요.
				
				""".formatted(username, issue.code(), issue.ttlSeconds()/60));   // 메세지 내용
		
		 mailSender.send(msg);
				
		 return Map.of(
				 "token" , issue.token(),
				 "ttlSeconds" , issue.ttlSeconds()
				 );
		
	}
	
	// 사원 휴대폰, 이메일 정보 가져오기
	public Employee selectEmpInfo(String username) {
		Employee employee = employeeMapper.selectByUserName(username);
		
		return employee;
	}

	public void updateInfo(String username, String email, String phone) {
		employeeMapper.updateInfo(username,email,phone);
	}
	
	/** 조직도 리스트 **/
	public List<Map<String,Object>> organizationList(Page p){
		return employeeMapper.organizationList(p);
	}
	
	/** 조직도 리스트 전체 데이터 수 **/
	public int organizationListCount(Map<String,Object> param){
		return employeeMapper.organizationListCount(param);
	}
	
	/** 사원 카드 조회 **/
	public Map<String, Object> employeeCard(int id){
		return employeeMapper.employeeCard(id);
	}
	
	/** 해당 팀 소속 사원 조회 **/
	public List<Map<String,Object>> empListByTeam(String team){
		return employeeMapper.empListByTeam(team);
	}
	
	// 조서진 추가
    /**
     * 사원의 완전한 정보 조회 (부서, 팀, 직급 포함)
     */
    @Transactional(readOnly = true)
    public Map<String, Object> getEmployeeFullInfo(int empId) {
        Map<String, Object> info = employeeMapper.selectEmployeeFullInfo(empId);
        if (info == null) {
            throw new IllegalArgumentException("사원 정보를 찾을 수 없습니다: " + empId);
        }
        return info;
    }
    
    /**
     * 부서장 권한 확인 (DB 기반)
     */
    @Transactional(readOnly = true)
    public boolean isDepartmentManager(int empId) {
        return employeeMapper.checkManagerAuthority(empId) > 0;
    }
    
    /**
     * 특정 부서의 부서장인지 확인
     */
    @Transactional(readOnly = true)
    public boolean isDepartmentManagerOf(int empId, int deptId) {
        return employeeMapper.countDepartmentManagerRole(empId, deptId) > 0;
    }
    
    /**
     * 특정 부서를 관리할 수 있는지 확인 (같은 부서 + 부서장 권한)
     */
    @Transactional(readOnly = true)
    public boolean canManageDepartment(int empId, Integer deptId) {
        if (deptId == null) return false;
        
        // 1. 부서장 권한 확인
        if (!isDepartmentManager(empId)) return false;
        
        // 2. 사용자의 현재 부서 확인
        Map<String, Object> userInfo = getEmployeeFullInfo(empId);
        Integer userDeptId = (Integer) userInfo.get("deptId");
        
        // 3. 같은 부서인지 확인
        return userDeptId != null && userDeptId.equals(deptId);
    }
    
    /**
     * 경영지원부장 권한 확인
     */
    @Transactional(readOnly = true)
    public boolean isManagementSupportManager(int empId) {
        return employeeMapper.checkManagementSupportManager(empId) > 0;
    }
    
    /**
     * PM 권한 확인 (기획부/개발팀/기술팀 소속 + PM 역할)
     */
    @Transactional(readOnly = true)
    public boolean isProjectManager(int empId) {
        return employeeMapper.checkProjectManagerAuthority(empId) > 0;
    }
    
    /**
     * 사용자 권한 정보 한번에 조회 (성능 최적화)
     */
    @Transactional(readOnly = true)
    public Map<String, Object> getUserPermissionInfo(int empId) {
        Map<String, Object> info = employeeMapper.selectUserPermissionInfo(empId);
        if (info == null) {
            throw new IllegalArgumentException("사원 정보를 찾을 수 없습니다: " + empId);
        }
        return info;
    }
    
    /**
     * 같은 부서 사원들 조회
     */
    @Transactional(readOnly = true)
    public List<Map<String, Object>> getDepartmentMembers(int deptId) {
        return employeeMapper.selectDepartmentMembers(deptId);
    }
    
    /**
     * 사용자의 부서 ID 조회 (캘린더용)
     */
    @Transactional(readOnly = true)
    public Integer getUserDepartmentId(int empId) {
        return employeeMapper.getUserDeptIdForCalendar(empId);
    }
    
    /**
     * 특정 부서의 부서장들 조회
     */
    @Transactional(readOnly = true)
    public List<Map<String, Object>> getDepartmentManagers(int deptId) {
        return employeeMapper.selectDepartmentManagers(deptId);
    }
    
    // ====== 캘린더 Controller에서 사용할 편의 메서드들 ======
    
    /**
     * 부서 일정 등록 권한 확인
     */
    @Transactional(readOnly = true)
    public boolean canCreateDepartmentEvent(int empId, Integer targetDeptId) {
        try {
            // 1. 부서장 권한 확인
            if (!isDepartmentManager(empId)) {
                System.out.println("부서 일정 등록 권한 없음 - 부서장 아님: empId=" + empId);
                return false;
            }
            
            // 2. 사용자의 현재 부서 확인
            Map<String, Object> userInfo = getEmployeeFullInfo(empId);
            Integer userDeptId = (Integer) userInfo.get("deptId");
            
            if (userDeptId == null) {
                System.out.println("부서 일정 등록 권한 없음 - 부서 소속 없음: empId=" + empId);
                return false;
            }
            
            // 3. 타겟 부서가 지정되었다면 자신의 부서와 일치하는지 확인
            if (targetDeptId != null && !userDeptId.equals(targetDeptId)) {
                System.out.println("부서 일정 등록 권한 없음 - 다른 부서: userDept=" + userDeptId + ", targetDept=" + targetDeptId);
                return false;
            }
            
            System.out.println("부서 일정 등록 권한 확인: empId=" + empId + ", deptId=" + userDeptId + ", 권한=TRUE");
            return true;
            
        } catch (Exception e) {
            System.out.println("부서 일정 등록 권한 확인 중 오류: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * 부서 일정 수정/삭제 권한 확인
     */
    @Transactional(readOnly = true)
    public boolean canModifyDepartmentEvent(int empId, Integer eventDeptId, int creatorId) {
        try {
            // 1. 본인이 작성한 일정인지 확인
            if (empId != creatorId) {
                System.out.println("부서 일정 수정 권한 없음 - 작성자 아님: empId=" + empId + ", creatorId=" + creatorId);
                return false;
            }
            
            // 2. 해당 부서를 관리할 수 있는지 확인
            if (!canManageDepartment(empId, eventDeptId)) {
                System.out.println("부서 일정 수정 권한 없음 - 부서 관리 권한 없음: empId=" + empId + ", eventDeptId=" + eventDeptId);
                return false;
            }
            
            System.out.println("부서 일정 수정 권한 확인: empId=" + empId + ", eventDeptId=" + eventDeptId + ", 권한=TRUE");
            return true;
            
        } catch (Exception e) {
            System.out.println("부서 일정 수정 권한 확인 중 오류: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * 부서 일정 조회 권한 확인
     */
    @Transactional(readOnly = true)
    public boolean canViewDepartmentEvent(int empId, Integer eventDeptId) {
        try {
            if (eventDeptId == null) return false;
            
            // 같은 부서 소속인지 확인
            Integer userDeptId = getUserDepartmentId(empId);
            boolean canView = userDeptId != null && userDeptId.equals(eventDeptId);
            
            System.out.println("부서 일정 조회 권한 확인: empId=" + empId + 
                             ", userDeptId=" + userDeptId + 
                             ", eventDeptId=" + eventDeptId + 
                             ", 권한=" + canView);
            
            return canView;
            
        } catch (Exception e) {
            System.out.println("부서 일정 조회 권한 확인 중 오류: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * 디버깅용 - 사용자의 권한 정보 출력
     */
    @Transactional(readOnly = true)
    public void printUserAuthorities(int empId) {
        try {
            Map<String, Object> info = getUserPermissionInfo(empId);
            System.out.println("=== 사용자 권한 정보 ===");
            System.out.println("사원ID: " + info.get("empId"));
            System.out.println("이름: " + info.get("empName"));
            System.out.println("역할: " + info.get("role"));
            System.out.println("부서: " + info.get("deptName") + " (ID: " + info.get("deptId") + ")");
            System.out.println("팀: " + info.get("teamName") + " (ID: " + info.get("teamId") + ")");
            System.out.println("직급: " + info.get("rankName"));
            System.out.println("부서장 권한: " + info.get("isDeptManager"));
            System.out.println("경영지원부장 권한: " + info.get("isManagementSupportManager"));
            System.out.println("PM 권한: " + info.get("isProjectManager"));
            System.out.println("======================");
        } catch (Exception e) {
            System.out.println("권한 정보 출력 중 오류: " + e.getMessage());
        }
    }
}
	
