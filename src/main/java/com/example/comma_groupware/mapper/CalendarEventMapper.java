package com.example.comma_groupware.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import com.example.comma_groupware.dto.CalendarEvent;

@Mapper
public interface CalendarEventMapper {
    
    // ====== 기본 CRUD ======
    int insert(CalendarEvent e);
    
    CalendarEvent selectById(@Param("eventId") int eventId);
    
    // 기간별 조회
    List<CalendarEvent> selectByRange(
            @Param("start") LocalDateTime start,
            @Param("end") LocalDateTime end
    );
    
    // 부분 수정 (null 무시)
    int updatePartial(CalendarEvent e);
    
    // 삭제
    int delete(@Param("eventId") int eventId);

    // ====== 권한별 조회 메서드 ======
    
    /**
     * 오늘의 일정 조회 (사용자별 권한 적용)
     */
    List<CalendarEvent> findTodayScheduleForUser(
            @Param("empId") int empId,
            @Param("deptId") int deptId,
            @Param("startOfDay") LocalDateTime startOfDay,
            @Param("endOfDay") LocalDateTime endOfDay
    );
    
    /**
     * 범위별 일정 조회 (권한 + 검색 지원)
     */
    List<CalendarEvent> findEventsByRangeAndUserWithKeyword(
            @Param("start") LocalDateTime start,
            @Param("end") LocalDateTime end,
            @Param("empId") int empId,
            @Param("deptId") int deptId,
            @Param("types") List<String> types,
            @Param("keyword") String keyword
    );
    
    /**
     * 일정 상세 조회 (권한 체크 포함)
     */
    CalendarEvent findByIdWithPermissionCheck(
            @Param("eventId") int eventId
    );
    
    // ====== 통계 및 현황 ======
    
    /**
     * 오늘의 일정 통계 (타입별 개수)
     */
    Map<String, Integer> getTodayScheduleStats(
            @Param("empId") int empId,
            @Param("deptId") int deptId,
            @Param("startOfDay") LocalDateTime startOfDay,
            @Param("endOfDay") LocalDateTime endOfDay
    );
    
    /**
     * 부서별 일정 통계
     */
    Map<String, Object> getDepartmentScheduleStats(
            @Param("deptId") int deptId
    );
    
    /**
     * 프로젝트별 일정 통계
     */
    Map<String, Object> getProjectScheduleStats(
            @Param("pmId") int pmId
    );
    
    /**
     * 개인 일정 월간 통계
     */
    List<Map<String, Object>> getPersonalScheduleMonthlyStats(
            @Param("empId") int empId,
            @Param("year") int year
    );
    
    // ====== 휴가 관련 ======
    
    /**
     * 부서 휴가 현황 조회 (일자별)
     */
    List<CalendarEvent> findDepartmentVacations(
            @Param("deptId") int deptId,
            @Param("start") LocalDateTime start,
            @Param("end") LocalDateTime end
    );
    
    /**
     * 기간별 부서 휴가 현황 (상세)
     */
    List<Map<String, Object>> findDepartmentVacationsByRange(
            @Param("deptId") int deptId,
            @Param("start") LocalDateTime start,
            @Param("end") LocalDateTime end
    );
    
    /**
     * 부서 휴가 사용 현황 요약 (연간)
     */
    List<Map<String, Object>> getDepartmentVacationSummary(
    	    @Param("deptId") Integer deptId, 
    	    @Param("year") int year
    	);

    
    /**
     * 월간 부서 휴가 현황
     */
    List<Map<String, Object>> getMonthlyDepartmentVacations(
            @Param("deptId") int deptId,
            @Param("year") int year,
            @Param("month") int month
    );
    
    /**
     * 휴가 일정 자동 등록 (전자결재 연동용)
     */
    int insertVacationFromApproval(
            @Param("title") String title,
            @Param("vacationType") String vacationType,
            @Param("startDate") LocalDateTime startDate,
            @Param("endDate") LocalDateTime endDate,
            @Param("empId") int empId
    );
    
    /**
     * 휴가 충돌 체크 (같은 부서 내)
     */
    List<Map<String, Object>> checkVacationConflicts(
            @Param("deptId") int deptId,
            @Param("excludeEmpId") int excludeEmpId,
            @Param("startDate") LocalDateTime startDate,
            @Param("endDate") LocalDateTime endDate
    );
    
    // ====== 알림 및 대시보드용 ======
    
    /**
     * 다가오는 중요 일정
     */
    List<Map<String, Object>> findUpcomingImportantEvents(
            @Param("empId") int empId,
            @Param("deptId") int deptId
    );
    
    /**
     * 이번 주 부서 회의 현황
     */
    List<Map<String, Object>> getThisWeekDepartmentMeetings(
            @Param("deptId") int deptId
    );
    
    /**
     * 프로젝트 마감 임박 일정
     */
    List<Map<String, Object>> getProjectDeadlineAlerts(
            @Param("empId") int empId
    );
    
    // ====== 검색 및 유틸리티 ======
    
    /**
     * 일정 검색
     */
    List<CalendarEvent> searchEvents(
            @Param("keyword") String keyword,
            @Param("empId") int empId,
            @Param("deptId") int deptId,
            @Param("eventType") String eventType,
            @Param("startDate") LocalDate startDate,
            @Param("endDate") LocalDate endDate,
            @Param("limit") int limit
    );
    
    /**
     * 중복 일정 체크
     */
    int checkConflictingEvents(
            @Param("empId") int empId,
            @Param("eventType") String eventType,
            @Param("startDatetime") LocalDateTime startDatetime,
            @Param("endDatetime") LocalDateTime endDatetime,
            @Param("excludeEventId") Integer excludeEventId
    );
    
    /**
     * 프로젝트 멤버 확인
     */
    boolean isProjectMember(
            @Param("projectId") int projectId,
            @Param("empId") int empId
    );
    
    // ====== 배치 처리용 ======
    
    /**
     * 만료된 일정 정리 (선택적)
     */
    int deleteExpiredEvents(@Param("beforeDate") LocalDateTime beforeDate);
    
    /**
     * 반복 일정 생성 (선택적)
     */
    int insertRecurringEvents(
            @Param("baseEvent") CalendarEvent baseEvent,
            @Param("endDate") LocalDateTime endDate,
            @Param("intervalType") String intervalType
    );
    
    List<Map<String, Object>> selectDepartmentVacationSummary(
    	    @Param("deptId") Integer deptId, 
        @Param("year") int year
    	);
}