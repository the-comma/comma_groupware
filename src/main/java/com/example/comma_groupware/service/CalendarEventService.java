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
@RequiredArgsConstructor
@Transactional
public class CalendarEventService {

    private final CalendarEventMapper calendarEventMapper;

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
    
    
}