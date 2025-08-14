package com.example.comma_groupware.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class EquipmentRequest {

	private int requestId;
	private int projectId;
	private int empId;
	private int equipmentId;
	private int quantity;
	private LocalDateTime requestDate;
	private String requestStatus;
}
