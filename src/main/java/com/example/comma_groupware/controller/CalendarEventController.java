package com.example.comma_groupware.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class CalendarEventController {

    @GetMapping("/calendar") // http://localhost:83/calendar
    public String calendarPage(Model model) {
        // model.addAttribute("events", eventList); // 초기 로드 필요시
        return "appsCalendar"; // -> /WEB-INF/views/appsCalendar.jsp
    }
}
