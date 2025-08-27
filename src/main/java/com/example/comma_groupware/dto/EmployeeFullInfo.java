package com.example.comma_groupware.dto;

import java.time.LocalDate;

import lombok.Data;

@Data
public class EmployeeFullInfo {
    private Integer empId;
    private String empName;
    private String role;
    private Integer deptId;
    private String deptName;
    private Integer teamId;
    private String teamName;
    private Integer rankId;
    private String rankName;
    private LocalDate deptStartDate;
    private LocalDate rankStartDate;

}
