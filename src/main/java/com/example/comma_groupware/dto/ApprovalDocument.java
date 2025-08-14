package com.example.comma_groupware.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class ApprovalDocument {
	private int approvalDocumentId;
	private int empId;
	private String approvalTitle;
	private String documentType;
	private String approvalStatus;
	private String approvalReason;
	private Integer isFile;
	private LocalDateTime createAt;
	private LocalDateTime completeAt;
}
