package com.example.comma_groupware.dto;

import java.time.LocalDateTime;
import com.example.comma_groupware.domain.Employee;

import lombok.Data;

@Data
public class EmpDeptDeptHistory {
	private Employee emp;
	
	private LocalDateTime startDate;
	private LocalDateTime endDate;
	
	private String deptName;
	
	public EmpDeptDeptHistory() {
		
	}
	
	public EmpDeptDeptHistory(Employee e) {
		this.emp = e;
	}
}
