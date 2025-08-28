package com.example.comma_groupware.controller;

import org.springframework.web.bind.annotation.*;
import org.springframework.security.core.Authentication;

import com.example.comma_groupware.dto.CalendarEvent;
import com.example.comma_groupware.dto.Employee;
import com.example.comma_groupware.dto.Department;
import com.example.comma_groupware.service.CalendarEventService;
import com.example.comma_groupware.service.EmployeeService;
import com.example.comma_groupware.service.DepartmentService;
import com.example.comma_groupware.mapper.EmployeeMapper;

import lombok.RequiredArgsConstructor;
import java.util.Objects;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.OffsetDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/calendar/events")
@RequiredArgsConstructor
public class CalendarEventRestController {

    private final CalendarEventService calendarService;
    private final EmployeeService employeeService;
    private final DepartmentService departmentService;
    private final EmployeeMapper employeeMapper;

    // ====== 테스트 API ======
    @GetMapping("/test")
    public Map<String, Object> testApi(Authentication auth) {
        System.out.println("=== testApi 호출됨 ===");
        
        Employee currentUser = getCurrentEmployee(auth);
        
        // 권한 정보 디버깅
        employeeService.printUserAuthorities(currentUser.getEmpId());
        
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("user", currentUser.getEmpName());
        result.put("userId", currentUser.getEmpId());
        result.put("message", "API 연결 성공");
        result.put("timestamp", LocalDateTime.now().toString());
        
        System.out.println("응답 데이터: " + result);
        return result;
    }

    // ====== 공통 헬퍼 메서드들 ======
    private LocalDateTime parse(String v) {
        if (v == null || v.isBlank()) return null;
        if (v.length() == 10) return LocalDate.parse(v).atStartOfDay();
        try { return LocalDateTime.parse(v); }
        catch (Exception ignore) { 
            try { return LocalDateTime.parse(v.substring(0,16)); }
            catch (Exception ignore2) { return LocalDate.parse(v.substring(0,10)).atStartOfDay(); }
        }
    }
    
    private LocalDateTime parseRangeParam(String v) {
        try { return OffsetDateTime.parse(v).toLocalDateTime(); }
        catch (Exception ignore1) {
            try { return LocalDateTime.parse(v); }
            catch (Exception ignore2) { return LocalDate.parse(v).atStartOfDay(); }
        }
    }
    
