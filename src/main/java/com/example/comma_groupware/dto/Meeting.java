package com.example.comma_groupware.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class Meeting {

	private int meetingId;
	private int projectId;
	private String meetingTitle;
	private String meetingContent;
	private int writerId;
	private LocalDateTime meetingDate;
	private LocalDateTime createdAt; 
	private int fileCount;
	
}
