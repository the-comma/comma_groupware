package com.example.comma_groupware.service;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.comma_groupware.dto.CalendarEvent;
import com.example.comma_groupware.mapper.CalendarEventMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CalendarEventService {

    private final CalendarEventMapper mapper;

    @Transactional
    public int create(CalendarEvent e) {
        return mapper.insert(e); // insert 후 e.eventId 세팅됨
    }

    @Transactional(readOnly = true)
    public List<CalendarEvent> findByRange(LocalDateTime start, LocalDateTime end) {
        return mapper.selectByRange(start, end);
    }

    // ✅ 부분 수정 (null 필드 스킵)
    @Transactional
    public int updatePartial(CalendarEvent e) {
        return mapper.updatePartial(e);
    }

    // ✅ 삭제
    @Transactional
    public int delete(int id) {
        return mapper.delete(id);
    }
}
