package com.example.comma_groupware.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class AnonymousComment {
	private long commentId;
	private long postId;
	private int writerId;
	private String commentContent;
	private long commnetParent;
	private LocalDateTime createdAt;
}
