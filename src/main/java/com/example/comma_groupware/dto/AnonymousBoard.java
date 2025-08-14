package com.example.comma_groupware.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class AnonymousBoard {
	private long boardId;
	private String boardName;
	private String boardDesc;
	private LocalDateTime createdAt;
}
