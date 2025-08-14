package com.example.comma_groupware.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class ChatRoomUser {
	private long chatRoomEmpId;
	private long chatRoomId;
	private int empId;
	private int chatRoomIsActive;
	private int chatRoomIsHidden;
	private long chatRoomLastReadMessageId;
	private LocalDateTime joinedAt;
	private LocalDateTime exitedAt;
}
