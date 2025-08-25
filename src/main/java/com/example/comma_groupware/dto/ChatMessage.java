package com.example.comma_groupware.dto;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor 
@AllArgsConstructor
public class ChatMessage {
	private long chatMessageId;
	private long chatRoomId;
	private int senderId;
	private String chatContent;
	private String messageType;
	private LocalDateTime createdAt;
	private int isDeleted;
	
	
}
