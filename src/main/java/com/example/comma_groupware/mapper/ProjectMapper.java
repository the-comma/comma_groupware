package com.example.comma_groupware.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.comma_groupware.dto.Page;
import com.example.comma_groupware.dto.Project;

@Mapper
public interface ProjectMapper {
	
	int addProject(Project project);							// 프로젝트 추가
	
	List<Map<String, Object>> selectProjectByEmpId(Page page);	// 사원 아이디로 참여중인 프로젝트 조회
	int countProjectByEmpId(Map<String,Object> param);			// 사원 아이디로 참여중인 프로젝트 카운트
}
