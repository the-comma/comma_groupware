package com.example.comma_groupware.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import lombok.RequiredArgsConstructor;

import com.example.comma_groupware.dto.CalendarEvent;
import com.example.comma_groupware.mapper.CalendarEventMapper;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Service
@Transactional
public class CalendarEventService {

    private final CalendarEventMapper calendarEventMapper;
    private final EmployeeService employeeService;  
    
    public CalendarEventService(CalendarEventMapper calendarEventMapper, EmployeeService employeeService) {
        this.calendarEventMapper = calendarEventMapper;
        this.employeeService = employeeService;
    }
    

    // ====== 기본 CRUD ======
    
    public void create(CalendarEvent event) {
        validateEvent(event);
        calendarEventMapper.insert(event);
    }
    
    @Transactional(readOnly = true)
    public CalendarEvent findById(int eventId) {
        return calendarEventMapper.selectById(eventId);
    }
    
    @Transactional(readOnly = true)
    public List<CalendarEvent> findByRange(LocalDateTime start, LocalDateTime end) {
        return calendarEventMapper.selectByRange(start, end);
    }
    
    public void updatePartial(CalendarEvent event) {
        if (event.getEventId() <= 0) {
            throw new IllegalArgumentException("수정할 일정 ID가 필요합니다.");
        }
        
        // 기존 일정 존재 여부 확인
        CalendarEvent existing = findById(event.getEventId());
        if (existing == null) {
            throw new IllegalArgumentException("존재하지 않는 일정입니다.");
        }
        
        calendarEventMapper.updatePartial(event);
    }
    
    public void delete(int eventId) {
        CalendarEvent existing = findById(eventId);
        if (existing == null) {
            throw new IllegalArgumentException("존재하지 않는 일정입니다.");
        }
        
        calendarEventMapper.delete(eventId);
    }

    // ====== 권한별 조회 서비스 ======
    
    @Transactional(readOnly = true)
    public List<CalendarEvent> findTodayScheduleForUser(int empId, int deptId, 
                                                      LocalDateTime startOfDay, LocalDateTime endOfDay) {
        return calendarEventMapper.findTodayScheduleForUser(empId, deptId, startOfDay, endOfDay);
    }
    
    @Transactional(readOnly = true)
    public List<CalendarEvent> findEventsByRangeAndUser(LocalDateTime start, LocalDateTime end,
                                                      int empId, int deptId, List<String> types) {
    	return calendarEventMapper.findEventsByRangeAndUser(start, end, empId, deptId, types);
    }
    
    @Transactional(readOnly = true)
    public CalendarEvent findByIdWithPermissionCheck(int eventId) {
        return calendarEventMapper.findByIdWithPermissionCheck(eventId);
    }
    
    

    // ====== 통계 서비스 ======
    
    @Transactional(readOnly = true)
    public Map<String, Integer> getTodayScheduleStats(int empId, int deptId,
                                                    LocalDateTime startOfDay, LocalDateTime endOfDay) {
        Map<String, Integer> stats = calendarEventMapper.getTodayScheduleStats(empId, deptId, startOfDay, endOfDay);
        
        // null 값들을 0으로 초기화
        stats.putIfAbsent("company", 0);
        stats.putIfAbsent("department", 0);
        stats.putIfAbsent("project", 0);
        stats.putIfAbsent("vacation", 0);
        stats.putIfAbsent("personal", 0);
        stats.putIfAbsent("total", 0);
        
        return stats;
    }
    
    @Transactional(readOnly = true)
    public Map<String, Object> getDepartmentScheduleStats(int deptId) {
        return calendarEventMapper.getDepartmentScheduleStats(deptId);
    }
    
    @Transactional(readOnly = true)
    public Map<String, Object> getProjectScheduleStats(int pmId) {
        return calendarEventMapper.getProjectScheduleStats(pmId);
    }
    
    @Transactional(readOnly = true)
    public List<Map<String, Object>> getPersonalScheduleMonthlyStats(int empId, int year) {
        return calendarEventMapper.getPersonalScheduleMonthlyStats(empId, year);
    }

    // ====== 휴가 관련 서비스 ======
    
