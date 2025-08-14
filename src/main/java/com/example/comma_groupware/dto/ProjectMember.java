package com.example.comma_groupware.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class ProjectMember {
	private int empId;
	private int projectId;
	private String projectRole;
	private LocalDateTime assignedAt;
}
