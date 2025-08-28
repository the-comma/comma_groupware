package com.example.comma_groupware.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.security.core.Authentication;

import com.example.comma_groupware.dto.Employee;
import com.example.comma_groupware.dto.Department;
import com.example.comma_groupware.dto.CalendarEvent;
import com.example.comma_groupware.service.EmployeeService;
import com.example.comma_groupware.service.DepartmentService;
import com.example.comma_groupware.service.CalendarEventService;
import com.example.comma_groupware.mapper.EmployeeMapper;

import lombok.RequiredArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.stream.Collectors;

@Controller
public class CalendarEventController {

    private final EmployeeService employeeService;
    private final DepartmentService departmentService;
    private final CalendarEventService calendarService;
    private final EmployeeMapper employeeMapper;
    
    public CalendarEventController(EmployeeService employeeService, DepartmentService departmentService, 
                                 CalendarEventService calendarService, EmployeeMapper employeeMapper) {
        this.employeeService = employeeService;
        this.departmentService = departmentService;
        this.calendarService = calendarService;
        this.employeeMapper = employeeMapper;
    }
    
    // ====== 메인 캘린더 페이지 ======
    @GetMapping("/calendar")
    public String calendarPage(Model model, Authentication auth) {
        // 사용자 정보 조회
        Employee currentUser = getCurrentEmployee(auth);
        
        // EmployeeService를 통한 정확한 권한 정보 조회
        Map<String, Object> userPermission = employeeService.getUserPermissionInfo(currentUser.getEmpId());
        
        // 권한 정보를 JSP에 전달
        boolean isManagementSupportManager = ((Number) userPermission.get("isManagementSupportManager")).intValue() == 1;
        boolean isDepartmentManager = ((Number) userPermission.get("isDeptManager")).intValue() == 1;
        boolean isProjectManager = ((Number) userPermission.get("isProjectManager")).intValue() == 1;
        
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("userDepartment", userPermission.get("deptName"));
        model.addAttribute("isManagementSupportManager", isManagementSupportManager);
        model.addAttribute("isDepartmentManager", isDepartmentManager);
        model.addAttribute("isProjectManager", isProjectManager);
        
        // 부서 목록 (부서 일정 등록용) - 수정된 로직
        List<Department> departments = new ArrayList<>();
        if (isDepartmentManager || isManagementSupportManager) {
            if (isManagementSupportManager) {
                // 경영지원부장은 전체 부서 조회 가능
                departments = departmentService.findAll();
                System.out.println("경영지원부장 - 전체 부서 조회: " + departments.size() + "개");
            } else if (isDepartmentManager) {
                // 일반 부서장은 자신의 부서만
                Integer deptId = (Integer) userPermission.get("deptId");
                if (deptId != null) {
                    Department userDept = departmentService.findById(deptId);
                    if (userDept != null) {
                        departments.add(userDept);
                        System.out.println("부서장 - 자신 부서만: " + userDept.getDeptName());
                    }
                }
            }
        }
        // 부서장이 아니어도 departments 변수는 항상 전달 (빈 리스트라도)
        model.addAttribute("departments", departments);
        
        // 디버깅용 권한 정보 출력
        System.out.println("=== 캘린더 페이지 권한 디버깅 ===");
        System.out.println("경영지원부장: " + isManagementSupportManager);
        System.out.println("부서장: " + isDepartmentManager);
        System.out.println("PM: " + isProjectManager);
        System.out.println("부서 목록 개수: " + departments.size());
        System.out.println("사용자 부서: " + userPermission.get("deptName"));
        employeeService.printUserAuthorities(currentUser.getEmpId());
        
        model.addAttribute("topbarTitle", "캘린더");
        return "appsCalendar";
    }

    // ====== 캘린더 관리 페이지 ======
    @GetMapping("/calendar/management")
    public String calendarManagementPage(Model model, Authentication auth) {
        Employee currentUser = getCurrentEmployee(auth);
        
        // 정확한 권한 체크
        boolean isManagementSupportManager = employeeService.isManagementSupportManager(currentUser.getEmpId());
        boolean isDepartmentManager = employeeService.isDepartmentManager(currentUser.getEmpId());
        boolean isProjectManager = employeeService.isProjectManager(currentUser.getEmpId());
        
        // 권한 체크 - 관리자급만 접근 가능
        if (!isManagementSupportManager && !isDepartmentManager && !isProjectManager) {
            return "redirect:/calendar"; // 권한 없으면 일반 캘린더로 리다이렉트
        }
        
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("isManagementSupportManager", isManagementSupportManager);
        model.addAttribute("isDepartmentManager", isDepartmentManager);
        model.addAttribute("isProjectManager", isProjectManager);
        
        // 부서별 통계 (부서장 이상)
        if (isDepartmentManager || isManagementSupportManager) {
            Integer deptId = isManagementSupportManager ? 0 : employeeService.getUserDepartmentId(currentUser.getEmpId());
            if (deptId != null) {
                Map<String, Object> departmentStats = calendarService.getDepartmentScheduleStats(deptId);
                model.addAttribute("departmentStats", departmentStats);
            }
        }
        
        // 프로젝트별 통계 (PM)
        if (isProjectManager) {
            Map<String, Object> projectStats = calendarService.getProjectScheduleStats(currentUser.getEmpId());
            model.addAttribute("projectStats", projectStats);
        }
        
        return "calendarManagement";
    }