    @Transactional(readOnly = true)
    public List<CalendarEvent> findDepartmentVacations(int deptId, LocalDate targetDate) {
        LocalDateTime start = targetDate.atStartOfDay();
        LocalDateTime end = targetDate.atTime(23, 59, 59);
        return calendarEventMapper.findDepartmentVacations(deptId, start, end);
    }
    
    @Transactional(readOnly = true)
    public List<Map<String, Object>> findDepartmentVacationsByRange(int deptId, 
                                                                  LocalDateTime start, LocalDateTime end) {
        return calendarEventMapper.findDepartmentVacationsByRange(deptId, start, end);
    }
    
    @Transactional(readOnly = true)
    public Map<String, Object> getDepartmentVacationSummary(int deptId, int year) {
        List<Map<String, Object>> vacationList = calendarEventMapper.getDepartmentVacationSummary(deptId, year);
        
        // 요약 통계 계산
        int totalEmployees = vacationList.size();
        int totalVacationDays = vacationList.stream()
            .mapToInt(emp -> ((Number) emp.getOrDefault("total_vacation_days", 0)).intValue())
            .sum();
        
        return Map.of(
            "employees", vacationList,
            "totalEmployees", totalEmployees,
            "totalVacationDays", totalVacationDays,
            "averageVacationDays", totalEmployees > 0 ? (double) totalVacationDays / totalEmployees : 0
        );
    }
    
    @Transactional(readOnly = true)
    public List<Map<String, Object>> getMonthlyDepartmentVacations(int deptId, int year, int month) {
        return calendarEventMapper.getMonthlyDepartmentVacations(deptId, year, month);
    }
    
    /**
     * 전자결재 승인 후 휴가 일정 자동 등록
     */
    public void createVacationFromApproval(String applicantName, String vacationType, 
                                         LocalDateTime startDate, LocalDateTime endDate, int empId) {
        String title = applicantName + " " + vacationType;
        calendarEventMapper.insertVacationFromApproval(title, vacationType, startDate, endDate, empId);
    }
    
    @Transactional(readOnly = true)
    public List<Map<String, Object>> checkVacationConflicts(int deptId, int excludeEmpId,
                                                           LocalDateTime startDate, LocalDateTime endDate) {
        return calendarEventMapper.checkVacationConflicts(deptId, excludeEmpId, startDate, endDate);
    }

    // ====== 알림 및 대시보드 서비스 ======
    
    @Transactional(readOnly = true)
    public List<Map<String, Object>> findUpcomingImportantEvents(int empId, int deptId) {
        return calendarEventMapper.findUpcomingImportantEvents(empId, deptId);
    }
    
    @Transactional(readOnly = true)
    public List<Map<String, Object>> getThisWeekDepartmentMeetings(int deptId) {
        return calendarEventMapper.getThisWeekDepartmentMeetings(deptId);
    }
    
    @Transactional(readOnly = true)
    public List<Map<String, Object>> getProjectDeadlineAlerts(int empId) {
        return calendarEventMapper.getProjectDeadlineAlerts(empId);
    }

    // ====== 검색 및 유틸리티 서비스 ======
    
    @Transactional(readOnly = true)
    public List<CalendarEvent> searchEvents(String keyword, int empId, int deptId,
                                          String eventType, LocalDate startDate, LocalDate endDate, int limit) {
        return calendarEventMapper.searchEvents(keyword, empId, deptId, eventType, startDate, endDate, limit);
    }
    
    @Transactional(readOnly = true)
    public boolean hasConflictingEvents(int empId, String eventType,
                                      LocalDateTime startDatetime, LocalDateTime endDatetime, Integer excludeEventId) {
        int count = calendarEventMapper.checkConflictingEvents(empId, eventType, startDatetime, endDatetime, excludeEventId);
        return count > 0;
    }
    
    @Transactional(readOnly = true)
    public boolean isProjectMember(int projectId, int empId) {
        return calendarEventMapper.isProjectMember(projectId, empId);
    }

    // ====== 배치 처리 서비스 ======
    
    /**
     * 만료된 일정 정리 (배치 작업용)
     */
    public int cleanupExpiredEvents(LocalDateTime beforeDate) {
        return calendarEventMapper.deleteExpiredEvents(beforeDate);
    }

    // ====== 비즈니스 로직 및 검증 ======
    