    private String toEventType(String category) {
        if (category == null) return "PERSONAL";
        switch (category.toLowerCase()) {
            case "company":    return "COMPANY";
            case "department": return "DEPARTMENT";
            case "project":    return "PROJECT";
            case "vacation":   return "VACATION";
            case "personal":   return "PERSONAL";
            default:           return "PERSONAL";
        }
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

    private Employee getCurrentEmployee(Authentication auth) {
        String username = auth.getName();
        Employee emp = employeeMapper.selectByUserName(username);
        if (emp == null) throw new IllegalStateException("사용자 정보를 찾을 수 없습니다: " + username);
        return emp;
    }

    // ====== 오늘의 일정 조회 (권한 강화) ======
    @GetMapping("/today")
    public List<Map<String, Object>> getTodaySchedule(Authentication auth) {
        Employee currentUser = getCurrentEmployee(auth);
        
        LocalDate today = LocalDate.now();
        LocalDateTime startOfDay = today.atStartOfDay();
        LocalDateTime endOfDay = today.atTime(23, 59, 59);
        
        System.out.println("=== 오늘의 일정 조회 (권한 강화) ===");
        System.out.println("사용자: " + currentUser.getEmpName());
        
        try {
            // Service의 권한 강화된 오늘 일정 조회 사용
            List<CalendarEvent> events = calendarService.findTodayScheduleForUserWithPermission(
                currentUser.getEmpId(), startOfDay, endOfDay);
            
            return events.stream()
                .map(this::mapEventToResponse)
                .sorted((a, b) -> {
                    boolean aAllDay = (Boolean) a.get("allDay");
                    boolean bAllDay = (Boolean) b.get("allDay");
                    if (aAllDay && !bAllDay) return -1;
                    if (!aAllDay && bAllDay) return 1;
                    return ((String) a.get("start")).compareTo((String) b.get("start"));
                })
                .collect(Collectors.toList());
                
        } catch (Exception e) {
            System.out.println("오늘의 일정 조회 실패: " + e.getMessage());
            throw e;
        }
    }

    // ====== 일정 등록 (권한 강화) ======
    @PostMapping
    public Map<String, Object> createEvent(@RequestBody Map<String, Object> req, Authentication auth) {
        Employee currentUser = getCurrentEmployee(auth);
        
        System.out.println("=== 일정 등록 (권한 강화) ===");
        System.out.println("사용자: " + currentUser.getEmpName() + " (ID: " + currentUser.getEmpId() + ")");
        
        String eventType = (String) req.get("type");
        if (eventType == null || eventType.isBlank()) {
            eventType = "personal";
        }
        
        String title = (String) req.get("title");
        String start = (String) req.get("start");
        String end = (String) req.get("end");
        String memo = (String) req.get("memo");
        
        System.out.println("일정 타입: " + eventType + ", 제목: " + title);
        
        // CalendarEvent 객체 생성
        CalendarEvent event = new CalendarEvent();
        event.setEventTitle(title);
        event.setEventDesc(memo);
        event.setStartDatetime(parse(start));
        event.setEndDatetime((end == null || end.isBlank()) ? 
            event.getStartDatetime().plusHours(1) : parse(end));
        event.setIsAllDay((start != null && start.length() == 10) ? 1 : 0);
        event.setEventType(toEventType(eventType));
        event.setCreatedBy(currentUser.getEmpId());
        
        // 타입별 추가 설정 (부서 일정 처리 강화)
        setEventTypeSpecificFieldsEnhanced(event, req, currentUser);
        
        try {
            // Service의 권한 체크 포함된 생성 메서드 사용
            calendarService.createWithPermissionCheck(event, currentUser.getEmpId());
            
            System.out.println("일정 등록 성공: " + event.getEventTitle());
            return mapEventToResponse(event);
            
        } catch (IllegalStateException | IllegalArgumentException e) {
            System.out.println("일정 등록 실패: " + e.getMessage());
            throw e;
        }
    }

    // ====== 캘린더 범위 조회 (권한 강화) ======
 // ====== 캘린더 범위 조회 (권한 강화 + 검색 추가) ======
    @PostMapping("/range")
    public List<Map<String, Object>> getEventsByRange(
            @RequestBody Map<String, Object> req,
            Authentication auth) {

        Employee currentUser = getCurrentEmployee(auth);

        String startStr = (String) req.get("start");
        String endStr = (String) req.get("end");
        String keyword = (String) req.get("keyword"); // 🔥 검색어 추가
        @SuppressWarnings("unchecked")
        List<String> types = (List<String>) req.get("types");

        LocalDateTime start = parseRangeParam(startStr);
        LocalDateTime end = parseRangeParam(endStr);

        if (types == null || types.isEmpty()) {
            types = new ArrayList<>();
            types.add("company");
            types.add("department");
            types.add("project");
            types.add("vacation");
            types.add("personal");
        }

        System.out.println("=== 일정 범위 조회 (권한 강화 + 검색) ===");
        System.out.println("사용자: " + currentUser.getEmpName() +
                           ", 기간: " + startStr + " ~ " + endStr +
                           ", 검색어: " + keyword +
                           ", 타입: " + types);

        try {
            // 🔥 Service에 keyword 전달
            List<CalendarEvent> events = calendarService.findEventsByRangeAndUserWithPermission(
                start, end, currentUser.getEmpId(), types, 
                (keyword != null && !keyword.isBlank()) ? "%" + keyword + "%" : null
            );

            List<Map<String, Object>> response = events.stream()
                .map(this::mapEventToResponse)
                .collect(Collectors.toList());

            System.out.println("조회 결과: " + response.size() + "개 일정");
            return response;

        } catch (Exception e) {
            System.out.println("일정 조회 실패: " + e.getMessage());
            throw e;
        }
    }


    // ====== 일정 상세 조회 (권한 강화) ======
    @GetMapping("/{id}")
    public Map<String, Object> getEventDetail(@PathVariable int id, Authentication auth) {
        Employee currentUser = getCurrentEmployee(auth);
        
        System.out.println("=== 일정 상세 조회 (권한 강화) ===");
        System.out.println("일정 ID: " + id + ", 사용자: " + currentUser.getEmpName());
        
        try {
            // Service의 권한 체크 포함된 상세 조회 사용
            CalendarEvent event = calendarService.findByIdWithPermissionCheck(id, currentUser.getEmpId());
            
            Map<String, Object> response = mapEventToResponse(event);
            
            // 수정 권한 체크 (Service 메서드 활용)
            boolean canModify = canModifyEventWithService(event, currentUser.getEmpId());
            response.put("canModify", canModify);
            
            // 작성자 정보 추가
            try {
                Employee creator = employeeService.findById(event.getCreatedBy());
                if (creator != null) {
                    response.put("creatorName", creator.getEmpName());
                    Map<String, Object> creatorInfo = employeeService.getEmployeeFullInfo(creator.getEmpId());
                    response.put("creatorDept", creatorInfo.get("deptName"));
                } else {
                    response.put("creatorName", "알 수 없음");
                    response.put("creatorDept", "");
                }
            } catch (Exception e) {
                System.out.println("작성자 정보 조회 실패: " + e.getMessage());
                response.put("creatorName", "조회 실패");
                response.put("creatorDept", "");
            }
            
            System.out.println("일정 상세 조회 성공");
            return response;
            
        } catch (IllegalStateException | IllegalArgumentException e) {
            System.out.println("일정 상세 조회 실패: " + e.getMessage());
            throw e;
        }
    }

    // ====== 일정 수정 (권한 강화) ======
    @PutMapping("/{id}")
    public Map<String, Object> updateEvent(@PathVariable int id, 
                                         @RequestBody Map<String, Object> req, 
                                         Authentication auth) {
        Employee currentUser = getCurrentEmployee(auth);
        
        System.out.println("=== 일정 수정 (권한 강화) ===");
        System.out.println("일정 ID: " + id + ", 사용자: " + currentUser.getEmpName());
        
        String title = (String) req.get("title");
        String start = (String) req.get("start");
        String end = (String) req.get("end");
        String memo = (String) req.get("memo");
        
        CalendarEvent updateEvent = new CalendarEvent();
        updateEvent.setEventId(id);
        if (title != null) updateEvent.setEventTitle(title);
        if (memo != null) updateEvent.setEventDesc(memo);
        if (start != null) updateEvent.setStartDatetime(parse(start));
        if (end != null) updateEvent.setEndDatetime(parse(end));
        
        try {
            // Service의 권한 체크 포함된 수정 메서드 사용
            calendarService.updateWithPermissionCheck(updateEvent, currentUser.getEmpId());
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "일정이 수정되었습니다.");
            
            System.out.println("일정 수정 성공: " + id);
            return response;
            
        } catch (IllegalStateException | IllegalArgumentException e) {
            System.out.println("일정 수정 실패: " + e.getMessage());
            throw e;
        }
    }

