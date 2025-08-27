package com.example.comma_groupware.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.security.core.Authentication;

import com.example.comma_groupware.dto.Employee;
import com.example.comma_groupware.dto.Department;
import com.example.comma_groupware.dto.CalendarEvent;  // 추가된 import
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
import java.util.stream.Collectors;

@Controller
@RequiredArgsConstructor
public class CalendarEventController {

    private final EmployeeService employeeService;
    private final DepartmentService departmentService;
    private final CalendarEventService calendarService;
    private final EmployeeMapper employeeMapper;
    
    // ====== 메인 캘린더 페이지 ======
    @GetMapping("/calendar")
    public String calendarPage(Model model, Authentication auth) {
        // 사용자 정보 조회
        Employee currentUser = getCurrentEmployee(auth);
        Department userDept = getCurrentUserDepartment(currentUser.getEmpId());
        
        // 사용자 권한 정보를 모델에 추가
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("userDepartment", userDept != null ? userDept.getDateName() : "");
        model.addAttribute("isManagementSupportManager", hasManagementSupportRole(currentUser, userDept));
        model.addAttribute("isDepartmentManager", isDepartmentManager(currentUser));
        model.addAttribute("isProjectManager", isProjectManager(currentUser, userDept));
        
        // 부서 목록 (부서 일정 등록용)
        if (isDepartmentManager(currentUser)) {
            List<Department> departments = hasManagementSupportRole(currentUser, userDept) ? 
                departmentService.findAll() : 
                (userDept != null ? List.of(userDept) : List.of());
            model.addAttribute("departments", departments);
        }
        
        return "appsCalendar"; // -> /WEB-INF/views/appsCalendar.jsp
    }

    // ====== 캘린더 관리 페이지 ======
    @GetMapping("/calendar/management")
    public String calendarManagementPage(Model model, Authentication auth) {
        Employee currentUser = getCurrentEmployee(auth);
        Department userDept = getCurrentUserDepartment(currentUser.getEmpId());
        
        // 권한 체크 - 관리자급만 접근 가능
        if (!hasManagementSupportRole(currentUser, userDept) && 
            !isDepartmentManager(currentUser) && 
            !isProjectManager(currentUser, userDept)) {
            return "redirect:/calendar"; // 권한 없으면 일반 캘린더로 리다이렉트
        }
        
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("isManagementSupportManager", hasManagementSupportRole(currentUser, userDept));
        model.addAttribute("isDepartmentManager", isDepartmentManager(currentUser));
        model.addAttribute("isProjectManager", isProjectManager(currentUser, userDept));
        
        // 부서별 통계 (부서장 이상)
        if (isDepartmentManager(currentUser) || hasManagementSupportRole(currentUser, userDept)) {
            int deptId = hasManagementSupportRole(currentUser, userDept) ? 0 : (userDept != null ? userDept.getDeptId() : 0);
            Map<String, Object> departmentStats = calendarService.getDepartmentScheduleStats(deptId);
            model.addAttribute("departmentStats", departmentStats);
        }
        
        // 프로젝트별 통계 (PM)
        if (isProjectManager(currentUser, userDept)) {
            Map<String, Object> projectStats = calendarService.getProjectScheduleStats(currentUser.getEmpId());
            model.addAttribute("projectStats", projectStats);
        }
        
        return "calendarManagement"; // -> /WEB-INF/views/calendarManagement.jsp
    }

    // ====== 대시보드용 오늘의 일정 위젯 ======
    @GetMapping("/dashboard/today-schedule")
    public String todayScheduleWidget(Model model, Authentication auth) {
        Employee currentUser = getCurrentEmployee(auth);
        Department userDept = getCurrentUserDepartment(currentUser.getEmpId());
        
        // 오늘의 일정 요약 정보
        LocalDate today = LocalDate.now();
        LocalDateTime startOfDay = today.atStartOfDay();
        LocalDateTime endOfDay = today.atTime(23, 59, 59);
        
        // 오늘의 일정 개수 (타입별)
        Map<String, Integer> todayStats = calendarService.getTodayScheduleStats(
            currentUser.getEmpId(), userDept != null ? userDept.getDeptId() : 0,
            startOfDay, endOfDay
        );
        
        // 오늘의 주요 일정 (최대 5개)
        List<CalendarEvent> todayEventsList = calendarService.findTodayScheduleForUser(
            currentUser.getEmpId(), userDept != null ? userDept.getDeptId() : 0, startOfDay, endOfDay
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
        
        return "dashboard/todayScheduleWidget"; // -> /WEB-INF/views/dashboard/todayScheduleWidget.jsp
    }

    // ====== 휴가 현황 페이지 ======
    @GetMapping("/calendar/vacation")
    public String vacationStatusPage(Model model, Authentication auth) {
        Employee currentUser = getCurrentEmployee(auth);
        Department userDept = getCurrentUserDepartment(currentUser.getEmpId());
        
        // 이번 달 부서원 휴가 현황
        LocalDate today = LocalDate.now();
        LocalDate startOfMonth = today.withDayOfMonth(1);
        LocalDate endOfMonth = today.withDayOfMonth(today.lengthOfMonth());
        
        List<Map<String, Object>> departmentVacations = calendarService.findDepartmentVacationsByRange(
            userDept != null ? userDept.getDeptId() : 0, 
            startOfMonth.atStartOfDay(), endOfMonth.atTime(23, 59, 59)
        );
        
        // 부서원별 휴가 사용 현황 요약
        Map<String, Object> vacationSummary = calendarService.getDepartmentVacationSummary(
            userDept != null ? userDept.getDeptId() : 0, today.getYear()
        );
        
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("departmentVacations", departmentVacations);
        model.addAttribute("vacationSummary", vacationSummary);
        model.addAttribute("currentMonth", today.getMonthValue());
        model.addAttribute("currentYear", today.getYear());
        
        return "calendarVacation"; // -> /WEB-INF/views/calendarVacation.jsp
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

    // 사용자의 현재 부서 정보 조회
    private Department getCurrentUserDepartment(int empId) {
        return employeeService.getCurrentDepartment(empId);
    }

    private boolean hasManagementSupportRole(Employee employee, Department userDept) {
        // 경영지원부장 권한 체크
        return userDept != null && 
               "경영지원부".equals(userDept.getDateName()) &&
               employee.getRole() != null && 
               (employee.getRole().contains("부장") || employee.getRole().contains("MANAGER"));
    }

    private boolean isDepartmentManager(Employee employee) {
        // 부서장 권한 체크
        return employee.getRole() != null && 
               (employee.getRole().contains("부장") || 
                employee.getRole().contains("팀장") ||
                employee.getRole().contains("매니저") ||
                employee.getRole().contains("MANAGER"));
    }

    private boolean isProjectManager(Employee employee, Department userDept) {
        // PM 권한 체크 (기획부 소속 + PM 직책)
        return userDept != null &&
               ("기획부".equals(userDept.getDateName()) || 
                "개발팀".equals(userDept.getDateName()) ||
                "기술팀".equals(userDept.getDateName())) &&
               (employee.getRole() != null && 
                (employee.getRole().contains("PM") || 
                 employee.getRole().contains("프로젝트") ||
                 employee.getRole().contains("매니저") ||
                 employee.getRole().contains("MANAGER")));
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