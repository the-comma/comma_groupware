package com.example.comma_groupware.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.time.LocalDateTime;
import java.util.List;
import com.example.comma_groupware.dto.CalendarEvent;

@Mapper
public interface CalendarEventMapper {
    int insert(CalendarEvent e);
    
 // ✅ 추가: 기간 조회
    List<CalendarEvent> selectByRange(
            @org.apache.ibatis.annotations.Param("start") java.time.LocalDateTime start,
            @org.apache.ibatis.annotations.Param("end")   java.time.LocalDateTime end
        );
 // 부분 수정 (null 무시)
    int updatePartial(CalendarEvent e);
    
 // 삭제 (eventId로)   
 // XML에서 #{eventId} 쓰고 있으니 @Param 필요
    int delete(@Param("eventId") int eventId);
    
  }