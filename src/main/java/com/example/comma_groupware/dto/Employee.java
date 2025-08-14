package com.example.comma_groupware.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class Employee {
	private int empId;
	private String username;
	private String password;
	private String empEmail;
	private String empName;
	private String empStatus;
	private String empPhone;
	private String empExp;
	private String role;
	private LocalDateTime createAt;
	private LocalDateTime updatedAt;
}
	