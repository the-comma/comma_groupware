package com.example.comma_groupware.dto;

import lombok.Data;

@Data
public class TaskMember {
	private int taskId; //과업ID
	private int empId;	//사원ID
	
	public TaskMember() {
		
	}
	
	public TaskMember(int taskId, int empId) {
		this.taskId = taskId;
		this.empId = empId;
	}
}
