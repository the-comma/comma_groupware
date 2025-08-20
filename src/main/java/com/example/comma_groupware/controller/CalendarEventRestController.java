package com.example.comma_groupware.controller;

import org.springframework.web.bind.annotation.*;

import com.example.comma_groupware.dto.CalendarEvent;
import com.example.comma_groupware.dto.Employee;
import com.example.comma_groupware.service.CalendarEventService;
import com.example.comma_groupware.mapper.EmployeeMapper;

import lombok.RequiredArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.OffsetDateTime;
import java.util.List;
import java.util.Map;

import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/api/calendar/events")
@RequiredArgsConstructor
public class CalendarEventRestController {

    private final CalendarEventService service;
    private final EmployeeMapper employeeMapper;

    // ====== 공통 헬퍼 ======
    private LocalDateTime parse(String v){
        if (v == null || v.isBlank()) return null;
        if (v.length() == 10) return LocalDate.parse(v).atStartOfDay(); // yyyy-MM-dd
        try { return LocalDateTime.parse(v); }                          // yyyy-MM-ddTHH:mm[:ss]
        catch (Exception ignore) { return LocalDateTime.parse(v.substring(0,16)); } // yyyy-MM-ddTHH:mm
    }
    private LocalDateTime parseRangeParam(String v){
        try { return OffsetDateTime.parse(v).toLocalDateTime(); } // 2025-08-01T00:00:00+09:00
        catch (Exception ignore1) {
            try { return LocalDateTime.parse(v); }                // 2025-08-01T00:00:00
            catch (Exception ignore2) { return LocalDate.parse(v).atStartOfDay(); } // 2025-08-01
        }
    }
    private String toType(String cat){
        if (cat == null) return "COMPANY";
        switch (cat) {
            case "cat-company":    return "COMPANY";
            case "cat-department": return "DEPARTMENT";
            case "cat-project":    return "PROJECT";
            case "cat-vacation":   return "VACATION";
            default:               return "ETC";
        }
    }
    private String toClassName(String type){
        if (type == null) return "cat-company";
        switch (type) {
            case "COMPANY":    return "cat-company";
            case "DEPARTMENT": return "cat-department";
            case "PROJECT":    return "cat-project";
            case "VACATION":   return "cat-vacation";
            default:           return "cat-etc";
        }
    }

    // ====== CREATE (모달 저장) ======
    @PostMapping
    public Map<String, Object> create(@RequestBody Map<String, Object> req,
                                      HttpSession session) {
        // 로그인 사용자
        String username = (String) session.getAttribute("username");
        if (username == null) throw new IllegalStateException("세션에 username 없음(로그인 필요)");
        Employee emp = employeeMapper.selectByUserName(username);
        if (emp == null) throw new IllegalStateException("employee 조회 실패: " + username);

        // 요청 값
        String title = (String) req.get("title");
        String start = (String) req.get("start");
        String end   = (String) req.get("end");
        String cat   = (String) req.get("category");
        String memo  = (String) req.get("memo");

        // DTO
        CalendarEvent e = new CalendarEvent();
        e.setEventTitle(title);
        e.setEventDesc(memo);
        e.setStartDatetime(parse(start));
        e.setEndDatetime((end == null || end.isBlank()) ? e.getStartDatetime().plusHours(1) : parse(end));
        e.setIsAllDay((start != null && start.length() == 10) ? 1 : 0);
        e.setEventType(toType(cat));
        e.setDeptId(0);
        e.setProjectId(0);
        e.setCreatedBy(emp.getEmpId()); // FK 통과 핵심

        // 체크 제약 대응(명시)
        if ("DEPARTMENT".equals(e.getEventType())) { e.setProjectId(0); }
        if ("PROJECT".equals(e.getEventType()))    { e.setDeptId(0); }
        if ("COMPANY".equals(e.getEventType()) || "VACATION".equals(e.getEventType()) || "ETC".equals(e.getEventType())) {
            e.setDeptId(0); e.setProjectId(0);
        }

        service.create(e);

        return Map.of(
            "id", e.getEventId(),
            "title", e.getEventTitle(),
            "start", e.getStartDatetime().toString(),
            "end",   e.getEndDatetime() != null ? e.getEndDatetime().toString() : null,
            "memo",  e.getEventDesc(),
            "classNames", new String[]{ cat != null ? cat : "cat-company" }
        );
    }

    // ====== READ (캘린더 초기/범위 로딩) ======
    // FullCalendar가 ?start=...&end=...로 호출함
    @GetMapping
    public List<Map<String, Object>> list(@RequestParam String start,
                                          @RequestParam String end) {
        LocalDateTime s = parseRangeParam(start);
        LocalDateTime e = parseRangeParam(end);

        return service.findByRange(s, e).stream().map(ev -> Map.of(
            "id", ev.getEventId(),
            "title", ev.getEventTitle(),
            "start", ev.getStartDatetime().toString(),
            "end",   ev.getEndDatetime() != null ? ev.getEndDatetime().toString() : null,
            "allDay", ev.getIsAllDay() == 1,
            "classNames", new String[]{ toClassName(ev.getEventType()) },
            "extendedProps", Map.of("memo", ev.getEventDesc())
        )).toList();
    }
    
    @PutMapping(value="/{id}", consumes="application/json", produces="application/json")
    public Map<String,Object> update(@PathVariable int id,
                                     @RequestBody Map<String,Object> req) {
        // 부분 업데이트 허용
        String title = (String) req.get("title");
        String start = (String) req.get("start");
        String end   = (String) req.get("end");
        String cat   = (String) req.get("category");
        String memo  = (String) req.get("memo");

        CalendarEvent e = new CalendarEvent();
        e.setEventId(id);
        if (title != null) e.setEventTitle(title);
        if (memo  != null) e.setEventDesc(memo);
        if (start != null) e.setStartDatetime(parse(start));
        if (end   != null) e.setEndDatetime(parse(end));
        if (cat   != null) e.setEventType(toType(cat));

        service.updatePartial(e); // null 필드 스킵 업데이트

        return Map.of("ok", true);
    }

    @DeleteMapping(value="/{id}", produces="application/json")
    public Map<String,Object> delete(@PathVariable int id){
        service.delete(id);
        return Map.of("ok", true);
    }

}

