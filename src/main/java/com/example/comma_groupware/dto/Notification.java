package com.example.comma_groupware.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class Notification {
	private long notiId;
	private String notiRefType;
	private Long notiRefId;
	private String notiTitle;
	private String notiMessage;
	private String notiUrl;
	private String extraData;
	private LocalDateTime createdAt;
}