    // ====== 대시보드용 오늘의 일정 위젯 ======
    @GetMapping("/dashboard/today-schedule")
    public String todayScheduleWidget(Model model, Authentication auth) {
        Employee currentUser = getCurrentEmployee(auth);
        Integer deptId = employeeService.getUserDepartmentId(currentUser.getEmpId());
        
        // 오늘의 일정 요약 정보
        LocalDate today = LocalDate.now();
        LocalDateTime startOfDay = today.atStartOfDay();
        LocalDateTime endOfDay = today.atTime(23, 59, 59);
        
        // 오늘의 일정 개수 (타입별)
        Map<String, Integer> todayStats = calendarService.getTodayScheduleStats(
            currentUser.getEmpId(), deptId != null ? deptId : 0,
            startOfDay, endOfDay
        );
        
        // 오늘의 주요 일정 (최대 5개)
        List<CalendarEvent> todayEventsList = calendarService.findTodayScheduleForUser(
            currentUser.getEmpId(), deptId != null ? deptId : 0, startOfDay, endOfDay
        );
        
        List<Map<String, Object>> todayEvents = todayEventsList.stream()
            .limit(5)
            .map(event -> {
                Map<String, Object> eventMap = new HashMap<>();
                eventMap.put("id", event.getEventId());
                eventMap.put("title", event.getEventTitle());
                eventMap.put("start", event.getStartDatetime());
                eventMap.put("type", toCategoryName(event.getEventType()));
                eventMap.put("isAllDay", event.getIsAllDay() == 1);
                return eventMap;
            })
            .collect(Collectors.toList());
        
        model.addAttribute("todayStats", todayStats);
        model.addAttribute("todayEvents", todayEvents);
        model.addAttribute("currentUser", currentUser);
        
        return "dashboard/todayScheduleWidget";
    }

    // ====== 휴가 현황 페이지 ======
    @GetMapping("/calendar/vacation")
    public String vacationStatusPage(Model model, Authentication auth) {
        Employee currentUser = getCurrentEmployee(auth);
        Integer deptId = employeeService.getUserDepartmentId(currentUser.getEmpId());
        
        // 이번 달 부서원 휴가 현황
        LocalDate today = LocalDate.now();
        LocalDate startOfMonth = today.withDayOfMonth(1);
        LocalDate endOfMonth = today.withDayOfMonth(today.lengthOfMonth());
        
        List<Map<String, Object>> departmentVacations = calendarService.findDepartmentVacationsByRange(
            deptId != null ? deptId : 0, 
            startOfMonth.atStartOfDay(), endOfMonth.atTime(23, 59, 59)
        );
        
        // 부서원별 휴가 사용 현황 요약
        Map<String, Object> vacationSummary = calendarService.getDepartmentVacationSummary(
            deptId, today.getYear()  // Integer 그대로 전달 (null이어도 괜찮음)
        );

        // 필요하다면 employees 부분만 추출
        List<Map<String, Object>> vacationList = (List<Map<String, Object>>) vacationSummary.get("employees");
        
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("departmentVacations", departmentVacations);
        model.addAttribute("vacationSummary", vacationSummary);
        model.addAttribute("currentMonth", today.getMonthValue());
        model.addAttribute("currentYear", today.getYear());
        
        return "calendarVacation";
    }

    // ====== 헬퍼 메서드 ======
    private Employee getCurrentEmployee(Authentication auth) {
        String username = auth.getName();
        Employee emp = employeeMapper.selectByUserName(username);
        if (emp == null) {
            throw new IllegalStateException("사용자 정보를 찾을 수 없습니다: " + username);
        }
        return emp;
    }

    private String toCategoryName(String type) {
        if (type == null) return "personal";
        switch (type) {
            case "COMPANY":    return "company";
            case "DEPARTMENT": return "department";
            case "PROJECT":    return "project";
            case "VACATION":   return "vacation";
            case "PERSONAL":   return "personal";
            default:           return "personal";
        }
    }
}