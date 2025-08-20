package com.example.comma_groupware.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.example.comma_groupware.dto.Project;

@Mapper
public interface ProjectMapper {
	
	int addProject(Project project);
}
