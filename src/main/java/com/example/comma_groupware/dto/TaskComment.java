package com.example.comma_groupware.dto;

import java.time.LocalDate;

import lombok.Data;

@Data
public class TaskComment {
	private Long taskCommentId;				//과업댓글ID
	private int writerId;					//작성자ID
	private int taskId;						//과업ID
	private Long taskCommentParent;			//과업부모댓글
	private String taskCommentContent;		//과업댓글 
	private LocalDate createdAt;			//작성일시
}
