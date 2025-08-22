package com.example.comma_groupware.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.example.comma_groupware.dto.ProjectMember;

@Mapper
public interface ProjectMemberMapper {
	int addProjectMember(ProjectMember projectMember);
}
