package com.example.comma_groupware.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class ApprovalLine {
	private int approvalLineId;
	private int approvalDocumentId;
	private int empId;
	private int approvalStep;
	private String approvalStatus;
	private int fileCount;
	private LocalDateTime approveAt;
}
