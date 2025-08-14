package com.example.comma_groupware.dto;

import java.time.LocalDateTime;
import java.time.LocalTime;

import lombok.Data;

@Data
public class Attendance { //근태
	private Long attendanceId; 		 //근태ID
	private int empId; 				 //사원ID
	private String attendanceStatus; //출결상태
	private LocalTime checkIn;		 //출근시간
	private LocalTime checkOut;		 //퇴근시간
	private LocalDateTime date;		 //날짜
}
