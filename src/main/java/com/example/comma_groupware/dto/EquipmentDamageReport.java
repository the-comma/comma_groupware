package com.example.comma_groupware.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class EquipmentDamageReport {

	private int damageReportId;
	private int usageId;
	private int reportedBy;
	private LocalDateTime reportDate;
	private String damageDesc;
}
