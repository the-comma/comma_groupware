package com.example.comma_groupware.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class ChatMessage {
	private long chatMessageId;
	private long chatRoomId;
	private int senderId;
	private String chatContent;
	private String messageType;
	private LocalDateTime createdAt;
	private int isDeleted;
}
