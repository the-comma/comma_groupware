package com.example.comma_groupware.dto;

import lombok.Data;

@Data
public class AnnymousLike {  //게시글 좋아요
	private Long likeId; // 좋아요ID
	private Long postId; // 게시글ID
	private int empId;  // 사원(유저)ID
}
