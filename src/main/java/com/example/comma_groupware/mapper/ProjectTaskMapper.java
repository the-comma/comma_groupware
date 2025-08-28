package com.example.comma_groupware.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.comma_groupware.dto.ProjectTask;

@Mapper
public interface ProjectTaskMapper {
	
	int addProjectTask(ProjectTask projectTask);
	int modifyProjectTask(ProjectTask projectTask);
	
	List<Map<String,Object>> selectTaskListByProjectId(Map<String, Object> param);	// 프로젝트 아이디로 해당 프로젝트 작업 리스트 조회
	ProjectTask selectTaskByTaskId(int taskId);										// 작업 아이디로 해당 작업 상세 조회
	boolean deleteTaskFileByFileId(int fileId);										// 파일 아이디로 파일 데이터 삭제
	boolean deleteTaskByTaskId(int taskId);											// 작업 아이디로 작업 삭제
}
