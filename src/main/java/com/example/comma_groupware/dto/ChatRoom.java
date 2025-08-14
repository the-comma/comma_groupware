package com.example.comma_groupware.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class ChatRoom {
	private long chatRoomId;
	private String chatRoomType;
	private String chatRoomTitle;
	private LocalDateTime createdAt;
}
