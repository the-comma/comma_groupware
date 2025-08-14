package com.example.comma_groupware.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class ProjectTask {
	private int taskId;
	private int taskParent;
	private int projectId;
	private String taskTitle;
	private String taskStatus;
	private int fileCount;
	private LocalDateTime dueDate;
}
