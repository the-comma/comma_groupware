package com.example.comma_groupware.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class Equipment {

	private int equipmentId;
	private String equipmentName;
	private String equipmentDesc;
	private int stockQuantity;
	private LocalDateTime createdAt;
	private LocalDateTime updatedAt;
}
