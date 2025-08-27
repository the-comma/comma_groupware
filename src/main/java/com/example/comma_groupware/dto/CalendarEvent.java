package com.example.comma_groupware.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class CalendarEvent {
	private int eventId;
	private String eventTitle;
	private String eventDesc;
	private LocalDateTime startDatetime;
	private LocalDateTime endDatetime;
	private int isAllDay;
	private String eventType;
	private Integer deptId;
	private Integer projectId;
	private Integer createdBy;
	private LocalDateTime createdAt;
	private LocalDateTime updatedAt;
}

