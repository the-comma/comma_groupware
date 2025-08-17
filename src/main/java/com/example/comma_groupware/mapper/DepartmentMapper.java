package com.example.comma_groupware.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface DepartmentMapper {
	
	// SELECT
	List<Map<String,Object>> getDeptTeamList();	// 부서/팀 가져오기
}
