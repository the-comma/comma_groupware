package com.example.comma_groupware.domain;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class Chatroom {
	private long chatRoomId;
	private String chatRoomType;
	private String chatRoomTitle;
	private LocalDateTime createdAt;
	
}
