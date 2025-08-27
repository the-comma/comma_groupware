package com.example.comma_groupware.controller;

import org.springframework.web.bind.annotation.*;
import org.springframework.security.core.Authentication;

import com.example.comma_groupware.dto.CalendarEvent;
import com.example.comma_groupware.dto.Employee;
import com.example.comma_groupware.dto.Department;
import com.example.comma_groupware.dto.RankHistory;
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

    @GetMapping("/test")
    public Map<String, Object> testApi(Authentication auth) {
        System.out.println("=== testApi 호출됨 ===");
        
        Employee currentUser = getCurrentEmployee(auth);
        
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("user", currentUser.getEmpName());
        result.put("userId", currentUser.getEmpId());
        result.put("message", "API 연결 성공");
        result.put("timestamp", LocalDateTime.now().toString());
        
        System.out.println("응답 데이터: " + result);
        return result;
    }
    
    // ====== 공통 헬퍼 ======
    private LocalDateTime parse(String v){
        if (v == null || v.isBlank()) return null;
        if (v.length() == 10) return LocalDate.parse(v).atStartOfDay(); // yyyy-MM-dd
        try { return LocalDateTime.parse(v); }                          // yyyy-MM-ddTHH:mm[:ss]
        catch (Exception ignore) { 
            try { return LocalDateTime.parse(v.substring(0,16)); } // yyyy-MM-ddTHH:mm
            catch (Exception ignore2) { return LocalDate.parse(v.substring(0,10)).atStartOfDay(); }
        }
    }
    
    private LocalDateTime parseRangeParam(String v){
        try { return OffsetDateTime.parse(v).toLocalDateTime(); } // 2025-08-01T00:00:00+09:00
        catch (Exception ignore1) {
            try { return LocalDateTime.parse(v); }                // 2025-08-01T00:00:00
            catch (Exception ignore2) { return LocalDate.parse(v).atStartOfDay(); } // 2025-08-01
        }
    }
    
    private String toEventType(String category){
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
    
    private String toCategoryName(String type){
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

    // 사용자의 현재 부서 정보 조회
    private Department getCurrentUserDepartment(int empId) {
        return employeeService.getCurrentDepartment(empId);
    }

    // ====== 오늘의 일정 조회 (대시보드용) ======
    @GetMapping("/today")
    public List<Map<String, Object>> getTodaySchedule(Authentication auth) {
        Employee currentUser = getCurrentEmployee(auth);
        Department userDept = getCurrentUserDepartment(currentUser.getEmpId());
        
        LocalDate today = LocalDate.now();
        LocalDateTime startOfDay = today.atStartOfDay();
        LocalDateTime endOfDay = today.atTime(23, 59, 59);
        
        // 사용자가 볼 수 있는 모든 일정 조회
        List<CalendarEvent> events = calendarService.findTodayScheduleForUser(
            currentUser.getEmpId(), 
            userDept != null ? userDept.getDeptId() : 0, 
            startOfDay, 
            endOfDay
        );
        
        return events.stream()
            .map(this::mapEventToResponse)
            .sorted((a, b) -> {
                // 시간순 정렬 (종일 일정은 먼저)
                boolean aAllDay = (Boolean) a.get("allDay");
                boolean bAllDay = (Boolean) b.get("allDay");
                if (aAllDay && !bAllDay) return -1;
                if (!aAllDay && bAllDay) return 1;
                return ((String) a.get("start")).compareTo((String) b.get("start"));
            })
            .collect(Collectors.toList());
    }

    // ====== 권한별 일정 등록 ======
    @PostMapping
    public Map<String, Object> createEvent(@RequestBody Map<String, Object> req, Authentication auth) {
        Employee currentUser = getCurrentEmployee(auth);
        Department userDept = getCurrentUserDepartment(currentUser.getEmpId());
        
        // ✅ type 기본값 처리
        String eventType = (String) req.get("type");
        if (eventType == null || eventType.isBlank()) {
            eventType = "personal";  // 기본값
        }

        String title = (String) req.get("title");
        String start = (String) req.get("start");
        String end = (String) req.get("end");
        String memo = (String) req.get("memo");
        
        // 권한 체크
        validateCreatePermission(eventType, currentUser, userDept);
        
        CalendarEvent event = new CalendarEvent();
        event.setEventTitle(title);
        event.setEventDesc(memo);
        event.setStartDatetime(parse(start));
        event.setEndDatetime((end == null || end.isBlank()) ? 
            event.getStartDatetime().plusHours(1) : parse(end));
        event.setIsAllDay((start != null && start.length() == 10) ? 1 : 0);
        event.setEventType(toEventType(eventType));  // ← 여기서 대문자 "PERSONAL" 변환됨
        event.setCreatedBy(currentUser.getEmpId());
        
        // 타입별 추가 설정
        setEventTypeSpecificFields(event, req, currentUser, userDept);
        
        calendarService.create(event);
        
        return mapEventToResponse(event);
    }


    // ====== 캘린더 범위 조회 (필터링 포함) ======
    @PostMapping("/range")
    public List<Map<String, Object>> getEventsByRange(
            @RequestBody Map<String, Object> req, 
            Authentication auth) {
        
        Employee currentUser = getCurrentEmployee(auth);
        Department userDept = getCurrentUserDepartment(currentUser.getEmpId());
        
        String startStr = (String) req.get("start");
        String endStr = (String) req.get("end");
        @SuppressWarnings("unchecked")
        List<String> types = (List<String>) req.get("types");
        
        LocalDateTime start = parseRangeParam(startStr);
        LocalDateTime end = parseRangeParam(endStr);
        
        // 기본 전체 조회 (Java 8 호환)
        if (types == null || types.isEmpty()) {
            types = new ArrayList<>();
            types.add("company");
            types.add("department");
            types.add("project");
            types.add("vacation");
            types.add("personal");
        }
        
        List<CalendarEvent> events = calendarService.findEventsByRangeAndUser(
            start, end, currentUser.getEmpId(), 
            userDept != null ? userDept.getDeptId() : 0, types);
        
        return events.stream()
            .map(this::mapEventToResponse)
            .collect(Collectors.toList());
    }

    // ====== 일정 상세 조회 ======
    @GetMapping("/{id}")
    public Map<String, Object> getEventDetail(@PathVariable int id, Authentication auth) {
        System.out.println("=== 일정 상세 조회: " + id + " ===");
        
        Employee currentUser = getCurrentEmployee(auth);
        Department userDept = getCurrentUserDepartment(currentUser.getEmpId());
        CalendarEvent event = calendarService.findById(id);
        
        if (event == null) {
            throw new IllegalArgumentException("존재하지 않는 일정입니다.");
        }
        
        System.out.println("이벤트: " + event.getEventTitle() + ", 작성자ID: " + event.getCreatedBy());
        
        // 조회 권한 체크
        validateViewPermission(event, currentUser, userDept);
        
        Map<String, Object> response = mapEventToResponse(event);
        
        // 상세 정보 추가
        response.put("canModify", canModifyEvent(event, currentUser, userDept));
        
        // 작성자 정보 조회
        try {
            Employee creator = employeeService.findById(event.getCreatedBy());
            System.out.println("작성자 조회 결과: " + (creator != null ? creator.getEmpName() : "null"));
            
            if (creator != null) {
                response.put("creatorName", creator.getEmpName());
                Department creatorDept = getCurrentUserDepartment(creator.getEmpId());
                response.put("creatorDept", creatorDept != null ? creatorDept.getDateName() : "");
            } else {
                response.put("creatorName", "알 수 없음");
                response.put("creatorDept", "");
            }
        } catch (Exception e) {
            System.out.println("작성자 정보 조회 실패: " + e.getMessage());
            e.printStackTrace();
            response.put("creatorName", "조회 실패");
            response.put("creatorDept", "");
        }
        
        System.out.println("최종 응답: " + response);
        return response;
    }

    // ====== 일정 수정 ======
    @PutMapping("/{id}")
    public Map<String, Object> updateEvent(@PathVariable int id, 
                                         @RequestBody Map<String, Object> req, 
                                         Authentication auth) {
        Employee currentUser = getCurrentEmployee(auth);
        Department userDept = getCurrentUserDepartment(currentUser.getEmpId());
        CalendarEvent existingEvent = calendarService.findById(id);
        
        if (existingEvent == null) {
            throw new IllegalArgumentException("존재하지 않는 일정입니다.");
        }
        
        // 수정 권한 체크
        if (!canModifyEvent(existingEvent, currentUser, userDept)) {
            throw new IllegalStateException("일정을 수정할 권한이 없습니다.");
        }
        
        // 휴가 일정은 수정 불가
        if ("VACATION".equals(existingEvent.getEventType())) {
            throw new IllegalStateException("휴가 일정은 수정할 수 없습니다.");
        }
        
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
        
        calendarService.updatePartial(updateEvent);
        
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "일정이 수정되었습니다.");
        return response;
    }

    // ====== 일정 삭제 ======
    @DeleteMapping("/{id}")
    public Map<String, Object> deleteEvent(@PathVariable int id, Authentication auth) {
        Employee currentUser = getCurrentEmployee(auth);
        Department userDept = getCurrentUserDepartment(currentUser.getEmpId());
        CalendarEvent event = calendarService.findById(id);
        
        if (event == null) {
            throw new IllegalArgumentException("존재하지 않는 일정입니다.");
        }
        
        // 삭제 권한 체크
        if (!canModifyEvent(event, currentUser, userDept)) {
            throw new IllegalStateException("일정을 삭제할 권한이 없습니다.");
        }
        
        // 휴가 일정은 삭제 불가
        if ("VACATION".equals(event.getEventType())) {
            throw new IllegalStateException("휴가 일정은 삭제할 수 없습니다.");
        }
        
        calendarService.delete(id);
        
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "일정이 삭제되었습니다.");
        return response;
    }

    // ====== 부서 목록 조회 ======
    @GetMapping("/departments")
    public List<Map<String, Object>> getDepartments(Authentication auth) {
        Employee currentUser = getCurrentEmployee(auth);
        Department userDept = getCurrentUserDepartment(currentUser.getEmpId());
        
        // 부서장이면 본인 부서만, 경영지원부장이면 전체 부서
        List<Department> departments;
        if (hasRole(auth, "ROLE_MANAGEMENT_SUPPORT_MANAGER")) {
            departments = departmentService.findAll();
        } else {
            departments = new ArrayList<>();
            if (userDept != null) {
                departments.add(userDept);
            }
        }
        
        return departments.stream()
            .map(dept -> {
                Map<String, Object> deptMap = new HashMap<>();
                deptMap.put("id", dept.getDeptId());
                deptMap.put("name", dept.getDateName());
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
        Department userDept = getCurrentUserDepartment(currentUser.getEmpId());
        LocalDate targetDate = date != null ? LocalDate.parse(date) : LocalDate.now();
        
        List<CalendarEvent> vacations = calendarService.findDepartmentVacations(
            userDept != null ? userDept.getDeptId() : 0, targetDate);
        
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
    }

    // ====== 권한 검증 헬퍼 메서드 ======
    private void validateCreatePermission(String eventType, Employee currentUser, Department userDept) {
        switch (eventType) {
            case "company":
                if (!hasManagementSupportRole(currentUser, userDept)) {
                    throw new IllegalStateException("회사 일정은 경영지원부장만 등록할 수 있습니다.");
                }
                break;
            case "department":
                if (!isDepartmentManager(currentUser)) {
                    throw new IllegalStateException("부서 일정은 부서장만 등록할 수 있습니다.");
                }
                break;
            case "project":
                if (!isProjectManager(currentUser, userDept)) {
                    throw new IllegalStateException("프로젝트 일정은 PM만 등록할 수 있습니다.");
                }
                break;
            case "vacation":
                throw new IllegalStateException("휴가 일정은 전자결재를 통해서만 등록됩니다.");
            case "personal":
                // 모든 사용자 가능
                break;
            default:
                throw new IllegalArgumentException("잘못된 일정 유형입니다: " + eventType);
        }
    }

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
                // ✅ null도 허용 (DB에서는 null로 저장)
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



    private boolean canModifyEvent(CalendarEvent event, Employee currentUser, Department userDept) {
        // 본인이 등록한 일정이 아니면 수정 불가 (null-safe)
        if (!Objects.equals(event.getCreatedBy(), currentUser.getEmpId())) {
            return false;
        }

        // 휴가 일정은 수정 불가
        if ("VACATION".equals(event.getEventType())) {
            return false;
        }

        // 권한별 수정 가능 여부
        switch (event.getEventType()) {
            case "COMPANY":
                return hasManagementSupportRole(currentUser, userDept);
            case "DEPARTMENT":
                return isDepartmentManager(currentUser);
            case "PROJECT":
                return isProjectManager(currentUser, userDept);
            case "PERSONAL":
                return true;
            default:
                return false;
        }
    }

    private void setEventTypeSpecificFields(CalendarEvent event, Map<String, Object> req, 
            Employee currentUser, Department userDept) {
        switch (event.getEventType()) {
            case "COMPANY":
            case "VACATION":
            case "PERSONAL":
                event.setDeptId(null);
                event.setProjectId(null);
                break;

            case "DEPARTMENT":
                Integer deptId = (Integer) req.get("departmentId");
                if (deptId == null && userDept == null) {
                    throw new IllegalArgumentException("부서 일정은 deptId가 필요합니다.");
                }
                event.setDeptId(deptId != null ? deptId : userDept.getDeptId());
                event.setProjectId(null);
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
    
 // ====== 조회 권한 검증 ======
    private void validateViewPermission(CalendarEvent event, Employee currentUser, Department userDept) {
        switch (event.getEventType()) {
            case "COMPANY":
                // 회사 일정 → 모두 조회 가능
                break;

            case "DEPARTMENT":
                if (userDept == null || !Objects.equals(userDept.getDeptId(), event.getDeptId())) {
                    throw new IllegalStateException("해당 부서 일정은 조회할 수 없습니다.");
                }
                break;

            case "PROJECT":
                boolean isCreator = Objects.equals(event.getCreatedBy(), currentUser.getEmpId());
                boolean isProjectMember = calendarService.isProjectMember(
                        event.getProjectId(), currentUser.getEmpId());
                boolean isDeptManager = isDepartmentManager(currentUser); // 부서장 권한

                if (!(isCreator || isProjectMember || isDeptManager)) {
                    throw new IllegalStateException("이 프로젝트 일정은 조회할 수 없습니다.");
                }
                break;


            case "VACATION":
                // 휴가 → 본인 or 같은 부서
                if (!event.getCreatedBy().equals(currentUser.getEmpId()) &&
                    (userDept == null || !Objects.equals(userDept.getDeptId(), event.getDeptId()))) {
                    throw new IllegalStateException("해당 휴가 일정은 조회할 수 없습니다.");
                }
                break;

            case "PERSONAL":
                if (!event.getCreatedBy().equals(currentUser.getEmpId())) {
                    throw new IllegalStateException("개인 일정은 본인만 조회할 수 있습니다.");
                }
                break;

            default:
                throw new IllegalArgumentException("알 수 없는 일정 유형: " + event.getEventType());
        }
    }



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

        // ✅ 부서 정보 추가 (null-safe)
        if (event.getDeptId() != null) {
            Department dept = departmentService.findById(event.getDeptId());
            if (dept != null) {
                response.put("department", dept.getDateName());
                response.put("departmentId", dept.getDeptId());
            }
        }

        // 휴가 일정인 경우 추가 정보
        if ("VACATION".equals(event.getEventType())) {
            Employee applicant = employeeService.findById(event.getCreatedBy());
            if (applicant != null) {
                response.put("applicant", applicant.getEmpName());
                Department applicantDept = getCurrentUserDepartment(applicant.getEmpId());
                response.put("applicantDept", applicantDept != null ? applicantDept.getDateName() : "");
            }
            response.put("vacationType", parseVacationType(event.getEventDesc()));
        }

        return response;
    }
    
    


    // ====== 권한 체크 헬퍼 ======
    private boolean hasRole(Authentication auth, String role) {
        return auth.getAuthorities().stream()
            .anyMatch(grantedAuthority -> grantedAuthority.getAuthority().equals(role));
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

    private String parseVacationType(String eventDesc) {
        if (eventDesc == null) return "연차";
        
        if (eventDesc.contains("반차")) return "반차";
        if (eventDesc.contains("병가")) return "병가";
        if (eventDesc.contains("연차")) return "연차";
        if (eventDesc.contains("특별휴가")) return "특별휴가";
        
        return "연차"; // 기본값
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
        return response;
    }
    
 // 조회
    @GetMapping
    public List<Map<String, Object>> getEvents(
            @RequestParam String start,
            @RequestParam String end,
            @RequestParam(required = false) String types,
            Authentication auth) {
        
        System.out.println("=== GET 이벤트 조회 ===");
        System.out.println("start: " + start + ", end: " + end + ", types: " + types);
        
        Employee currentUser = getCurrentEmployee(auth);
        Department userDept = getCurrentUserDepartment(currentUser.getEmpId());
        
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
            // 기본값: 모든 타입
            typeList.add("company");
            typeList.add("department");
            typeList.add("project");
            typeList.add("vacation");
            typeList.add("personal");
        }
        
        List<CalendarEvent> events = calendarService.findEventsByRangeAndUser(
            startTime, endTime, currentUser.getEmpId(), 
            userDept != null ? userDept.getDeptId() : 0, typeList);
        
        System.out.println("조회된 이벤트 수: " + events.size());
        
        return events.stream()
            .map(this::mapEventToResponse)
            .collect(Collectors.toList());
    }
}