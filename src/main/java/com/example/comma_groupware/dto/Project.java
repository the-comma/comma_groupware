package com.example.comma_groupware.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class Project {
	private int projectId;
	private String projectTitle;
	private int pmId;
	private String projectDesc;
	private String projectStatus;
	private String projectGitUrl;
	private LocalDateTime startDate;
	private LocalDateTime endDate;
}
