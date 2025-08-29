package com.example.comma_groupware.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class requestExpenseItem {
	private int itemId;
	private int approvalDocumentId;
	private LocalDateTime useDate;
	private String memo;
	private int texable;
	private int supply;
	private int vat;
	private int total;
}
