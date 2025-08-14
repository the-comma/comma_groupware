package com.example.comma_groupware.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class RejectReson {
	private int rejectReasonId; 	//거절ID
	private int approvalLineId;     //결재선
	private String rejectReason;	//반려사유
	private LocalDateTime rejectAt;	//반려일시
	
}
