package com.example.comma_groupware.dto;

import java.time.LocalDate;

import lombok.Data;

@Data
public class RequestExpense {		 //지출결의서
	private int requestId; 			//요청Id
	private int approvalDocumentId; //결재문서ID
	private int expenseId; 			//지출ID
	private String requestReason; 	//요청사유
	private Long requestAmount;		//요청금액
	private LocalDate expenseDate;	//지출일시
}
