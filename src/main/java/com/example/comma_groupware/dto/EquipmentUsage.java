package com.example.comma_groupware.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class EquipmentUsage {
	private int usageId;
	private int projectId;
	private int empId;
	private int equipmentId;
	private int usageQuantity;
	private LocalDateTime issuedDate;
	private String usageStatus;
	private int damagedReported;
}
