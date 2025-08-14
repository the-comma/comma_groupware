package com.example.comma_groupware.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class AnnymousComment {  //게시글 댓글
	private Long commentId;         // 댓글ID
	private Long postId;            // 게시글ID
	private String writerId;	    // 댓글작성자ID
	private String commentContent;  // 댓글
	private String commentParent;   // 부모댓글 (null 일시 최상위 댓글) 
	private LocalDateTime createdAt;// 작성일시 
}
