package com.example.comma_groupware.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class AnonymousPost {
	private long postId;
	private long boardId;
	private int writerId;
	private String postTitle;
	private String postContent;
	private int viewCount;
	private int likeCount;
	private LocalDateTime createdAt;
	private LocalDateTime updatedAt;
}
