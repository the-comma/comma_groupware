package com.example.comma_groupware.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class Attendance {
	private long attendanceId;
	private int empId;
	private String attendanceStatus;
	private LocalDateTime checkIn;
	private LocalDateTime checkOut;
	private LocalDateTime date;
}
