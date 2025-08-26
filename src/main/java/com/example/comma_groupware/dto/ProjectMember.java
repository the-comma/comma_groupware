package com.example.comma_groupware.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class ProjectMember {
	private int empId;
	private int projectId;
	private String projectRole;
	private LocalDateTime assignedAt;
	
	public ProjectMember() {
		
	}
	
	public ProjectMember(int empId, int projectId, String projectRole) {
		this.empId = empId;
		this.projectId = projectId;
		this.projectRole = projectRole;
	}
}
