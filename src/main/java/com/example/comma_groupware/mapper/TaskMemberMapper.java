package com.example.comma_groupware.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.example.comma_groupware.dto.TaskMember;

@Mapper
public interface TaskMemberMapper {
	
	int addTaskMember(TaskMember taskMember);
}
