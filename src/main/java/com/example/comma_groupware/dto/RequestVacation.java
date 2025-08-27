package com.example.comma_groupware.dto;

import java.time.LocalDate;

import lombok.Data;

@Data
public class RequestVacation { 	
	private int requestId;				//요청ID
	private int approvalDocumentId;		//결재문서ID
	private int vacationId;				//휴가ID
	private LocalDate startDate;		//휴가시작날짜
	private LocalDate endDate;			//휴가종료날짜
    private double  totalDays;          // 사용일수(0.5 단위)
    private String  emergencyContact;   // 비상연락처
    private String  handover;           // 인수인계 메모
    private String  vacationReason;     // 사유
}
