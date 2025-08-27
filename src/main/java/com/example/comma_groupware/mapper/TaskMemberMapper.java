package com.example.comma_groupware.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.comma_groupware.dto.TaskMember;

@Mapper
public interface TaskMemberMapper {
	
	int addTaskMember(TaskMember taskMember);			// 작업 멤버 추가
	List<Map<String, Object>> selectTaskMemberByTaskId(int taskId);	// 작업 멤버 조회
}
