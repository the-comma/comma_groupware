package com.example.comma_groupware.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class AnonymousLike {
	private long likeId;
	private long postId;
	private int empId;
	private LocalDateTime likedAt;
}
