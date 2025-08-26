package com.example.comma_groupware.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.comma_groupware.dto.ProjectMember;

@Mapper
public interface ProjectMemberMapper {
	int addProjectMember(ProjectMember projectMember);
	List<Map<String, Object>> selectProjectMebmerListByProjectId(Map<String, Object> param);
}
