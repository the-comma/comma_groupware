package com.example.comma_groupware.dto;

import java.time.LocalTime;

import lombok.Data;

@Data
public class DepartmentHistory { //사원별 부서이력
	private int deptHistoryId;	 //부서이력 
	private int deptId;			 //부서
	private int empId;			 //사원
	private LocalTime startDate; //시작날짜
	private LocalTime endDate;	 //종료날짜
}
