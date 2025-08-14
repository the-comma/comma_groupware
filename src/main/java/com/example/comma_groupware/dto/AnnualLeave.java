package com.example.comma_groupware.dto;

import lombok.Data;

@Data
public class AnnualLeave { //연차(휴가)
	private int empId; 				 // 사원ID;
	private double annualLeaveCount; // 잔여연차
}
