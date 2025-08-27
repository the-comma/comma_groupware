package com.example.comma_groupware.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.comma_groupware.dto.ProjectTask;

@Mapper
public interface ProjectTaskMapper {
	
	int addProjectTask(ProjectTask projectTask);
	
	List<Map<String,Object>> selectTaskListByProjectId(Map<String, Object> param);	// 프로젝트 아이디로 해당 프로젝트 작업 리스트 조회
	ProjectTask selectTaskByTaskId(int taskId);										// 작업 아이디로 해당 작업 상세 조회
}
