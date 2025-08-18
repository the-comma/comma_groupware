package com.example.comma_groupware.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.comma_groupware.dto.Page;

@Mapper
public interface EmployeeMapper {
	
	// SELECT
	List<Map<String,Object>> organizationList(Page p);					// 조직도 조회
	int organizationListCount(Map<String,Object> param);	// 조직도 리스트 전체 데이터 수
	
	Map<String, Object> employeeCard(int empId);
}
