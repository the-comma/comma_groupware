package com.example.comma_groupware.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class RankHisotry {
	private Long rankHistoryId;
	private int empId;
	private int rankId;
	private LocalDateTime startDate;
	private LocalDateTime endDate;
}
