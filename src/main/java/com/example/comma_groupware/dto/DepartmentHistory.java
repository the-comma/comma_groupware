package com.example.comma_groupware.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class DepartmentHistory {
	private int deptHistoryId;
	private int deptId;
	private int empId;
	private LocalDateTime startDate;
	private LocalDateTime endDate;
}
