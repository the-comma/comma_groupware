package com.example.comma_groupware.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class RankHisotry {
	private Long rankHistoryId;    //사원별 직급이력
	private int empId;				 //사원ID
	private int rankId;				 //직급ID
	private LocalDateTime startDate; //시작일
	private LocalDateTime endDate;   //종료일

}