    /**
     * 일정 생성 전 유효성 검증
     */
    private void validateEvent(CalendarEvent event) {
        if (event == null) {
            throw new IllegalArgumentException("일정 정보가 필요합니다.");
        }
        
        if (event.getEventTitle() == null || event.getEventTitle().trim().isEmpty()) {
            throw new IllegalArgumentException("일정 제목은 필수입니다.");
        }
        
        if (event.getStartDatetime() == null) {
            throw new IllegalArgumentException("시작 일시는 필수입니다.");
        }
        
        if (event.getCreatedBy() == null || event.getCreatedBy() == 0) {
            throw new IllegalArgumentException("등록자 정보가 필요합니다.");
        }
        
        // 종료 시간이 시작 시간보다 이전인지 확인
        if (event.getEndDatetime() != null && event.getEndDatetime().isBefore(event.getStartDatetime())) {
            throw new IllegalArgumentException("종료 시간은 시작 시간보다 늦어야 합니다.");
        }
        
        // 이벤트 타입별 필드 검증
        validateEventTypeConstraints(event);
    }
    
    /**
     * 이벤트 타입별 제약조건 검증
     */

    private void validateEventTypeConstraints(CalendarEvent event) {
        String eventType = event.getEventType();

        if (eventType == null) {
            event.setEventType("PERSONAL");
            eventType = "PERSONAL";
        }

        switch (eventType) {
            case "COMPANY":
            case "VACATION":
            case "PERSONAL":
                // deptId, projectId는 반드시 null이어야 한다
                if (event.getDeptId() != null || event.getProjectId() != null) {
                    throw new IllegalArgumentException(eventType + " 일정은 부서나 프로젝트와 연결될 수 없습니다.");
                }
                break;

            case "DEPARTMENT":
                if (event.getDeptId() == null) {
                    throw new IllegalArgumentException("부서 일정은 deptId가 필요합니다.");
                }
                if (event.getProjectId() != null) {
                    throw new IllegalArgumentException("부서 일정은 프로젝트와 연결될 수 없습니다.");
                }
                break;

            case "PROJECT":
                if (event.getProjectId() == null) {
                    throw new IllegalArgumentException("프로젝트 일정은 projectId가 필요합니다.");
                }
                if (event.getDeptId() != null) {
                    throw new IllegalArgumentException("프로젝트 일정은 부서와 연결될 수 없습니다.");
                }
                break;

            default:
                throw new IllegalArgumentException("지원하지 않는 일정 유형입니다: " + eventType);
        }
    }

    
    /**
     * 중복 일정 검증 (선택적 사용)
     */
    public void validateNoConflicts(CalendarEvent event) {
        if (hasConflictingEvents(event.getCreatedBy(), event.getEventType(), 
                                event.getStartDatetime(), event.getEndDatetime(), event.getEventId())) {
            throw new IllegalStateException("같은 시간대에 이미 등록된 일정이 있습니다.");
        }
    }
    
    /**
     * 휴가 충돌 알림 (부서 내 휴가가 겹치는 경우)
     */
    @Transactional(readOnly = true)
    public String getVacationConflictWarning(int deptId, int empId, 
                                           LocalDateTime startDate, LocalDateTime endDate) {
        List<Map<String, Object>> conflicts = checkVacationConflicts(deptId, empId, startDate, endDate);
        
        if (conflicts.isEmpty()) {
            return null;
        }
        
        StringBuilder warning = new StringBuilder("같은 기간에 휴가 예정인 부서원: ");
        for (int i = 0; i < conflicts.size(); i++) {
            if (i > 0) warning.append(", ");
            warning.append(conflicts.get(i).get("emp_name"));
        }
        
        return warning.toString();
    }
    
        // ====== 부서별 필터링이 강화된 조회 메서드들 ======
        
