package com.example.comma_groupware.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.comma_groupware.dto.Project;
import com.example.comma_groupware.mapper.ProjectMapper;

@Service
public class ProjectService {

	ProjectMapper projectMapper;
	
	public ProjectService(ProjectMapper projectMapper){
		this.projectMapper = projectMapper;
	}
	
	@Transactional
	public int addProject(Project project) {
		
		// 멤버 추가까지
		
		return projectMapper.addProject(project);
	}
}
