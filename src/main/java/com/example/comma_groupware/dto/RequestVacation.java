package com.example.comma_groupware.dto;

import java.time.LocalDate;

import lombok.Data;

@Data
public class RequestVacation { 	
	private int requestId;				//요청ID
	private int approvalDocumentId;		//결재문서ID
	private int vacationId;				//휴가ID
	private String requestReason;		//요청사유
	private LocalDate startDate;		//휴가시작날짜
	private LocalDate endDate;			//휴가종료날짜

}