        /**
         * 사용자별 권한을 고려한 일정 범위 조회 (강화된 버전)
         */
        @Transactional(readOnly = true)
        public List<CalendarEvent> findEventsByRangeAndUserWithPermission(LocalDateTime start, LocalDateTime end,
                                                                         int empId, List<String> types) {
            System.out.println("=== 권한 기반 일정 조회 시작 ===");
            System.out.println("사용자 ID: " + empId);
            System.out.println("요청 타입들: " + types);
            
            // 1. 사용자의 권한 정보 조회
            Map<String, Object> userInfo = employeeService.getUserPermissionInfo(empId);
            Integer userDeptId = (Integer) userInfo.get("deptId");
            
            System.out.println("사용자 부서: " + userInfo.get("deptName") + " (ID: " + userDeptId + ")");
            
            // 2. 기본 조회 (mapper에서 기본적인 권한 필터링)
            List<CalendarEvent> events = calendarEventMapper.findEventsByRangeAndUser(
                start, end, empId, userDeptId != null ? userDeptId : 0, types);
            
            System.out.println("DB에서 조회된 일정 수: " + events.size());
            
            // 3. 서비스 레이어에서 추가 권한 필터링
            List<CalendarEvent> filteredEvents = events.stream()
                .filter(event -> hasViewPermission(event, empId, userInfo))
                .collect(java.util.stream.Collectors.toList());
            
            System.out.println("권한 필터링 후 일정 수: " + filteredEvents.size());
            System.out.println("=== 권한 기반 일정 조회 완료 ===");
            
            return filteredEvents;
        }
        
        /**
         * 오늘의 일정 조회 (권한 강화)
         */
        @Transactional(readOnly = true)
        public List<CalendarEvent> findTodayScheduleForUserWithPermission(int empId, LocalDateTime startOfDay, LocalDateTime endOfDay) {
            System.out.println("=== 오늘의 일정 조회 (권한 강화) ===");
            
            // 사용자 권한 정보 조회
            Map<String, Object> userInfo = employeeService.getUserPermissionInfo(empId);
            Integer userDeptId = (Integer) userInfo.get("deptId");
            
            // 기본 조회
            List<CalendarEvent> events = calendarEventMapper.findTodayScheduleForUser(
                empId, userDeptId != null ? userDeptId : 0, startOfDay, endOfDay);
            
            // 권한 필터링
            List<CalendarEvent> filteredEvents = events.stream()
                .filter(event -> hasViewPermission(event, empId, userInfo))
                .collect(java.util.stream.Collectors.toList());
            
            System.out.println("오늘의 일정 - 원본: " + events.size() + ", 필터링 후: " + filteredEvents.size());
            
            return filteredEvents;
        }
        
        /**
         * 일정 상세 조회 (권한 체크 포함)
         */
        @Transactional(readOnly = true)
        public CalendarEvent findByIdWithPermissionCheck(int eventId, int requestUserId) {
            CalendarEvent event = calendarEventMapper.selectById(eventId);
            
            if (event == null) {
                throw new IllegalArgumentException("존재하지 않는 일정입니다.");
            }
            
            // 조회 권한 체크
            Map<String, Object> userInfo = employeeService.getUserPermissionInfo(requestUserId);
            
            if (!hasViewPermission(event, requestUserId, userInfo)) {
                System.out.println("일정 조회 권한 없음: eventId=" + eventId + ", userId=" + requestUserId);
                throw new IllegalStateException("해당 일정을 조회할 권한이 없습니다.");
            }
            
            return event;
        }
        
        // ====== 권한 체크 헬퍼 메서드들 ======
        
