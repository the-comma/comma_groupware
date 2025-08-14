package com.example.comma_groupware.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class NotificationRecipient {
	private long notiRecipientId;
	private long notiId;
	private int empId;
	private int isRead;
	private LocalDateTime deliveredAt;
	private LocalDateTime createdAt;
}