    // ====== 일정 삭제 (권한 강화) ======
    @DeleteMapping("/{id}")
    public Map<String, Object> deleteEvent(@PathVariable int id, Authentication auth) {
        Employee currentUser = getCurrentEmployee(auth);
        
        System.out.println("=== 일정 삭제 (권한 강화) ===");
        System.out.println("일정 ID: " + id + ", 사용자: " + currentUser.getEmpName());
        
        try {
            // Service의 권한 체크 포함된 삭제 메서드 사용
            calendarService.deleteWithPermissionCheck(id, currentUser.getEmpId());
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "일정이 삭제되었습니다.");
            
            System.out.println("일정 삭제 성공: " + id);
            return response;
            
        } catch (IllegalStateException | IllegalArgumentException e) {
            System.out.println("일정 삭제 실패: " + e.getMessage());
            throw e;
        }
    }

    // ====== GET 방식 일정 조회 (권한 강화) ======
    @GetMapping
    public List<Map<String, Object>> getEvents(
            @RequestParam String start,
            @RequestParam String end,
            @RequestParam(required = false) String types,
            Authentication auth) {
        
        Employee currentUser = getCurrentEmployee(auth);
        
        LocalDateTime startTime = parseRangeParam(start);
        LocalDateTime endTime = parseRangeParam(end);
        
        // 타입 파싱 (쉼표로 구분된 문자열)
        List<String> typeList = new ArrayList<>();
        if (types != null && !types.isEmpty()) {
            String[] typeArray = types.split(",");
            for (String type : typeArray) {
                typeList.add(type.trim());
            }
        } else {
            typeList.add("company");
            typeList.add("department");
            typeList.add("project");
            typeList.add("vacation");
            typeList.add("personal");
        }
        
        System.out.println("=== GET 이벤트 조회 (권한 강화) ===");
        System.out.println("사용자: " + currentUser.getEmpName() + ", 타입: " + typeList);
        
        try {
            // Service의 권한 기반 필터링 메서드 사용
            List<CalendarEvent> events = calendarService.findEventsByRangeAndUserWithPermission(
                startTime, endTime, currentUser.getEmpId(), typeList);
            
            return events.stream()
                .map(this::mapEventToResponse)
                .collect(Collectors.toList());
                
        } catch (Exception e) {
            System.out.println("GET 이벤트 조회 실패: " + e.getMessage());
            throw e;
        }
    }

    // ====== 부서 목록 조회 ======
    @GetMapping("/departments")
    public List<Map<String, Object>> getDepartments(Authentication auth) {
        Employee currentUser = getCurrentEmployee(auth);
        
        // Service를 통한 권한 체크
        List<Department> departments = new ArrayList<>();
        
        if (employeeService.isManagementSupportManager(currentUser.getEmpId())) {
            // 경영지원부장은 전체 부서 조회 가능
            departments = departmentService.findAll();
        } else if (employeeService.isDepartmentManager(currentUser.getEmpId())) {
            // 부서장은 자신의 부서만 조회 가능
            try {
                Map<String, Object> userInfo = employeeService.getEmployeeFullInfo(currentUser.getEmpId());
                Integer deptId = (Integer) userInfo.get("deptId");
                if (deptId != null) {
                    Department userDept = departmentService.findById(deptId);
                    if (userDept != null) {
                        departments.add(userDept);
                    }
                }
            } catch (Exception e) {
                System.out.println("부서 정보 조회 실패: " + e.getMessage());
            }
        }
        
        return departments.stream()
            .map(dept -> {
                Map<String, Object> deptMap = new HashMap<>();
                deptMap.put("id", dept.getDeptId());
                deptMap.put("name", dept.getDeptName());
                return deptMap;
            })
            .collect(Collectors.toList());
    }

    // ====== 부서원 휴가 현황 조회 ======
    @GetMapping("/vacation/department")
    public List<Map<String, Object>> getDepartmentVacations(
            @RequestParam(required = false) String date, 
            Authentication auth) {
        
        Employee currentUser = getCurrentEmployee(auth);
        LocalDate targetDate = date != null ? LocalDate.parse(date) : LocalDate.now();
        
        try {
            Map<String, Object> userInfo = employeeService.getEmployeeFullInfo(currentUser.getEmpId());
            Integer deptId = (Integer) userInfo.get("deptId");
            
            if (deptId == null) {
                throw new IllegalStateException("소속 부서 정보를 찾을 수 없습니다.");
            }
            
            // Service의 부서장 권한 체크 메서드 사용
            List<CalendarEvent> vacations = calendarService.findDepartmentVacationsForManager(
                deptId, targetDate, currentUser.getEmpId());
            
            return vacations.stream()
                .map(vacation -> {
                    Employee applicant = employeeService.findById(vacation.getCreatedBy());
                    Map<String, Object> vacationMap = new HashMap<>();
                    vacationMap.put("id", vacation.getEventId());
                    vacationMap.put("title", vacation.getEventTitle());
                    vacationMap.put("start", vacation.getStartDatetime().toString());
                    vacationMap.put("end", vacation.getEndDatetime() != null ? 
                        vacation.getEndDatetime().toString() : null);
                    vacationMap.put("applicantName", applicant != null ? applicant.getEmpName() : "Unknown");
                    vacationMap.put("vacationType", vacation.getEventDesc() != null ? 
                        vacation.getEventDesc() : "연차");
                    vacationMap.put("date", targetDate.format(DateTimeFormatter.ofPattern("MM월 dd일")));
                    return vacationMap;
                })
                .collect(Collectors.toList());
                
        } catch (Exception e) {
            System.out.println("휴가 현황 조회 실패: " + e.getMessage());
            throw e;
        }
    }

    // ====== 부서 일정 필드 설정 (강화된 버전) ======
    private void setEventTypeSpecificFieldsEnhanced(CalendarEvent event, Map<String, Object> req, Employee currentUser) {
        switch (event.getEventType()) {
            case "COMPANY":
            case "VACATION":
            case "PERSONAL":
                event.setDeptId(null);
                event.setProjectId(null);
                break;

            case "DEPARTMENT":
                try {
                    // Service에서 사용자 정보 조회
                    Map<String, Object> userInfo = employeeService.getEmployeeFullInfo(currentUser.getEmpId());
                    Integer userDeptId = (Integer) userInfo.get("deptId");
                    
                    if (userDeptId == null) {
                        throw new IllegalArgumentException("소속 부서 정보를 찾을 수 없습니다.");
                    }
                    
                    // 부서장 권한은 Service의 createWithPermissionCheck에서 체크하므로 여기서는 설정만
                    event.setDeptId(userDeptId);
                    event.setProjectId(null);
                    
                    System.out.println("부서 일정 설정: 사용자부서=" + userDeptId + 
                                     " (" + userInfo.get("deptName") + ")");
                    
                } catch (Exception e) {
                    System.out.println("부서 일정 설정 실패: " + e.getMessage());
                    throw new IllegalArgumentException("부서 일정 설정 중 오류가 발생했습니다.");
                }
                break;

            case "PROJECT":
                Integer projectId = (Integer) req.get("projectId");
                if (projectId == null) {
                    throw new IllegalArgumentException("프로젝트 일정은 projectId가 필요합니다.");
                }
                event.setDeptId(null);
                event.setProjectId(projectId);
                break;
        }
    }

    // ====== 수정 권한 체크 (Service 활용) ======
    private boolean canModifyEventWithService(CalendarEvent event, int empId) {
        try {
            // 본인이 등록한 일정이 아니면 false
            if (!event.getCreatedBy().equals(empId)) {
                return false;
            }
            
            // 휴가 일정은 수정 불가
            if ("VACATION".equals(event.getEventType())) {
                return false;
            }
            
            // 타입별 권한 체크 (Service 메서드 활용)
            switch (event.getEventType()) {
                case "COMPANY":
                    return employeeService.isManagementSupportManager(empId);
                    
                case "DEPARTMENT":
                    // Service의 강화된 부서 권한 체크 사용
                    return employeeService.canModifyDepartmentEvent(empId, event.getDeptId(), event.getCreatedBy());
                    
                case "PROJECT":
                    return employeeService.isProjectManager(empId);
                    
                case "PERSONAL":
                    return true;
                    
                default:
                    return false;
            }
        } catch (Exception e) {
            System.out.println("권한 체크 중 오류: " + e.getMessage());
            return false;
        }
    }

    // ====== 응답 매핑 ======
    private Map<String, Object> mapEventToResponse(CalendarEvent event) {
        Map<String, Object> response = new HashMap<>();
        response.put("id", event.getEventId());
        response.put("title", event.getEventTitle());
        response.put("start", event.getStartDatetime().toString());
        response.put("end", event.getEndDatetime() != null ? event.getEndDatetime().toString() : null);
        response.put("allDay", event.getIsAllDay() == 1);
        response.put("type", toCategoryName(event.getEventType()));
        response.put("memo", event.getEventDesc() != null ? event.getEventDesc() : "");
        response.put("creator", event.getCreatedBy());
        response.put("createdDate", event.getCreatedAt() != null ?
            event.getCreatedAt().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")) : "");

        // 부서 정보 추가 (null-safe)
        if (event.getDeptId() != null) {
            Department dept = departmentService.findById(event.getDeptId());
            if (dept != null) {
                response.put("department", dept.getDeptName());
                response.put("departmentId", dept.getDeptId());
            }
        }

        // 휴가 일정인 경우 추가 정보
        if ("VACATION".equals(event.getEventType())) {
            Employee applicant = employeeService.findById(event.getCreatedBy());
            if (applicant != null) {
                response.put("applicant", applicant.getEmpName());
                try {
                    Map<String, Object> applicantInfo = employeeService.getEmployeeFullInfo(applicant.getEmpId());
                    response.put("applicantDept", applicantInfo.get("deptName"));
                } catch (Exception e) {
                    response.put("applicantDept", "");
                }
            }
            response.put("vacationType", parseVacationType(event.getEventDesc()));
        }

        return response;
    }

    // ====== 유틸리티 메서드들 ======
    private String parseVacationType(String eventDesc) {
        if (eventDesc == null) return "연차";
        
        if (eventDesc.contains("반차")) return "반차";
        if (eventDesc.contains("병가")) return "병가";
        if (eventDesc.contains("연차")) return "연차";
        if (eventDesc.contains("특별휴가")) return "특별휴가";
        
        return "연차";
    }

    // ====== 전역 예외 처리 ======
    @ExceptionHandler(IllegalStateException.class)
    public Map<String, Object> handleIllegalStateException(IllegalStateException e) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", false);
        response.put("error", "권한 오류");
        response.put("message", e.getMessage());
        return response;
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public Map<String, Object> handleIllegalArgumentException(IllegalArgumentException e) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", false);
        response.put("error", "입력 오류");
        response.put("message", e.getMessage());
        return response;
    }

    @ExceptionHandler(Exception.class)
    public Map<String, Object> handleGenericException(Exception e) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", false);
        response.put("error", "서버 오류");
        response.put("message", "일정 처리 중 오류가 발생했습니다.");
        System.out.println("예외 발생: " + e.getMessage());
        e.printStackTrace();
        return response;
    }
}