        /**
         * 일정 조회 권한 체크 (핵심 메서드)
         */
        private boolean hasViewPermission(CalendarEvent event, int empId, Map<String, Object> userInfo) {
            String eventType = event.getEventType();
            Integer userDeptId = (Integer) userInfo.get("deptId");
            
            switch (eventType) {
                case "COMPANY":
                    // 회사 일정은 모든 사용자가 조회 가능
                    return true;
                    
                case "DEPARTMENT":
                    // 부서 일정은 같은 부서원만 조회 가능
                    boolean canViewDept = userDeptId != null && userDeptId.equals(event.getDeptId());
                    if (!canViewDept) {
                        System.out.println("부서 일정 조회 권한 없음: userDept=" + userDeptId + ", eventDept=" + event.getDeptId());
                    }
                    return canViewDept;
                    
                case "PERSONAL":
                    // 개인 일정은 본인만 조회 가능
                    boolean canViewPersonal = event.getCreatedBy().equals(empId);
                    if (!canViewPersonal) {
                        System.out.println("개인 일정 조회 권한 없음: user=" + empId + ", creator=" + event.getCreatedBy());
                    }
                    return canViewPersonal;
                    
                case "VACATION":
                    // 휴가 일정은 본인이거나 같은 부서원
                    boolean isSelf = event.getCreatedBy().equals(empId);
                    boolean isSameDeptForVacation = employeeService.canViewDepartmentEvent(empId, event.getDeptId());
                    return isSelf || isSameDeptForVacation;
                    
                case "PROJECT":
                    // 프로젝트 일정은 프로젝트 멤버이거나 작성자이거나 부서장
                    boolean isCreator = event.getCreatedBy().equals(empId);
                    boolean isManager = employeeService.isDepartmentManager(empId);
                    boolean isProjectMember = isProjectMember(event.getProjectId(), empId);
                    
                    return isCreator || isManager || isProjectMember;
                    
                default:
                    System.out.println("알 수 없는 일정 타입: " + eventType);
                    return false;
            }
        }
        
        /**
         * 부서 일정 생성 권한 체크
         */
        public void validateDepartmentEventCreation(CalendarEvent event, int empId) {
            if (!"DEPARTMENT".equals(event.getEventType())) {
                return; // 부서 일정이 아니면 체크하지 않음
            }
            
            System.out.println("=== 부서 일정 생성 권한 체크 ===");
            
            // 1. 부서장 권한 확인
            if (!employeeService.isDepartmentManager(empId)) {
                throw new IllegalStateException("부서 일정은 부서장만 등록할 수 있습니다.");
            }
            
            // 2. 자신의 부서에만 등록 가능한지 확인
            if (!employeeService.canManageDepartment(empId, event.getDeptId())) {
                throw new IllegalStateException("자신이 관리하는 부서에만 일정을 등록할 수 있습니다.");
            }
            
            System.out.println("부서 일정 생성 권한 확인 완료: empId=" + empId + ", deptId=" + event.getDeptId());
        }
        
        /**
         * 부서 일정 수정/삭제 권한 체크
         */
        public void validateDepartmentEventModification(CalendarEvent event, int empId) {
            if (!"DEPARTMENT".equals(event.getEventType())) {
                return; // 부서 일정이 아니면 체크하지 않음
            }
            
            System.out.println("=== 부서 일정 수정 권한 체크 ===");
            
            if (!employeeService.canModifyDepartmentEvent(empId, event.getDeptId(), event.getCreatedBy())) {
                throw new IllegalStateException("이 부서 일정을 수정할 권한이 없습니다.");
            }
            
            System.out.println("부서 일정 수정 권한 확인 완료");
        }
        
        // ====== create 메서드 오버라이드 (권한 체크 포함) ======
        
        /**
         * 일정 생성 (권한 체크 포함)
         */
        public void createWithPermissionCheck(CalendarEvent event, int creatorId) {
            System.out.println("=== 권한 체크를 포함한 일정 생성 ===");
            
            // 기본 유효성 검증
            validateEvent(event);
            
            // 생성자 정보 설정
            event.setCreatedBy(creatorId);
            
            // 타입별 권한 체크
            switch (event.getEventType()) {
                case "COMPANY":
                    if (!employeeService.isManagementSupportManager(creatorId)) {
                        throw new IllegalStateException("회사 일정은 경영지원부장만 등록할 수 있습니다.");
                    }
                    break;
                    
                case "DEPARTMENT":
                    validateDepartmentEventCreation(event, creatorId);
                    break;
                    
                case "PROJECT":
                    if (!employeeService.isProjectManager(creatorId)) {
                        throw new IllegalStateException("프로젝트 일정은 PM만 등록할 수 있습니다.");
                    }
                    break;
                    
                case "VACATION":
                    throw new IllegalStateException("휴가 일정은 전자결재를 통해서만 등록됩니다.");
                    
                case "PERSONAL":
                    // 개인 일정은 모든 사용자 가능
                    break;
                    
                default:
                    throw new IllegalArgumentException("지원하지 않는 일정 유형: " + event.getEventType());
            }
            
            // 실제 생성
            calendarEventMapper.insert(event);
            
            System.out.println("일정 생성 완료: " + event.getEventTitle() + " (타입: " + event.getEventType() + ")");
        }
        
