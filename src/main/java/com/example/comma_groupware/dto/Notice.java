package com.example.comma_groupware.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class Notice {
	private int noticeId;
	private int writerId;
	private String noticeTitle;
	private String noticeContent;
	private int isPin;
	private int noticeViewCount;
	private LocalDateTime createdAt;
	private LocalDateTime updatedAt;
	private int fileCount;
	private Integer isFile;
}
