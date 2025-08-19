package com.example.comma_groupware.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller  // ★ 스프링이 이 클래스를 웹 컨트롤러로 인식
public class CalendarEventController {

    @GetMapping("/calendar")  // http://localhost:83/calendar
    public String calendarPage(Model model) {
        // 여기서 DB 값 넣고 싶으면 model.addAttribute("events", eventList);
        return "appsCalendar"; 
        // → /WEB-INF/views/appsCalendar.jsp 로 이동
    }
    
    
}