        /**
         * 일정 수정 (권한 체크 포함)
         */
        public void updateWithPermissionCheck(CalendarEvent event, int requestUserId) {
            if (event.getEventId() <= 0) {
                throw new IllegalArgumentException("수정할 일정 ID가 필요합니다.");
            }
            
            // 기존 일정 조회
            CalendarEvent existing = findById(event.getEventId());
            if (existing == null) {
                throw new IllegalArgumentException("존재하지 않는 일정입니다.");
            }
            
            System.out.println("=== 일정 수정 권한 체크 ===");
            
            // 휴가 일정은 수정 불가
            if ("VACATION".equals(existing.getEventType())) {
                throw new IllegalStateException("휴가 일정은 수정할 수 없습니다.");
            }
            
            // 타입별 수정 권한 체크
            validateModificationPermission(existing, requestUserId);
            
            // 수정 실행
            calendarEventMapper.updatePartial(event);
            
            System.out.println("일정 수정 완료: eventId=" + event.getEventId());
        }
        
        /**
         * 일정 삭제 (권한 체크 포함)
         */
        public void deleteWithPermissionCheck(int eventId, int requestUserId) {
            CalendarEvent existing = findById(eventId);
            if (existing == null) {
                throw new IllegalArgumentException("존재하지 않는 일정입니다.");
            }
            
            System.out.println("=== 일정 삭제 권한 체크 ===");
            
            // 휴가 일정은 삭제 불가
            if ("VACATION".equals(existing.getEventType())) {
                throw new IllegalStateException("휴가 일정은 삭제할 수 없습니다.");
            }
            
            // 타입별 삭제 권한 체크
            validateModificationPermission(existing, requestUserId);
            
            // 삭제 실행
            calendarEventMapper.delete(eventId);
            
            System.out.println("일정 삭제 완료: eventId=" + eventId);
        }
        
        /**
         * 수정/삭제 권한 체크 (공통)
         */
        private void validateModificationPermission(CalendarEvent event, int requestUserId) {
            // 본인이 등록한 일정이 아니면 수정/삭제 불가
            if (!event.getCreatedBy().equals(requestUserId)) {
                throw new IllegalStateException("본인이 등록한 일정만 수정/삭제할 수 있습니다.");
            }
            
            // 타입별 추가 권한 체크
            switch (event.getEventType()) {
                case "COMPANY":
                    if (!employeeService.isManagementSupportManager(requestUserId)) {
                        throw new IllegalStateException("회사 일정 수정 권한이 없습니다.");
                    }
                    break;
                    
                case "DEPARTMENT":
                    validateDepartmentEventModification(event, requestUserId);
                    break;
                    
                case "PROJECT":
                    if (!employeeService.isProjectManager(requestUserId)) {
                        throw new IllegalStateException("프로젝트 일정 수정 권한이 없습니다.");
                    }
                    break;
                    
                case "PERSONAL":
                    // 개인 일정은 본인 확인만으로 충분
                    break;
            }
        }
        
        // ====== 부서별 통계 및 유틸리티 메서드들 ======
        
        /**
         * 부서별 일정 현황 조회
         */
        @Transactional(readOnly = true)
        public Map<String, Object> getDepartmentEventsSummary(int deptId, int requestUserId) {
            // 요청자가 해당 부서 소속인지 확인
            if (!employeeService.canViewDepartmentEvent(requestUserId, deptId)) {
                throw new IllegalStateException("해당 부서의 일정 현황을 조회할 권한이 없습니다.");
            }
            
            return calendarEventMapper.getDepartmentScheduleStats(deptId);
        }
        
        /**
         * 부서원들의 휴가 일정 조회 (부서장용)
         */
        @Transactional(readOnly = true)
        public List<CalendarEvent> findDepartmentVacationsForManager(int deptId, LocalDate targetDate, int requestUserId) {
            // 부서장 권한 확인
            if (!employeeService.isDepartmentManagerOf(requestUserId, deptId)) {
                throw new IllegalStateException("해당 부서의 휴가 현황을 조회할 권한이 없습니다.");
            }
            
            return findDepartmentVacations(deptId, targetDate);
        }
    
}