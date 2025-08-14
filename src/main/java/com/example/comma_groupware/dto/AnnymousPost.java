package com.example.comma_groupware.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class AnnymousPost { // 게시글
	private Long postId;              // 게시글ID
	private Long boardId;			  // 게시판ID (어떤 게시판에 쓴 게시글인지)
	private int writerId;			  // 작성자(유저)ID
	private String postTitle;		  // 제목
	private String postContent;		  // 내용
	private int viewCount;			  // 조회수
	private int likeCount;			  // 좋아요 수
	private LocalDateTime createdAt;  //작성 일시
	private LocalDateTime updatedAt;  //수정 일시
}
